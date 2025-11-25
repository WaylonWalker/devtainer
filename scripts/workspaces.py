#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "typer",
#     "rich",
#     "pydantic",
#     "pydantic-settings",
# ]
# ///

from __future__ import annotations

import os
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Tuple, Dict

import typer
from pydantic import Field, ValidationError
from pydantic_settings import BaseSettings, SettingsConfigDict
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt

app = typer.Typer(help="Workspace management tool")
console = Console()


# -------------------------
# Settings / Configuration
# -------------------------


class WorkspaceSettings(BaseSettings):
    """
    Configuration for workspace management.

    Resolution order:
    - CLI flags (handled separately)
    - Environment variables
    - Defaults below
    """

    # Base workspace root choice:
    # - CLI flag: --workspace-root
    # - ENV: WORKSPACES_DIR
    # - Default: ~/git
    base_workspaces_dir: Path = Field(
        default=Path("~/git").expanduser(),
        validation_alias="WORKSPACES_DIR",
    )

    model_config = SettingsConfigDict(extra="ignore")

    @property
    def repos_dir(self) -> Path:
        # repos_dir = workspaces_dir from spec
        return self.base_workspaces_dir

    @property
    def workspaces_dir(self) -> Path:
        # workspaces_dir = workspaces_dir + ".workspaces"
        return Path(str(self.base_workspaces_dir) + ".workspaces")


def get_settings(workspaces_dir_override: Optional[Path]) -> WorkspaceSettings:
    """
    Build settings from env/default and then override base_workspaces_dir if flag is passed.
    """
    try:
        settings = WorkspaceSettings()
    except ValidationError as e:
        console.print("[red]Error loading settings:[/red]", e)
        raise typer.Exit(1)

    if workspaces_dir_override is not None:
        settings.base_workspaces_dir = workspaces_dir_override.expanduser()

    return settings


# -------------------------
# Models / Helpers
# -------------------------


@dataclass
class GitStatus:
    ahead: int = 0
    behind: int = 0
    dirty: bool = False

    @property
    def ascii(self) -> str:
        """
        Simple ascii indicators:
        - ahead: ↑N
        - behind: ↓N
        - dirty: *
        Examples:
          clean: "."
          ahead 1, clean: "↑1"
          behind 2, dirty: "↓2*"
          ahead 1, behind 1, dirty: "↑1↓1*"
        """
        parts: List[str] = []
        if self.ahead:
            parts.append(f"↑{self.ahead}")
        if self.behind:
            parts.append(f"↓{self.behind}")
        s = "".join(parts) or "."
        if self.dirty:
            s += "*"
        return s


def run_git(args: List[str], cwd: Path) -> Tuple[int, str, str]:
    result = subprocess.run(
        ["git", *args],
        cwd=str(cwd),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return result.returncode, result.stdout, result.stderr


def get_git_status(repo_path: Path) -> Optional[GitStatus]:
    if not (repo_path / ".git").exists() and not (repo_path / ".git").is_dir():
        # It might be a worktree (gitdir is not directly here), but `git` should still work
        if not (repo_path / ".git").exists():
            # Try assuming it is a git repo/worktree anyway
            pass

    # Determine upstream
    rc, out, _ = run_git(["rev-parse", "--abbrev-ref", "@{upstream}"], cwd=repo_path)
    has_upstream = rc == 0

    ahead = 0
    behind = 0
    if has_upstream:
        rc2, out2, _ = run_git(["rev-list", "--left-right", "--count", "HEAD...@{upstream}"], cwd=repo_path)
        if rc2 == 0:
            # output: "<behind> <ahead>\n"
            try:
                behind_s, ahead_s = out2.strip().split()
                behind = int(behind_s)
                ahead = int(ahead_s)
            except ValueError:
                pass

    rc3, out3, _ = run_git(["status", "--porcelain"], cwd=repo_path)
    if rc3 != 0:
        return None

    dirty = bool(out3.strip())
    return GitStatus(ahead=ahead, behind=behind, dirty=dirty)


def get_current_branch(repo_path: Path) -> Optional[str]:
    rc, out, _ = run_git(["rev-parse", "--abbrev-ref", "HEAD"], cwd=repo_path)
    if rc != 0:
        return None
    return out.strip()


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def read_workspace_readme_description(readme_path: Path) -> str:
    """
    Read description from workspace README.

    Spec: workspace description (read from the readme, everything after the h1 title)

    Expect format:
        # <name>

        <description...>
    """
    if not readme_path.is_file():
        return ""

    content = readme_path.read_text(encoding="utf-8")
    lines = content.splitlines()

    # Find first H1
    desc_lines: List[str] = []
    found_h1 = False
    for line in lines:
        if not found_h1:
            if re.match(r"^#\s+", line):
                found_h1 = True
            continue
        # after H1
        desc_lines.append(line)

    # strip leading blank lines
    while desc_lines and not desc_lines[0].strip():
        desc_lines.pop(0)
    return "\n".join(desc_lines).strip()


def write_workspace_readme(path: Path, name: str, description: str) -> None:
    content = f"# {name}\n\n{description.strip()}\n"
    path.write_text(content, encoding="utf-8")


def list_dirs(path: Path) -> List[Path]:
    if not path.exists():
        return []
    return sorted([p for p in path.iterdir() if p.is_dir()])


def is_git_repo(path: Path) -> bool:
    # For repos_dir, we expect a main non-worktree repo: .git dir or file
    if (path / ".git").exists():
        return True
    # As a fallback, try `git rev-parse` (handles bare repos, etc.)
    rc, _, _ = run_git(["rev-parse", "--git-dir"], cwd=path)
    return rc == 0


def fuzzy_select(items: List[str]) -> Optional[str]:
    """
    Use iterfzf to select item.

    Returns selected item or None if cancelled.
    """
    if not items:
        return None

    try:
        proc = subprocess.Popen(
            ["iterfzf"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        console.print("[red]iterfzf is not installed or not in PATH.[/red]")
        return None

    assert proc.stdin is not None
    assert proc.stdout is not None

    proc.stdin.write("\n".join(items))
    proc.stdin.close()

    out = proc.stdout.read().strip()
    proc.wait()
    if proc.returncode != 0 or not out:
        return None
    return out


# -------------------------
# CLI options helpers
# -------------------------


def common_workspace_root_option() -> Path:
    return typer.Option(
        None,
        "--workspace-root",
        "-w",
        help=(
            "Base workspaces directory. "
            "Defaults to ENV WORKSPACES_DIR or ~/git. "
            "repos_dir = workspace_root, workspaces_dir = workspace_root + '.workspaces'"
        ),
        dir_okay=True,
        file_okay=False,
        resolve_path=True,
        envvar=None,
    )


workspace_root_option = typer.Option(
    None,
    "--workspace-root",
    "-w",
    help=(
        "Base workspaces directory. "
        "Defaults to ENV WORKSPACES_DIR or ~/git. "
        "repos_dir = workspace_root, workspaces_dir = workspace_root + '.workspaces'"
    ),
    dir_okay=True,
    file_okay=False,
    resolve_path=True,
)

workspace_name_option = typer.Option(
    None,
    "--workspace",
    "-W",
    help="Workspace name (directory under workspaces_dir). "
    "If omitted for some commands, may prompt or infer from CWD.",
)


# -------------------------
# Commands
# -------------------------


@app.command("list-workspaces")
def list_workspaces(
    workspace_root: Optional[Path] = workspace_root_option,
):
    """
    List all workspaces.
    Shows workspace name, description, and included repos with git indicators.
    """
    settings = get_settings(workspace_root)
    workspaces_dir = settings.workspaces_dir
    ensure_dir(workspaces_dir)

    ws_dirs = list_dirs(workspaces_dir)
    if not ws_dirs:
        console.print(f"[yellow]No workspaces found in {workspaces_dir}[/yellow]")
        raise typer.Exit(0)

    table = Table(title=f"Workspaces in {workspaces_dir}")
    table.add_column("Workspace")
    table.add_column("Description")
    table.add_column("Repos")

    for ws in ws_dirs:
        name = ws.name
        readme = ws / "readme.md"
        desc = read_workspace_readme_description(readme)

        # list repos under workspace directory (excluding readme.md etc.)
        repo_dirs = [p for p in ws.iterdir() if p.is_dir()]
        repo_statuses: List[str] = []
        for rd in sorted(repo_dirs, key=lambda p: p.name):
            status = get_git_status(rd)
            if status is None:
                indicator = "?"
            else:
                indicator = status.ascii
            repo_statuses.append(f"{rd.name} [{indicator}]")
        repos_summary = "\n".join(repo_statuses) if repo_statuses else "-"

        table.add_row(name, desc or "-", repos_summary)

    console.print(table)


def _resolve_workspace_from_cwd(settings: WorkspaceSettings) -> Optional[str]:
    """
    Try to infer workspace name from current directory:
    if cwd is inside settings.workspaces_dir/<workspace>/..., return <workspace>.
    """
    cwd = Path.cwd().resolve()
    ws_root = settings.workspaces_dir.resolve()
    try:
        rel = cwd.relative_to(ws_root)
    except ValueError:
        return None
    # first path component is workspace name
    parts = rel.parts
    if not parts:
        return None
    return parts[0]


def _require_workspace_name(
    settings: WorkspaceSettings, workspace: Optional[str]
) -> str:
    """
    Get workspace name using the precedence:
    - explicit CLI flag
    - inferred from CWD
    - prompt user to choose from existing
    """
    workspaces_dir = settings.workspaces_dir
    ensure_dir(workspaces_dir)

    if workspace:
        return workspace

    inferred = _resolve_workspace_from_cwd(settings)
    if inferred:
        return inferred

    options = [p.name for p in list_dirs(workspaces_dir)]
    if not options:
        console.print(
            f"[red]No workspaces exist yet in {workspaces_dir}. "
            f"Create one first with `create-workspace`.[/red]"
        )
        raise typer.Exit(1)

    console.print("[yellow]No workspace specified; please choose one.[/yellow]")
    selected = fuzzy_select(options)
    if selected is None:
        console.print("[red]No workspace selected.[/red]")
        raise typer.Exit(1)
    return selected


@app.command("create-workspace")
def create_workspace(
    name: Optional[str] = typer.Option(None, "--name", "-n", help="Workspace name."),
    description: Optional[str] = typer.Option(
        None, "--description", "-d", help="Workspace description."
    ),
    workspace_root: Optional[Path] = workspace_root_option,
):
    """
    Create a new workspace directory with a README.

    README format: `# <name>\\n\\n<description>`
    """
    settings = get_settings(workspace_root)
    workspaces_dir = settings.workspaces_dir
    ensure_dir(workspaces_dir)

    if not name:
        name = Prompt.ask("Workspace name")
    if not description:
        description = Prompt.ask("Workspace description")

    ws_dir = workspaces_dir / name
    if ws_dir.exists():
        console.print(f"[red]Workspace '{name}' already exists at {ws_dir}[/red]")
        raise typer.Exit(1)

    ws_dir.mkdir(parents=True)
    readme = ws_dir / "readme.md"
    write_workspace_readme(readme, name=name, description=description or "")

    console.print(f"[green]Created workspace[/green] {name} at {ws_dir}")


@app.command("list-repos")
def list_repos(
    workspace: Optional[str] = workspace_name_option,
    workspace_root: Optional[Path] = workspace_root_option,
):
    """
    List repos and current branch in a workspace.
    Shows repo name, branch, and git status ascii/int indicators.
    """
    settings = get_settings(workspace_root)
    workspaces_dir = settings.workspaces_dir
    ensure_dir(workspaces_dir)

    ws_name = _require_workspace_name(settings, workspace)
    ws_dir = workspaces_dir / ws_name
    if not ws_dir.is_dir():
        console.print(f"[red]Workspace '{ws_name}' does not exist at {ws_dir}[/red]")
        raise typer.Exit(1)

    repo_dirs = [p for p in ws_dir.iterdir() if p.is_dir()]

    if not repo_dirs:
        console.print(f"[yellow]No repos found in workspace '{ws_name}'[/yellow]")
        raise typer.Exit(0)

    table = Table(title=f"Repos in workspace '{ws_name}'")
    table.add_column("Repo")
    table.add_column("Branch")
    table.add_column("Status (↑ahead ↓behind *)")

    for rd in sorted(repo_dirs, key=lambda p: p.name):
        branch = get_current_branch(rd) or "?"
        status = get_git_status(rd)
        indicator = status.ascii if status else "?"
        table.add_row(rd.name, branch, indicator)

    console.print(table)


@app.command("add-repos")
def add_repos(
    workspace: Optional[str] = workspace_name_option,
    workspace_root: Optional[Path] = workspace_root_option,
):
    """
    Add repos to a workspace.

    - Uses iterfzf to pick repo(s) from repos_dir
    - For each selected repo, creates a git worktree on branch named exactly as the workspace
      inside the workspace directory under a folder named after the repo.
    """
    settings = get_settings(workspace_root)
    repos_dir = settings.repos_dir
    workspaces_dir = settings.workspaces_dir

    ensure_dir(repos_dir)
    ensure_dir(workspaces_dir)

    ws_name = _require_workspace_name(settings, workspace)
    ws_dir = workspaces_dir / ws_name
    if not ws_dir.exists():
        console.print(
            f"[red]Workspace '{ws_name}' does not exist at {ws_dir}. "
            f"Create it first with `create-workspace`.[/red]"
        )
        raise typer.Exit(1)

    # list all directories in repos_dir as repos
    candidates = [p for p in list_dirs(repos_dir) if is_git_repo(p)]
    if not candidates:
        console.print(f"[yellow]No git repos found in {repos_dir}[/yellow]")
        raise typer.Exit(0)

    names = [c.name for c in candidates]
    console.print(
        f"Select repos to add to workspace '{ws_name}' "
        "(use iterfzf's multi-select if configured)."
    )
    selected = fuzzy_select(names)
    if selected is None:
        console.print("[red]No repo selected.[/red]")
        raise typer.Exit(1)

    # iterfzf can support multi-select and return joined with newline; but in our
    # simple wrapper we read entire stdout as a single string which may contain multiple lines
    selected_names = [line.strip() for line in selected.splitlines() if line.strip()]
    selected_set = set(selected_names)

    name_to_path: Dict[str, Path] = {c.name: c for c in candidates}

    for repo_name in sorted(selected_set):
        if repo_name not in name_to_path:
            console.print(f"[yellow]Skipping unknown repo '{repo_name}'[/yellow]")
            continue

        repo_path = name_to_path[repo_name]
        target = ws_dir / repo_name

        if target.exists():
            console.print(
                f"[yellow]Target {target} already exists; skipping worktree creation.[/yellow]"
            )
            continue

        # ensure branch exists or create it based on default branch
        console.print(f"[blue]Preparing repo {repo_name} for workspace {ws_name}[/blue]")

        # Fetch or ensure branch
        rc_b, _, _ = run_git(["rev-parse", "--verify", ws_name], cwd=repo_path)
        if rc_b != 0:
            # branch doesn't exist; create from default HEAD
            console.print(
                f"[yellow]Branch '{ws_name}' does not exist in {repo_name}; creating it.[/yellow]"
            )
            rc_cb, _, err_cb = run_git(["checkout", "-b", ws_name], cwd=repo_path)
            if rc_cb != 0:
                console.print(
                    f"[red]Failed to create branch '{ws_name}' in {repo_name}:[/red] {err_cb}"
                )
                continue
            # go back to previous branch after creation (optional)
            run_git(["checkout", "-"], cwd=repo_path)

        # git worktree add <target> <branch>
        rc_wt, _, err_wt = run_git(
            ["worktree", "add", str(target), ws_name], cwd=repo_path
        )
        if rc_wt != 0:
            console.print(
                f"[red]Failed to create worktree for {repo_name} in workspace {ws_name}:[/red] {err_wt}"
            )
            continue

        console.print(
            f"[green]Added worktree for repo {repo_name} at {target} on branch {ws_name}[/green]"
        )


# -------------------------
# Entry
# -------------------------

if __name__ == "__main__":
    app()

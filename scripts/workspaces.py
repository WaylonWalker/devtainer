#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "typer",
#     "rich",
#     "pydantic",
#     "pydantic-settings",
#     "iterfzf",
# ]
# ///

import os
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Tuple

import typer
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt
from iterfzf import iterfzf

app = typer.Typer(
    help="Workspace management tool",
    invoke_without_command=True,
)
console = Console()


# ---------------------------------------------------------------------------
# Settings
# ---------------------------------------------------------------------------


class Settings(BaseSettings):
    """
    Global configuration for workspaces.

    Resolution for workspaces_name:
    1. Command-line flag --workspaces-name
    2. Environment variable WORKSPACES_NAME
    3. Default "git"

    repos_dir = ~/workspaces_name
    workspaces_dir = ~/workspaces_name + ".workspaces"
    """

    workspaces_name: str = Field(
        default="git",
        description="Logical name of the workspace group (e.g. 'git', 'work', 'personal').",
    )

    # pydantic v2-style config
    model_config = SettingsConfigDict(
        env_prefix="",
        env_file=None,
        env_nested_delimiter="__",
        # map env vars explicitly
        extra="ignore",
    )

    @classmethod
    def from_env_and_override(cls, override_workspaces_name: Optional[str]) -> "Settings":
        """
        Construct settings honoring:
        1. CLI override
        2. WORKSPACES_NAME env
        3. default "git"
        """
        # First, load from env (WORKSPACES_NAME)
        s = cls()
        if override_workspaces_name is not None:
            s.workspaces_name = override_workspaces_name
        # We still want WORKSPACES_NAME to be honored even though
        # we don't use "fields" config anymore:
        env_val = os.getenv("WORKSPACES_NAME")
        if env_val and override_workspaces_name is None:
            s.workspaces_name = env_val
        return s


def resolve_paths(workspaces_name: Optional[str]) -> Tuple[Settings, Path, Path]:
    """
    Build Settings and derived paths, honoring CLI override of workspaces_name.
    """
    base_settings = Settings.from_env_and_override(workspaces_name)
    name = base_settings.workspaces_name
    repos_dir = Path(os.path.expanduser(f"~/{name}")).resolve()
    workspaces_dir = Path(os.path.expanduser(f"~/{name}.workspaces")).resolve()
    return base_settings, repos_dir, workspaces_dir


# ---------------------------------------------------------------------------
# Models / helpers
# ---------------------------------------------------------------------------


@dataclass
class GitStatus:
    ahead: int = 0
    behind: int = 0
    dirty: bool = False

    @property
    def indicator(self) -> str:
        """
        Build ASCII indicator:
        - clean: "·"
        - ahead 1: "↑1"
        - behind 2: "↓2"
        - both ahead/behind: "↑1 ↓2"
        - add '*' when dirty, e.g. "↑1*" or "↑1 ↓2*"
        """
        parts: List[str] = []
        if self.ahead:
            parts.append(f"↑{self.ahead}")
        if self.behind:
            parts.append(f"↓{self.behind}")
        base = " ".join(parts) if parts else "·"
        if self.dirty:
            base += "*"
        return base


def get_git_status(repo_path: Path) -> GitStatus:
    """
    Get ahead/behind and dirty info for a Git repo.

    Uses `git status --porcelain=v2 --branch` and parses:
    - '# branch.ab +A -B' for ahead/behind
    - any non-comment line for dirty
    """
    try:
        out = subprocess.check_output(
            ["git", "status", "--porcelain=v2", "--branch"],
            cwd=repo_path,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except Exception:
        return GitStatus()

    ahead = 0
    behind = 0
    dirty = False

    for line in out.splitlines():
        if line.startswith("# branch.ab"):
            # Example: "# branch.ab +1 -2"
            m = re.search(r"\+(\d+)\s+-(\d+)", line)
            if m:
                ahead = int(m.group(1))
                behind = int(m.group(2))
        elif not line.startswith("#"):
            dirty = True

    return GitStatus(ahead=ahead, behind=behind, dirty=dirty)


def get_current_branch(repo_path: Path) -> Optional[str]:
    try:
        out = subprocess.check_output(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            cwd=repo_path,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        return out.strip()
    except Exception:
        return None


def ensure_git_repo(path: Path) -> bool:
    # Works for repos and worktrees (.git file or dir)
    return (path / ".git").exists()


def run_cmd(cmd: List[str], cwd: Optional[Path] = None) -> Tuple[int, str, str]:
    proc = subprocess.Popen(
        cmd,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    out, err = proc.communicate()
    return proc.returncode, out, err


def find_workspace_dir(workspaces_dir: Path, workspace_name: Optional[str]) -> Path:
    """
    Resolve the directory of a workspace.

    - If workspace_name given: use workspaces_dir / workspace_name
    - Else: use current working directory (must be inside workspaces_dir).
    """
    if workspace_name:
        return workspaces_dir / workspace_name

    cwd = Path.cwd().resolve()
    try:
        cwd.relative_to(workspaces_dir)
    except ValueError:
        console.print(
            f"[red]Not inside workspaces_dir ({workspaces_dir}). "
            "Please use --workspace to specify a workspace.[/red]"
        )
        raise typer.Exit(1)

    # The top-level workspace directory is the first component under workspaces_dir
    rel = cwd.relative_to(workspaces_dir)
    workspace_root = workspaces_dir / rel.parts[0]
    return workspace_root


def read_workspace_readme(ws_dir: Path) -> Tuple[str, str]:
    """
    Return (name_from_h1, description_from_rest_of_file).
    If file missing or malformed, fallback appropriately.
    """
    readme = ws_dir / "readme.md"
    if not readme.exists():
        name = ws_dir.name
        return name, ""

    text = readme.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines:
        return ws_dir.name, ""

    # First non-empty line must be '# ...' per spec
    first_non_empty_idx = next((i for i, l in enumerate(lines) if l.strip()), None)
    if first_non_empty_idx is None:
        return ws_dir.name, ""

    first_line = lines[first_non_empty_idx].strip()
    if not first_line.startswith("# "):
        # Fallback
        return ws_dir.name, "\n".join(lines[first_non_empty_idx + 1 :]).strip()

    name = first_line[2:].strip()
    desc = "\n".join(lines[first_non_empty_idx + 1 :]).strip()
    return name, desc


def write_workspace_readme(ws_dir: Path, name: str, description: str) -> None:
    ws_dir.mkdir(parents=True, exist_ok=True)
    content = f"# {name}\n\n{description}\n"
    (ws_dir / "readme.md").write_text(content, encoding="utf-8")


# ---------------------------------------------------------------------------
# Commands / main callback
# ---------------------------------------------------------------------------


@app.callback()
def main(
    ctx: typer.Context,
    workspaces_name: Optional[str] = typer.Option(
        None,
        "--workspaces-name",
        "-W",
        help=(
            "Logical name for this workspace set (e.g. 'git', 'work', 'personal'). "
            "Overrides WORKSPACES_NAME env. Defaults to 'git'."
        ),
    ),
):
    """
    Manage workspaces and associated Git worktrees.

    If no command is given, this will list workspaces.
    """
    settings, repos_dir, workspaces_dir = resolve_paths(workspaces_name)
    ctx.obj = {
        "settings": settings,
        "repos_dir": repos_dir,
        "workspaces_dir": workspaces_dir,
    }

    # Default behavior when no subcommand is provided:
    if ctx.invoked_subcommand is None:
        # Call the list_workspaces command programmatically
        list_workspaces(ctx)
        raise typer.Exit(0)


def get_ctx_paths(ctx: typer.Context) -> Tuple[Settings, Path, Path]:
    obj = ctx.obj or {}
    return obj["settings"], obj["repos_dir"], obj["workspaces_dir"]


# ---------------- list-workspaces ----------------


@app.command("list-workspaces")
def list_workspaces(
    ctx: typer.Context,
):
    """
    List all workspaces.

    Shows:
    - workspace directory name
    - workspace description (from README markdown, everything after H1)
    - included repos with git status indicators
    """
    _settings, _repos_dir, workspaces_dir = get_ctx_paths(ctx)
    workspaces_dir.mkdir(parents=True, exist_ok=True)

    table = Table(title=f"Workspaces ({workspaces_dir})")
    table.add_column("Workspace", style="bold")
    table.add_column("Description", overflow="fold")
    table.add_column("Repos", overflow="fold")

    if not workspaces_dir.exists():
        console.print(f"[yellow]No workspaces_dir found at {workspaces_dir}[/yellow]")
        raise typer.Exit(0)

    for ws in sorted(p for p in workspaces_dir.iterdir() if p.is_dir()):
        name, desc = read_workspace_readme(ws)
        repos: List[str] = []
        for child in sorted(p for p in ws.iterdir() if p.is_dir()):
            if child.name.lower() == "readme.md":
                continue
            if not ensure_git_repo(child):
                continue
            status = get_git_status(child)
            branch = get_current_branch(child) or "?"
            indicator = status.indicator
            repos.append(f"{child.name} [{branch}] {indicator}")
        repos_str = "\n".join(repos) if repos else "-"
        table.add_row(ws.name, desc or "-", repos_str)

    console.print(table)


# ---------------- create-workspace ----------------


@app.command("create-workspace")
def create_workspace(
    ctx: typer.Context,
    name: Optional[str] = typer.Option(
        None, "--name", "-n", help="Name of the new workspace (directory name)."
    ),
    description: Optional[str] = typer.Option(
        None,
        "--description",
        "-d",
        help="Description of the workspace. Will be written into readme.md.",
    ),
):
    """
    Create a new workspace.

    - Asks for name and description if not provided.
    - Creates directory under workspaces_dir.
    - Creates README with format '# <name>\\n\\n<description>'.
    """
    _settings, _repos_dir, workspaces_dir = get_ctx_paths(ctx)
    workspaces_dir.mkdir(parents=True, exist_ok=True)

    if not name:
        name = Prompt.ask("Workspace name")

    if not description:
        description = Prompt.ask("Workspace description", default="")

    ws_dir = workspaces_dir / name
    if ws_dir.exists():
        console.print(f"[red]Workspace '{name}' already exists at {ws_dir}[/red]")
        raise typer.Exit(1)

    write_workspace_readme(ws_dir, name, description)
    console.print(f"[green]Created workspace[/green] {ws_dir}")


# ---------------- list-repos ----------------


@app.command("list-repos")
def list_repos(
    ctx: typer.Context,
    workspace: Optional[str] = typer.Option(
        None,
        "--workspace",
        "-w",
        help=(
            "Workspace name to inspect. "
            "If omitted, uses the workspace containing the current directory."
        ),
    ),
):
    """
    List repos and branches in the current (or specified) workspace.

    Shows:
    - repo directory name
    - current branch
    - ahead/behind/dirty indicators
    """
    _settings, _repos_dir, workspaces_dir = get_ctx_paths(ctx)
    ws_dir = find_workspace_dir(workspaces_dir, workspace)

    if not ws_dir.exists():
        console.print(f"[red]Workspace '{ws_dir.name}' does not exist at {ws_dir}[/red]")
        raise typer.Exit(1)

    table = Table(title=f"Repos in workspace '{ws_dir.name}'")
    table.add_column("Repo (dir)", style="bold")
    table.add_column("Branch")
    table.add_column("Status")

    for child in sorted(p for p in ws_dir.iterdir() if p.is_dir()):
        if child.name.lower() == "readme.md":
            continue
        if not ensure_git_repo(child):
            continue
        branch = get_current_branch(child) or "?"
        status = get_git_status(child)
        table.add_row(child.name, branch, status.indicator)

    console.print(table)


# ---------------- add-repo ----------------


def list_all_repos(repos_dir: Path) -> List[Path]:
    """
    List all directories in repos_dir that appear to be git repos.
    """
    if not repos_dir.exists():
        return []
    repos = []
    for p in sorted(repos_dir.iterdir()):
        if p.is_dir() and ensure_git_repo(p):
            repos.append(p)
    return repos


def pick_repo_with_iterfzf(repos: List[Path]) -> Optional[Path]:
    """
    Use iterfzf (Python library) to pick a repo from a list of paths.
    """
    if not repos:
        return None

    names = [r.name for r in repos]
    choice = iterfzf(names, prompt="pick a repo> ")

    if not choice:
        return None

    for r in repos:
        if r.name == choice:
            return r
    return None


@app.command("add-repo")
def add_repo(
    ctx: typer.Context,
    workspace: Optional[str] = typer.Option(
        None,
        "--workspace",
        "-w",
        help=(
            "Workspace to add repo to. "
            "If omitted, uses the workspace containing the current directory."
        ),
    ),
    repo_name: Optional[str] = typer.Option(
        None,
        "--repo",
        "-r",
        help=(
            "Name of repo (directory under repos_dir). "
            "If omitted, uses iterfzf to pick from repos_dir."
        ),
    ),
):
    """
    Add a repo to a workspace.

    - Lists all directories in repos_dir as repos.
    - Uses iterfzf to pick repo if --repo not given.
    - Creates a worktree for branch named after the workspace
      into workspace_dir / repo_name.
    """
    _settings, repos_dir, workspaces_dir = get_ctx_paths(ctx)
    ws_dir = find_workspace_dir(workspaces_dir, workspace)
    if not ws_dir.exists():
        console.print(f"[red]Workspace '{ws_dir.name}' does not exist at {ws_dir}[/red]")
        raise typer.Exit(1)

    ws_name = ws_dir.name

    all_repos = list_all_repos(repos_dir)
    if not all_repos:
        console.print(f"[red]No git repos found in {repos_dir}[/red]")
        raise typer.Exit(1)

    repo_path: Optional[Path] = None
    if repo_name:
        for r in all_repos:
            if r.name == repo_name:
                repo_path = r
                break
        if repo_path is None:
            console.print(
                f"[red]Repo '{repo_name}' not found in {repos_dir}. "
                "Use --repo with a valid name or omit to use iterfzf.[/red]"
            )
            raise typer.Exit(1)
    else:
        repo_path = pick_repo_with_iterfzf(all_repos)
        if repo_path is None:
            console.print("[yellow]No repo selected.[/yellow]")
            raise typer.Exit(0)

    target_dir = ws_dir / repo_path.name
    if target_dir.exists():
        console.print(
            f"[yellow]Directory {target_dir} already exists. "
            "Assuming repo already added.[/yellow]"
        )
        raise typer.Exit(0)

    # Ensure branch exists or create it
    branch = ws_name
    code, _out, err = run_cmd(["git", "rev-parse", "--verify", branch], cwd=repo_path)
    if code != 0:
        # create branch from current HEAD
        console.print(
            f"[yellow]Branch '{branch}' does not exist in {repo_path.name}; creating it.[/yellow]"
        )
        code, _out, err = run_cmd(["git", "branch", branch], cwd=repo_path)
        if code != 0:
            console.print(
                f"[red]Failed to create branch '{branch}' in {repo_path.name}:[/red]\n{err}"
            )
            raise typer.Exit(1)

    # Create worktree
    ws_dir.mkdir(parents=True, exist_ok=True)
    code, _out, err = run_cmd(
        ["git", "worktree", "add", str(target_dir), branch],
        cwd=repo_path,
    )
    if code != 0:
        console.print(
            f"[red]Failed to create worktree for repo {repo_path.name} "
            f"on branch '{branch}' into {target_dir}:[/red]\n{err}"
        )
        raise typer.Exit(1)

    console.print(
        f"[green]Added repo[/green] {repo_path.name} "
        f"to workspace [bold]{ws_name}[/bold] at {target_dir}"
    )


if __name__ == "__main__":
    app()

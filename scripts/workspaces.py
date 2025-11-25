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
from functools import lru_cache
from pathlib import Path
from typing import List, Optional, Tuple

import typer
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from rich.console import Console
from rich.table import Table
from rich.text import Text

app = typer.Typer(help="Manage git workspaces built out of worktrees from a repos directory.")
console = Console()


# =========================
# Settings
# =========================


class WorkspaceSettings(BaseSettings):
    """
    Application settings.

    Resolution order (lowest to highest precedence):
    - defaults
    - .env file (if present)
    - environment variables
    - CLI options (we pass them in explicitly)
    """

    repos_dir: Path = Field(default=Path("~/git").expanduser())
    workspaces_root: Path = Field(default=Path("~/git.workspaces").expanduser())

    model_config = SettingsConfigDict(
        env_prefix="WORKSPACES_",
        env_file=".workspaces.env",
        extra="ignore",
    )


@lru_cache(maxsize=32)
def get_settings(
    repos_dir: Optional[Path] = None,
    workspaces_root: Optional[Path] = None,
) -> WorkspaceSettings:
    kwargs = {}
    if repos_dir is not None:
        kwargs["repos_dir"] = repos_dir
    if workspaces_root is not None:
        kwargs["workspaces_root"] = workspaces_root
    return WorkspaceSettings(**kwargs)


# =========================
# Domain models
# =========================


@dataclass
class GitStatusSummary:
    ahead: int = 0
    behind: int = 0
    dirty: bool = False

    @property
    def is_clean(self) -> bool:
        return self.ahead == 0 and self.behind == 0 and not self.dirty

    def ascii_indicator(self) -> str:
        """
        Simple ASCII indicators:

        - ahead:  ↑N
        - behind: ↓N
        - dirty:  *
        - clean:  ·
        """
        parts: List[str] = []
        if self.ahead:
            parts.append(f"↑{self.ahead}")
        if self.behind:
            parts.append(f"↓{self.behind}")
        if self.dirty:
            parts.append("*")
        if not parts:
            parts.append("·")
        return " ".join(parts)


@dataclass
class RepoInfo:
    name: str
    path: Path
    git_root: Optional[Path]
    status: Optional[GitStatusSummary]


@dataclass
class WorkspaceInfo:
    name: str
    path: Path
    description: str
    repos: List[RepoInfo]


# =========================
# Git helpers
# =========================


def run_git(args: List[str], cwd: Path) -> Tuple[int, str, str]:
    proc = subprocess.run(
        ["git", *args],
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    return proc.returncode, proc.stdout.strip(), proc.stderr.strip()


def get_git_root(path: Path) -> Optional[Path]:
    code, out, _ = run_git(["rev-parse", "--show-toplevel"], cwd=path)
    if code != 0:
        return None
    return Path(out)


def get_git_status_summary(path: Path) -> Optional[GitStatusSummary]:
    # Ensure it's a git repo
    if get_git_root(path) is None:
        return None

    # ahead / behind
    code, out, _ = run_git(
        ["rev-list", "--left-right", "--count", "@{u}...HEAD"],
        cwd=path,
    )
    ahead = behind = 0
    if code == 0 and out:
        try:
            behind_str, ahead_str = out.split()
            behind = int(behind_str)
            ahead = int(ahead_str)
        except Exception:
            ahead = behind = 0

    # dirty?
    code, out, _ = run_git(["status", "--porcelain"], cwd=path)
    dirty = bool(out.strip()) if code == 0 else False

    return GitStatusSummary(ahead=ahead, behind=behind, dirty=dirty)


# =========================
# Workspace helpers
# =========================


def read_workspace_description(readme_path: Path) -> str:
    """
    Read the workspace description from README:
    everything after the first H1 (`# ...`) heading.
    """
    if not readme_path.is_file():
        return ""

    text = readme_path.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines()

    found_h1 = False
    desc_lines: List[str] = []

    for line in lines:
        if not found_h1:
            if re.match(r"^#\s+", line.strip()):
                found_h1 = True
            continue
        desc_lines.append(line)

    # strip leading/trailing blank lines
    while desc_lines and desc_lines[0].strip() == "":
        desc_lines.pop(0)
    while desc_lines and desc_lines[-1].strip() == "":
        desc_lines.pop()

    return "\n".join(desc_lines).strip()


def discover_workspaces(workspaces_root: Path) -> List[WorkspaceInfo]:
    workspaces: List[WorkspaceInfo] = []
    if not workspaces_root.is_dir():
        return workspaces

    for child in sorted(workspaces_root.iterdir()):
        if not child.is_dir():
            continue
        readme = child / "README.md"
        description = read_workspace_description(readme)
        workspaces.append(
            WorkspaceInfo(
                name=child.name,
                path=child,
                description=description,
                repos=[],
            )
        )
    return workspaces


def discover_workspace_repos(workspace_path: Path) -> List[RepoInfo]:
    repos: List[RepoInfo] = []
    if not workspace_path.is_dir():
        return repos

    for child in sorted(workspace_path.iterdir()):
        if not child.is_dir():
            continue
        git_root = get_git_root(child)
        status = get_git_status_summary(child) if git_root else None
        repos.append(
            RepoInfo(
                name=child.name,
                path=child,
                git_root=git_root,
                status=status,
            )
        )
    return repos


def discover_repos_in_repos_dir(repos_dir: Path) -> List[Path]:
    if not repos_dir.is_dir():
        return []
    return [p for p in sorted(repos_dir.iterdir()) if p.is_dir()]


# =========================
# CLI utilities
# =========================


def resolve_current_workspace(
    workspaces_root: Path,
    workspace_name: Optional[str],
) -> WorkspaceInfo:
    """
    Resolve a workspace by name. If not provided, and there is only one workspace,
    use that. Otherwise, require explicit name.
    """
    workspaces = discover_workspaces(workspaces_root)
    if not workspaces:
        console.print("[red]No workspaces found.[/red]")
        raise typer.Exit(code=1)

    if workspace_name:
        for ws in workspaces:
            if ws.name == workspace_name:
                ws.repos = discover_workspace_repos(ws.path)
                return ws
        console.print(f"[red]Workspace '{workspace_name}' not found.[/red]")
        raise typer.Exit(code=1)

    if len(workspaces) == 1:
        ws = workspaces[0]
        ws.repos = discover_workspace_repos(ws.path)
        return ws

    console.print(
        "[red]Multiple workspaces exist. Please specify --workspace NAME.[/red]"
    )
    raise typer.Exit(code=1)


def ensure_iterfzf_exists() -> None:
    from shutil import which

    if which("iterfzf") is None:
        console.print(
            "[red]iterfzf is required for this command but is not installed or "
            "not on PATH.[/red]"
        )
        raise typer.Exit(code=1)


def run_iterfzf(candidates: List[str]) -> Optional[str]:
    """
    Run iterfzf with the given candidates. Return the selected line or None if
    the user cancelled.
    """
    ensure_iterfzf_exists()
    proc = subprocess.Popen(
        ["iterfzf"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    assert proc.stdin is not None
    proc.stdin.write("\n".join(candidates))
    proc.stdin.close()
    out, _ = proc.communicate()
    if proc.returncode != 0:
        return None
    return out.strip() or None


# =========================
# Commands
# =========================


@app.command("list-workspaces")
def list_workspaces(
    repos_dir: Optional[Path] = typer.Option(
        None,
        "--repos-dir",
        help="Directory containing base repos (default: $WORKSPACES_REPOS_DIR or ~/git).",
    ),
    workspaces_root: Optional[Path] = typer.Option(
        None,
        "--workspaces-root",
        "--workspaces-dir",
        help=(
            "Directory containing workspace directories "
            "(default: $WORKSPACES_WORKSPACES_ROOT or ~/git.workspaces)."
        ),
    ),
) -> None:
    """
    List workspaces: name, description, and included repos with git indicators.
    """
    settings = get_settings(
        repos_dir=repos_dir,
        workspaces_root=workspaces_root,
    )
    workspaces = discover_workspaces(settings.workspaces_root)
    if not workspaces:
        console.print(
            f"[yellow]No workspaces found in {settings.workspaces_root}.[/yellow]"
        )
        raise typer.Exit(code=0)

    table = Table(title="Workspaces", show_lines=False)
    table.add_column("Workspace", style="cyan", no_wrap=True)
    table.add_column("Description", style="white")
    table.add_column("Repos", style="magenta")

    for ws in workspaces:
        repos = discover_workspace_repos(ws.path)
        repos_lines: List[str] = []
        for r in repos:
            indicator = r.status.ascii_indicator() if r.status else "?"
            repos_lines.append(f"{r.name} [{indicator}]")
        repos_text = "\n".join(repos_lines) if repos_lines else "-"
        desc_summary = ws.description.splitlines()[0] if ws.description else ""
        table.add_row(ws.name, desc_summary, repos_text)

    console.print(table)


@app.command("create-workspace")
def create_workspace(
    name: Optional[str] = typer.Option(
        None,
        "--name",
        "-n",
        help="Workspace name (also used as directory name).",
    ),
    description: Optional[str] = typer.Option(
        None,
        "--description",
        "-d",
        help="Workspace description. If omitted, will be prompted.",
    ),
    workspaces_root: Optional[Path] = typer.Option(
        None,
        "--workspaces-root",
        "--workspaces-dir",
        help=(
            "Directory containing workspace directories "
            "(default: $WORKSPACES_WORKSPACES_ROOT or ~/git.workspaces)."
        ),
    ),
) -> None:
    """
    Create a new workspace with a README.md containing name and description.
    """
    settings = get_settings(workspaces_root=workspaces_root)

    if not name:
        name = typer.prompt("Workspace name")
    if not name:
        console.print("[red]Workspace name cannot be empty.[/red]")
        raise typer.Exit(code=1)

    if description is None:
        description = typer.prompt("Workspace description", default="")

    ws_dir = settings.workspaces_root / name
    if ws_dir.exists():
        console.print(f"[red]Workspace '{name}' already exists at {ws_dir}.[/red]")
        raise typer.Exit(code=1)

    ws_dir.mkdir(parents=True, exist_ok=False)

    readme_path = ws_dir / "README.md"
    readme_content = f"# {name}\n\n{description or ''}\n"
    readme_path.write_text(readme_content, encoding="utf-8")

    console.print(f"[green]Created workspace[/green] [cyan]{name}[/cyan] at {ws_dir}")


@app.command("list-repos")
def list_repos(
    workspace: Optional[str] = typer.Option(
        None,
        "--workspace",
        "-w",
        help="Workspace name. If omitted and only one workspace exists, that is used.",
    ),
    repos_dir: Optional[Path] = typer.Option(
        None,
        "--repos-dir",
        help="Directory containing base repos (default: $WORKSPACES_REPOS_DIR or ~/git).",
    ),
    workspaces_root: Optional[Path] = typer.Option(
        None,
        "--workspaces-root",
        "--workspaces-dir",
        help=(
            "Directory containing workspace directories "
            "(default: $WORKSPACES_WORKSPACES_ROOT or ~/git.workspaces)."
        ),
    ),
) -> None:
    """
    List repos and branches in the current (or specified) workspace, with git indicators.
    """
    settings = get_settings(
        repos_dir=repos_dir,
        workspaces_root=workspaces_root,
    )
    ws = resolve_current_workspace(settings.workspaces_root, workspace)

    repos = discover_workspace_repos(ws.path)
    if not repos:
        console.print(
            f"[yellow]No repos found in workspace '{ws.name}' ({ws.path}).[/yellow]"
        )
        raise typer.Exit(code=0)

    table = Table(title=f"Repos in workspace '{ws.name}'", show_lines=False)
    table.add_column("Repo", style="cyan", no_wrap=True)
    table.add_column("Branch", style="green", no_wrap=True)
    table.add_column("Status", style="magenta", no_wrap=True)
    table.add_column("Path", style="white")

    for r in repos:
        branch = "?"
        if r.git_root:
            code, out, _ = run_git(["rev-parse", "--abbrev-ref", "HEAD"], cwd=r.path)
            if code == 0 and out:
                branch = out
        indicator = r.status.ascii_indicator() if r.status else "?"
        table.add_row(r.name, branch, indicator, str(r.path))

    console.print(table)


@app.command("add-repo")
def add_repo(
    workspace: Optional[str] = typer.Option(
        None,
        "--workspace",
        "-w",
        help="Workspace name. Default: current workspace (if only one exists).",
    ),
    repos_dir: Optional[Path] = typer.Option(
        None,
        "--repos-dir",
        help="Directory containing base repos (default: $WORKSPACES_REPOS_DIR or ~/git).",
    ),
    workspaces_root: Optional[Path] = typer.Option(
        None,
        "--workspaces-root",
        "--workspaces-dir",
        help=(
            "Directory containing workspace directories "
            "(default: $WORKSPACES_WORKSPACES_ROOT or ~/git.workspaces)."
        ),
    ),
) -> None:
    """
    Add repos to a workspace:

    - Use iterfzf to pick a repo from repos_dir (all directories)
    - Checkout a worktree on branch with the name of the workspace into the workspace
      under directory named by the repo.
    """
    settings = get_settings(
        repos_dir=repos_dir,
        workspaces_root=workspaces_root,
    )
    ws = resolve_current_workspace(settings.workspaces_root, workspace)

    # Discover repos available to add
    repo_dirs = discover_repos_in_repos_dir(settings.repos_dir)
    if not repo_dirs:
        console.print(
            f"[red]No repos found in repos_dir {settings.repos_dir}.[/red]"
        )
        raise typer.Exit(code=1)

    candidates = [d.name for d in repo_dirs]
    selected = run_iterfzf(candidates)
    if not selected:
        console.print("[yellow]No repo selected.[/yellow]")
        raise typer.Exit(code=1)

    # Map selected name back to full path
    selected_path = next((d for d in repo_dirs if d.name == selected), None)
    if not selected_path:
        console.print(
            f"[red]Selected repo '{selected}' not found in repos_dir {settings.repos_dir}.[/red]"
        )
        raise typer.Exit(code=1)

    console.print(f"Selected repo: [cyan]{selected_path}[/cyan]")

    # Ensure selected path is a git repo
    git_root = get_git_root(selected_path)
    if git_root is None:
        console.print(
            f"[red]{selected_path} is not a git repository (no .git found).[/red]"
        )
        raise typer.Exit(code=1)

    target_dir = ws.path / selected_path.name
    branch_name = ws.name

    # Create branch if needed
    code, out, err = run_git(["rev-parse", "--verify", branch_name], cwd=git_root)
    if code != 0:
        console.print(
            f"[yellow]Branch '{branch_name}' does not exist in repo. Creating it from HEAD.[/yellow]"
        )
        code, _, err = run_git(["branch", branch_name], cwd=git_root)
        if code != 0:
            console.print(
                f"[red]Failed to create branch '{branch_name}' in repo {git_root}:[/red]\n{err}"
            )
            raise typer.Exit(code=1)

    # Create worktree
    if target_dir.exists():
        console.print(
            f"[red]Target worktree directory already exists: {target_dir}[/red]"
        )
        raise typer.Exit(code=1)

    target_dir.parent.mkdir(parents=True, exist_ok=True)

    console.print(
        f"Adding worktree for repo [cyan]{git_root}[/cyan] into "
        f"[cyan]{target_dir}[/cyan] on branch [green]{branch_name}[/green]..."
    )

    code, _, err = run_git(
        ["worktree", "add", str(target_dir), branch_name],
        cwd=git_root,
    )
    if code != 0:
        console.print(f"[red]git worktree add failed:[/red]\n{err}")
        raise typer.Exit(code=1)

    console.print(
        f"[green]Worktree created[/green] for repo [cyan]{selected_path.name}[/cyan] "
        f"in workspace [cyan]{ws.name}[/cyan]."
    )


# =========================
# Entrypoint
# =========================


def main() -> None:
    app()


if __name__ == "__main__":
    main()

# Agent Workflow

Follow the shared repository workflow in `AGENTS.md`, including the requirement to work from a dedicated worktree under `~/git/worktree/`, pull the primary checkout with fast-forward-only behavior before landing, preserve pre-existing user changes, and remove the task worktree after landing. Do not push or publish unless the user asks.

This is a containerization and dotfiles project. Use `just` for project tasks, do not run deployment recipes unless asked, and follow the project-specific build and documentation guidance in `AGENTS.md`.

# Global Git Workspace Instructions

- Keep primary checkouts in `~/git` clean. Use a dedicated task worktree under `~/git/worktree/` for each task.
- Inspect the primary checkout's status and existing worktrees first. Do not reuse or remove another task's worktree.
- Commit only task changes from the task worktree. Preserve unrelated user changes.
- Before landing, return to the primary checkout under `~/git` and pull with fast-forward-only behavior. If it is dirty or cannot be updated safely, stop and report why; never stash, reset, or overwrite changes.
- Land the task commit through the repository's normal local workflow. Do not push or publish unless the user asks.
- Remove the task worktree after landing, verify that it is gone, and finish from the primary checkout under `~/git`.

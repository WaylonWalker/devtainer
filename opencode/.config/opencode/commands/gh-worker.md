---
description: Autonomous issue worker - works GitHub issues in worktrees until all complete
agent: gh-worker
---
Work through all open GitHub issues autonomously.

$ARGUMENTS

Check the issue list, create worktrees in ~/git.workspaces, delegate to subagents, create PRs, ensure CI passes, and keep going until all issues are complete and merged.

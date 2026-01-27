---
description: Execute a plan by raira ID - implement changes in worktree with full tool access
---
Execute the plan with ID $ARGUMENTS.

First, verify the plan is ready for execution:
!`raira plan show $ARGUMENTS --format json`

If the plan is not marked as ready (`ready: false`), warn the user and ask if they want to proceed anyway. Plans should be reviewed and marked ready with `raira plan update <id> --ready` before execution.

## Phase 1: Setup Workspace

Get the linked issue ID from the plan, then create a workspace with git worktree:

```bash
# Get issue ID from plan
raira plan show $ARGUMENTS --format json | jq -r '.for_issue'

# Create workspace (outputs worktree path)
raira workspace start <issue-id>
```

All implementation work MUST happen in the worktree directory returned by `raira workspace start`.

Setting plan status to in-progress:
!`raira plan update $ARGUMENTS --status in-progress`

Read the plan body (use --format markdown for the actual content):
!`raira plan show $ARGUMENTS --format markdown`

## Phase 2: Implementation

Implement the changes in the worktree. Lean heavily on delegation:
use @general subagents for research, experiments, edits, and test runs, keeping the
orchestration tight and supervised.

After each change, verify it works before moving to the next step.

Locate project check instructions in AGENTS.md and run the appropriate
checks for this project before completion.

Continuously re-read the plan between iterations and surface blockers/risks before
proceeding. You may add notes about proposed additions or blockers discovered.

## Phase 3: Commit, Push, and PR

When implementation is complete:

1. **Commit changes** in the worktree:
   ```bash
   git add -A
   git commit -m "feat: <description based on plan>"
   ```

2. **Push branch** to remote:
   ```bash
   git push -u origin <branch-name>
   ```

3. **Create PR** using gh CLI:
   ```bash
   gh pr create --title "<issue title>" --body "Closes #<issue-id>

   ## Summary
   <brief description of changes>
   "
   ```

4. **Watch CI** - monitor the PR checks:
   ```bash
   gh pr checks --watch
   ```
   If CI fails, fix issues and push again.

## Phase 4: Completion

When PR is created and CI passes:

1. Mark the plan as completed: `raira plan update $ARGUMENTS --status completed`
2. Close the linked issue: `raira issue update <issue-id> --status completed`
3. Report the PR URL to the user

## RAIRA CLI Reference

For full command reference, use:
```bash
raira explain workspace  # Workspace/worktree commands
raira explain issue      # Issue management
raira explain plan       # Plan management
```

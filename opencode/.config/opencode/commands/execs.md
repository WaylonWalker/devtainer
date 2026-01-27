---
description: Execute multiple issues in parallel - each in its own worktree, respects dependencies
---
Execute multiple issues by ID: $ARGUMENTS

## Phase 1: Load Issues and Build Dependency Graph

First, fetch all requested issues:
!`raira issue show $ARGUMENTS --format json 2>/dev/null || echo '[]'`

For each issue ID provided, load:
1. The issue details (status, priority, dependencies)
2. Any existing plan for the issue
3. Dependency status (are blocking issues completed?)

Build a dependency graph to determine execution order:
- Issues with no dependencies (or all deps completed) can start immediately
- Issues with pending dependencies must wait
- Detect circular dependencies and report them

## Phase 2: Validate and Prepare

For each issue, check readiness:

1. **Has plan?** If no plan exists, create one first:
   - Use @planner agent to generate plan
   - Mark plan as ready after review

2. **Plan ready?** If plan exists but not ready:
   - Log warning: "Issue <id> has draft plan - skipping (use /review-plan <id> first)"
   - Skip this issue

3. **Dependencies met?** If blocking deps not completed:
   - Check if blocking issues are in our execution list
   - If yes: schedule after dependencies
   - If no: skip with message "Blocked by <dep-id> (not in execution list)"

## Phase 3: Parallel Execution with Worktrees

Execute issues respecting the dependency graph. Each issue gets its own worktree:

```
EXECUTION STRATEGY:
- Group issues into "waves" based on dependencies
- Wave 1: Issues with no pending dependencies
- Wave 2: Issues whose deps are all in Wave 1
- Wave N: Issues whose deps are all in Waves 1..(N-1)

For each wave:
  - Create worktrees for all issues in wave: raira workspace start <issue-id>
  - Launch @general subagents in parallel for each issue
  - Each subagent works in its own worktree
  - Wait for all subagents in wave to complete
  - Record results (success/failure/skipped)
  - Move to next wave
```

For each issue execution:

1. **Create workspace**: `raira workspace start <issue-id>`
2. Set issue status: `raira issue update <id> --status in-progress`
3. Get the plan: `raira plan list --for-issue <id> --ready --format json`
4. Execute via @general subagent in the worktree:
   - "Execute plan <plan-id> for issue <id> in worktree <path>.
      Follow all steps in the plan. Run project checks.
      Commit, push, create PR, watch CI.
      Mark plan completed when done.
      If blocked, return with blocker description."
5. On success:
   - Mark plan completed: `raira plan update <plan-id> --status completed`
   - Mark issue completed: `raira issue update <id> --status completed`
6. On failure:
   - Log error and reason
   - Leave issue as in-progress
   - Continue to next issue

## Phase 4: Summary Report

After all waves complete, report:

```
EXECUTION SUMMARY
=================
Total issues: N
Completed:    X
Failed:       Y
Skipped:      Z (blocked or no ready plan)

COMPLETED:
- [abc123] Issue title - PR: <url>
- [def456] Issue title - PR: <url>

FAILED:
- [ghi789] Issue title - Error: test failures in module X

SKIPPED:
- [jkl012] Issue title - Blocked by mno345 (not completed)
- [pqr678] Issue title - No ready plan (draft exists)

WORKSPACES:
- Use `raira workspace list` to see active worktrees
- Clean up with `raira workspace stop <issue-id>`

Next steps:
- Review failed issues: raira issue show <id>
- Fix blockers and re-run: /execs ghi789 jkl012
```

## Error Handling

- **Skip and continue**: On any failure, log it and proceed to next issue
- **Respect dependencies**: Don't start issue if its deps failed in this run
- **Idempotent**: Re-running with same issues skips already-completed ones
- **Worktree isolation**: Each issue works in isolated worktree, failures don't affect others

## RAIRA CLI Reference

For full command reference, use:
```bash
raira explain workspace  # Workspace/worktree commands
raira explain issue      # Issue management
raira explain plan       # Plan management
```

## Usage Examples

```bash
# Execute specific issues (each gets own worktree)
/execs abc123 def456 ghi789

# Execute issues (some may depend on others)
/execs parent-id child-id grandchild-id
```

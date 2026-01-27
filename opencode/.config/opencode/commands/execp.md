---
description: Execute all open issues for a project - batch execution with worktrees and dependency ordering
---
Execute all actionable issues for project: $ARGUMENTS

## Phase 1: Discover Project Issues

Fetch all open issues for the project:
!`raira issue list --project $ARGUMENTS --status open --format json`

Also fetch issues that are in-progress (may need to resume):
!`raira issue list --project $ARGUMENTS --status in-progress --format json`

Filter to actionable issues (those ready to work on):
!`raira issue actionable --format json | jq '[.[] | select(.project == "$ARGUMENTS")]'`

## Phase 2: Prioritize and Order

Sort issues by:
1. **Priority**: high > medium > low
2. **Dependencies**: issues with no deps first
3. **Has ready plan**: issues with ready plans before those needing planning

Build execution list:
```
HIGH PRIORITY (no deps, has plan):     Execute first
HIGH PRIORITY (no deps, needs plan):   Plan then execute
HIGH PRIORITY (has deps):              Wait for deps
MEDIUM PRIORITY: ...
LOW PRIORITY: ...
```

## Phase 3: Pre-flight Check

Before starting, show the execution plan:

```
PROJECT EXECUTION PLAN: $ARGUMENTS
===================================
Found N open issues, M actionable

WAVE 1 (parallel - each gets own worktree):
  [HIGH] abc123 - Critical bug fix (has ready plan)
  [HIGH] def456 - Security update (has ready plan)

WAVE 2 (after wave 1):
  [MED]  ghi789 - Feature X (depends on abc123)
  
WAVE 3 (after wave 2):
  [LOW]  jkl012 - Cleanup task (depends on ghi789)

DEFERRED (blocked by external deps):
  [MED]  mno345 - Blocked by pqr678 (different project)

NEEDS PLANNING:
  [HIGH] stu901 - No plan yet - will create plan first

Proceed? (Continuing automatically in 5s, Ctrl+C to abort)
```

## Phase 4: Execute Using Worktrees

For each wave, create isolated worktrees and execute in parallel:

1. **Create worktrees** for all issues in wave:
   ```bash
   raira workspace start <issue-id>  # Returns worktree path
   ```

2. **Launch parallel execution**:
   - Each @general subagent works in its own worktree
   - "Execute plan <plan-id> for issue <id> in worktree <path>.
      Follow all steps. Run checks. Commit, push, create PR, watch CI."

3. **Collect results** and proceed to next wave if any issues succeeded

Issues needing plans:
1. Before execution wave, run planning:
   - Use @planner agent: "Create plan for issue <id>"
   - Auto-mark as ready if plan looks complete
2. Add to appropriate wave based on dependencies

## Phase 5: Continuous Progress

After each wave, re-evaluate:
- Did any blocked issues become unblocked?
- Are there new issues added to the project?
- Should we continue or stop?

```
WAVE 1 COMPLETE
===============
Completed: 2/2 issues
Time: 15m 32s
PRs created:
  - abc123: https://github.com/org/repo/pull/123
  - def456: https://github.com/org/repo/pull/124

Unblocked for Wave 2:
- ghi789 (dep abc123 now completed)

Continuing to Wave 2...
```

## Phase 6: Final Summary

```
PROJECT EXECUTION COMPLETE: $ARGUMENTS
======================================
Duration: 1h 23m
Issues processed: 8
  Completed: 6
  Failed: 1
  Skipped: 1

COMPLETED:
- [abc123] Critical bug fix - PR: <url>
- [def456] Security update - PR: <url>
- [ghi789] Feature X - PR: <url>
- [jkl012] Cleanup task - PR: <url>
- [stu901] New feature (plan created + executed) - PR: <url>
- [vwx234] Documentation update - PR: <url>

FAILED:
- [yz0567] Integration issue - Tests failing, needs manual review

SKIPPED:
- [mno345] Blocked by external dependency pqr678

WORKSPACES:
Active worktrees: `raira workspace list`
Clean up completed: `raira workspace stop <issue-id>`

PROJECT STATUS:
  Open issues remaining: 2
  Run /execp $ARGUMENTS again after resolving blockers
```

## RAIRA CLI Reference

For full command reference, use:
```bash
raira explain workspace  # Workspace/worktree commands
raira explain issue      # Issue management  
raira explain plan       # Plan management
```

## Usage

```bash
# Execute all open issues for a project
/execp rada

# Execute for raira project
/execp raira
```

## Notes

- Each issue executes in its own git worktree (isolated branches)
- Skips already-completed issues
- Creates plans for issues without them
- Respects dependency ordering
- Parallelizes within priority waves
- Creates PRs and watches CI for each issue
- Stops gracefully on Ctrl+C (marks current work)

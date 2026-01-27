---
description: Create plans for multiple issues in parallel
agent: planner
---
Create plans for multiple issues: $ARGUMENTS

## Phase 1: Load Issues

Fetch all requested issues:
!`raira issue show $ARGUMENTS --format json 2>/dev/null || echo '[]'`

For each issue, check:
1. Does a plan already exist? `raira plan list --for-issue <id> --format json`
2. Is the issue open/in-progress? (skip completed/cancelled)
3. Are there blocking dependencies that should be planned first?

## Phase 2: Filter and Prioritize

Sort issues for planning:
1. **No existing plan**: These need plans created
2. **Has draft plan**: May need review/completion
3. **Has ready plan**: Skip (already planned)

Build planning queue:
```
NEEDS PLAN:
  [HIGH] abc123 - Critical bug (no plan)
  [MED]  def456 - Feature request (no plan)

HAS DRAFT PLAN (may need completion):
  [HIGH] ghi789 - Has draft, needs review

SKIP (already planned):
  [LOW]  jkl012 - Has ready plan
```

## Phase 3: Parallel Planning

Launch @planner subagents in parallel for each issue needing a plan:

For each issue:
1. Research the codebase using @explore subagents
2. Search for related issues/plans: `raira search query '<keywords>'`
3. Gather context about affected areas
4. Create comprehensive plan via raira:
   ```
   raira plan create --title '<descriptive title>' --for-issue <id>
   ```
5. Add plan body with:
   - Summary of approach
   - Specific file paths and changes
   - Step-by-step implementation tasks
   - Testing strategy
   - Acceptance criteria mapping

Parallelization strategy:
- Launch up to 3 planning subagents concurrently
- Each subagent handles one issue completely
- Collect results as they complete

## Phase 4: Summary Report

```
PLANNING SUMMARY
================
Issues processed: N
Plans created:    X
Plans updated:    Y
Skipped:          Z

CREATED:
- [abc123] Critical bug fix
  Plan: plan-abc123 (draft)
  
- [def456] Feature request  
  Plan: plan-def456 (draft)

UPDATED:
- [ghi789] Existing draft expanded

SKIPPED (already has ready plan):
- [jkl012] Cleanup task

NEXT STEPS:
- Review draft plans: /review-plan <plan-id>
- Mark plans ready: raira plan update <id> --ready
- Execute plans: /execs abc123 def456 ghi789
```

## Usage

```bash
# Create plans for specific issues
/plans abc123 def456 ghi789

# Plan issues that came from actionable list
/plans $(raira issue actionable --format json | jq -r '.[].id' | head -5 | tr '\n' ' ')
```

## Notes

- Plans are created as drafts (not marked ready)
- Use `/review-plan <id>` to review before execution
- Skips issues that already have ready plans
- Respects issue dependencies for planning order

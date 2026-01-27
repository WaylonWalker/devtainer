---
description: Create plans for all open issues in a project
agent: planner
---
Create plans for all open issues in project: $ARGUMENTS

## Phase 1: Discover Project Issues

Fetch all open issues for the project that need planning:
!`raira issue list --project $ARGUMENTS --status open --format json`

Also check in-progress issues that may need plans:
!`raira issue list --project $ARGUMENTS --status in-progress --format json`

For each issue, check if a plan exists:
!`raira plan list --for-issue <id> --format json`

## Phase 2: Categorize Issues

```
PROJECT PLANNING: $ARGUMENTS
============================
Total open issues: N

NEEDS PLAN (no plan exists):
  [HIGH] abc123 - Critical bug fix
  [HIGH] def456 - Security vulnerability
  [MED]  ghi789 - Feature request
  [LOW]  jkl012 - Documentation update

HAS DRAFT PLAN (needs review):
  [MED]  mno345 - Has draft plan, may need updates

ALREADY PLANNED (has ready plan):
  [HIGH] pqr678 - Ready for execution
  [LOW]  stu901 - Ready for execution

Proceeding to create N plans...
```

## Phase 3: Prioritized Planning

Plan issues in priority order:
1. **High priority first**: Critical bugs, security issues
2. **Medium priority**: Features, enhancements  
3. **Low priority**: Cleanup, documentation

For each priority level, launch parallel planning:

### Planning Process (per issue)

Use @planner subagent for each issue:

1. **Research phase**:
   - Explore codebase with @explore agents
   - Search related issues: `raira search query '<keywords>'`
   - Identify affected files and components

2. **Plan creation**:
   ```bash
   echo '<plan body>' | raira plan create \
     --title 'Plan: <descriptive title>' \
     --for-issue <issue-id> \
     --priority <inherit from issue>
   ```

3. **Plan content** should include:
   - **Summary**: Brief approach description
   - **Files to modify**: Specific paths
   - **Implementation steps**: Numbered tasks
   - **Testing strategy**: How to verify
   - **Acceptance criteria**: Map to issue criteria

Parallelization:
- Up to 3 concurrent planning subagents
- Higher priority issues get planned first
- Results collected as they complete

## Phase 4: Progress Updates

After each batch completes:

```
PROGRESS: $ARGUMENTS
====================
High priority:  3/3 planned
Medium priority: 2/5 planned (in progress...)
Low priority:   0/2 pending

Recently created:
- plan-abc123: Critical bug fix (draft)
- plan-def456: Security update (draft)
- plan-ghi789: Feature X (draft)

Continuing with medium priority issues...
```

## Phase 5: Final Summary

```
PROJECT PLANNING COMPLETE: $ARGUMENTS
=====================================
Duration: 25m 15s
Issues processed: 10

PLANS CREATED: 7
  [HIGH] abc123 - Critical bug fix → plan-abc123
  [HIGH] def456 - Security update → plan-def456
  [MED]  ghi789 - Feature X → plan-ghi789
  [MED]  jkl012 - Enhancement Y → plan-jkl012
  [MED]  mno345 - Feature Z → plan-mno345
  [LOW]  pqr678 - Cleanup → plan-pqr678
  [LOW]  stu901 - Docs update → plan-stu901

ALREADY HAD PLANS: 2
  [HIGH] vwx234 - Already has ready plan
  [MED]  yz0567 - Already has ready plan

SKIPPED: 1
  [LOW]  abc890 - Blocked by external dependency

NEXT STEPS:
1. Review draft plans:
   /review-plan plan-abc123
   /review-plan plan-def456
   ...

2. Mark plans ready after review:
   raira plan update <id> --ready

3. Execute all ready plans:
   /execp $ARGUMENTS

PROJECT STATUS:
  Issues with ready plans: 9/10
  Ready for /execp: Yes (after marking new plans ready)
```

## Usage

```bash
# Plan all open issues for a project
/planp rada

# Plan all raira project issues
/planp raira
```

## Notes

- Creates plans as drafts (review before marking ready)
- Skips issues that already have plans
- Prioritizes high-priority issues first
- Parallelizes planning within priority tiers
- Use `/execp <project>` after plans are ready

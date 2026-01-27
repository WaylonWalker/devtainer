---
description: Review all draft plans for a project - approve or fix automatically
agent: review
---
Review and fix all plans for project: $ARGUMENTS

## Phase 1: Discover Project Plans

Fetch all draft plans for the project (ready: false):
!`raira plan list --project $ARGUMENTS --not-ready --format json`

For context, also see ready plans:
!`raira plan list --project $ARGUMENTS --ready --format json`

```
PROJECT PLAN REVIEW: $ARGUMENTS
===============================
Draft plans to review: X
Already ready (skip): Y

DRAFT PLANS:
  [HIGH] plan-abc123 - Critical bug fix (for issue abc123)
  [MED]  plan-def456 - Feature X (for issue def456)
  [LOW]  plan-ghi789 - Cleanup (for issue ghi789)

Proceeding with review and fixes...
```

## Phase 2: Prioritized Review & Action

Review plans in priority order (high → medium → low).
Launch @review subagents in parallel (up to 3 concurrent).

For each plan, the subagent must:

### Step 1: Load Full Context

```bash
# Get plan content
raira plan show <plan-id> --format markdown

# Get linked issue for acceptance criteria
raira issue show <issue-id> --format json
```

### Step 2: Review Against Criteria

- **Issue Alignment**: Does plan address all issue requirements?
- **Specificity**: Are file paths and changes concrete?
- **Feasibility**: Is the approach technically sound?
- **Testability**: Is there a clear verification strategy?
- **Scope**: Is it appropriately sized?

### Step 3: Take Action

#### APPROVED (plan is solid):
```bash
raira plan update <plan-id> --ready
```

#### NEEDS WORK (fixable issues):
Fix the issues directly in the plan, then mark ready:

```bash
# Create improved plan body with fixes:
# - Add missing sections (error handling, tests, etc.)
# - Fix outdated file paths
# - Clarify ambiguous steps
# - Add acceptance criteria mapping

echo '<improved plan body>' | raira plan update <plan-id> --body -
raira plan update <plan-id> --ready
```

**Common fixes to apply inline**:
- Missing error handling → Add "Error Handling" section
- Outdated paths → Research correct paths and update
- No test strategy → Add "Testing" section with specific test cases
- Vague steps → Make concrete with file paths and code snippets
- Missing AC mapping → Add section mapping plan steps to issue acceptance criteria

#### REJECTED (fundamental issues):
Add review notes explaining why, leave as draft:

```bash
echo '<original body>

---

## Review Notes

**Status**: Rejected - needs replanning

**Fundamental Issues**:
1. <issue description>
2. <issue description>

**Recommendation**: Replan this issue with `/plan-issue <issue-id>`

' | raira plan update <plan-id> --body -
```

## Phase 3: Progress Updates

```
REVIEW PROGRESS: $ARGUMENTS
===========================
High priority:   2/2 done
Medium priority: 1/3 in progress...
Low priority:    0/2 pending

Completed:
  ✓ plan-abc123: Approved → marked ready
  ✓ plan-def456: Fixed (added test section) → marked ready
  ⚠ plan-ghi789: Reviewing...
```

## Phase 4: Final Summary

```
PROJECT PLAN REVIEW COMPLETE: $ARGUMENTS
========================================
Duration: 12m 45s
Plans reviewed: 8

APPROVED (no changes needed): 3
  ✓ plan-abc123 - raira plan update abc123 --ready
  ✓ plan-def456 - raira plan update def456 --ready
  ✓ plan-jkl012 - raira plan update jkl012 --ready

FIXED & APPROVED: 4
  ✓ plan-ghi789 - Added error handling section
    raira plan update ghi789 --body - && --ready
    
  ✓ plan-mno345 - Fixed file paths, added test strategy
    raira plan update mno345 --body - && --ready
    
  ✓ plan-pqr678 - Clarified steps 3-5
    raira plan update pqr678 --body - && --ready
    
  ✓ plan-stu901 - Added acceptance criteria mapping
    raira plan update stu901 --body - && --ready

REJECTED (needs replanning): 1
  ✗ plan-vwx234 - Fundamental architecture conflict
    Added review notes to plan
    Action needed: /plan-issue vwx234

SUMMARY:
  Plans now ready: 7
  Plans need replanning: 1
  
PROJECT STATUS:
  Ready for execution: /execp $ARGUMENTS
  After replanning vwx234: /review-plans plan-vwx234
```

## Usage

```bash
# Review and fix all draft plans for a project
/review-planp rada

# Review all plans for raira
/review-planp raira
```

## Notes

- **Automatically fixes** minor issues (missing sections, outdated paths, etc.)
- **Marks ready** after fixing - no manual step needed
- **Rejects** only plans with fundamental issues requiring full replan
- All actions via raira CLI commands
- Reviews in priority order
- Ready for `/execp` immediately after

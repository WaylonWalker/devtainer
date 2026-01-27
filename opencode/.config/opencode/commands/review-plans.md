---
description: Review multiple plans in parallel - approve or fix automatically
agent: review
---
Review multiple plans and take action: $ARGUMENTS

## Phase 1: Load Plans

Fetch all requested plans:
!`raira plan show $ARGUMENTS --format json 2>/dev/null || echo '[]'`

For each plan, gather:
1. Plan details and body content: `raira plan show <id> --format markdown`
2. Linked issue context: `raira issue show <issue-id> --format json`
3. Current ready status

## Phase 2: Parallel Review & Action

Launch @review subagents in parallel for each plan (up to 3 concurrent).

For each plan, the subagent must:

### Step 1: Review Against Criteria

- **Completeness**: Does it address all issue requirements?
- **Specificity**: Are file paths and changes concrete?
- **Feasibility**: Is the approach technically sound?
- **Testability**: Is there a clear verification strategy?
- **Scope**: Is it appropriately sized (not too big/small)?

### Step 2: Take Action Based on Verdict

#### If APPROVED (plan is solid):
```bash
# Mark the plan as ready
raira plan update <plan-id> --ready
```

#### If NEEDS WORK (fixable issues):
Fix the plan directly, then mark ready:
```bash
# Update the plan body with fixes
echo '<corrected plan body with fixes applied>' | raira plan update <plan-id> --body -

# Then mark as ready
raira plan update <plan-id> --ready
```

Common fixes to apply:
- Add missing error handling sections
- Update outdated file paths
- Add missing test strategy
- Clarify ambiguous steps
- Add missing acceptance criteria mapping

#### If REJECT (fundamental issues):
Add review notes to the plan explaining why, leave as draft:
```bash
# Append rejection notes to plan body
echo '<original body>

---
## Review Notes ($(date +%Y-%m-%d))

**Status**: Rejected - needs replanning

**Issues**:
- <fundamental issue 1>
- <fundamental issue 2>

**Recommendation**: Replan with /plan-issue <issue-id>
' | raira plan update <plan-id> --body -
```

## Phase 3: Summary Report

```
REVIEW SUMMARY
==============
Plans reviewed: N

APPROVED & MARKED READY: X
  ✓ [HIGH] plan-abc123 - Critical bug fix
    Action: raira plan update abc123 --ready
    
  ✓ [MED]  plan-def456 - Feature implementation  
    Action: raira plan update def456 --ready

FIXED & MARKED READY: Y
  ✓ [MED]  plan-ghi789 - Enhancement
    Fixed: Added missing error handling section
    Fixed: Updated file path src/old.ts → src/new.ts
    Action: raira plan update ghi789 --body - && raira plan update ghi789 --ready

REJECTED (needs replanning): Z
  ✗ [HIGH] plan-mno345 - Redesign
    Issues: Conflicts with architecture, missing stakeholder input
    Action: Added review notes to plan body
    Next: /plan-issue mno345

ACTIONS TAKEN:
  - Marked X plans as ready (no changes needed)
  - Fixed and marked Y plans as ready
  - Added rejection notes to Z plans

NEXT STEPS:
  - Execute ready plans: /execs abc123 def456 ghi789
  - Replan rejected issues: /plan-issue mno345
```

## Usage

```bash
# Review and fix specific plans
/review-plans plan-abc123 plan-def456 plan-ghi789

# Review plans by issue ID (finds associated plans)
/review-plans --for-issues abc123 def456
```

## Notes

- **Approved plans**: Marked ready immediately
- **Fixable plans**: Fixed inline and marked ready
- **Rejected plans**: Review notes added, left as draft for replanning
- All actions use raira CLI commands
- Parallelizes reviews for efficiency

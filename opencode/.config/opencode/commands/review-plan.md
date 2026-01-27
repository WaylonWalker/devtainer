---
description: Review a raira plan for project fit
subtask: true
agent: review
---
Load the plan-review skill, then review this plan:

!`raira plan show $ARGUMENTS --format json`
!`raira plan show $ARGUMENTS --format markdown`

After reviewing, take action based on your verdict:

## If APPROVED or APPROVED WITH SUGGESTIONS

If you are confident the plan is ready for execution, mark it ready:

```bash
raira plan update $ARGUMENTS --ready
```

## If NEEDS REVISION

If the issues are minor and fixable, fix them directly and mark ready:

```bash
# Update plan with fixes
echo '<corrected plan body>' | raira plan update $ARGUMENTS --body -

# Then mark ready
raira plan update $ARGUMENTS --ready
```

If the issues are fundamental and require replanning, leave as draft and add review notes:

```bash
echo '<original body>

---
## Review Notes

**Status**: Needs revision
**Issues**:
- <issue 1>
- <issue 2>

**Recommendation**: Address issues and re-review
' | raira plan update $ARGUMENTS --body -
```

## RAIRA CLI Reference

```bash
raira explain plan  # Plan management commands
```

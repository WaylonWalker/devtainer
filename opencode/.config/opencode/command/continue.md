---
description: Execute next plan phase with checkpointing
agent: build
subtask: true
---

Read PLAN.md and execute next unchecked action item:

1. **Checkpoint**: Create restore point (!`git stash` or temporary branch)
2. **Pre-check**: Fast validation (!`ruff check --quiet`, !`ty --quiet`)
3. **Execute**: Complete single action item with focused scope
4. **Quick Test**: Targeted test for changes only
5. **Rollback**: If failed, restore checkpoint and report specific issues
6. **Validate**: Run full validation suite only on success
7. **Update**: Mark item complete in PLAN.md with timestamp
8. **Commit**: Atomic commit with descriptive message

If validation fails, rollback automatically and suggest fixes. Stop after each item for review.

**Auto-merge detection**: If 3+ related subtasks are completed, automatically merge into single deliverable and update PLAN.md.

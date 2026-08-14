---
description: Execute next plan phase with checkpointing
agent: build
subtask: true
---

Read PLAN.md and execute next unchecked action item:

1. **Inspect**: Check repository instructions, current status, diff, and relevant code.
2. **Pre-check**: Run the project's focused baseline validation when practical.
3. **Execute**: Complete one coherent action item without overwriting unrelated changes.
4. **Quick Test**: Run targeted validation for the change.
5. **Failure Handling**: Stop and report failures; do not reset, stash, restore, or discard changes automatically.
6. **Validate**: Run the strongest practical validation on success.
7. **Update**: Mark the item complete in PLAN.md only after successful verification.
8. **Report**: Summarize edits, commands and outcomes, remaining risks, and the next item.

Do not commit, push, create branches, or rewrite history unless explicitly requested. Stop after the item is complete.

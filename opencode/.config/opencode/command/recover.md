---
description: Recover from failed operations
agent: build
subtask: true
---

Recover project state after failed operations:

1. **Assess current state**:
   - Inspect git status, the complete diff, recent relevant history, and any existing stashes.
   - Identify which changes predated this session and must be preserved.

2. **Recommend recovery**:
   - Explain the smallest safe recovery action and exactly what it would affect.
   - Prefer targeted fixes over broad rollback.
   - Never reset, clean, restore, checkout, stash, commit, or create a branch without explicit approval.

3. **Validation check**:
   - Use repository-defined validation commands when available.
   - Distinguish code failures from environmental failures.

4. **Report recovery status**:
   - State what was inspected, what remains changed, and the recommended next step.

Focus on preserving user work and avoiding irreversible operations.

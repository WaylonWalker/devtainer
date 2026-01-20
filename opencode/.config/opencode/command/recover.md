---
description: Recover from failed operations
agent: build
subtask: true
---

Recover project state after failed operations:

1. **Assess current state**:
   - Git status: !`git status`
   - Recent failures: !`git log --oneline -5 --grep="fail\|error\|revert"`
   - Stashed changes: !`git stash list`

2. **Recovery options**:
   - **Soft reset**: !`git reset --soft HEAD~1` (keep changes, undo commit)
   - **Hard reset**: !`git reset --hard HEAD~1` (discard changes)
   - **Stash pop**: !`git stash pop` (restore stashed changes)
   - **Branch checkout**: !`git checkout -b recovery-backup` (create backup)

3. **Validation check**:
   - Run quick lint: !`just lint --quiet` (if available)
   - Check compilation: !`just build --dry-run` (if available)
   - Verify tests: !`just test --quiet` (if available)

4. **Report recovery status**:
   - ✅ Recovered successfully
   - ⚠️ Partial recovery (manual intervention needed)
   - ❌ Recovery failed (suggest manual fix)

Focus on safe recovery with minimal data loss.
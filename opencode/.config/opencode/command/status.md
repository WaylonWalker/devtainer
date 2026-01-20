---
description: Quick project status overview
agent: explore
subtask: true
---

Provide fast project status without full validation:

1. **Plan Status**: !`if [ -f PLAN.md ]; then head -20 PLAN.md; else echo "No PLAN.md found"; fi`
2. **Git State**: !`git status --porcelain`
3. **Recent Activity**: !`git log --oneline -3`
4. **Current Branch**: !`git branch --show-current`
5. **Quick Metrics**:
   - Files changed: !`git diff --name-only | wc -l`
   - Lines added/removed: !`git diff --stat | tail -1`
   - Untracked files: !`git ls-files --others --exclude-standard | wc -l`

Status indicators:
- 🟢 Clean: No uncommitted changes
- 🟡 WIP: Some changes in progress  
- 🔴 Issues: Validation failures or conflicts

Focus on speed - no expensive validation or compilation steps.
---
description: Audit current changes against plan
agent: general
subtask: true
---

Review current changes against PLAN.md:

Recent changes: !`git diff --staged` !`git diff`

Comprehensive check:
1. **Plan Alignment**: Do changes support plan objectives? [PASS/FAIL]
2. **Code Quality**: Style, patterns, best practices compliance
3. **Test Coverage**: % coverage for affected modules
4. **Documentation**: API docs, README, inline comments updated?
5. **Breaking Changes**: Semantic versioning impact assessment
6. **Performance**: Any regressions or improvements?
7. **Security**: No secrets exposed, proper input validation

Provide structured feedback with:
- Critical issues (blocking)
- Improvements (suggested)
- Compliances (passing)
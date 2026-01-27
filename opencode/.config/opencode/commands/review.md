---
description: Code review for PR - analyze branch changes before merge
subtask: true
---
Please analyze the changes in this branch about to merge into main and focus on
identifying critical issues related to:

- Potential bugs or issues
- Performance
- Security
- Correctness

First, run these commands to understand the changes:
!`git log --oneline main..HEAD`
!`git diff main...HEAD --stat`

Then analyze the full diff:
!`git diff main...HEAD`

If critical issues are found, list them in a few short bullet points. If no
critical issues are found, provide a simple approval. Sign off with a checkbox
indicator: (approved) or (issues found).

Keep your response concise. Only highlight critical issues that must be
addressed before merging. Skip detailed style or minor suggestions unless they
impact performance, security, or correctness.

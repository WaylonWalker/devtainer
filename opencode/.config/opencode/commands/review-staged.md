---
description: Code review for staged changes - analyze before commit
subtask: true
---
Please analyze the staged changes and focus on identifying critical issues related to:

- Potential bugs or issues
- Performance
- Security
- Correctness

Here are the staged changes:
!`git diff --staged`

If critical issues are found, list them in a few short bullet points. If no
critical issues are found, provide a simple approval. Sign off with a checkbox
indicator: (approved) or (issues found).

Keep your response concise. Only highlight critical issues that must be
addressed before committing. Skip detailed style or minor suggestions unless they
impact performance, security, or correctness.

---
description: Suggest commit message for staged changes
model: anthropic/claude-haiku-4-5
subtask: true
---
Analyze this staged diff and suggest a commit message:

!`git diff --staged`

FORMAT:
- Use conventional commits format: type(scope): description
- Types: feat, fix, docs, style, refactor, test, chore
- Keep the subject line under 50 characters
- Add a brief body if the change is complex

Present the suggested commit message. If the user approves, they can commit
with: git commit -m "your message"

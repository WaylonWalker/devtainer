---
description: Read-only agent for code and plan reviews
mode: subagent
tools:
  write: false
  edit: false
permission:
  bash:
    "*": deny
    "raira *": allow
    "git log*": allow
    "git show*": allow
    "git diff*": allow
---
Analyze and provide feedback without making changes. Use @explore for codebase research.

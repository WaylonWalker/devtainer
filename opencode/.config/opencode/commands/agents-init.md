---
description: Initialize AGENTS.md for a project
---
Analyze this codebase and create an AGENTS.md file containing:
1. Build/lint/test commands - especially for running a single test
2. Code style guidelines including imports, formatting, types, naming conventions, error handling, etc.

The file you create will be given to agentic coding agents (such as yourself) that operate in this repository. Make it about 150 lines long.

IMPORTANT FILES TO READ:
- Read existing justfile if present for build/test commands
- Read .pre-commit-config.yaml if present for linting/formatting tools
- If there are Cursor rules (in .cursor/rules/ or .cursorrules), include them
- If there are Copilot rules (in .github/copilot-instructions.md), include them

If there is already an AGENTS.md, improve it rather than replacing it.

Use @explore subagents to research the codebase structure and conventions.

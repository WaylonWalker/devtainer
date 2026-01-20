---
description: Run optimized validation suite
agent: build
subtask: true
---

Run complete validation pipeline using just:

First check available recipes: !`just --list`

Then run validation with parallel execution where possible:
1. **Parallel**: !`just lint` & !`just typecheck` (if both available)
2. **Sequential**: !`just test` (after lint/typecheck pass)
3. **Coverage**: !`just test-coverage` (if tests pass)
4. **Build**: !`just build` (final validation)

If any recipes are missing, run `/sync-justfile` first to create them.

Report failures with specific line numbers and suggested fixes. Exit with error status if any checks fail.
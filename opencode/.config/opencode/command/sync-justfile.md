---
description: Sync justfile with auto-detected project setup
agent: build
subtask: true
---

Ensure justfile has commands needed for PLAN.md validation:

1. Read current PLAN.md and extract validation requirements
2. Auto-detect project type and existing tooling:
   - Python: pyproject.toml, requirements.txt, setup.py
   - TypeScript: package.json, tsconfig.json
   - Rust: Cargo.toml
   - Go: go.mod
3. Read current justfile: @justfile
4. Check for required recipes:
   - `lint` (code linting)
   - `typecheck` or `type-check` (type checking)
   - `test` (run tests)
   - `test-coverage` (tests with coverage if needed)
   - `build` (build/compile if applicable)
   - `dev` or `start` (development server)

5. Add missing recipes with project-specific commands:
   - Python: `ruff check`, `ruff format`, `pytest`, `ty check`
   - TypeScript: `eslint`, `prettier`, `vitest`, `tsc`
   - Rust: `cargo clippy`, `cargo test`, `cargo build`
6. Test each recipe with `just --dry-run` before applying
7. Update justfile with missing validation recipes

Focus on making validation steps language-agnostic but project-aware.

# Python Development Environment Instructions for AI Agents

## Project Detection

**Identify Python projects by the presence of:**
1. `pyproject.toml` (primary indicator)
2. `setup.py` (rare, legacy projects)
3. `uv.lock` (confirms uv-based project)

## Environment Management

**CRITICAL: Never run `python` directly!** Always use one of these methods:

- **Preferred:** `uv run python script.py` or `uv run command`
- **Alternative:** Activate virtual environment with `source .venv/bin/activate`
- **Never:** `python script.py`, `pip install`, `pytest` (bare commands)

**Setup commands:**
```bash
# Install/sync dependencies
uv sync --all-extras

# Create virtual environment
uv venv

# Add dependencies
uv add package_name
```

## Command Execution Priority

**Always follow this order:**

1. **Check for `justfile` first** - Use defined commands for team consistency
2. **Fallback to direct uv commands** if no justfile exists
3. **Never use bare Python commands** (python, pip, pytest, etc.)

## Standard Justfile Commands

Look for these standard commands in justfiles (run with `just <command>`):

```just
# Core development commands
check              # Run multiple checks (lint, typecheck, test)
fix                # Auto-fix issues (ruff check --fix, ruff format)
format             # Code formatting only
lint               # Code linting only
typecheck          # Type checking only
test               # Run tests
test-coverage      # Tests with coverage if needed
build              # Build/compile if applicable
dev or start       # Development server
```

## Core Tooling Commands

**When no justfile exists, use these uv commands:**

### Type Checking with `ty`
```bash
uv run ty check src/          # Check specific directory
uv run ty check .             # Check entire project
```

**About ty:**
- Astral's blazing-fast type checker (same creators as uv and ruff)
- 25x faster than mypy
- Configuration in `pyproject.toml` under `[tool.ty]`
- Rule-based system with error/warn/ignore levels

**Example ty configuration:**
```toml
[tool.ty.rules]
index-out-of-bounds = "ignore"
redundant-cast = "warn"
possibly-missing-attribute = "error"
```

### Code Quality
```bash
uv run ruff format            # Format code
uv run ruff check --fix       # Lint and auto-fix
uv run pytest                 # Run tests
uv run pytest --cov          # Tests with coverage
```

## Development Workflow

**When entering a Python project:**

1. **Detect project type:** Look for `pyproject.toml`
2. **Check for justfile:** `ls justfile` or `ls Justfile`
3. **Set up environment:** `uv sync --all-extras`
4. **Use commands:**
   - If justfile exists: `just <command>`
   - If no justfile: `uv run <command>`

**Example complete workflow:**
```bash
# Enter project
cd /path/to/project

# Detect Python project (pyproject.toml found)

# Check for justfile
if [ -f "justfile" ]; then
    just check      # Use team-defined commands
else
    uv run ruff check --fix
    uv run ty check
    uv run pytest
fi
```

## Common Command Patterns

**Linting and Formatting:**
```bash
just format        # or: uv run ruff format
just lint          # or: uv run ruff check
just fix           # or: uv run ruff check --fix && uv run ruff format
```

**Testing:**
```bash
just test          # or: uv run pytest
just test-coverage # or: uv run pytest --cov
```

**Type Checking:**
```bash
just typecheck     # or: uv run ty check
```

**Complete Quality Check:**
```bash
just check         # Usually runs: format, lint, typecheck, test
```

## Project Structure Expectations

**Typical Python project layout:**
```
project/
├── pyproject.toml      # Project configuration
├── uv.lock            # Dependency lock file
├── justfile           # Team commands (preferred)
├── src/               # Source code
├── tests/             # Test files
└── .venv/             # Virtual environment
```

## Agent Instructions Summary

**For AI agents working on Python projects:**

1. **Always detect** `pyproject.toml` first
2. **Never use bare Python commands** - use `uv run` prefix
3. **Check for justfile** and prefer its commands
4. **Use ty for type checking**, not mypy
5. **Use ruff for formatting and linting**
6. **Use pytest for testing**
7. **Maintain consistency** with team-defined workflows

## Troubleshooting

**Common issues:**
- **"command not found"** → Use `uv run` prefix
- **"module not found"** → Run `uv sync` first
- **Type checker errors** → Ensure virtual environment is active or use `uv run`
- **Permission issues** → Check if virtual environment is properly set up

**Verification:**
```bash
uv run python -c "import sys; print(sys.executable)"  # Should show .venv path
uv run ty --version     # Verify ty installation
uv run ruff --version   # Verify ruff installation
```
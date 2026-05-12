---
date: '2026-02-08'
description: 'uv - fast Python packaging and dependency management'
published: true
title: 'uv'
---

uv is a fast, all-in-one Python packaging and dependency management tool written in Rust. It's a modern replacement for pip, pip-tools, and virtualenv.

## Features

- **Fast** - Written in Rust, significantly faster than pip
- **All-in-one** - Replaces pip, pip-tools, and virtualenv
- **Compatible** - Drop-in replacement for pip commands
- **Universal** - Works with pyproject.toml, requirements.txt, setup.py
- **Cross-platform** - macOS, Linux, Windows
- **Cache optimization** - Smart caching for faster operations

## Setup

### Installation

```bash
# Via mise (recommended)
mise install uv

# Via pip (temporary)
pip install uv

# Via cargo
cargo install uv

# Via curl (script install)
curl -LsSf https://astral.sh/uv/install.sh | sh

# macOS/Linux one-liner
curl -LsSf https://astral.sh/uv/install.sh | sh && source ~/.bashrc
```

### Shell Completion

```bash
# Add to ~/.zshrc or ~/.bashrc
eval "$(uv --shell-completion bash)"
# or for zsh:
eval "$(uv --shell-completion zsh)"
```

## Project Management

### Creating Projects

```bash
# Create new project
uv init my-project
cd my-project

# Create with specific Python version
uv init --python 3.11 my-project

# Create application (not library)
uv init --app my-app
```

### Virtual Environments

```bash
# Create virtual environment
uv venv

# Create with specific Python version
uv venv --python 3.11

# Activate environment
source .venv/bin/activate  # Linux/macOS
# or Windows:
# .venv\Scripts\activate

# Run command in venv without activation
uv run python script.py
uv run pytest
```

## Package Management

### Installing Packages

```bash
# Install packages
uv add requests
uv add "requests>=2.28.0"

# Add dev dependencies
uv add --dev pytest black ruff

# Install from requirements.txt
uv pip install -r requirements.txt

# Install specific version
uv pip install requests==2.28.1
```

### Managing Dependencies

```bash
# List installed packages
uv pip list

# Show package details
uv pip show requests

# Update packages
uv pip install --upgrade requests

# Remove packages
uv remove requests
uv pip uninstall requests

# Sync from pyproject.toml
uv sync
```

## Project Structure

uv expects a modern Python project structure:

```
my-project/
├── pyproject.toml    # Project metadata and dependencies
├── .venv/           # Virtual environment
├── src/             # Source code
│   └── my_project/
├── tests/           # Tests
├── README.md
└── .gitignore
```

### pyproject.toml Example

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
authors = [{name = "Your Name", email = "you@example.com"}]
dependencies = ["requests>=2.28.0"]

[project.optional-dependencies]
dev = ["pytest", "black", "ruff"]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 88

[tool.black]
line-length = 88
```

## Workflows

### Development Workflow

```bash
# 1. Start new project
uv init my-app
cd my-app

# 2. Add dependencies
uv add fastapi uvicorn

# 3. Create virtual environment
uv venv
source .venv/bin/activate

# 4. Run development server
uv run uvicorn main:app --reload
```

### Testing Workflow

```bash
# Add test dependencies
uv add --dev pytest pytest-cov

# Run tests
uv run pytest

# Run with coverage
uv run pytest --cov=my_project

# Run specific test file
uv run pytest tests/test_app.py
```

### Linting & Formatting

```bash
# Add dev tools
uv add --dev black ruff isort

# Format code
uv run black .
uv run ruff check --fix .
uv run isort .
```

## Advanced Features

### Lock Files

```bash
# Generate lock file
uv lock

# Install from lock file
uv sync --locked

# Update lock file
uv lock --upgrade
```

### Python Version Management

```bash
# Install Python versions
uv python install 3.11
uv python install 3.12

# List available versions
uv python list

# Use specific version for project
uv pin 3.11
```

### Publishing

```bash
# Build package
uv build

# Publish to PyPI
uv publish
```

## Migration from pip

| pip command | uv equivalent |
|-------------|---------------|
| `pip install requests` | `uv add requests` |
| `pip install -r requirements.txt` | `uv pip install -r requirements.txt` |
| `pip freeze > requirements.txt` | `uv pip compile pyproject.toml -o requirements.txt` |
| `python -m venv .venv` | `uv venv` |
| `source .venv/bin/activate` | `source .venv/bin/activate` (or use `uv run`) |

## Configuration

### Configuration Files

```bash
# ~/.config/uv/uv.toml (global)
[pip]
# Global pip settings

[install]
# Default install options

# .venv/ (project-local)
# Project-specific settings in pyproject.toml
```

### Environment Variables

```bash
# Set Python version
UV_PYTHON=3.11 uv add requests

# Set cache directory
UV_CACHE_DIR=/path/to/cache

# Disable progress bars
UV_NO_PROGRESS=true uv sync
```

## Integration with Tools

### mise Integration

```bash
# .mise.toml
[tools]
uv = "latest"
python = "3.11"

# mise automatically uses uv for Python projects
```

### Neovim Integration

Use `uv run` as your Python interpreter:

```lua
-- In your neovim config
vim.g.python3_host_prog = 'uv run python'
```

## See Also

![[ mise ]]

![[ ruff ]]

![[ pytest ]]

![embed](https://docs.astral.sh/uv/)
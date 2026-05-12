---
date: '2026-02-07'
description: 'Workspace script - session management automation for tmux'
published: true
title: 'Workspace Script'
---

A custom workspace management script that automates tmux session creation and management for organized project development.

## Overview

The workspace script provides automated tmux session management, making it easy to:

- Create organized session groups
- Quickly switch between projects
- Maintain consistent development environments
- Sync workspace configuration across machines

## Location

```
~/git/workspaces/workspaces.py
```

## Features

- **Git repository discovery** - Automatically find repos in workspace directories
- **Session groups** - Organize related projects
- **Quick attach** - Fast switching between workspaces
- **Configuration sync** - Keep workspace definitions in version control

## Usage

### Basic Commands

```bash
# Attach to workspace (creates if needed)
~/git/workspaces/workspaces.py -W git attach

# Create new workspace
~/git/workspaces/workspaces.py -W git create

# Add current repo to workspace
~/git/workspaces/workspaces.py -W git add
```

### From tmux

The script integrates with tmux keybindings:

| Key | Action |
|-----|--------|
| `Alt+Space` | Attach to workspace |
| `Alt+T` | Attach to workspace in current directory |
| `Alt+Escape` | Create new workspace |
| `Alt+Backspace` | Add repo to workspace |

## How It Works

1. **Discovers repositories** - Scans configured directories for git repos
2. **Creates sessions** - Generates tmux sessions with standardized layouts
3. **Manages windows** - Each repo gets its own window or layout
4. **Syncs config** - Stores workspace definitions in git-tracked files

## Configuration

Workspaces are defined in:

```
~/.config/workspaces/config.toml
```

Example:

```toml
[workspaces.git]
path = "~/git"
auto_discover = true
layout = "main-vertical"

[workspaces.work]
path = "~/work"
auto_discover = false
repos = ["project1", "project2"]
```

## Integration with tmux

The script is called from tmux keybindings in `~/.tmux.conf`:

```bash
bind -n M-Space display-popup -T 'attach to workspace' -E -d '~/git' "~/git/workspaces/workspaces.py -W git attach"
```

This creates popup windows for workspace management without leaving your current context.

## See Also

![[ tmux ]]

![[ zsh ]]

![embed](https://github.com/nvim-telescope/telescope-project.nvim)

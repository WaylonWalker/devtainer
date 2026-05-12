---
date: '2026-02-07'
description: 'tmux configuration for persistent terminal sessions with popup windows and session management'
published: true
title: 'tmux Configuration'
---

tmux is a terminal multiplexer that lets you switch easily between several
programs in one terminal, detach them (they keep running in the background) and
reattach them to a different terminal.

## Features

- **Popup windows** - Quick access to sessions and tools without leaving current
  context
- **Session management** - Easy switching between projects
- **Vi mode** - Familiar keybindings for copy mode
- **Minimal status bar** - Hidden by default, toggle when needed

## Setup

### Installation

Install via mise:

```bash
mise install tmux
```

Or your package manager:

```bash
# Ubuntu/Debian
sudo apt install tmux

# Arch Linux
sudo pacman -S tmux
```

### Configuration

The config file is `~/.tmux.conf`. Main settings:

```bash
# Vi mode for copy/paste
setw -g mode-keys vi

# Don't detach on destroy
set-option -g detach-on-destroy off

# Focus events for nvim integration
set-option -g focus-events on

# Hidden status bar by default
set-option -g status off
```

## Key Bindings

### Prefix

The prefix key is `Ctrl+Space` (custom):

```bash
bind Space send-prefix
```

### Session Management

| Key | Action |
|-----|--------|
| `Alt+Space` | Popup: attach to workspace session |
| `Alt+T` | Popup: attach to workspace in current directory |
| `Alt+Escape` | Popup: create new workspace |
| `Alt+Backspace` | Popup: add repo to workspace |
| `Ctrl+J` | Popup: switch to any session with fzf |
| `Alt+G` | Popup: open scratch session |
| `Alt+Shift+G` | Popup: open scratch session (large) |
| `Ctrl+K` | Popup: kill sessions |
| `J` | tmux session tree browser |

### Copy Mode

| Key | Action |
|-----|--------|
| `Alt+[` | Enter copy mode |
| `Alt+V` | Enter copy mode |
| `Alt+Enter` | Enter copy mode |
| `Enter` | Enter copy mode |

Copy uses `wl-copy` on Wayland or `xclip` on X11.

### Status Bar

| Key | Action |
|-----|--------|
| `Prefix+s` | Toggle status bar |
| `Prefix+Ctrl+S` | Toggle status bar |

### Git Integration

| Key | Action |
|-----|--------|
| `Alt+F` | Popup: git commit --verbose |
| `Alt+Shift+F` | Popup: gitui |

### Workspaces

| Key | Action |
|-----|--------|
| `Ctrl+W` | Popup: attach to ~/work |
| `Alt+W` | Popup: attach to ~/work |
| `Ctrl+G` | Popup: attach to ~/git |
| `Ctrl+P` | Popup: attach to ~/project |
| `Ctrl+T` | New session: todo list in nvim |

## Popup Windows

Popups are a key feature - they let you access tools without leaving your
current context:

```bash
# Example: switch sessions without leaving current window
bind C-j display-popup -E "\
    tmux list-sessions -F '#{?session_attached,,#{session_name}}' |\
    sed '/^$/d' |\
    fzf --reverse --header jump-to-session --preview 'tmux capture-pane -pt {}' \\
        --bind 'enter:execute(tmux switch-client -t {})+accept'"
```

## Workflows

### Project Hopping

1. `Alt+Space` to see all workspace sessions
2. `Ctrl+J` to fuzzy-find any session
3. `Alt+G` for a quick scratch pad

### Git Workflow

1. `Alt+F` to write a commit message in a popup
2. `Alt+Shift+F` for full gitui when needed

### Todo Management

1. `Ctrl+T` opens a dedicated todo session with three files:
   - `backlog.md` - Things to do eventually
   - `doing.md` - Currently working on
   - `done.md` - Completed tasks

## Clipboard Integration

Copy mode automatically integrates with system clipboard:

```bash
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel \\
    "bash -c 'command -v wl-copy >/dev/null && wl-copy || \\
    xclip -i -f -selection primary | xclip -i -selection clipboard'"
```

## See Also

![[ zellij ]]

![[ zsh ]]

![[ workspace ]]

![embed](https://github.com/tmux/tmux/wiki)

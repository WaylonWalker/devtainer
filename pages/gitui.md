---
date: '2026-02-07'
description: 'gitui - a blazing-fast terminal UI for git'
published: true
title: 'gitui'
---

gitui is a blazing-fast terminal UI for git written in Rust. It provides a keyboard-driven interface for common git operations with minimal dependencies and excellent performance.

![gitui staging workflow](/tapes/gitui-intro.mp4)

## Features

- **Fast** - Written in Rust, starts instantly
- **Keyboard-driven** - No mouse required
- **Minimal dependencies** - Single binary
- **Async operations** - Non-blocking UI
- **Popup friendly** - Works great in tmux popups

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install gitui

# Arch Linux
sudo pacman -S gitui

# macOS
brew install gitui

# Cargo
cargo install gitui
```

## Launching

```bash
gitui
```

Or from within a git repo with `Ctrl+G` (from zsh config).

## Key Bindings

### Global

| Key | Action |
|-----|--------|
| `?` | Help |
| `q` | Quit |
| `Tab` | Switch panel (Status, Log, Diff) |
| `1-3` | Jump to panel |

### Status Panel

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate files |
| `Space` | Stage/unstage file |
| `Enter` | View diff |
| `a` | Stage all |
| `r` | Revert changes |
| `c` | Commit |
| `p` | Push |
| `f` | Pull/Fetch |
| `b` | Branch |
| `h` | Stash |

### Commit

| Key | Action |
|-----|--------|
| `c` | Open commit dialog |
| `Ctrl+s` | Submit commit |
| `Esc` | Cancel |

### Log Panel

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate commits |
| `Enter` | View commit details |
| `r` | Revert commit |
| `e` | Edit past commit (rebase) |

### Branch

| Key | Action |
|-----|--------|
| `b` | Open branch list |
| `c` | Create branch |
| `d` | Delete branch |
| `m` | Merge branch |
| `Enter` | Checkout branch |

## tmux Integration

From `.tmux.conf`:

```bash
bind -n M-F display-popup -h 95% -w 95% -d '#{pane_current_path}' -E 'gitui'
```

Opens gitui in a popup with `Alt+Shift+F` for full-screen git operations.

From `.zshrc`:

```bash
bindkey -s '^g' 'gitui\n'
```

Opens gitui with `Ctrl+G` in current shell.

## Workflow

Typical git workflow with gitui:

1. **Edit files** in neovim
2. **Stage changes** with `Space` in gitui
3. **Review diff** with `Enter`
4. **Commit** with `c` and write message
5. **Push** with `p`

All without leaving the terminal or using a mouse.

## Comparison with lazygit

gitui is my primary git TUI because:

- **Simpler** - Less configuration needed
- **Faster** - Smaller binary, quicker startup
- **Popup-friendly** - Works great in tmux popups
- **Rust** - Aligns with my other Rust tools

I keep lazygit installed as an alternative when I need more advanced features.

## See Also

![[ git ]]

![[ lazygit ]]

![[ tmux ]]

![embed](https://github.com/extrawurst/gitui)

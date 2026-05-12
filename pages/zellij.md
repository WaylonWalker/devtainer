---
date: '2026-02-07'
description: 'Zellij - a terminal workspace with batteries included'
published: true
title: 'Zellij'
---

Zellij is a terminal workspace with batteries included. It's a modern alternative to tmux and screen.

## Features

- **Layout system** - Define window layouts in YAML
- **Plugins** - Extend functionality with WebAssembly plugins
- **Rust-based** - Fast and safe implementation
- **WebAssembly** - Plugin system built on WASM
- **Easy to use** - Sensible defaults, minimal configuration

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install zellij

# Arch Linux
sudo pacman -S zellij

# macOS
brew install zellij

# Cargo
cargo install zellij
```

## Launching

```bash
# Start new session
zellij

# Start with specific layout
zellij --layout mylayout

# Attach to existing
zellij attach

# List sessions
zellij list-sessions
```

## Key Bindings

Zellij uses `Ctrl+g` as the prefix key:

### Session

| Key | Action |
|-----|--------|
| `Ctrl+g` `d` | Detach |
| `Ctrl+g` `q` | Quit |
| `Ctrl+g` `s` | Session manager |

### Panes

| Key | Action |
|-----|--------|
| `Ctrl+g` `n` | New pane (horizontal) |
| `Ctrl+g` `p` | New pane (vertical) |
| `Ctrl+g` `x` | Close pane |
| `Ctrl+g` `h/j/k/l` | Move between panes |
| `Ctrl+g` `f` | Fullscreen pane |
| `Alt+Arrow` | Move between panes (no prefix) |

### Tabs

| Key | Action |
|-----|--------|
| `Ctrl+g` `c` | New tab |
| `Ctrl+g` `,` | Rename tab |
| `Ctrl+g` `Ctrl+h/l` | Previous/next tab |
| `Ctrl+g` `[1-9]` | Go to tab |

### Scroll/Search

| Key | Action |
|-----|--------|
| `Ctrl+g` `[` | Enter scroll mode |
| `Ctrl+s` | Search (in scroll mode) |
| `n/N` | Next/previous match |
| `Esc` | Exit scroll mode |

## Layouts

Create layouts in `~/.config/zellij/layouts/`:

```yaml
# ~/.config/zellij/layouts/dev.yaml
template:
  direction: Horizontal
  parts:
    - direction: Vertical
      split_size:
        Percent: 50
      parts:
        - direction: Vertical
        - direction: Vertical
    - direction: Vertical
      split_size:
        Percent: 50
      parts:
        - direction: Vertical
          run:
            command: {cmd: cargo, args: ["watch", "-x", "run"]}
```

Use: `zellij --layout dev`

## Configuration

Config file: `~/.config/zellij/config.kdl`

Example:

```kdl
theme "dracula"

default_shell "zsh"

keybinds {
    normal {
        bind "Ctrl a" { SwitchToMode "Tmux"; }
    }
}

plugins {
    filepicker location="zellij:filepicker"
}
```

## See Also

![[ tmux ]]

![[ zsh ]]

![[ workspace ]]

![[ cheatsheets/session-management ]]

![embed](https://zellij.dev/documentation/)

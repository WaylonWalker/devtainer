---
date: '2026-02-07'
description: 'Yazi - a terminal file manager'
published: true
title: 'Yazi'
---

Yazi is a blazing-fast terminal file manager written in Rust with async I/O.

## Features

- **Async I/O** - Non-blocking file operations
- **Fast** - Written in Rust, optimized for speed
- **Previews** - Built-in image, video, and code previews
- **Customizable** - Keybindings, themes, and plugins
- **Integration** - Works with neovim, tmux, shells

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install yazi

# Or install script
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Then cargo install yazi-fm

# Arch Linux (AUR)
yay -S yazi
```

## Configuration

Config directory: `~/.config/yazi/`

- `yazi.toml` - General configuration
- `keymap.toml` - Key bindings
- `theme.toml` - Colors and styling

## Key Bindings

### Navigation

| Key | Action |
|-----|--------|
| `j/k` or `↓/↑` | Move down/up |
| `h/l` or `←/→` | Parent/child directory |
| `gg` | Go to top |
| `G` | Go to bottom |
| `H` | Back in history |
| `L` | Forward in history |

### File Operations

| Key | Action |
|-----|--------|
| `Space` | Select item |
| `y` | Yank (copy) |
| `x` | Cut |
| `p` | Paste |
| `d` | Delete |
| `D` | Permanent delete |
| `r` | Rename |
| `a` | Create file |
| `A` | Create directory |
| `Enter` | Open file |
| `o` | Open with specific app |

### View

| Key | Action |
|-----|--------|
| `Tab` | Switch panel |
| `~` | Go to home |
| `.` | Toggle hidden files |
| `s` | Search files |
| `S` | Search contents |
| `/` | Filter items |
| `z` | Jump to directory |
| `c` | Copy path |

## Shell Integration

Add to `~/.zshrc`:

```bash
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
```

Then use `yy` to launch yazi and automatically cd to the last visited directory on exit.

## See Also

![[ neovim ]]

![[ zsh ]]

![embed](https://yazi-rs.github.io/)

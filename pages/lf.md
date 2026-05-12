---
date: '2026-02-07'
description: 'lf - a terminal file manager written in Go'
published: true
title: 'lf'
---

lf is a terminal file manager written in Go, heavily inspired by ranger. It focuses on simplicity and speed with minimal dependencies.

![lf demo](/tapes/lf-intro.mp4)

## Features

- **Fast** - Written in Go, starts instantly
- **Minimal** - Single binary, no runtime dependencies
- **Configurable** - Shell commands for previews and custom actions
- **Mouse support** - Optional mouse integration
- **Server mode** - Remote file management via client/server

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install lf

# Arch Linux
sudo pacman -S lf

# macOS
brew install lf

# Go install
go install github.com/gokcehan/lf@latest
```

## Configuration

Config file: `~/.config/lf/lfrc`

Example configuration:

```bash
# Basic settings
set preview true
set drawbox true
set hidden true
set ignorecase true

# Key mappings
map gh cd ~
map g/ cd /
map E $$EDITOR $f

# Custom commands
map D delete
map x cut
map y copy
map p paste

# Previewer
set previewer ~/.config/lf/preview
```

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
| `~` | Go to home |

### File Operations

| Key | Action |
|-----|--------|
| `Space` | Toggle selection |
| `y` | Yank (copy) |
| `d` | Cut |
| `p` | Paste |
| `D` | Delete |
| `r` | Rename |
| `a` | Create file |
| `A` | Create directory |
| `E` | Open with $EDITOR |
| `Enter` | Open file |

### View

| Key | Action |
|-----|--------|
| `.` | Toggle hidden files |
| `i` | Toggle preview |
| `zh` | Toggle hidden files |

## tmux Integration

From `.tmux.conf`:

```bash
bind -n M-e display-popup -d '#{pane_current_path}' -h 100% -w 75% -x 0 -E "lf"
```

This opens lf in a popup window with Alt+E, starting in the current pane's directory.

![lf in tmux popup workflow](/tapes/lf-tmux-popup.mp4)

## Previews

lf uses external programs for previews. Create `~/.config/lf/preview`:

```bash
#!/bin/sh
case "$1" in
    *.txt|*.md) cat "$1" ;;
    *.jpg|*.png) viu "$1" ;;
    *) file "$1" ;;
esac
```

## Shell Integration

Add to `~/.zshrc`:

```bash
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$PWD" ] && cd "$dir"
    fi
}
```

Then use `lfcd` to launch lf and automatically cd to the last visited directory on exit.

## See Also

![[ yazi ]]

![[ zsh ]]

![embed](https://github.com/gokcehan/lf)

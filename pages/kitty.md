---
date: '2026-02-07'
description: 'kitty - a fast, feature-rich, GPU-based terminal emulator'
published: true
title: 'kitty Terminal'
---

kitty is a fast, feature-rich, GPU-based terminal emulator that offloads rendering to the GPU for smooth performance.

## Features

- **GPU acceleration** - Renders text using the GPU for better performance
- **Tabs and windows** - Built-in multiplexing without needing tmux
- **Unicode support** - Excellent support for emojis and international characters
- **Image support** - Display images directly in the terminal
- ** kittens** - Extend functionality with Python scripts

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo apt install kitty

# Arch Linux
sudo pacman -S kitty

# macOS
brew install kitty
```

Or via mise:

```bash
mise install kitty
```

## Configuration

Config file: `~/.config/kitty/kitty.conf`

Key settings from my config:

```bash
# Font
font_family      JetBrains Mono
font_size        12.0

# Opacity
background_opacity 0.95

# Cursor
cursor_shape     block
cursor_blink_interval 0

# Scrollback
scrollback_lines 10000
```

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+Shift+Enter` | New window |
| `Ctrl+Shift+W` | Close window |
| `Ctrl+Shift+]` | Next window |
| `Ctrl+Shift+[` | Previous window |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+Q` | Close tab |
| `Ctrl+Shift+Right` | Next tab |
| `Ctrl+Shift+Left` | Previous tab |
| `Ctrl+Shift+Up` | Scroll up |
| `Ctrl+Shift+Down` | Scroll down |
| `Ctrl+Shift+G` | Show last command output |
| `Ctrl+Shift+H` | Browse scrollback in less |

## kittens

kittens are small Python programs that extend kitty:

```bash
# SSH with kitty enhancements
kitty +kitten ssh hostname

# Diff files with image support
kitty +kitten diff file1 file2

# Transfer files over SSH
kitty +kitten transfer file.txt remote:
```

## Integration with tmux

While kitty has its own multiplexing, I often use it with tmux for session persistence:

```bash
# Start kitty with tmux
kitty tmux
```

## See Also

![[ wezterm ]]

![[ tmux ]]

![embed](https://sw.kovidgoyal.net/kitty/)

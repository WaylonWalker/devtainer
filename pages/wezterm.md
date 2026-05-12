---
date: '2026-02-07'
description: 'WezTerm - a GPU-accelerated cross-platform terminal emulator'
published: true
title: 'WezTerm'
---

WezTerm is a GPU-accelerated cross-platform terminal emulator and multiplexer written in Rust.

## Features

- **Cross-platform** - Works on Linux, macOS, and Windows
- **GPU-accelerated** - Smooth rendering using OpenGL
- **Lua configuration** - Powerful scripting with Lua
- **Built-in multiplexer** - Tabs and panes without external tools
- **SSH client** - Native SSH support with terminal features

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
# Download .deb from GitHub releases

# Arch Linux
sudo pacman -S wezterm

# macOS
brew install --cask wezterm

# Windows
# Download from GitHub releases or use winget
winget install wez.wezterm
```

## Configuration

Config file: `~/.config/wezterm/wezterm.lua`

Example configuration:

```lua
local wezterm = require 'wezterm'

return {
    font = wezterm.font 'JetBrains Mono',
    font_size = 12.0,
    color_scheme = 'Dracula',
    window_background_opacity = 0.95,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
}
```

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Shift+Tab` | Next tab |
| `Ctrl+Shift+Enter` | Split pane vertically |
| `Ctrl+Shift+%` | Split pane horizontally |
| `Ctrl+Shift+Arrow` | Move between panes |
| `Ctrl+Shift+Space` | Quick select mode |
| `Ctrl+Shift+F` | Search scrollback |

## Multiplexer Features

WezTerm includes a built-in multiplexer that can replace tmux:

```lua
-- Enable multiplexing
config.leader = { key = 'a', mods = 'CTRL' }
config.keys = {
    { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
}
```

## See Also

![[ kitty ]]

![[ tmux ]]

![embed](https://wezfurlong.org/wezterm/)

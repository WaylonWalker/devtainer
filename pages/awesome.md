---
date: '2026-02-07'
description: 'Awesome WM - a highly configurable X11 window manager'
published: true
title: 'Awesome Window Manager'
---

Awesome is a highly configurable, next-generation window manager for X11 written in Lua.

## Features

- **Dynamic tiling** - Automatic window tiling with multiple layouts
- **Tag-based workspaces** - Up to 9 virtual tags per screen
- **Lua configuration** - Fully programmable in Lua
- **Low resource usage** - Minimal memory and CPU footprint
- **Extensible** - Widgets, menus, and themes via Lua

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo apt install awesome

# Arch Linux
sudo pacman -S awesome

# Fedora
sudo dnf install awesome
```

## Configuration

Config file: `~/.config/awesome/rc.lua`

Key sections:

- **Tags** - Virtual workspaces
- **Layouts** - How windows are arranged
- **Key bindings** - Keyboard shortcuts
- **Rules** - Window behavior by application
- **Widgets** - Status bar elements

## Default Key Bindings

Awesome uses `Mod4` (Windows/Super key) as modifier:

| Key | Action |
|-----|--------|
| `Mod4+Enter` | Open terminal |
| `Mod4+r` | Run prompt |
| `Mod4+Shift+q` | Quit Awesome |
| `Mod4+Ctrl+r` | Restart Awesome |
| `Mod4+j/k` | Focus next/previous window |
| `Mod4+Shift+j/k` | Swap with next/previous window |
| `Mod4+h/l` | Change master width |
| `Mod4+Space` | Next layout |
| `Mod4+Shift+Space` | Previous layout |
| `Mod4+1-9` | Switch to tag |
| `Mod4+Shift+1-9` | Move window to tag |

## Layouts

Built-in layouts include:

- **tile** - Master and stack layout
- **tile.left** - Master on right
- **tile.bottom** - Master on top
- **tile.top** - Master on bottom
- **fair** - Equal window sizes
- **max** - Fullscreen
- **magnifier** - Master magnified
- **floating** - Free-form windows

## Widgets

Create custom widgets in Lua:

```lua
-- Clock widget
mytextclock = wibox.widget.textclock()

-- Battery widget
battery = awful.widget.watch(
    "acpi -b",
    30,
    function(widget, stdout)
        local status = stdout:match("Battery %d: (%a+), (%d+)%%")
        widget:set_text(" BAT: " .. status .. " ")
    end
)
```

## See Also

![[ hyprland ]]

![[ polybar ]]

![embed](https://awesomewm.org/doc/)

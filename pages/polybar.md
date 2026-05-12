---
date: '2026-02-07'
description: 'Polybar - a fast and easy-to-use status bar for X11'
published: true
title: 'Polybar'
---

Polybar is a fast and easy-to-use status bar for X11 window managers.

## Features

- **Lightweight** - Minimal resource usage
- **Modular** - Enable only what you need
- **Themable** - Extensive customization options
- **Multi-monitor** - Support for multiple displays
- **Font icons** - Support for Nerd Fonts and icons

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo apt install polybar

# Arch Linux
sudo pacman -S polybar

# Fedora
sudo dnf install polybar

# Build from source
# See GitHub releases for latest version
```

## Configuration

Config file: `~/.config/polybar/config.ini`

Structure:

```ini
[bar/main]
width = 100%
height = 24
background = #1e1e2e
foreground = #cdd6f4

font-0 = "JetBrains Mono:size=10;2"
font-1 = "Font Awesome 6 Free:size=10;2"

modules-left = bspwm xwindow
modules-center = date
modules-right = volume network battery

[module/date]
type = internal/date
interval = 1
date = %Y-%m-%d
time = %H:%M
label = %date% %time%

[module/volume]
type = internal/pulseaudio
label-volume = VOL %percentage%%
```

## Launching

Add to your window manager startup:

```bash
# Kill existing
killall -q polybar

# Launch
polybar main &
```

## Common Modules

- **i3** - i3 workspace integration
- **bspwm** - BSPWM workspace integration
- **xwindow** - Active window title
- **xworkspaces** - EWMH workspace support
- **date** - Clock and calendar
- **alsa** / **pulseaudio** - Volume control
- **battery** - Battery status
- **cpu** - CPU usage
- **memory** - RAM usage
- **network** - Network status
- **temperature** - System temperature

## Custom Script Module

```ini
[module/custom-script]
type = custom/script
exec = ~/.config/polybar/scripts/custom.sh
interval = 5
label = %output%
```

## See Also

![[ awesome ]]

![[ waybar ]]

![embed](https://github.com/polybar/polybar)

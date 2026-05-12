---
date: '2026-02-07'
description: 'Waybar - a highly customizable Wayland bar'
published: true
title: 'Waybar'
---

Waybar is a highly customizable Wayland bar for Sway and other wlroots-based compositors.

## Features

- **Wayland native** - No XWayland needed
- **CSS styling** - Full CSS3 support for theming
- **Modular** - Use only the modules you need
- **Custom scripts** - Display any information via custom modules
- **System tray** - Support for tray icons

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo apt install waybar

# Arch Linux
sudo pacman -S waybar

# Fedora
sudo dnf install waybar
```

## Configuration

Config file: `~/.config/waybar/config`

Example configuration:

```json
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["sway/window"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "clock", "tray"],
    
    "sway/workspaces": {
        "format": "{name}"
    },
    
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}"
    },
    
    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""]
    }
}
```

## Styling

Style file: `~/.config/waybar/style.css`

Example styling:

```css
* {
    font-family: "JetBrains Mono", sans-serif;
    font-size: 13px;
}

window#waybar {
    background-color: #1e1e2e;
    color: #cdd6f4;
}

#workspaces button {
    padding: 0 10px;
    color: #cdd6f4;
}

#workspaces button.focused {
    background-color: #313244;
}

#clock {
    padding: 0 10px;
}
```

## Common Modules

- **clock** - Date and time
- **battery** - Battery status
- **cpu** - CPU usage
- **memory** - RAM usage
- **network** - Network status
- **pulseaudio** - Volume control
- **tray** - System tray
- **workspaces** - Workspace tags
- **window** - Active window title
- **custom** - Custom scripts

## Custom Module Example

```json
"custom/weather": {
    "format": "{}",
    "exec": "curl -s wttr.in/?format=1",
    "interval": 3600
}
```

## See Also

![[ hyprland ]]

![[ polybar ]]

![embed](https://github.com/Alexays/Waybar)

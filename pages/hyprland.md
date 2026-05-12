---
date: '2026-02-07'
description: 'Hyprland - a dynamic tiling Wayland compositor'
published: true
title: 'Hyprland Window Manager'
---

[Hyprland](https://hyprland.org/) is a dynamic tiling Wayland compositor that
doesn't sacrifice on its looks. It provides smooth animations, great
functionality, and an easy-to-use configuration.

## Features

- **Dynamic tiling** - Windows tile automatically with no manual layouts
- **Wayland native** - Modern protocol, better performance
- **Smooth animations** - Beautiful window transitions
- **Layer shell** - Status bars and notifications work properly
- **XWayland** - Run X11 applications seamlessly

## Setup

### Installation

On Arch Linux:

```bash
sudo pacman -S hyprland
```

On other distributions, see the [official installation
guide](https://wiki.hyprland.org/Getting-Started/Installation/).

### Configuration

Config files live in `~/.config/hypr/`:

- `hyprland.conf` - Main configuration
- `monitors.conf` - Monitor layouts and resolutions
- `bindings.conf` - Key bindings
- `autostart.conf` - Applications to start on launch

### Cursor Theme

This setup uses the KDE Breeze XCursor theme rather than hyprcursor:

```bash
env = XCURSOR_THEME,breeze_cursors
env = XCURSOR_SIZE,24

cursor {
    enable_hyprcursor = false
}
```

To restore the cursor setup on a new machine:

```bash
./scripts/setup-user-cursor.sh
sudo ./scripts/setup-system-cursor.sh
```

Use `breeze_cursors`, not `Breeze`. On this system `Breeze` is an icon theme,
while `breeze_cursors` is the actual cursor theme.

The user setup script updates GTK cursor settings in place so it does not need
to take over the rest of the GTK theme config.

## Window Rules

Applications automatically go to specific workspaces:

```bash
# Workspace assignments
windowrule = workspace 1, match:class ^(steam)$
windowrule = workspace 4, match:class ^(kitty)$
windowrule = workspace 5, match:class ^(firefox)$
windowrule = workspace 5, match:class ^(brave-browser)$
windowrule = workspace 6, match:class ^(signal)$
windowrule = workspace 8, match:class ^(brave-chat.openai.com__-Default)$
windowrule = workspace 9, match:class ^(org.prismlauncher.PrismLauncher)$

# Float certain windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on, match:class ^(xdg-desktop-portal-gtk)$
```

## Workspaces

Workspaces are organized by function:

| Workspace | Purpose |
|-----------|---------|
| 1 | Steam/Games |
| 2 | Graphics (Krita) |
| 3 | General |
| 4 | Terminals |
| 5 | Web Browsers |
| 6 | Chat (Signal) |
| 7 | Media |
| 8 | Web Apps (ChatGPT, YouTube) |
| 9 | Minecraft |
| 10 | System |

## Default Key Bindings

Hyprland uses a `SUPER` (Windows/Super) key modifier:

### Window Management

| Key | Action |
|-----|--------|
| `SUPER+Q` | Close window |
| `SUPER+Shift+Q` | Force kill window |
| `SUPER+T` | Toggle floating |
| `SUPER+F` | Toggle fullscreen |
| `SUPER+J` | Toggle split direction |

### Navigation

| Key | Action |
|-----|--------|
| `SUPER+arrow keys` | Change window focus |
| `SUPER+Shift+arrow keys` | Move window |
| `SUPER+1-0` | Switch to workspace |
| `SUPER+Shift+1-0` | Move window to workspace |

### Mouse

- `SUPER+LMB` - Move window
- `SUPER+RMB` - Resize window

## Scripts

Custom scripts in `~/.config/hypr/scripts/`:

### terminal.sh

Launch terminal with specific rules:

```bash
#!/usr/bin/env bash
kitty --class=kitty
```

### focus_or_launch.sh

Focus a window if it exists, otherwise launch it:

```bash
#!/usr/bin/env bash
# Usage: focus_or_launch <class> <command>
```

### toggle_waybar.sh

Toggle the status bar visibility:

```bash
#!/usr/bin/env bash
killall -SIGUSR1 waybar
```

## Autostart

Applications started automatically:

```bash
# From autostart.conf
exec-once = waybar
exec-once = hyprpaper
exec-once = mako  # Notification daemon
```

## Environment Variables

Wayland-specific settings:

```bash
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
```

## Troubleshooting

### Applications won't launch

Check if they're trying to use X11:

```bash
# Force XWayland for problematic apps
windowrule = xwayland, match:class ^(app-name)$
```

### Screen sharing not working

Ensure xdg-desktop-portal-hyprland is installed:

```bash
sudo pacman -S xdg-desktop-portal-hyprland
```

## See Also

![[ awesome ]]

![[ waybar ]]

![embed](https://wiki.hyprland.org/)

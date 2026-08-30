---
date: '2026-02-07'
description: 'Getting started with these dotfiles - installation and setup guide'
published: true
title: 'Getting Started'
---

This guide will help you set up these dotfiles on your own machine.

## Prerequisites

You'll need the following installed:

- Git
- A terminal emulator (kitty, wezterm, or alacritty recommended)
- zsh shell
- curl or wget

## Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/waylonwalker/devtainer.git ~/devtainer
cd ~/devtainer
```

### 2. Install Tools

The recommended way to install development tools is using [[mise]]:

```bash
# Install mise
curl https://mise.run | sh

# Activate mise in your shell
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

# Install all tools from the config
mise install
```

### 3. Symlink Configurations

Use [stow](https://www.gnu.org/software/stow/) or manual symlinks to install
configs:

```bash
# Using stow (if available)
stow zsh starship tmux

# Or manually
ln -sf ~/devtainer/zsh/.zshrc ~/.zshrc
ln -sf ~/devtainer/tmux/.tmux.conf ~/.tmux.conf
```

### 4. Apply Cursor Defaults

To keep the Breeze cursor in both Hyprland and SDDM after a fresh install, run:

```bash
./scripts/setup-user-cursor.sh
sudo ./scripts/setup-system-cursor.sh
```

The user script stows `hypr` and `icons`, then updates the GTK cursor settings
in place. The system script installs the SDDM cursor config and the system
default icon theme.

The scripts check for `stow`, `python3`, and an installed Breeze cursor theme.
If the theme is missing, install `breeze` on Arch or `breeze-cursor-theme` on
Ubuntu or Debian.

Run the same setup with:

```bash
just setup-cursors
```

## Recommended Order

1. **Shell** - Start with zsh for a better shell experience
2. **Terminal** - Install kitty or wezterm
3. **Editor** - Set up neovim with your preferred config
4. **Multiplexer** - Add tmux for session management
5. **Window Manager** - Hyprland (Wayland) or Awesome (X11)
6. **Cursor defaults** - Apply the user and system cursor setup scripts

## Omarchy (Hyprland) Hosts

Omarchy-specific and terminal configs live in dedicated stow packages. On a
fresh Omarchy install, apply them after Omarchy has generated its stock
configs:

```bash
cd ~/devtainer
stow omarchy omarchy-hypr alacritty foot ghostty kitty
```

- `omarchy/` → `~/.config/omarchy/` (shell bar, hooks, extensions, branding,
  default agent)
- `omarchy-hypr/` → `~/.config/hypr/` (personal `.lua` overrides: bindings,
  monitors, looknfeel, input, autostart; plus `hyprsunset.conf`, `xdph.conf`)
- `alacritty/`, `foot/`, `ghostty/`, `kitty/` → the matching `~/.config/<app>/`

`omarchy-hypr` holds only your override files (not Omarchy's generated
`hyprland.lua` entrypoint) so `omarchy update` can keep refreshing its defaults
without clobbering your personal bindings. Reload the shell/bar with
`omarchy restart shell` and validate Hyprland with `hyprctl reload`.

> `omarchy-hypr` and the legacy self-managed `hypr/` package both target
> `~/.config/hypr/` and are mutually exclusive. Use `omarchy-hypr` on Omarchy
> machines only.

## Tool-Specific Setup

Each tool has its own setup page:

- [[zsh#setup|zsh Setup]]
- [[tmux#setup|tmux Setup]]
- [[neovim#setup|neovim Setup]]
- [[hyprland#setup|hyprland Setup]]

## Troubleshooting

### Config not loading

Ensure symlinks are correct:

```bash
ls -la ~ | grep zshrc
```

### Tool not found

Check that mise is activated and tools are installed:

```bash
mise list
which zsh
```

### Permission issues

Some scripts may need executable permissions:

```bash
chmod +x ~/devtainer/scripts/*
```

## Next Steps

Once you have the basics set up, explore the individual tool documentation to
learn about features and customization options.

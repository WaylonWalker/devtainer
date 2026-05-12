---
date: '2026-02-07'
description: 'Hardware and software I use daily'
published: true
tags: ['slash']
title: 'Uses'
---

This is my setup - the hardware and software I use every day for development.

## Hardware

### Development Machine

*(Update with your actual specs)*

- **CPU**: AMD Ryzen or Intel
- **RAM**: 32GB+
- **Storage**: NVMe SSD
- **GPU**: Integrated or dedicated for external displays
- **Displays**: Multiple monitors for productivity

### Peripherals

- **Keyboard**: Mechanical with custom layout
- **Mouse**: Trackball or ergonomic mouse (used minimally)
- **Webcam**: For video calls
- **Microphone**: For recording and calls

### Mobile

*(Update with your actual devices)*

- **Phone**: Android or iOS
- **Tablet**: For reading and media

## Software Stack

### Operating System

- **OS**: Arch Linux
- **Window Manager**: Hyprland (Wayland)
- **Terminal**: kitty
- **Shell**: zsh with starship prompt

### Development Environment

- **Editor**: Neovim (lazy.nvim based config)
- **Multiplexer**: tmux
- **Version Control**: git with delta and gitui
- **Tool Manager**: mise
- **Container**: podman

### Daily Tools

- **Browser**: Brave
- **Password Manager**: Bitwarden
- **Notes**: Markdown files in git
- **Chat**: Signal
- **Music**: Streaming service

### CLI Tools

Essential command-line tools:

- `fzf` - Fuzzy finder
- `ripgrep` - Fast code search
- `fd` - Fast file finder
- `bat` - Syntax-highlighting cat
- `eza` - Modern ls replacement
- `zoxide` - Smart cd command
- `atuin` - Shell history
- `lf` - File manager (primary)
- `yazi` - Alternative file manager

### Neovim Plugins

Key plugins I rely on:

- lazy.nvim - Plugin manager
- telescope.nvim - Fuzzy finder
- nvim-lspconfig - LSP support
- nvim-treesitter - Syntax highlighting
- gitsigns.nvim - Git integration
- lualine.nvim - Status line

## Dotfiles Management

All configurations are in the devtainer repository:

```bash
git clone https://github.com/waylonwalker/devtainer.git ~/devtainer
```

Installed via symlinks or stow.

## Workflow

1. Terminal (kitty) always open with tmux
2. Neovim for all editing
3. Browser for research and documentation
4. Git for version control
5. Containers for isolated environments

## Inspiration

This /uses page is inspired by [uses.tech](https://uses.tech/) - a collection of developer setups.

See [[defaults]] for my default tool choices when starting new projects.

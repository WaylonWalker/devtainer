---
date: '2026-02-07'
description: 'Overview of my personal dotfiles - a collection of configurations for a productive development environment'
published: true
title: 'Dotfiles Overview'
slug: ''
---

Welcome to my personal dotfiles documentation. This is a collection of
configurations that I've built up over years of tweaking my development
environment to maximize productivity and minimize friction.

## Philosophy

These dotfiles follow a few core principles:

- **Minimal friction** - Tools should get out of the way and let you work
- **Keyboard-centric** - Mouse usage is minimized
- **Portable** - Works across different machines and environments
- **Version controlled** - Everything is tracked and reproducible

## What's Included

### Shell & Terminal

- [[zsh]] - Primary shell with extensive customization
- [[tmux]] - Terminal multiplexer for persistent sessions
- [[kitty]] - GPU-accelerated terminal emulator
- [[wezterm]] - Cross-platform terminal emulator

### Editors

- [[neovim]] - Modal editor with extensive plugin ecosystem
- [[helix]] - Post-modern modal editor

### Window Management

- [[hyprland]] - Dynamic tiling Wayland compositor
- [[awesome]] - Highly configurable X11 window manager

### Development Tools

- [[mise]] - Universal version manager for dev tools
- [[git]] - Version control configuration
- [[gitui]] - Terminal UI for git (primary)
- [[lazygit]] - Alternative git TUI

### Status & System

- [[waybar]] - Highly customizable Wayland bar
- [[polybar]] - Fast and easy-to-use status bar

### Utilities

- [[atuin]] - Magical shell history
- [[starship]] - Minimal, fast shell prompt
- [[fzf]] - Command-line fuzzy finder
- [[lf]] - Terminal file manager
- [[yazi]] - Alternative file manager
- [[zellij]] - Terminal workspace with batteries included

## Getting Started

If you're interested in using any of these configurations, check out the
[[getting-started|Getting Started]] guide for installation and setup
instructions.

## Structure

The dotfiles are organized by application, with each directory containing the
relevant configuration files:

```
.
├── zsh/           # Shell configuration
├── tmux/          # Terminal multiplexer
├── nvim/          # Neovim configuration
├── hypr/          # Hyprland window manager
├── mise/          # Dev tool management
└── ...
```

Each tool has its own documentation page covering setup, key features, and
customization options.

## Contributing

These are my personal configurations, but feel free to fork and adapt them for
your own use. If you find bugs or have suggestions, issues and pull requests are
welcome.

# llms.txt

> A comprehensive overview of Waylon Walker's devtainer - a personal development container environment and dotfiles collection

## What is Devtainer?

Devtainer is my personal development environment - a Docker container base image and a collection of dotfiles configurations built up over years of tweaking for maximum productivity and minimal friction.

The project provides:

- Pre-built Docker images with all my favorite CLI tools
- Version-controlled dotfiles for zsh, neovim, tmux, and more
- Documentation for setting up and customizing the environment
- Keybinding references for keyboard-driven workflows

## Core Philosophy

- **Minimal friction** - Tools should get out of the way
- **Keyboard-centric** - Mouse usage is minimized
- **Portable** - Works across different machines
- **Version controlled** - Everything is tracked and reproducible

## Quick Start

For users wanting to use these configurations:

1. Clone the repository: `git clone https://github.com/waylonwalker/devtainer.git ~/devtainer`
2. Install tools with mise: `mise install`
3. Symlink configurations as needed

See [[getting-started]] for detailed setup instructions.

## Main Tools Documented

### Shell & Terminal
- [[zsh]] - Primary shell with autosuggestions and syntax highlighting
- [[tmux]] - Terminal multiplexer with popup windows and session management
- [[kitty]] - GPU-accelerated terminal emulator
- [[wezterm]] - Cross-platform terminal emulator

### Editors
- [[neovim]] - Modal editor with lazy.nvim plugin management
- [[helix]] - Post-modern modal editor

### Window Management
- [[hyprland]] - Dynamic tiling Wayland compositor
- [[awesome]] - Highly configurable X11 window manager
- [[waybar]] - Wayland status bar
- [[polybar]] - X11 status bar

### Development Tools
- [[mise]] - Universal version manager for dev tools
- [[git]] - Version control with delta for diffs
- [[gitui]] - Terminal UI for git (primary)
- [[lazygit]] - Alternative git TUI
- [[gh]] - GitHub CLI
- [[delta]] - Syntax-highlighting diff viewer

### Utilities
- [[atuin]] - Magical shell history with sync
- [[starship]] - Minimal, fast shell prompt
- [[fzf]] - Command-line fuzzy finder
- [[lf]] - Terminal file manager
- [[yazi]] - Alternative file manager
- [[zellij]] - Terminal workspace multiplexer

## Keybindings Reference

Complete keyboard shortcut documentation is available:

- [[keybindings]] - Main keybindings index
- [[neovim-keybindings]] - Neovim shortcuts organized by category

## Project Structure

```
devtainer/
├── docker/              # Dockerfile variants
├── pages/               # Documentation (this site)
├── scripts/             # Utility scripts
├── installer/           # Generated tool installers
├── zsh/                 # Shell configuration
├── tmux/                # Terminal multiplexer config
├── nvim/                # Neovim configuration
├── hypr/                # Hyprland window manager config
├── mise/                # Dev tool management
└── ...
```

## Build Commands

This project uses `just` as the task runner:

- `just build` - Build all Docker variants
- `just build-latest` - Build main Ubuntu image
- `just testnvim` - Test Neovim configuration
- `just extract-keymaps` - Extract keybindings
- `just gen-keybinding-pages` - Generate keybinding documentation
- `just update-keybindings` - Full keybinding refresh

## License

MIT License - Feel free to fork and adapt for your own use.

## Contact

- Website: https://waylonwalker.com
- GitHub: https://github.com/waylonwalker
- Repository: https://github.com/waylonwalker/devtainer

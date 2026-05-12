---
date: '2026-02-07'
description: 'mise - the universal version manager for development tools'
published: true
title: 'mise Tool Management'
---

[mise](https://mise.jdx.dev/) is a universal version manager for development
tools. It replaces separate version managers (nvm, pyenv, rbenv, etc.) with a
single tool.

## Why mise?

- **One tool** - Manage all languages and tools in one place
- **Fast** - Written in Rust, activates in milliseconds
- **Compatible** - Works with asdf plugins
- **Project-specific** - Per-directory tool versions via `.tool-versions`

## Installation

```bash
curl https://mise.run | sh
```

Activate in your shell:

```bash
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

## Configuration

The main config is at `mise/.config/mise/config.toml`:

```toml
[settings]
idiomatic_version_file_enable_tools = ["ruby"]

[tools]
age = "latest"
argocd = "latest"
atuin = "latest"
bitwarden = "latest"
# ... more tools
```

## Key Commands

```bash
# Install all tools from config
mise install

# Install a specific tool
mise install node@20

# List installed tools
mise list

# Use a specific version in current directory
mise use node@20

# Run a command with a specific tool version
mise exec node@18 -- npm test
```

## Tools Managed

My setup includes:

### Development

- `neovim` - Text editor
- `node` - JavaScript runtime
- `pnpm` - Package manager
- `uv` - Python package manager

### Kubernetes

- `kubectl` - Kubernetes CLI
- `helm` - Package manager for K8s
- `k9s` - Terminal UI for K8s
- `argocd` - GitOps tool

### Utilities

- `fzf` - Fuzzy finder
- `ripgrep` - Fast grep alternative
- `fd` - Fast find alternative
- `bat` - Enhanced cat
- `eza` - Modern ls replacement
- `delta` - Syntax-highlighting pager for git
- `difftastic` - Structural diff tool
- `direnv` - Environment variable manager

### Terminal

- `starship` - Shell prompt
- `zellij` - Terminal multiplexer
- `tmux` - Terminal multiplexer
- `lf` - File manager
- `yazi` - Alternative file manager

### Git

- `gitui` - Terminal UI for git (primary)
- `lazygit` - Alternative git TUI
- `github-cli` - GitHub CLI
- `ripsecrets` - Secret scanner

### Media

- `vhs` - Terminal recording tool

## Project-Specific Versions

Create a `.tool-versions` file in project directories:

```bash
echo "nodejs 20.11.0" > .tool-versions
echo "python 3.11" >> .tool-versions
```

mise will automatically switch to these versions when you enter the directory.

## See Also

![embed](https://mise.jdx.dev/)

![embed](https://asdf-vm.com/manage/plugins.html)

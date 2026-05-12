---
date: '2026-02-07'
description: 'fzf - a command-line fuzzy finder'
published: true
title: 'fzf'
---

fzf is a general-purpose command-line fuzzy finder that integrates with shells and tools for fast file and command searching.

## Features

- **Fuzzy matching** - Find items with approximate search
- **Fast** - Written in Go, handles large lists
- **Flexible** - Works with any list of text
- **Preview** - Show previews of files and results
- **Scriptable** - Easy to integrate in scripts

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install fzf

# Ubuntu/Debian
sudo apt install fzf

# Arch Linux
sudo pacman -S fzf

# macOS
brew install fzf
```

## Shell Integration

Add to `~/.zshrc`:

```bash
source <(fzf --zsh)
```

For bash:

```bash
eval "$(fzf --bash)"
```

## Key Bindings

### Shell Integration

| Key | Action |
|-----|--------|
| `Ctrl+T` | Find files and insert path |
| `Ctrl+R` | Search command history |
| `Alt+C` | Find directories and cd |
| `Tab` | Complete paths with fzf |

### fzf Interface

| Key | Action |
|-----|--------|
| `Ctrl+J/K` or `Ctrl+N/P` | Navigate up/down |
| `Ctrl+H/L` | Move cursor left/right in query |
| `Enter` | Select item |
| `Esc` | Cancel |
| `Ctrl+U` | Clear query |
| `Tab` | Multi-select |
| `Shift+Tab` | Deselect |
| `?` | Toggle preview |

## Usage Examples

### Basic Usage

```bash
# Find files
cat file_list.txt | fzf

# Find processes
ps aux | fzf

# Find git branches
git branch | fzf
```

### With Preview

```bash
# Preview files
fzf --preview 'cat {}'

# Preview with bat
fzf --preview 'bat --style=numbers --color=always {}'

# Preview directories
tree -C {} | head -200
```

### Integration Examples

```bash
# Edit file with neovim
nvim $(fzf)

# Kill process
kill -9 $(ps aux | fzf | awk '{print $2}')

# Checkout git branch
git checkout $(git branch | fzf | sed 's/* //')

# cd into directory
cd $(find . -type d | fzf)
```

## Environment Variables

```bash
# Default options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Default command
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Ctrl+T command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Alt+C command
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
```

## See Also

![[ zsh ]]

![[ neovim ]]

![embed](https://github.com/junegunn/fzf)

---
date: '2026-02-08'
description: 'fzf keybindings and fuzzy finder quick reference'
published: true
slug: 'cheatsheets/fzf'
title: 'fzf Cheatsheet'
---

# fzf Cheatsheet

## Shell Integration Keybindings
| Key | Action |
|-----|--------|
| `Ctrl+T` | Find files and insert path |
| `Ctrl+R` | Search command history |
| `Alt+C` | Find directories and cd |
| `Tab` | Complete paths with fzf |

## fzf Interface Controls
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

## Common Commands
```bash
# Basic file finding
fzf

# With preview
fzf --preview 'bat --style=numbers --color=always {}'

# Edit selected file
nvim $(fzf)

# Kill process
kill -9 $(ps aux | fzf | awk '{print $2}')

# Git checkout branch
git checkout $(git branch | fzf | sed 's/* //')

# cd to directory
cd $(find . -type d | fzf)

# Search history
history | fzf
```

## Environment Variables
```bash
# Default appearance
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Default file search
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Ctrl+T command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Alt+C command  
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
```

## Integration Examples
```bash
# Find and edit config files
nvim ~/.config/**/*(.) | fzf

# Search git files
git ls-files | fzf

# Docker actions
docker ps | fzf | awk '{print $1}' | xargs docker logs

# Package management
apt list --installed | fzf
```

## Quick Workflows
**Find file:** `Ctrl+T` → type → `Enter`
**Search history:** `Ctrl+R` → type → `Enter`  
**Change directory:** `Alt+C` → select → `Enter`
**Multi-select:** `Tab` to select multiple items
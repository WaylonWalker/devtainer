---
date: '2026-02-07'
description: 'zsh shell configuration - my primary shell with autosuggestions, syntax highlighting, and custom functions'
published: true
title: 'zsh Configuration'
---

zsh is my primary shell, configured for productivity with autosuggestions,
syntax highlighting, and a custom prompt.

## Features

- **zsh-autosuggestions** - Fish-like suggestions as you type
- **zsh-syntax-highlighting** - Command validation as you type
- **Starship prompt** - Fast, customizable prompt with git info
- **fzf integration** - Fuzzy completion and history search
- **Atuin** - Enhanced shell history with sync

## Setup

### Installation

zsh should be installed via your package manager:

```bash
# Ubuntu/Debian
sudo apt install zsh

# Arch Linux
sudo pacman -S zsh

# macOS
brew install zsh
```

Make zsh your default shell:

```bash
chsh -s $(which zsh)
```

### Configuration

The main config file is `~/.zshrc`. Key sections include:

#### Path Management

```zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
```

#### Tool Activation

```zsh
# mise (tool manager)
eval "$(~/.local/bin/mise activate zsh)"

# starship prompt
eval "$(starship init zsh)"

# atuin history
eval "$(atuin init zsh)"

# direnv
eval "$(direnv hook zsh)"
```

#### Plugins

```zsh
# These provide suggestions and highlighting
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
```

## Custom Functions

### web2app

Create desktop web app launchers:

```zsh
web2app "GitHub" "https://github.com" "https://icon-url.png"
```

### Browser Detection

Automatically detects your default browser from desktop files:

```zsh
# Falls back through: brave, chromium, google-chrome, firefox
echo $BROWSER
```

## History Configuration

Extended history with sharing between sessions:

```zsh
HISTFILESIZE=1000000000
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt appendhistory
setopt share_history
```

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+E` | Edit command in $EDITOR |
| `Ctrl+K` | Clear screen and run wfetch |
| `Ctrl+N` | Expand alias |
| `Ctrl+P` | List all commands with fzf |
| `Ctrl+G` | Open gitui |
| `Up/Down` | History search by prefix |

## Completion

Advanced completion with:

- Case-insensitive matching
- Fuzzy matching
- Menu selection with arrow keys
- Grouped results with descriptions

## See Also

![[ starship ]]

![[ atuin ]]

![[ mise ]]

![embed](https://zsh.sourceforge.io/Doc/)

---
date: '2026-02-07'
description: 'Atuin - a magical shell history with sync'
published: true
title: 'Atuin'
---

Atuin replaces your existing shell history with a SQLite database and records additional context for better search and sync.

## Features

- **SQLite database** - Fast, searchable history
- **Context** - Records directory, exit code, duration
- **Sync** - Encrypted sync across machines
- **Fuzzy search** - Find commands easily
- **Stats** - View command usage statistics

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install atuin

# Or install script
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh

# Arch Linux
sudo pacman -S atuin

# macOS
brew install atuin
```

## Shell Integration

Add to `~/.zshrc`:

```bash
eval "$(atuin init zsh)"
```

For bash, add to `~/.bashrc`:

```bash
eval "$(atuin init bash)"
```

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Open Atuin history search |
| `Up` | Search history by prefix |
| `Down` | Navigate results |
| `Enter` | Execute command |
| `Tab` | Edit command |
| `Alt+Enter` | Execute and keep open |

## Search

Atuin provides powerful search:

```bash
# Fuzzy search
atuin search --interactive

# Search by directory
atuin search --cwd /path/to/project

# Search by exit code
atuin search --exit 0

# Search by time range
atuin search --after "2024-01-01"
```

## Sync

Sync history across machines:

```bash
# Register account
atuin register -u username -e email@example.com -p password

# Login
atuin login -u username -p password

# Sync
atuin sync
```

## Stats

View command statistics:

```bash
# Overall stats
atuin stats

# Stats for specific command
atuin stats --cmd git

# Daily stats
atuin stats -d
```

## Configuration

Config file: `~/.config/atuin/config.toml`

Example:

```toml
sync_address = "https://api.atuin.sh"
sync_frequency = "10m"
search_mode = "fuzzy"
style = "compact"
inline_height = 10
show_preview = true
```

## See Also

![[ zsh ]]

![embed](https://docs.atuin.sh/)

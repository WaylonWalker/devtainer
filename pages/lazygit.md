---
date: '2026-02-07'
description: 'Lazygit - a simple terminal UI for git commands'
published: true
title: 'Lazygit'
---

Lazygit is a simple terminal UI for git commands that makes common git operations fast and visual.

## Features

- **Visual staging** - Stage/unstage files with spacebar
- **Branch management** - Create, checkout, merge branches easily
- **Conflict resolution** - Interactive merge conflict handling
- **Commit history** - Browse and search commits
- **Stash management** - View and apply stashes
- **Custom commands** - Add your own keybindings

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit

# Arch Linux
sudo pacman -S lazygit

# macOS
brew install lazygit

# Via mise
mise install lazygit
```

## Launching

```bash
lazygit
```

Or from within a git repo:

```bash
lg  # If you have an alias
```

## Key Bindings

### Global

| Key | Action |
|-----|--------|
| `?` | Help |
| `q` | Quit |
| `1-5` | Switch panel (Status, Files, Local Branches, Commits, Stash) |
| `R` | Refresh |

### Files Panel

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage |
| `d` | Discard changes |
| `a` | Stage all |
| `A` | Unstage all |
| `c` | Commit |
| `C` | Commit with editor |
| `e` | Edit file |

### Branches Panel

| Key | Action |
|-----|--------|
| `c` | Checkout |
| `n` | New branch |
| `m` | Merge |
| `r` | Rebase |
| `d` | Delete |

### Commits Panel

| Key | Action |
|-----|--------|
| `s` | Squash |
| `r` | Reword |
| `d` | Drop |
| `e` | Edit |
| `p` | Pick |

## Custom Commands

Add custom commands in `~/.config/lazygit/config.yml`:

```yaml
customCommands:
  - key: 'f'
    context: 'files'
    description: 'Fixup commit'
    command: 'git commit --fixup {{.SelectedLocalCommit.Sha}}'
    subprocess: true
```

## See Also

![[ git ]]

![[ gitui ]]

![[ delta ]]

![embed](https://github.com/jesseduffield/lazygit)

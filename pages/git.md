---
date: '2026-02-07'
description: 'Git configuration with aliases, delta for diffs, and work/personal separation'
published: true
title: 'Git Configuration'
---

Git configuration optimized for daily development with useful aliases, improved
diff viewing, and separate configs for work and personal projects.

## Features

- **Delta** - Syntax-highlighted diffs and pager
- **Conditional includes** - Different configs for work vs personal
- **Useful aliases** - Shortcuts for common operations
- **Bat integration** - Better file viewing

## Setup

### Installation

Git is typically pre-installed. For latest version:

```bash
# Ubuntu/Debian
sudo apt install git

# Arch Linux
sudo pacman -S git

# Via mise
mise install git
```

### Configuration

Main config at `~/.gitconfig`:

```bash
[user]
    name = Waylon S. Walker
    email = waylon@waylonwalker.com
    signingkey = 66E2BF2B4190EFE4

[core]
    editor = nvim -c startinsert
    excludesfile = ~/.global-gitignore
    pager = bat --style=plain
```

## Conditional Includes

Different configurations for different directories:

```bash
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work

[includeIf "gitdir:~/git/"]
    path = ~/.gitconfig-git
```

Example `~/.gitconfig-work`:

```bash
[user]
    email = waylon@company.com
    name = Waylon Walker
```

## Key Settings

### Editor

Opens nvim in insert mode for commit messages:

```bash
editor = nvim -c startinsert
```

### Pager

Uses bat for better output:

```bash
pager = bat --style=plain
diff = bat --plain
```

### Autocorrect

Automatically fix typos after 1 second:

```bash
[help]
    autocorrect = 10
```

## Aliases

### squash-all

Squash entire branch history into single commit:

```bash
git squash-all "Initial commit"
```

Implementation:

```bash
squash-all = "!f(){ git reset $(git commit-tree HEAD^{tree} -m \"${1:-A new start}\");};f"
```

### restage

Restage already-staged files:

```bash
restage = !git diff --name-only --cached | xargs git add
```

## Credentials

Uses GitHub CLI for authentication:

```bash
[credential "https://github.com"]
    helper =
    helper = !gh auth git-credential

[credential]
    helper = store
```

## Delta Integration

Delta provides syntax highlighting for diffs:

```bash
[pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta

[delta]
    features = side-by-side line-numbers decorations
    syntax-theme = Dracula
```

## Default Behaviors

```bash
[init]
    defaultBranch = main

[push]
    default = current

[pull]
    rebase = true

[rebase]
    autoStash = true

[commit]
    gpgsign = false
```

## Global Gitignore

A `~/.global-gitignore` file excludes files across all repos:

```bash
# IDE
.idea/
.vscode/
*.swp
*~

# OS
.DS_Store
Thumbs.db

# Temporary
*.log
*.tmp
.env.local
```

## Workflows

### Starting a New Project

```bash
# Personal project
cd ~/git/new-project
git init
git add .
git commit -m "Initial commit"

# Work project (uses work email automatically)
cd ~/work/company-project
git init
git add .
git commit -m "Initial commit"
```

### Cleaning Up History

```bash
# Squash everything to one commit
git squash-all "Clean history"

# Push with force
git push --force-with-lease
```

## See Also

![[ lazygit ]]

![[ gitui ]]

![[ delta ]]

![[ gh ]]

![embed](https://git-scm.com/doc)

![embed](https://github.com/dandavison/delta)

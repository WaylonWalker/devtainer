---
date: '2026-02-07'
description: 'GitHub CLI - a command-line tool for GitHub'
published: true
title: 'GitHub CLI'
---

GitHub CLI (`gh`) is GitHub's official command-line tool that brings pull requests, issues, and other GitHub concepts to your terminal.

## Features

- **Pull requests** - Create, view, checkout, and merge PRs
- **Issues** - List, view, create, and close issues
- **Repositories** - Clone, create, fork repos
- **Actions** - View and monitor workflow runs
- **Codespaces** - Manage cloud development environments
- **Gists** - Create and manage gists

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install github-cli

# Ubuntu/Debian
# Download from GitHub releases

# Arch Linux
sudo pacman -S github-cli

# macOS
brew install gh
```

## Authentication

```bash
# Login to GitHub
gh auth login

# Verify status
gh auth status

# Logout
gh auth logout
```

## Repository Operations

```bash
# Clone repository
gh repo clone owner/repo

# Create new repository
gh repo create my-project --public

# Fork repository
gh repo fork owner/repo

# View repository
gh repo view owner/repo --web
```

## Pull Requests

```bash
# Create PR
git push origin feature-branch
gh pr create --title "Add feature" --body "Description"

# List PRs
gh pr list
gh pr list --state merged

# View PR
gh pr view 123
gh pr view 123 --web

# Checkout PR locally
gh pr checkout 123

# Check PR status
gh pr status

# Merge PR
gh pr merge 123 --squash
```

## Issues

```bash
# List issues
gh issue list
gh issue list --state closed

# Create issue
gh issue create --title "Bug report" --body "Description"

# View issue
gh issue view 123
gh issue view 123 --web

# Close issue
gh issue close 123

# Comment on issue
gh issue comment 123 --body "Thanks for reporting"
```

## Workflows

```bash
# List workflow runs
gh run list

# View workflow run
gh run view 123456789

# Watch workflow run
gh run watch 123456789

# Re-run failed jobs
gh run rerun 123456789
```

## Aliases

Create shortcuts for common commands:

```bash
# Create alias
gh alias set pv 'pr view'
gh alias set co 'pr checkout'

# Use alias
gh pv 123
gh co 123

# List aliases
gh alias list
```

## Configuration

Config file: `~/.config/gh/config.yml`

Example:

```yaml
git_protocol: ssh
editor: nvim
prompt: enabled
pager: delta
aliases:
    co: pr checkout
    pv: pr view
```

## See Also

![[ git ]]

![[ lazygit ]]

![embed](https://cli.github.com/)

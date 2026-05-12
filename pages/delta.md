---
date: '2026-02-07'
description: 'Delta - syntax-highlighting pager for git and diff output'
published: true
title: 'Delta'
---

Delta is a syntax-highlighting pager for git and diff output that makes code reviews more pleasant.

## Features

- **Syntax highlighting** - Language-aware highlighting of diffs
- **Side-by-side view** - Compare old and new versions
- **Git integration** - Works as git pager
- **Customizable** - Themes, colors, and layout options
- **Fast** - Written in Rust

## Setup

Install via package manager:

```bash
# Via mise (recommended)
mise install delta

# Ubuntu/Debian
# Download .deb from GitHub releases

# Arch Linux
sudo pacman -S git-delta

# macOS
brew install git-delta
```

## Git Integration

Add to `~/.gitconfig`:

```bash
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    features = side-by-side line-numbers decorations
    syntax-theme = Dracula
    plus-style = "syntax #003800"
    minus-style = "syntax #3f0001"

[delta "decorations"]
    commit-decoration-style = bold yellow box ul
    file-style = bold yellow ul
    file-decoration-style = none
    hunk-header-decoration-style = cyan box ul

[delta "line-numbers"]
    line-numbers-left-style = cyan
    line-numbers-right-style = cyan
    line-numbers-minus-style = 124
    line-numbers-plus-style = 28
```

## Usage

Once configured, Delta works automatically:

```bash
# Any git diff command
git diff
git show
git log -p
git stash show -p
```

### Standalone

Use Delta with any diff:

```bash
diff -u file1 file2 | delta
```

## Key Bindings (in less)

Since Delta uses less as the pager:

| Key | Action |
|-----|--------|
| `q` | Quit |
| `Space` | Page down |
| `b` | Page up |
| `/` | Search |
| `n/N` | Next/previous match |
| `g` | Go to top |
| `G` | Go to bottom |

## Themes

Delta supports bat themes:

```bash
# List available themes
delta --list-themes

# Use specific theme
delta --syntax-theme=OneHalfDark
```

## Features Options

```bash
# Side-by-side vs unified
delta --side-by-side
delta --no-side-by-side

# Show/hide line numbers
delta --line-numbers
delta --no-line-numbers

# Navigate with n/N
delta --navigate
```

## See Also

![[ git ]]

![[ lazygit ]]

![embed](https://github.com/dandavison/delta)

---
date: '2026-02-07'
description: 'Helix - a post-modern modal text editor'
published: true
title: 'Helix Editor'
---

Helix is a post-modern modal text editor inspired by Kakoune. It features multiple cursors, tree-sitter integration, and a clean design.

## Features

- **Modal editing** - Vim-like modal interface with improvements
- **Multiple cursors** - Kakoune-style multiple selections
- **Tree-sitter** - Built-in syntax highlighting and parsing
- **LSP support** - Language Server Protocol integration
- **No plugins needed** - Batteries included philosophy

## Setup

Install via package manager:

```bash
# Ubuntu/Debian
sudo add-apt-repository ppa:maveonair/helix-editor
sudo apt update
sudo apt install helix

# Arch Linux
sudo pacman -S helix

# macOS
brew install helix

# Via mise
mise install helix
```

## Configuration

Config file: `~/.config/helix/config.toml`

Example configuration:

```toml
theme = "dracula"

[editor]
line-number = "relative"
mouse = false
cursorline = true
auto-save = true

[editor.cursor-shape]
normal = "block"
insert = "bar"
select = "underline"

[editor.file-picker]
hidden = false
```

## Key Differences from Vim/Neovim

Helix uses a selection-first approach:

| Action | Vim | Helix |
|--------|-----|-------|
| Select word | `viw` | `w` |
| Delete word | `diw` | `wd` |
| Change word | `ciw` | `wc` |
| Yank word | `yiw` | `wy` |
| Go to line | `G` | `gh` |

## Key Bindings

| Key | Mode | Action |
|-----|------|--------|
| `Space` | Normal | Command palette |
| `Space+f` | Normal | File picker |
| `Space+b` | Normal | Buffer picker |
| `Space+g` | Normal | Git picker |
| `Space+s` | Normal | Symbol picker |
| `Space+?` | Normal | Command picker |
| `Ctrl+s` | Any | Save |
| `Ctrl+c` | Normal | Comment line |
| `Ctrl+w` | Normal | Window commands |

## Multiple Cursors

Helix excels at multiple selections:

- `%` - Select all occurrences in file
- `s` - Select matches in selection
- `C` - Copy selection to next line
- `A-C` - Copy selection to previous line
- `;` - Collapse selection to cursor
- `Alt-;` - Flip cursor and selection

## See Also

![[ neovim ]]

![embed](https://docs.helix-editor.com/)

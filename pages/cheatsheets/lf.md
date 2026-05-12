---
date: '2026-02-08'
description: 'LF file manager keybindings and quick reference'
published: true
slug: 'cheatsheets/lf'
title: 'LF Cheatsheet'
---

# LF Cheatsheet

## Navigation
| Key | Action |
|-----|--------|
| `hjkl` | Left, Down, Up, Right |
| `Enter` | Enter directory or open file |
| `Backspace` | Parent directory |
| `g` | Go to top |
| `G` | Go to bottom |
| `Home` | Go to top |
| `End` | Go to bottom |

## File Operations
| Key | Action |
|-----|--------|
| `d` | Delete (move to trash) |
| `D` | Delete permanently |
| `y` | Copy (yank) |
| `p` | Paste |
| `c` | Cut |
| `r` | Rename |
| `:rename` | Interactive rename |
| `:bulk` | Bulk rename |

## Selection
| Key | Action |
|-----|--------|
| `v` | Toggle selection |
| `V` | Select all |
| `u` | Clear selection |
| `t` | Toggle selection for glob pattern |
| `Ctrl+A` | Select all files |
| `Ctrl+U` | Clear all selections |

## File Creation
| Key | Action |
|-----|--------|
| `:touch filename` | Create empty file |
| `:mkdir dirname` | Create directory |
| `F` | Create file |
| `M` | Create directory |

## View & Preview
| Key | Action |
|-----|--------|
| `Space` | Toggle preview |
| `zh` | Toggle hidden files |
| `zI` | Toggle preview of directories |
| `$` | Toggle preview window |
| `%` | Toggle percent view |
| `a` | Show file size |
| `A` | Show detailed info |

## Search
| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `f` | Find character in line |
| `F` | Find character backward |

## Jump Points
| Key | Action |
|-----|--------|
| `cd ~` | Home |
| `cd /` | Root |
| `m` | Set bookmark |
| `'` | Go to bookmark |
| `\` | Go to bookmark by name |

## Shell Integration
| Key | Action |
|-----|--------|
| `!` | Shell command |
| `$` | Shell command with current file |
| `&` | Shell command in background |
| `w` | Open with `$EDITOR` |
| `W` | Open with default app |
| `e` | Open file in editor |
| `x` | Execute file |

## Workflows
| Key | Action |
|-----|--------|
| `Ctrl+P` | Toggle tmux popup |
| `i` | Toggle preview mode |
| `q` | Quit |
| `Ctrl+C` | Cancel operation |

## Common Patterns
```bash
# File selection workflow
v → select files → y → navigate → p → paste

# Bulk rename
Ctrl+A → :bulk → edit with nvim → save

# Quick file ops
d → Enter to confirm trash
c → navigate → Enter to move

# Preview images
Space → image preview → q to exit preview
```

## Custom Commands
| Command | Action |
|---------|--------|
| `:zip` | Create zip archive |
| `:extract` | Extract archive |
| `:chmod +x` | Make executable |
| `:du -sh` | Show directory size |

## Quick Workflows
**Navigate:** `hjkl` or `Enter` to enter directories
**Select multiple:** `v` on each file → `y` to copy
**Quick delete:** Select files → `d` → confirm
**File info:** `a` for sizes, `Space` for preview
**Edit:** `e` to open in nvim, `Enter` to open with default
---
date: '2026-02-08'
description: 'Neovim keybindings and essential commands quick reference'
published: true
slug: 'cheatsheets/neovim'
title: 'Neovim Cheatsheet'
---

# Neovim Cheatsheet

## Navigation
| Key | Action |
|-----|--------|
| `hjkl` | Left, Down, Up, Right |
| `w` | Word forward |
| `b` | Word backward |
| `0` | Start of line |
| `$` | End of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `Ctrl+U` | Page up |
| `Ctrl+D` | Page down |
| `%` | Jump to matching bracket |

## File Operations
| Key | Action |
|-----|--------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:e filename` | Open file |
| `:tabnew` | New tab |
| `:tabn` | Next tab |
| `:tabp` | Previous tab |
| `:sp` | Split horizontal |
| `:vsp` | Split vertical |

## Insert Mode
| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at line start |
| `A` | Insert at line end |
| `o` | Open line below |
| `O` | Open line above |
| `Esc` | Exit insert mode |

## Editing
| Key | Action |
|-----|--------|
| `x` | Delete character |
| `dd` | Delete line |
| `yy` | Copy line |
| `p` | Paste after |
| `P` | Paste before |
| `u` | Undo |
| `Ctrl+R` | Redo |
| `.` | Repeat last command |
| `>>` | Indent line |
| `<<` | Outdent line |

## Search & Replace
| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `:%s/old/new/g` | Replace all |
| `:%s/old/new/gc` | Replace with confirm |

## Visual Mode
| Key | Action |
|-----|--------|
| `v` | Character visual mode |
| `V` | Line visual mode |
| `Ctrl+V` | Block visual mode |
| `d` | Delete selection |
| `y` | Copy selection |
| `c` | Change selection |

## Telescope (Fuzzy Finding)
| Key | Action |
|-----|--------|
| `Ctrl+P` | Find files |
| `Ctrl+F` | Live grep |
| `Ctrl+B` | Buffers |
| `Ctrl+H` | Help tags |
| `Ctrl+R` | Resume last picker |

## LSP (Language Server)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `Ctrl+K` | Signature help |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

## Git (GitSigns)
| Key | Action |
|-----|--------|
| `]c` | Next git hunk |
| `[c` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

## Terminal
| Key | Action |
|-----|--------|
| `Ctrl+T` | Toggle terminal |
| `<C-\\><C-N>` | Terminal normal mode |

## Quick Workflows
**File finding:** `Ctrl+P` → type → `Enter`
**Code navigation:** `gd` on symbol → `Ctrl+O` to return
**Git workflow:** `]c` → `<leader>hs` → stage changes
**Search:** `Ctrl+F` → type → `Enter` to open result
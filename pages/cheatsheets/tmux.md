---
date: '2026-02-08'
description: 'tmux keybindings and quick reference'
published: true
slug: 'cheatsheets/tmux'
title: 'tmux Cheatsheet'
---

# tmux Cheatsheet

## Prefix
`Ctrl+Space` (custom, not `Ctrl+B`)

## Session Management
| Key | Action |
|-----|--------|
| `Alt+Space` | Popup: attach to workspace session |
| `Alt+T` | Popup: attach to workspace in current directory |
| `Alt+Escape` | Popup: create new workspace |
| `Alt+Backspace` | Popup: add repo to workspace |
| `Ctrl+J` | Popup: switch to any session with fzf |
| `Alt+G` | Popup: open scratch session |
| `Alt+Shift+G` | Popup: open scratch session (large) |
| `Ctrl+K` | Popup: kill sessions |
| `J` | tmux session tree browser |

## Copy Mode
| Key | Action |
|-----|--------|
| `Alt+[` | Enter copy mode |
| `Alt+V` | Enter copy mode |
| `Alt+Enter` | Enter copy mode |
| `Enter` | Enter copy mode |

## Status Bar
| Key | Action |
|-----|--------|
| `Prefix+s` | Toggle status bar |
| `Prefix+Ctrl+S` | Toggle status bar |

## Git Integration
| Key | Action |
|-----|--------|
| `Alt+F` | Popup: git commit --verbose |
| `Alt+Shift+F` | Popup: gitui |

## Workspaces
| Key | Action |
|-----|--------|
| `Ctrl+W` | Popup: attach to ~/work |
| `Alt+W` | Popup: attach to ~/work |
| `Ctrl+G` | Popup: attach to ~/git |
| `Ctrl+P` | Popup: attach to ~/project |
| `Ctrl+T` | New session: todo list in nvim |

## Window Management
| Key | Action |
|-----|--------|
| `Prefix+c` | Create new window |
| `Prefix+n` | Next window |
| `Prefix+p` | Previous window |
| `Prefix+0-9` | Go to window number |
| `Prefix+,` | Rename window |
| `Prefix+&` | Kill window |

## Pane Management
| Key | Action |
|-----|--------|
| `Prefix+"` | Split horizontal |
| `Prefix+%` | Split vertical |
| `Prefix+hjkl` | Navigate panes |
| `Prefix+HJKL` | Resize panes |
| `Prefix+x` | Kill pane |
| `Prefix+z` | Zoom pane |

## Quick Workflows
**Project hopping:** `Alt+Space` → select session
**Scratch pad:** `Alt+G` for quick notes
**Git commit:** `Alt+F` for fast commit
**Todo list:** `Ctrl+T` opens dedicated todo session
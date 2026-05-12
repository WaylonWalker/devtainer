---
date: '2026-02-08'
description: 'ZSH shell keybindings and productivity features'
published: true
slug: 'cheatsheets/zsh'
title: 'ZSH Cheatsheet'
---

# ZSH Cheatsheet

## Keybindings
| Key | Action |
|-----|--------|
| `Ctrl+T` | fzf file completion |
| `Ctrl+R` | fzf history search |
| `Alt+C` | fzf directory completion |
| `Ctrl+A` | Beginning of line |
| `Ctrl+E` | End of line |
| `Ctrl+U` | Delete to beginning |
| `Ctrl+K` | Delete to end |
| `Ctrl+W` | Delete word backward |
| `Alt+D` | Delete word forward |
| `Ctrl+L` | Clear screen |
| `Ctrl+D` | Exit shell |
| `Ctrl+Z` | Background/foreground |

## History Expansion
| Pattern | Action |
|---------|--------|
| `!!` | Last command |
| `!$` | Last argument |
| `!^` | First argument |
| `!:1-3` | Arguments 1-3 |
| `^foo^bar` | Replace foo with bar in last command |

## Directory Navigation
| Command | Action |
|---------|--------|
| `cd -` | Previous directory |
| `cd ~` | Home directory |
| `pushd dir` | Add to stack |
| `popd` | Remove from stack |
| `dirs` | Show stack |
| `...` | Go up 2 directories |
| `....` | Go up 3 directories |

## Aliases
| Alias | Command |
|-------|---------|
| `l` | `ls -la` |
| `la` | `ls -A` |
| `ll` | `ls -alF` |
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `k` | `kubectl` |
| `dc` | `docker-compose` |

## FZF Integration
```bash
# Search history
Ctrl+R

# Find files to open
nvim **/* | fzf

# Change directory
cd **/* | fzf

# Kill processes
kill -9 $(ps aux | fzf | awk '{print $2}')
```

## Completion
| Key | Action |
|-----|--------|
| `Tab` | Complete |
| `Tab` again | Menu of options |
| `Ctrl+I` | Alternative complete |
| `Esc+/` | Complete from history |

## Global Aliases (pipe anywhere)
| Alias | Meaning |
|-------|---------|
| `H` | `| head` |
| `T` | `| tail` |
| `G` | `| grep` |
| `L` | `| less` |
| `S` | `| sort` |
| `U` | `| uniq` |

## Directory Stack
```bash
# Add directories
pushd ~/git/project
pushd ~/work/another

# Navigate stack
pushd +1  # Rotate forward
pushd -1  # Rotate backward

# Show stack
dirs -v

# Remove from stack
popd
```

## Quick Workflows
**Edit file:** `nvim **/*.py | fzf` → select
**Search history:** `Ctrl+R` → type → `Enter`
**Directory navigation:** `Alt+C` → fuzzy find
**Chain commands:** `ps aux | G process | L` → pipe through grep and less
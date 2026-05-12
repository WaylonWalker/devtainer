---
date: '2026-02-08'
description: 'GitUI TUI git client keybindings and quick reference'
published: true
slug: 'cheatsheets/gitui'
title: 'GitUI Cheatsheet'
---

# GitUI Cheatsheet

## Navigation
| Key | Action |
|-----|--------|
| `hjkl` | Left, Down, Up, Right |
| `Enter` | Select/Confirm |
| `Tab` | Switch between panels |
| `Esc` | Go back/Cancel |
| `q` | Quit |

## File Staging Panel
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all |
| `A` | Stage all tracked |
| `c` | Commit |
| `e` | Edit file in $EDITOR |
| `d` | Discard changes |
| `i` | Toggle ignored files |
| `r` | Refresh |

## Staging View (Hunks)
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage hunk |
| `a` | Stage all hunks |
| `A` | Stage all tracked |
| `c` | Commit |
| `s` | Stage selection |
| `u` | Unstage selection |
| `d` | Discard hunk |
| `e` | Edit hunk |
| `Enter` | Toggle hunk selection |

## Log Panel
| Key | Action |
|-----|--------|
| `Enter` | Show commit details |
| `c` | Cherry-pick commit |
| `r` | Revert commit |
| `b` | Create branch from commit |
| `t` | Tag commit |
| `s` | Squash commits |
| `f` | Fixup commits |

## Branch Panel
| Key | Action |
|-----|--------|
| `c` | Checkout branch |
| `n` | New branch |
| `d` | Delete branch |
| `D` | Force delete branch |
| `r` | Rename branch |
| `m` | Merge branch |
| `R` | Rebase onto branch |

## Stashing
| Key | Action |
|-----|--------|
| `z` | Stash changes |
| `Z` | Stash with message |
| `p` | Pop stash |
| `a` | Apply stash |
| `d` | Drop stash |

## Status Panel
| Key | Action |
|-----|--------|
| `l` | Open log |
| `b` | Open branches |
| `s` | Open stash |
| `t` | Open tags |
| `r` | Open remotes |
| `f` | Fetch |
| `P` | Push |
| `p` | Pull |
| `m` | Merge |
| `R` | Rebase |

## Search
| Key | Action |
|-----|--------|
| `/` | Search |
| `n` | Next result |
| `N` | Previous result |

## Help
| Key | Action |
|-----|--------|
| `?` | Show help |
| `1` | Show status help |
| `2` | Show log help |
| `3` | Show diffing help |

## Common Workflows

### Commit Changes
1. Open GitUI: `gitui`
2. Stage files: `Space` on each file
3. Commit: `c` → type message → `Enter`

### Switch Branch
1. Open branches: `b`
2. Select branch: `j/k` → `Enter`
3. Checkout: `c`

### Cherry-pick
1. Open log: `l`
2. Select commit: `Enter`
3. Cherry-pick: `c`

### Resolve Conflicts
1. During merge/rebase, conflicts appear
2. Press `e` to edit conflicted file
3. Resolve in editor
4. Return to GitUI
5. Continue: `c`

## Keyboard Tips
**Quick quit:** `q` from anywhere
**Back out:** `Esc` cancels current operation
**Bulk stage:** In staging, `a` stages all
**Search files:** `/` to search, `n` for next
**Edit file:** `e` opens in $EDITOR

## Quick Reference
**Status → Commit:** `gitui` → `Space` files → `c`
**Checkout:** `gitui` → `b` → select → `c`
**Log view:** `gitui` → `l`
**Stash:** `gitui` → `z`
**Push:** `gitui` → `P`
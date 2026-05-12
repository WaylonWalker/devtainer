---
date: '2026-02-08'
description: 'Daily terminal workflow and productivity patterns'
published: true
slug: 'cheatsheets/daily-workflow'
title: 'Daily Workflow Cheatsheet'
---

# Daily Workflow Cheatsheet

## Morning Startup
1. **Open terminal session**
   - `Alt+Space` → Open workspace session
   - Or `Alt+T` → Workspace in current directory

2. **Check status**
   - `gs` → Git status
   - `gitui` → Review changes
   - `Alt+Shift+F` → Open gitui in popup

3. **Open project**
   - `Ctrl+P` → Find files with telescope
   - `Ctrl+T` → Open todo list session

## File Operations
| Task | Method |
|------|--------|
| Find file | `Ctrl+T` (fzf) or `Ctrl+P` (telescope) |
| Navigate directories | `Alt+C` (fzf cd) or `lf` |
| Quick edit | `nvim $(fzf)` |
| File preview | `lf` → `Space` for preview |

## Common Patterns

### Working on New Feature
```bash
# 1. Create feature branch
git checkout -b feature-name

# 2. Work on files
nvim $(fzf)  # Find and open files

# 3. Commit changes
gitui        # Stage and commit

# 4. Push branch
git push -u origin feature-name
```

### File Management Workflow
```bash
# 1. Navigate with lf
lf

# 2. Quick operations in lf:
#    v → select files → y → copy
#    d → move to trash
#    Space → preview files
```

### Search & Replace
```bash
# Search in files
Ctrl+F (telescope live grep)

# Find files by name
Ctrl+P (telescope find files)

# Command line search
rg "pattern" | nvim -  # Edit results
```

## Session Management

### Project Switching
| Key | Action |
|-----|--------|
| `Alt+Space` | Popup: workspace session |
| `Ctrl+J` | Fuzzy-find any session |
| `Alt+T` | Workspace in current dir |
| `Alt+G` | Quick scratch session |

### Window Management
| Task | Key |
|------|-----|
| New terminal | `Ctrl+T` in tmux |
| Split horizontal | `tmux: Prefix+"` |
| Split vertical | `tmux: Prefix+%` |
| Switch panes | `tmux: Prefix+hjkl` |

## Productivity Shortcuts

### Quick Commands
| Task | Command |
|------|---------|
| Edit config | `nvim ~/.zshrc` |
| Source config | `source ~/.zshrc` |
| System update | `sudo apt update && sudo apt upgrade` |
| Check tools | `mise list` |

### Shell Aliases
| Alias | Command |
|-------|---------|
| `l` | `ls -la` |
| `la` | `ls -A` |
| `g` | `git` |
| `gs` | `git status` |
| `k` | `kubectl` |
| `dc` | `docker-compose` |

## Git Workflow

### Daily Commit Pattern
```bash
# 1. Check what changed
gs

# 2. Stage changes
gitui    # Visual staging

# 3. Commit
# In gitui: Space files → c → type message → Enter

# 4. Push to remote
git push
```

### Branch Management
```bash
# Switch branches
git checkout branch-name

# Create new branch
git checkout -b feature-name

# Sync with main
git checkout main
git pull origin main
git checkout feature-branch
git merge main
```

## End of Day

### Clean Up
1. **Commit all work**
   - `gs` → check status
   - `gitui` → stage and commit
   - `git push` → sync to remote

2. **Save session**
   - tmux sessions persist automatically
   - Clean up temporary scratch sessions

3. **Update notes**
   - `Ctrl+T` → todo session
   - Update doing.md/done.md

## Troubleshooting Quick Fixes

### Merge Conflicts
```bash
# Edit conflicts
nvim $(git diff --name-only | head -1)

# Or use gitui
gitui  # Shows conflicted files, press e to edit
```

### File Recovery
```bash
# Restore deleted file
git checkout HEAD -- filename

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard all local changes
git reset --hard HEAD
```

## Quick Reference Card

**Session:** `Alt+Space` → select
**Files:** `Ctrl+T` → find → `Enter`
**Edit:** `nvim filename`
**Git:** `gitui` → `Space` files → `c`
**Search:** `Ctrl+F` → type → `Enter`
**Todo:** `Ctrl+T` (tmux todo session)
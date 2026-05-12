---
date: '2026-02-08'
description: 'Terminal session management with tmux and workspace patterns'
published: true
slug: 'cheatsheets/session-management'
title: 'Session Management Cheatsheet'
---

# Session Management Cheatsheet

## Tmux Session Operations

### Session Creation
| Key | Action |
|-----|--------|
| `Alt+Escape` | Popup: create new workspace |
| `Ctrl+T` | Todo list session (nvim) |
| `tmux new -s name` | Manual session creation |

### Session Navigation
| Key | Action |
|-----|--------|
| `Alt+Space` | Popup: attach to workspace |
| `Ctrl+J` | Fuzzy-find any session |
| `Alt+T` | Workspace in current directory |
| `J` | tmux session tree browser |

### Quick Session Access
| Key | Target |
|-----|--------|
| `Ctrl+W` | ~/work directory |
| `Alt+W` | ~/work directory |
| `Ctrl+G` | ~/git directory |
| `Ctrl+P` | ~/project directory |

### Session Management
| Key | Action |
|-----|--------|
| `Ctrl+K` | Popup: kill sessions |
| `tmux ls` | List all sessions |
| `tmux kill-session -t name` | Kill specific session |

## Workspace Patterns

### Project Workspace
```bash
# Create project-specific session
Alt+T  # Creates workspace in current dir

# Session structure:
# Window 1: nvim (code)
# Window 2: gitui (version control)
# Window 3: lf (file management)
# Window 4: shell (commands)
```

### Scratch Sessions
| Key | Session Type |
|-----|--------------|
| `Alt+G` | Small scratch session |
| `Alt+Shift+G` | Large scratch session |

### Todo Session
| Key | Purpose |
|-----|---------|
| `Ctrl+T` | Todo management (nvim with 3 files) |
|  | - backlog.md |
|  | - doing.md |
|  | - done.md |

## Window Management

### Window Creation
| Key | Action |
|-----|--------|
| `tmux: Prefix+c` | Create new window |
| `tmux: Prefix+"` | Split horizontal |
| `tmux: Prefix+%` | Split vertical |

### Window Navigation
| Key | Action |
|-----|--------|
| `tmux: Prefix+n` | Next window |
| `tmux: Prefix+p` | Previous window |
| `tmux: Prefix+0-9` | Go to window number |
| `tmux: Prefix+ hjkl` | Navigate panes |

### Window Naming
| Key | Action |
|-----|--------|
| `tmux: Prefix+,` | Rename window |
| `tmux: Prefix+&` | Kill window |

## Session Templates

### Development Session
```bash
# Window 1: Code Editor
nvim .

# Window 2: Git Operations  
gitui

# Window 3: File Manager
lf

# Window 4: Terminal/Testing
# Open for commands
```

### Review Session
```bash
# Window 1: PR/Code Review
nvim files-to-review

# Window 2: Git Status
git status

# Window 3: Build/Testing
# Run tests, builds
```

### Debug Session
```bash
# Window 1: Code with issues
nvim problem-file

# Window 2: Logs/Terminal
tail -f logs/app.log

# Window 3: Shell for debugging
# Commands, inspection
```

## Session Persistence

### What Persists
- tmux sessions survive reboots
- Working directories maintained
- Window layouts preserved
- Running processes continue

### What Doesn't Persist
- Shell history (managed by zsh)
- Temporary files
- Clipboard contents

### Backup Sessions
```bash
# Save session configuration
tmux list-windows -t session-name > session-backup.txt

# Recreate session from backup
# Use saved layout to rebuild
```

## Workflow Patterns

### Context Switching
```bash
# Switch to different project
Alt+Space  # Select workspace session

# Quick scratch for temporary work
Alt+G  # Open scratch session

# Return to main work
Ctrl+J  # Fuzzy-find main session
```

### Collaborative Sessions
```bash
# Share session with pair programming
tmux new -s pair-programming
# Other person: tmux attach -t pair-programming
```

### Automated Sessions
```bash
# Session for specific task
tmux new -s task-name \; \
  send-keys 'nvim file1' Enter \; \
  new-window \; \
  send-keys 'cd project && git status' Enter
```

## Quick Reference

**Start work:** `Alt+Space` → select workspace
**Quick scratch:** `Alt+G` → temporary session  
**Project hopping:** `Ctrl+J` → fuzzy-find
**Kill session:** `Ctrl+K` → select → confirm
**Todo time:** `Ctrl+T` → task management
**File browse:** `Alt+C` → find directory → `lf`

## Session Health

### Clean Up Sessions
```bash
# List all sessions
tmux ls

# Kill dead sessions
tmux kill-session -t dead-session

# Clean up detached
tmux list-sessions | grep detached
```

### Session Monitoring
```bash
# Check session activity
tmux list-sessions -F '#{session_name}: #{session_attached}'

# Monitor long-running processes
# In session: jobs -l
```

## Best Practices

1. **One session per project** - Keeps context organized
2. **Name sessions meaningfully** - Easy identification
3. **Use consistent window layouts** - Muscle memory
4. **Kill unused sessions** - Prevent clutter
5. **Backup important layouts** - Quick recreation
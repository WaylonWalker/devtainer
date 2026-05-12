---
date: '2026-02-08'
description: 'Git commands and workflows quick reference'
published: true
slug: 'cheatsheets/git'
title: 'Git Cheatsheet'
---

# Git Cheatsheet

## Setup & Config
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
```

## Repository Operations
| Command | Action |
|---------|--------|
| `git init` | Initialize repository |
| `git clone url` | Clone repository |
| `git status` | Show status |
| `git log --oneline` | Compact log |
| `git log --graph` | Visual branch graph |

## Staging & Committing
| Command | Action |
|---------|--------|
| `git add file` | Stage file |
| `git add .` | Stage all |
| `git commit -m "msg"` | Commit staged |
| `git commit -am "msg"` | Stage+commit tracked |
| `git amend` | Edit last commit |
| `git reset file` | Unstage file |
| `git checkout -- file` | Discard changes |

## Branch Operations
| Command | Action |
|---------|--------|
| `git branch` | List branches |
| `git branch name` | Create branch |
| `git checkout branch` | Switch branch |
| `git checkout -b name` | Create+switch |
| `git branch -d name` | Delete merged |
| `git branch -D name` | Delete force |
| `git merge branch` | Merge branch |
| `git rebase branch` | Rebase onto |

## Remote Operations
| Command | Action |
|---------|--------|
| `git remote add name url` | Add remote |
| `git fetch` | Fetch changes |
| `git pull` | Pull + merge |
| `git push` | Push to remote |
| `git push -u origin branch` | Push+set upstream |
| `git push origin --delete branch` | Delete remote branch |

## History & Diff
| Command | Action |
|---------|--------|
| `git diff` | Show unstaged |
| `git diff --staged` | Show staged |
| `git diff HEAD~1` | Show last commit |
| `git show commit` | Show commit details |
| `git blame file` | Show line history |
| `git log -p file` | File history with diff |

## Stashing
| Command | Action |
|---------|--------|
| `git stash` | Stash changes |
| `git stash save "msg"` | Stash with message |
| `git stash list` | List stashes |
| `git stash apply` | Apply stash |
| `git stash pop` | Apply+remove |
| `git stash drop` | Remove stash |

## Undo & Fix
| Command | Action |
|---------|--------|
| `git reset --soft HEAD~1` | Undo last commit |
| `git reset --hard HEAD~1` | Undo last commit + changes |
| `git revert commit` | Create inverse commit |
| `git clean -fd` | Remove untracked files |

## Common Workflows

### Start New Feature
```bash
git checkout -b feature-name
# ...work...
git add .
git commit -m "Add feature description"
git push -u origin feature-name
```

### Sync Branch
```bash
git checkout main
git pull origin main
git checkout feature-branch
git merge main
git push
```

### Fix Last Commit
```bash
# Add forgotten file
git add forgotten-file
git commit --amend --no-edit
# Or edit message
git commit --amend
```

### Selective Commit
```bash
git add file1 file3
git commit -m "Commit specific files"
git add file2
git commit -m "Separate commit"
```

## Quick Tips
**Uncommitted changes:** `git stash` → `git pull` → `git stash pop`
**See what changed:** `git diff HEAD~5 HEAD`
**Find commit:** `git log --grep="search term"`
**Cherry-pick:** `git cherry-pick commit-hash`
**Tag release:** `git tag v1.0.0 && git push --tags`
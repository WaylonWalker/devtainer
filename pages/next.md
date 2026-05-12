---
date: '2026-02-07'
description: 'Upcoming content and improvements for the site'
published: true
tags: ['slash']
title: 'Next'
---

Upcoming content, improvements, and ideas for this documentation site.

## Guides & How-To

- [ ] **Installation/bootstrap guide** - Complete step-by-step fresh machine setup
- [ ] **Migration guide** - Moving from other tools (VS Code → Neovim, etc.)
- [ ] **Sync strategy** - How dotfiles stay synchronized across machines
- [ ] **Backup & restore** - Disaster recovery for the environment
- [ ] **Per-machine configs** - Laptop vs desktop differences
- [ ] **Troubleshooting** - Common issues and fixes with solutions

### Quick Reference Pages (Potential Additions)

- [ ] **mise recipes** - Common mise tool configurations
- [ ] **neovim recipes** - Language-specific neovim setups  
- [ ] **tmux layouts** - Project-specific session layouts
- [ ] **git workflows** - Team-specific git process documentation

## Deep Dives

- [ ] **Workflow documentation** - "How I work" series
  - TDD workflow
  - Debugging workflow
  - Code review process
- [ ] **Plugin deep dives** - Specific neovim plugins explained
- [ ] **Script explanations** - Custom scripts in detail
  - workspace.py
  - web2app function
  - kube-check script

## Meta/Context

- [x] **Tool comparison** - Detailed comparisons (Why X over Y) → [[tool-comparison]]
- [x] **Evolution** - How the setup has changed over 10+ years → [[evolution]]
- [x] **Philosophy** - Deeper dive into the "why" behind choices → [[philosophy]]
- [x] **Hardware** - Detailed workstation specs → [[hardware]]

## Interactive/Reference

- [x] **Cheatsheets** - Quick reference cards for common operations → [[cheatsheets]]

## Improvements

- [x] Add wikilink support to zellij page (it's missing the embeds) → [[zellij]]
- [x] Create uv.md page (referenced in yep.md but missing) → [[uv]]
- [x] Add more external embeds to tool pages
- [x] **VHS recordings for key workflows** - Designed 12 tape posts with markdown frontmatter

### VHS Recording Infrastructure

Each VHS tape now has its own markdown post in `pages/tapes/` with:
- Frontmatter including `template: image` and `image: /tapes/filename.mp4`
- Description of what is shown
- Key takeaway
- Related tool embeds

**Tape Posts Created:**
- [x] lf-intro.md - Basic file manager navigation
- [x] lf-tmux-popup.md - Popup integration workflow
- [x] gitui-intro.md - Staging and committing
- [x] tmux-scratch-session.md - Alt+G scratch pad workflow
- [x] tmux-session-switching.md - Session management
- [x] tmux-git-project-session.md - Project-specific sessions
- [x] fzf-file-finding.md - Ctrl+T fuzzy finding
- [x] fzf-history-search.md - Ctrl+R history search
- [x] lazygit-staging.md - Alternative git UI workflow
- [x] lazydocker-containers.md - Docker management
- [x] neovim-telescope.md - File finding in editor
- [x] neovim-lsp-go-to-definition.md - Code navigation

**Still to Record:**
- [ ] Record actual mp4 files for all designed tapes
- [ ] tmux "day in the terminal" workflow demo
- [ ] Workspace management script demo
- [ ] Kubernetes workflow with k9s

**Sandbox Setup:**
All VHS recordings use the `vhs/sandbox/` directory for safety. See AGENTS.md for sandbox best practices.

**Workflow Demos (20-30 seconds)**
- "A day in the terminal" - tmux session → neovim → gitui → back
- Workspace management - Using workspace script to switch projects
- Git workflow - Branch, edit, stage, commit with gitui
- File exploration - fzf + lf + bat pipeline
- Kubernetes workflow - k9s to inspect, edit, apply

**Setup Guides (30-45 seconds)**
- Fresh machine bootstrap - mise install → stow configs → verify
- Adding a new tool - Update mise config → install → verify → commit
- Creating a workspace - ~/git/workspaces/workspaces.py create workflow

**Configuration Highlights (15-20 seconds)**
- Starship prompt customization - Show git status, tool versions
- tmux keybinding demo - Prefix key, splits, popups
- Neovim plugin showcase - Telescope file finding, LSP features

**Comparison Videos**
- "Before/After" - Mouse-heavy workflow vs keyboard-driven
- IDE vs Terminal - Same task in VS Code vs neovim+tmux

**Tape Organization**
```
vhs/
├── tools/
│   ├── tmux-intro.tape
│   ├── fzf-demo.tape
│   └── lazygit-workflow.tape
├── workflows/
│   ├── git-workflow.tape
│   ├── dev-session.tape
│   └── workspace-switching.tape
└── guides/
    ├── bootstrap.tape
    └── new-tool-setup.tape
```

**Integration with Docs**
- Embed videos in tool pages after the "Features" section
- Use as hero videos on index pages
- Link to full recordings from quickstart guides
- Create GIF fallbacks for mobile/low-bandwidth
- [ ] Dark/light theme toggle

## Content Ideas

### Still To Create

- **ricing** - Aesthetic customization beyond function
- **one-shot-apps** - Documentation for the one-shot-apps directory
- **ansible** - Infrastructure as code for machine setup
- **distrobox** - Container-based development environments
- **qutebrowser** - Keyboard-driven web browser config
- **k9s** - Kubernetes terminal UI

### Recently Completed (Not Previously Listed)

- **hyprland** - Wayland tiling compositor configuration → [[hyprland]]
- **helix** - Modern modal text editor → [[helix]]
- **awesome** - X11 tiling window manager → [[awesome]]
- **lazygit** - Git TUI alternative to gitui → [[lazygit]]
- **atuin** - Enhanced shell history with sync → [[atuin]]
- **delta** - Syntax-highlighted git diff viewer → [[delta]]
- **gh** - GitHub CLI for git operations → [[gh]]
- **starship** - Fast, customizable shell prompt → [[starship]]
- **kitty** - GPU-accelerated terminal emulator → [[kitty]]
- **wezterm** - Cross-platform terminal emulator → [[wezterm]]
- **polybar** - Status bar for X11 window managers → [[polybar]]
- **waybar** - Status bar for Wayland compositors → [[waybar]]
- **yazi** - Async file manager alternative to lf → [[yazi]]
- **workspace** - Project management and workspace switching → [[workspace]]
- **defaults** - Default application and system configurations → [[defaults]]

---

*This is a living document. Items will be checked off as they're completed and new ideas will be added.*

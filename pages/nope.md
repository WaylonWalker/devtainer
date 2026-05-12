---
date: '2026-02-07'
description: 'Things I avoid and do not recommend'
published: true
tags: ['slash']
title: 'Nope'
---

Things I avoid, do not use, or actively recommend against.

This is not about bashing tools that work for others - these are things that do not work for *me* and my workflows.

## Software I Avoid

### IDEs

- **VS Code** - Resource-heavy for what I need. I prefer Neovim's speed and efficiency.
- **JetBrains products** - Overkill for my use cases and too resource-intensive.

Why: I spend most of my time in a terminal. Heavy IDEs feel sluggish and get in my way.

### Window Managers

- **GNOME** - Too much mouse interaction, not keyboard-friendly enough for my workflow.
- **i3** (personally) - Used it for years, but prefer Hyprland's Wayland-native approach now.

Note: I actually like KDE, but my primary requirement for any window manager is robust workspace management with hotkeys. I need win+num to switch, win+shift+num to send apps, and win+ctrl+num to join workspaces. I enjoy tiling but have no strong preference between tiling and floating - both work fine with a good workspace manager that lets me reach any app in one keystroke.

### Development Tools

- **nvm/rbenv/pyenv separately** - Use [[mise]] instead. One tool instead of many.
- **Docker Desktop** - Bloated. Use podman or docker CLI directly.

### Python Dependency Management

After years using pip-tools, hatch, and conda, I've been **uv pilled**. I now avoid:

- **Poetry** - Overly complex for my needs
- **Hatch** - Used it for years, but uv is simpler
- **pip-tools** - Used it for years, uv replaces it completely
- **virtualenv** - uv handles environments
- **conda** - Used it for years, uv + pyproject.toml is cleaner
- **flit** - Unnecessary with uv

**What I use instead:** [[uv]] - Fast, simple, and handles everything I need.

### JavaScript Development

I avoid JavaScript frameworks with heavy build pipelines and deep node_modules trees. I prefer:

- **Vanilla JavaScript** - No build step, no dependencies
- **CDN libraries** - Add what you need via script tag
- **Simple tools** - Avoid webpack, complex bundlers, and deep dependency chains

## Practices I Avoid

- **Mouse-heavy workflows** - Slows me down, causes wrist strain
- **Clicking through GUIs** - Prefer keyboard shortcuts and CLI
- **Manual, repetitive tasks** - Automate or script everything
- **Keeping everything in my head** - Document in version control
- **Heavy build pipelines** - Prefer simplicity over complexity

## Business Models

- **Subscription fatigue** - Prefer perpetual licenses or open source
- **Vendor lock-in** - Prefer tools with open standards and export options
- **Cloud-only dependencies** - Keep local-first options available

## Counter-Arguments I Accept

These tools work great for others:

- VS Code has excellent debugging support
- IDEs provide discoverability for new developers
- GUI tools can be more approachable
- Complex build pipelines enable powerful optimizations
- Poetry and conda solve real problems for many teams

Use what works for you. These are my preferences, not universal truths.

See [[yep]] for things I do recommend.

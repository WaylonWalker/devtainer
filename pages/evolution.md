---
date: '2026-02-08'
description: 'How my development setup has evolved over 10+ years'
published: true
title: 'Evolution'
---

The journey from beginner to professional developer. How tools, workflows, and preferences have changed over a decade of programming.

## Timeline Overview

```
2014-2016: The Beginner Years
├── Sublime Text + Chrome DevTools
├── MAMP/XAMP for local development
├── Git GUI clients (SourceTree)
└── Ubuntu Unity desktop

2016-2018: The Transition Years  
├── Vim + Tmux + Git Bash (Windows)
├── PHPStorm for professional work
├── Docker emerges for development
└── First terminal multiplexer experience

2018-2020: The Linux Years
├── Full Linux migration
├── Vim + Airline + YouCompleteMe
├── tmux becomes essential
├── First dotfile management attempts
└── i3 window manager experimentation

2020-2022: The Optimization Years
├── Neovim 0.5 + LSP revolution
├── zsh + Oh My Zsh deep dive
├── Custom scripts and automation
├── Package manager proliferation
└── Remote work becomes primary

2022-2024: The Modern Years
├── mise unified tool management
├── Kitty + Hyprland (Wayland)
├── GitUI for git operations
├── fzf integration everywhere
└── Devcontainer/remote development
```

## The Beginner Years (2014-2016)

### First Development Environment

**Hardware:** Consumer laptop, Windows 8.1
**Editor:** Sublime Text 2 with plugins
**Terminal:** Git Bash on Windows
**Version Control:** GitHub Desktop GUI
**Local Server:** XAMPP for PHP development
**Browser:** Chrome DevTools for debugging

**Typical Workflow:**
1. Open Sublime Text
2. Edit files in tabs
3. Switch to browser, refresh
4. Use XAMPP control panel to restart Apache
5. Push via GitHub Desktop
6. FTP files to production server

**Pain Points:**
- Context switching between applications
- GUI tools were slow for repetitive tasks
- No keyboard muscle memory
- Manual file synchronization
- Limited customization options

**Learning Experiences:**
- First exposure to version control
- Understanding of file systems
- Basic command line usage
- Web development fundamentals

## The Transition Years (2016-2018)

### Professional Development Tools

**Hardware:** Work laptop, Windows 10
**Editor:** PHPStorm (work), Notepad++ (personal)
**Terminal:** Windows Terminal + Git Bash
**Version Control:** SourceTree, Git commands
**Database:** phpMyAdmin, Workbench
**Remote:** PuTTY for SSH connections

**Key Changes:**
- First exposure to professional IDEs
- Started using command line more frequently
- Introduction to Docker containers
- Vagrant for development environments
- Git workflow with branching strategies

**Pain Points:**
- Still GUI-heavy workflow
- Windows/Linux tool inconsistency
- Slow IDE performance on large projects
- Manual environment setup
- No unified tool management

**Breakthrough Moments:**
- Vim keyboard shortcuts in IDEs
- Understanding of command line efficiency
- Containerization concept
- Dotfile awareness begins

## The Linux Years (2018-2020)

### Full Linux Migration

**Hardware:** Personal desktop build, Ubuntu 18.04
**Editor:** Vim with extensive configuration
**Terminal:** Gnome Terminal + tmux
**Version Control:** Git CLI + magit
**Window Manager:** i3wm (experiments)
**Package Management:** apt, npm, pip (separate)

**Major Shift:**
- Complete migration from Windows
- Vim for all text editing
- Terminal becomes primary interface
- First serious dotfile management
- Tmux for session persistence

**Configuration Evolution:**
```bash
# Early vimrc (~2018)
set number
set syntax on
colorscheme desert

# Evolving vimrc (~2019)
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set incsearch
set hlsearch

# Early tmux config (~2019)
set -g mode-keys vi
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R
```

**New Pain Points:**
- Plugin management complexity (Pathogen, then Vundle)
- Multiple package managers conflict
- Fragmented configuration
- Manual synchronization across machines
- Learning curve steep but rewarding

## The Optimization Years (2020-2022)

### Remote Work Revolution

**Hardware:** Home office setup, Ubuntu 20.04
**Editor:** Neovim 0.4-0.5 with LSP
**Terminal:** Alacritty + tmux + zsh
**Version Control:** Git CLI + some GUI tools
**Configuration:** vim-plug, Oh My Zsh
**Dotfiles:** Git stow for management

**Critical Changes:**
- Neovim with LSP (game changer)
- Remote work becomes permanent
- Heavy investment in keyboard shortcuts
- Systematic dotfile management
- Focus on speed and efficiency

**LSP Integration Impact:**
```lua
-- Early nvim LSP setup (~2020)
require'nvim_lsp'.setup{
  tsserver = {},
  pyright = {},
  html = {},
}
```

**Tool Consolidation:**
- One terminal for everything
- Consistent keybindings across tools
- Scripted workflows
- Reduced GUI usage to minimum

**Performance Optimizations:**
- Fast keyboard shortcuts
- Efficient file navigation
- Quick project switching
- Automated repetitive tasks

## The Modern Years (2022-2024)

### Unified Tool Management

**Hardware:** Development workstation, Ubuntu 22.04/24.04
**Editor:** Neovim 0.8+ with full Lua config
**Terminal:** Kitty + tmux + zsh
**Tool Management:** mise for everything
**Shell:** zsh with custom configuration
**Synchronization:** Git + automated scripts

**Modern Configuration:**
```toml
# .mise.toml - single source of truth
[tools]
python = "3.11"
node = "20"
rust = "stable"
uv = "latest"
fzf = "latest"
```

**Key Innovations:**
- mise unified tool management
- Wayland migration (Hyprland)
- GitUI for fast git operations
- Comprehensive fuzzy finding
- Container-based development
- Cross-machine synchronization

**Current Workflow:**
1. Open terminal (Kitty)
2. Tmux session with workspace
3. Neovim for code editing
4. GitUI for version control
5. fzf integrated everywhere
6. All tools consistent across machines

## Technology Evolution by Category

### Editors

| Era | Editor | Reason for Change |
|-----|--------|-------------------|
| 2014-16 | Sublime Text | Easy for beginners |
| 2016-18 | PHPStorm | Professional development |
| 2018-20 | Vim | Speed and portability |
| 2020-22 | Neovim | LSP and Lua scripting |
| 2022-24 | Neovim (optimized) | Ultimate customization |

### Terminal Multiplexers

| Era | Tool | Reason for Change |
|-----|------|-------------------|
| 2016-18 | None | Didn't understand the need |
| 2018-20 | tmux (basic) | Session persistence |
| 2020-22 | tmux (advanced) | Essential productivity |
| 2022-24 | tmux (custom) | Maximized efficiency |

### Shell

| Era | Shell | Reason for Change |
|-----|-------|-------------------|
| 2014-16 | Windows CMD | Only option available |
| 2016-18 | Git Bash | Git compatibility |
| 2018-20 | bash | Linux standard |
| 2020-22 | zsh + Oh My Zsh | Powerful features |
| 2022-24 | zsh (minimal) | Performance + customization |

### Package Management

| Era | Tool | Reason for Change |
|-----|------|-------------------|
| 2018-20 | System package managers | Basic needs |
| 2020-22 | Multiple managers | Language-specific tools |
| 2022-24 | mise | Unified management |

## Philosophy Evolution

### Early Years (2014-2018)
- "GUI tools are easier"
- "If it works, don't change it"
- "Configuration is overkill"
- "Learning curve isn't worth it"

### Transition Years (2018-2020)
- "Maybe CLI is better"
- "Vim shortcuts are useful"
- "Terminal multiplexing saves time"
- "Investment in learning pays off"

### Optimization Years (2020-2022)
- "Keyboard-first is fastest"
- "Customization matters"
- "Consistency across tools"
- "Automation is essential"

### Modern Years (2022-2024)
- "Efficiency is paramount"
- "Unified tool management"
- "Minimal, powerful configuration"
- "Cross-machine consistency"

## Pain Point Resolution

### Then vs Now

| Problem | Then (2018) | Now (2024) |
|---------|-------------|------------|
| Switching contexts | Multiple apps | Single terminal |
| File finding | GUI browsers | fzf + telescope |
| Version control | GUI clients | GitUI + CLI |
| Environment setup | Manual per project | mise + containers |
| Cross-machine sync | Manual copying | Git + scripts |
| Plugin management | Multiple systems | Built-in or single |
| Configuration sync | Manual copying | Git + stow |

## Key Breakthrough Moments

### 1. Vim Modal Editing (2018)
Understanding that modes make text manipulation orders of magnitude faster than traditional editors.

### 2. Tmux Sessions (2019)
Realizing that terminal sessions could persist and be organized like desktop workspaces.

### 3. Neovim LSP (2020)
Language Server Protocol bringing IDE features to terminal editors without sacrificing speed.

### 4. Mise Tool Management (2022)
Single tool managing all development environments instead of separate managers.

### 5. Wayland Migration (2023)
Moving to Wayland for better performance and multi-monitor support.

## Missed Opportunities

### Tools I Should Have Adopted Earlier

**Git CLI (vs GUI):** 2 years of productivity lost to GUI tools
**Vim (vs Sublime):** 3 years of slower text editing
**Terminal multiplexer:** 2 years of inefficient session management

### Technologies I Overlooked

**Containerization (2016):** Early Docker adoption would have simplified many projects
**Functional programming:** Rust concepts would have improved my programming
**Keyboard-first design:** Should have adopted earlier than 2018

## Future Evolution (2024+)

### Emerging Technologies

**AI Integration:** LLMs for code completion and documentation
**WebAssembly:** Desktop applications in the browser
**Cloud development:** True cloud-native IDEs
**Cross-platform tools:** Unified Linux/macOS/Windows experience

### Potential Changes

- Hybrid terminal/GUI workflows
- AI-powered development environments
- Container-based development as default
- Edge computing development

### Constant Principles

- Keyboard-first when possible
- Minimal, powerful tools
- Extensive customization
- Cross-platform consistency
- Open source preference

## Lessons Learned

### Technical Insights

1. **Investment pays off** - Time spent learning tools compounds
2. **Consistency matters** - Uniform tools reduce cognitive load
3. **Keyboard beats mouse** - For repetitive text manipulation
4. **Configuration is documentation** - Your setup should be self-explanatory
5. **Remote work changes everything** - Tools must work over SSH

### Personal Growth

1. **Patience with learning** - Complex tools have steep curves
2. **Evolution over revolution** - Gradual changes work better
3. **Community knowledge** - Leverage others' experience
4. **Document everything** - Future you will thank present you
5. **Balance efficiency and joy** - Tools should be both fast and pleasant

## See Also

![[ philosophy ]]

![[ tool-comparison ]]

![embed](https://github.com/topics/history)
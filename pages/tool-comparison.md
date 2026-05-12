---
date: '2026-02-08'
description: 'Detailed tool comparisons and why I chose X over Y'
published: true
title: 'Tool Comparison'
---

Why I chose specific tools over alternatives. These are my personal preferences based on workflow, performance, and philosophy.

## Terminal Multiplexers

### tmux vs Zellij

| Feature | tmux | Zellij |
|---------|------|--------|
| **Maturity** | 15+ years, battle-tested | Newer, actively developing |
| **Ecosystem** | Huge community, scripts | Growing, modern |
| **Performance** | Extremely fast, lightweight | Fast but larger binary |
| **Configuration** | Simple text config | KDL config, more complex |
| **Layouts** | Manual splitting | Declarative YAML layouts |
| **Plugins** | Limited (tmux plugins) | WASM-based, extensible |

**Why tmux?**
- Established and stable with years of battle testing
- Simpler configuration when needed
- Massive community and resources
- Performance critical for daily work
- Minimal dependencies and setup

**When I'd use Zellij:**
- If I wanted declarative layouts
- For teams preferring modern plugin system
- If I was starting from scratch today

### lf vs yazi

| Feature | lf | yazi |
|---------|----|------|
| **Language** | Go (compiled) | Rust + async I/O |
| **Speed** | Instant startup | Very fast |
| **Memory** | Minimal | Higher but still good |
| **Preview** | Configurable shell commands | Built-in, async |
| **Customization** | Shell commands | Lua config |
| **Dependencies** | Very few | More (for async) |

**Why lf?**
- Simpler configuration via shell commands
- Predictable behavior
- Smaller memory footprint
- Integrates perfectly with existing shell tools

**When I'd use yazi:**
- If I wanted better async file previews
- For image/media heavy workflows
- If I preferred Lua over shell config

## Git Tools

### gitui vs lazygit

| Feature | gitui | lazygit |
|---------|-------|---------|
| **Speed** | Extremely fast | Fast |
| **UI** | Minimal, keyboard-first | Feature-rich, some mouse |
| **Learning curve** | Low | Medium |
| **Customization** | Limited | High |
| **Advanced features** | Basic | Advanced (rebase, interactive) |

**Why gitui?**
- Speed is critical for frequent operations
- Keyboard-first philosophy matches my workflow
- Minimal interface reduces cognitive load
- Perfect for 90% of git operations

**When I'd use lazygit:**
- Complex rebase operations
- When I want more visual feedback
- For teams preferring feature-rich interfaces

## Shell

### zsh vs fish vs bash

| Feature | zsh | fish | bash |
|---------|-----|------|------|
| **Compatibility** | Bash-compatible | Not POSIX | POSIX standard |
| **Plugins** | Oh My Zsh huge | Built-in features | Limited |
| **Learning** | Medium | Easy | Easy |
| **Performance** | Good | Excellent | Best |
| **Innovation** | Mature | Innovative | Stable |

**Why zsh?**
- Bash compatibility means scripts work everywhere
- Huge plugin ecosystem via Oh My Zsh
- Powerful completion and customization
- Industry standard for power users

**When I'd use fish:**
- For beginners wanting excellent out-of-box experience
- When I don't need POSIX compatibility
- For systems where I want minimal config

## Package Management

### mise vs pyenv vs asdf

| Feature | mise | pyenv | asdf |
|---------|------|-------|------|
| **Speed** | Rust (fastest) | Ruby (slower) | Bash (slowest) |
| **Languages** | Many | Python only | Extensible |
| **Configuration** | TOML | Shell | Custom |
| **Backend** | Rust | Ruby | Bash |
| **Installation** | Single binary | Many deps | Many deps |

**Why mise?**
- Written in Rust for maximum speed
- Single binary, minimal dependencies
- Modern configuration with TOML
- Fast switching between versions
- Good balance of features vs complexity

**When I'd use pyenv:**
- If I only needed Python
- For legacy systems where mise isn't available

## Editors

### Neovim vs Helix vs VS Code

| Feature | Neovim | Helix | VS Code |
|---------|---------|-------|---------|
| **Learning curve** | High | Medium | Low |
| **Speed** | Extremely fast | Very fast | Slow |
| **Resource usage** | Minimal | Minimal | High |
| **Customization** | Unlimited | Good | High |
| **Language support** | LSP + plugins | Built-in | Excellent |
| **Mouse** | Optional | Optional | First-class |

**Why Neovim?**
- Modal editing is most efficient for text manipulation
- Extensible to do anything I need
- Works over SSH with full functionality
- Muscle memory from years of use
- Scriptable in Lua for automation

**When I'd use Helix:**
- If I wanted modern LSP integration out of box
- For simpler configuration than Neovim
- When I want good defaults without plugins

**When I'd use VS Code:**
- For complex debugging sessions
- When I need GUI-based profiling
- For team projects requiring specific extensions

## Terminal Emulators

### kitty vs wezterm vs alacritty

| Feature | kitty | wezterm | alacritty |
|---------|-------|---------|-----------|
| **Performance** | GPU-accelerated | Fast | Fastest |
| **Features** | Rich features | Most features | Minimal |
| **Configuration** | Python | Lua | TOML |
| **Multiplexer** | Built-in | Built-in | None |
| **Platform support** | Good | Excellent | Limited |

**Why kitty?**
- GPU acceleration for smooth rendering
- Good balance of features vs complexity
- Python config is flexible
- Built-in multiplexer for simple sessions
- Good font rendering and themes

**When I'd use wezterm:**
- For cross-platform consistency
- If I needed more advanced multiplexer features
- When Lua config is preferred

**When I'd use alacritty:**
- For maximum performance
- Minimal interface preferences
- When I don't need built-in features

## File Search

### fzf vs ripgrep vs grep

| Feature | fzf | ripgrep | grep |
|---------|-----|---------|------|
| **Use case** | Interactive search | Fast text search | Traditional |
| **Speed** | Good | Excellent | Variable |
| **Interface** | Interactive | CLI | CLI |
| **Regex** | Basic | PCRE2 | Basic |
| **Integration** | Universal | Standalone | Shell builtin |

**Why fzf + ripgrep combo:**
- fzf for interactive selection of anything
- ripgrep for fast file content search
- They work better together than separately
- Complementary strengths

## Workflow Philosophy

### Keyboard vs Mouse

| Aspect | Keyboard-First | Mouse-First |
|--------|---------------|-------------|
| **Speed** | Faster for text | Better for spatial |
| **Precision** | High | Medium |
| **Learning** | Steep | Easy |
| **RSI risk** | Lower | Higher |
| **Remote work** | Excellent | Poor |

**Why keyboard-first:**
- Precision commands eliminate clicking errors
- Muscle memory enables blind operation
- Works equally well locally and over SSH
- Reduced hand movement means less fatigue
- Text manipulation is fundamentally keyboard work

## Cost-Benefit Analysis

### When to Choose Complex Tools

| Tool | Simple Alternative | When Complexity is Worth It |
|------|-------------------|----------------------------|
| Neovim | nano/vim | Daily text manipulation |
| tmux | screen tabs | Complex session management |
| zsh | bash | Advanced completion/history |
| lf | ranger/mc | Heavy file operations |

### When to Choose Simple Tools

| Complex Tool | Simple Alternative | When Simple is Better |
|--------------|-------------------|----------------------|
| lazygit | git commands | Quick one-off operations |
| mise | system packages | Single-language projects |
| kitty | alacritty | Basic terminal needs |
| fzf | find/grep | Simple search patterns |

## Decision Framework

### My Tool Selection Criteria

1. **Performance** - Speed matters for daily use
2. **Reliability** - Tools must work consistently
3. **Keyboard-first** - Minimize mouse usage
4. **Extensibility** - Should adapt to my needs
5. **Remote-friendly** - Must work over SSH
6. **Open source** - Prefer free and inspectable code
7. **Active development** - Avoid abandoned projects

### Red Flags in Tool Selection

- Breaking changes frequently
- Heavy GUI requirements
- Poor keyboard support
- No remote/SSH capability
- Abandoned development
- Proprietary lock-in
- Complex dependencies

## See Also

![[ philosophy ]]

![[ evolution ]]

![embed](https://github.com/topics/terminal)
---
date: '2026-02-07'
description: 'Starship - minimal, fast, and customizable shell prompt'
published: true
title: 'Starship Prompt'
---

[Starship](https://starship.rs/) is a minimal, fast, and customizable prompt
for any shell. It provides useful context at a glance without cluttering your
terminal.

## Features

- **Fast** - Written in Rust, renders in milliseconds
- **Cross-shell** - Works with zsh, bash, fish, and more
- **Informative** - Git status, tool versions, execution time
- **Customizable** - Extensive configuration options

## Setup

### Installation

Via mise (recommended):

```bash
mise install starship
```

Or direct install:

```bash
curl -sS https://starship.rs/install.sh | sh
```

### Shell Integration

Add to `~/.zshrc`:

```bash
eval "$(starship init zsh)"
```

## Configuration

Config file: `~/.config/starship.toml`

### Minimal Setup

```toml
# Don't print a new line at the start of the prompt
add_newline = false

# Replace the "❯" symbol in the prompt with "➜"
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
```

### Git Status

Show detailed git information:

```toml
[git_status]
conflicted = "🏳"
ahead = "🏎💨"
behind = "😰"
diverged = "😵"
up_to_date = "✓"
untracked = "🤷"
stashed = "📦"
modified = "📝"
staged = "[++\($count\)](green)"
renamed = "👅"
deleted = "🗑"
```

### Tool Versions

Show active tool versions:

```toml
[nodejs]
format = "via [🤖 $version](bold green) "

[python]
format = "via [🐍 $version](bold blue) "

[rust]
format = "via [🦀 $version](bold red) "

[golang]
format = "via [🐹 $version](bold cyan) "
```

### Directory

Customize how directories are displayed:

```toml
[directory]
truncation_length = 3
truncate_to_repo = true
```

### Command Duration

Show how long the last command took:

```toml
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"
```

## Modules

Starship supports many modules out of the box:

### Development

- **git_branch** - Current git branch
- **git_commit** - Current git commit
- **git_state** - Rebase/merge/cherry-pick state
- **git_status** - Working tree status
- **package** - Package version from package.json, Cargo.toml, etc.

### Languages

- **nodejs** - Node.js version
- **python** - Python version and virtualenv
- **rust** - Rust version
- **golang** - Go version
- **ruby** - Ruby version
- **lua** - Lua version

### System

- **directory** - Current directory
- **hostname** - System hostname
- **username** - Current user
- **time** - Current time
- **battery** - Battery percentage
- **memory_usage** - RAM usage

### Tools

- **aws** - AWS profile
- **gcloud** - Google Cloud region
- **kubernetes** - Current k8s context
- **terraform** - Terraform workspace

## Conditional Formatting

Show modules only in certain contexts:

```toml
[nodejs]
detect_extensions = ["js", "mjs", "cjs", "ts"]
detect_files = ["package.json", ".node-version"]
detect_folders = ["node_modules"]
```

## Performance

Starship is designed to be fast, but you can optimize further:

```toml
# Disable unused modules
[fill]
disabled = true

[line_break]
disabled = true

# Reduce git status checks
[git_status]
disabled = false
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
```

## Transient Prompt

Keep previous prompts minimal:

```toml
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

# This requires shell-specific config
```

For zsh, add to `~/.zshrc`:

```bash
# Transient prompt
setopt transient_rprompt
```

## Troubleshooting

### Prompt not showing

1. Check starship is in PATH: `which starship`
2. Verify init command is in shell config
3. Restart shell: `exec zsh`

### Slow prompt

Profile with: `STARSHIP_LOG=trace starship prompt`

## See Also

![embed](https://starship.rs/config/)

![[ zsh ]]

![embed](https://starship.rs/presets/)

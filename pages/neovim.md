---
date: '2026-02-07'
description: 'Neovim configuration with lazy.nvim for plugin management'
published: true
title: 'Neovim Configuration'
---

Neovim is my primary text editor, configured with a modern setup using
lazy.nvim for plugin management.

## Features

- **lazy.nvim** - Fast, modern plugin manager
- **LSP** - Language Server Protocol for IDE-like features
- **Treesitter** - Better syntax highlighting and parsing
- **fzf/telescope** - Fuzzy finding for files, buffers, and more
- **Git integration** - Gitsigns, fugitive, and diffview

## Setup

### Installation

Via mise (recommended):

```bash
mise install neovim
```

Or from source/package manager:

```bash
# Ubuntu/Debian
sudo apt install neovim

# Arch Linux
sudo pacman -S neovim

# macOS
brew install neovim
```

### Configuration Structure

```
nvim/.config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json          # Plugin lockfile
└── lua/
    ├── config/
    │   ├── keymaps.lua     # Key bindings
    │   ├── options.lua     # Vim options
    │   └── lazy.lua        # Plugin manager setup
    └── plugins/            # Individual plugin configs
```

## Plugin Categories

### Core

- **lazy.nvim** - Plugin manager
- **plenary.nvim** - Lua utility library
- **nvim-web-devicons** - File type icons

### LSP & Completion

- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP server installer
- **nvim-cmp** - Completion engine
- **LuaSnip** - Snippet engine

### Fuzzy Finding

- **telescope.nvim** - Fuzzy finder framework
- **telescope-fzf-native** - Native fzf integration
- **telescope-ui-select** - UI selection enhancement

### Git

- **gitsigns.nvim** - Git decorations in gutter
- **vim-fugitive** - Git commands
- **diffview.nvim** - Enhanced diff viewing

### UI

- **lualine.nvim** - Status line
- **bufferline.nvim** - Tab-like buffer line
- **nvim-tree.lua** - File explorer
- **which-key.nvim** - Keybinding helper
- **indent-blankline.nvim** - Indentation guides

### Editing

- **nvim-treesitter** - Syntax tree parser
- **vim-surround** - Surround text objects
- **vim-commentary** - Comment toggling
- **nvim-autopairs** - Auto-close brackets
- **vim-sleuth** - Automatic indentation detection

### Themes

- **tokyonight.nvim** - Main color scheme

## Key Concepts

### Lazy Loading

Plugins are loaded on demand to improve startup time:

```lua
-- Load only when opening a file
{ "nvim-treesitter", event = "BufReadPost" }

-- Load on specific command
{ "neo-tree.nvim", cmd = "Neotree" }

-- Load on key mapping
{ "telescope.nvim", keys = { "<leader>ff", "<leader>fg" } }
```

### LSP Setup

Language servers are configured via mason and lspconfig:

```lua
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "pyright" }
})
```

### Custom Keymaps

All keymaps are in `lua/config/keymaps.lua`:

```lua
-- Leader key
vim.g.mapleader = " "

-- Quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
```

## Daily Workflow

### File Navigation

- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags

### Code Navigation

- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation

### Git

- `]c` / `[c` - Next/previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk

## Performance Tips

1. **Check startup time**: `nvim --startuptime startup.log`
2. **Profile plugins**: `:Lazy profile`
3. **Disable unused providers**:

```lua
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
```

## See Also

![embed](https://lazy.folke.io/)

![embed](https://github.com/neovim/nvim-lspconfig)

![embed](https://github.com/nvim-telescope/telescope.nvim)

![[ helix ]]

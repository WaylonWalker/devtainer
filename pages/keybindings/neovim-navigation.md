---
title: "Navigation and Movement - Neovim Keybindings"
slug: "neovim-navigation"
date: 2026-02-07
published: true
tags: ["neovim", "keybindings", "navigation"]
description: "Navigation and Movement keybindings for Neovim"
environment: "neovim"
category: "navigation"
aliases: ["neovim-navigation"]
---

Move through your code efficiently. Jump between files, symbols, and references.

## Keybindings

| Key | Mode | Description |
|-----|------|-------------|
| <S-Tab> | insert | vim.snippet.jump if active, otherwise <S-Tab> |
| <Tab> | insert | vim.snippet.jump if active, otherwise <Tab> |
| <Tab> | visual_select | vim.snippet.jump if active, otherwise <Tab> |
| # | visual_select | :help v_#-default |
| * | visual_select | :help v_star-default |
| <S-Tab> | visual_select | vim.snippet.jump if active, otherwise <S-Tab> |
| [B | normal | :brewind |
| [b | normal | :bprevious |
| [T | normal | :trewind |
| [t | normal | :tprevious |
| [A | normal | :rewind |
| [a | normal | :previous |
| [L | normal | :lrewind |
| [l | normal | :lprevious |
| [Q | normal | :crewind |
| [q | normal | :cprevious |
| [D | normal | Jump to the first diagnostic in the current buffer |
| [d | normal | Jump to the previous diagnostic in the current buffer |
| ]B | normal | :blast |
| ]b | normal | :bnext |
| ]T | normal | :tlast |
| ]t | normal | :tnext |
| ]A | normal | :last |
| ]a | normal | :next |
| ]L | normal | :llast |
| ]l | normal | :lnext |
| ]Q | normal | :clast |
| ]q | normal | :cnext |
| ]D | normal | Jump to the last diagnostic in the current buffer |
| ]d | normal | Jump to the next diagnostic in the current buffer |
| <C-W><C-D> | normal | Show diagnostics under the cursor |
| <C-W>d | normal | Show diagnostics under the cursor |
| # | visual | :help v_#-default |
| * | visual | :help v_star-default |
| <Tab> | select | vim.snippet.jump if active, otherwise <Tab> |
| <S-Tab> | select | vim.snippet.jump if active, otherwise <S-Tab> |

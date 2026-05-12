---
title: "LSP and IntelliSense - Neovim Keybindings"
slug: "neovim-lsp"
date: 2026-02-07
published: true
tags: ["neovim", "keybindings", "lsp"]
description: "LSP and IntelliSense keybindings for Neovim"
environment: "neovim"
category: "lsp"
aliases: ["neovim-lsp"]
---

Navigate code like an IDE. Jump to definitions, view documentation, and fix errors.

## Keybindings

| Key | Mode | Description |
|-----|------|-------------|
| gra | visual_select | vim.lsp.buf.code_action() |
| gO | normal | vim.lsp.buf.document_symbol() |
| grt | normal | vim.lsp.buf.type_definition() |
| gri | normal | vim.lsp.buf.implementation() |
| grr | normal | vim.lsp.buf.references() |
| gra | normal | vim.lsp.buf.code_action() |
| grn | normal | vim.lsp.buf.rename() |
| gra | visual | vim.lsp.buf.code_action() |

---
title: "Complete Keybindings List"
slug: "keybindings-complete-list"
date: 2026-02-07
published: true
tags: ["keybindings", "reference", "complete"]
description: "Complete alphabetical list of all keybindings across all environments"
aliases: ["keybindings-complete-list"]
---

All keybindings across Neovim and Awesome WM environments, organized alphabetically for quick reference.


## Neovim Keybindings

| Key | Mode | Description | Command |
|-----|------|-------------|----------|
| `#` | Visual | :help v_#-default | nil |
| `#` | Visual_select | :help v_#-default | nil |
| `%` | Normal |  | <Plug>(MatchitNormalForward) |
| `%` | Operator_pending |  | <Plug>(MatchitOperationForward) |
| `%` | Visual |  | <Plug>(MatchitVisualForward) |
| `%` | Visual_select |  | <Plug>(MatchitVisualForward) |
| `&` | Normal | :help &-default | :&&<CR> |
| `*` | Visual | :help v_star-default | nil |
| `*` | Visual_select | :help v_star-default | nil |
| `@` | Visual | :help v_@-default | mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>' : '@' |
| `@` | Visual_select | :help v_@-default | mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>' : '@' |
| `[ ` | Normal | Add empty line above cursor | nil |
| `[%` | Normal |  | <Plug>(MatchitNormalMultiBackward) |
| `[%` | Operator_pending |  | <Plug>(MatchitOperationMultiBackward) |
| `[%` | Visual |  | <Plug>(MatchitVisualMultiBackward) |
| `[%` | Visual_select |  | <Plug>(MatchitVisualMultiBackward) |
| `[<C-L>` | Normal | :lpfile | nil |
| `[<C-Q>` | Normal | :cpfile | nil |
| `[<C-T>` | Normal |  :ptprevious | nil |
| `[a` | Normal | :previous | nil |
| `[A` | Normal | :rewind | nil |
| `[b` | Normal | :bprevious | nil |
| `[B` | Normal | :brewind | nil |
| `[D` | Normal | Jump to the first diagnostic in the current buffer | nil |
| `[d` | Normal | Jump to the previous diagnostic in the current buffer | nil |
| `[l` | Normal | :lprevious | nil |
| `[L` | Normal | :lrewind | nil |
| `[q` | Normal | :cprevious | nil |
| `[Q` | Normal | :crewind | nil |
| `[t` | Normal | :tprevious | nil |
| `[T` | Normal | :trewind | nil |
| `] ` | Normal | Add empty line below cursor | nil |
| `]%` | Normal |  | <Plug>(MatchitNormalMultiForward) |
| `]%` | Operator_pending |  | <Plug>(MatchitOperationMultiForward) |
| `]%` | Visual |  | <Plug>(MatchitVisualMultiForward) |
| `]%` | Visual_select |  | <Plug>(MatchitVisualMultiForward) |
| `]<C-L>` | Normal | :lnfile | nil |
| `]<C-Q>` | Normal | :cnfile | nil |
| `]<C-T>` | Normal | :ptnext | nil |
| `]A` | Normal | :last | nil |
| `]a` | Normal | :next | nil |
| `]B` | Normal | :blast | nil |
| `]b` | Normal | :bnext | nil |
| `]D` | Normal | Jump to the last diagnostic in the current buffer | nil |
| `]d` | Normal | Jump to the next diagnostic in the current buffer | nil |
| `]L` | Normal | :llast | nil |
| `]l` | Normal | :lnext | nil |
| `]Q` | Normal | :clast | nil |
| `]q` | Normal | :cnext | nil |
| `]T` | Normal | :tlast | nil |
| `]t` | Normal | :tnext | nil |
| `a%` | Visual |  | <Plug>(MatchitVisualTextObject) |
| `a%` | Visual_select |  | <Plug>(MatchitVisualTextObject) |
| `g%` | Normal |  | <Plug>(MatchitNormalBackward) |
| `g%` | Operator_pending |  | <Plug>(MatchitOperationBackward) |
| `g%` | Visual |  | <Plug>(MatchitVisualBackward) |
| `g%` | Visual_select |  | <Plug>(MatchitVisualBackward) |
| `gc` | Normal | Toggle comment | nil |
| `gc` | Operator_pending | Comment textobject | nil |
| `gc` | Visual | Toggle comment | nil |
| `gc` | Visual_select | Toggle comment | nil |
| `gcc` | Normal | Toggle comment line | nil |
| `gO` | Normal | vim.lsp.buf.document_symbol() | nil |
| `gra` | Normal | vim.lsp.buf.code_action() | nil |
| `gra` | Visual | vim.lsp.buf.code_action() | nil |
| `gra` | Visual_select | vim.lsp.buf.code_action() | nil |
| `gri` | Normal | vim.lsp.buf.implementation() | nil |
| `grn` | Normal | vim.lsp.buf.rename() | nil |
| `grr` | Normal | vim.lsp.buf.references() | nil |
| `grt` | Normal | vim.lsp.buf.type_definition() | nil |
| `gx` | Normal | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | nil |
| `gx` | Visual | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | nil |
| `gx` | Visual_select | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | nil |
| `Q` | Visual | :help v_Q-default | mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q' |
| `Q` | Visual_select | :help v_Q-default | mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q' |
| `Y` | Normal | :help Y-default | y$ |


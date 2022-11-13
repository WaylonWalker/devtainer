--  ╭─────╮  ╭────────╮  ╭─────╮
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     ╰──╯        ╰──╯     │
--  │           init.lua       │
--  │           @_waylonwalker │
--  ╰──────────────────────────╯
--
-- ## usage
--
-- require'waylonwalker'
local M = {}

M.settings = require'waylonwalker.settings'
M.options = require'waylonwalker.options'
M.globals = require'waylonwalker.globals'
M.packer = require'waylonwalker.packer'
M.keymap = require'waylonwalker.keymap'
M.autocmds = require'waylonwalker.autocmds'
M.util = require'waylonwalker.util'
M.plugins = require'waylonwalker.plugins'
M.snippets = require'waylonwalker.snippets'


return M

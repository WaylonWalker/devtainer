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

M.setup = require("waylonwalker.setup")
M.settings = require("waylonwalker.settings")
M.lazy = require("waylonwalker.lazy")
M.options = require("waylonwalker.options")
M.globals = require("waylonwalker.globals")
M.keymap = require("waylonwalker.keymap")
M.autocmds = require("waylonwalker.autocmds")
M.util = require("waylonwalker.util")
M.plugins = require("waylonwalker.plugins")
M.snippets = require("waylonwalker.snippets")
M.daily_note = require("waylonwalker.daily_note")

return M

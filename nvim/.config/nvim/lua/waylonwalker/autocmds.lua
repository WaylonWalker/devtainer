local settings = require'waylonwalker.settings'
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

local M = {}

M.waylonwalker_augroup = augroup('waylonwalker', { clear = true })

M.sync_packer = function()
    print('syncing')
    vim.cmd("runtime lua/waylonwalker/packer.lua")
    require("packer").sync()
end

-- automatically run PackerSync on save of plugins.lua
if settings.packer_auto_sync then
  -- source plugins.lua and run PackerSync on save
  autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "packer.lua" },
    callback = M.sync_packer,
  })
end

-- M.has_pyflyby = os.execute('command -v tidy-imports') == 0
-- M.has_black = os.execute('command -v black') == 0
-- M.has_isort = os.execute('command -v isort') == 0

M.format_python = function()
    vim.cmd('silent execute "!tidy-imports --black --quiet --replace-star-imports --replace --add-missing --remove-unused " . bufname("%")')
    vim.cmd('silent execute "!isort " . bufname("%")')
    vim.cmd('silent execute "!black " . bufname("%")')
end

if settings.auto_format.python then
    autocmd({ "BufWritePost" }, {
        group=M.waylonwalker_augroup,
        pattern = { "*.py" },
        callback = M.format_python,
    })
end

return M


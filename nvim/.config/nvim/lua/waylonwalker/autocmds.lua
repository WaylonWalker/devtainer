local settings = require("waylonwalker.settings")
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local M = {}

M.waylonwalker_augroup = augroup("waylonwalker", { clear = true })

M.sync_packer = function()
    print("syncing")
    vim.cmd("runtime lua/waylonwalker/packer.lua")
    require("packer").sync()
end

-- automatically run PackerSync on save of plugins.lua
if settings.packer_auto_sync then
    -- source plugins.lua and run PackerSync on save
    autocmd({ "BufWritePost" }, {
        group = M.waylonwalker_augroup,
        pattern = { "packer.lua" },
        callback = M.sync_packer,
    })
end

return M

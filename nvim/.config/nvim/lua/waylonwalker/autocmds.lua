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

M.has_pyflyby = os.execute('command -v tidy-imports') == 0
M.has_black = os.execute('command -v black') == 0
M.has_isort = os.execute('command -v isort') == 0

M.format_python = function()

    local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) or ''
    local filename = filepath:match("^.+/(.+)$")

    if M.has_pyflyby then
        os.execute("tidy-imports --black --quiet --replace-star-imports --action REPLACE " .. filename)
        print('tidy-imports was ran')
        print(os.execute('where tidy-imports'))
    else
        print('tidy-imports command not found')
        print(os.execute('where tidy-imports'))
    end
    if M.has_isort then
        os.execute("isort " .. filename)
    end
    if M.has_black then
        os.execute("black " .. filename)
    end
    vim.cmd('e')

end


if settings.auto_format.python then
    autocmd({ "BufWritePre" }, {
        group=M.waylonwalker_augroup,
        pattern = { "*.py" },
        callback = M.format_python,
    })
end

return M


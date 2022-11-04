local M = {}
M.open = false
M.iswinmax = false
local api = vim.api

M.openqf = function()
    -- Toggles the quickfix menu
    if M.open then
        api.nvim_command('cclose') M.open = false
    else
        api.nvim_command('bel copen')
        api.nvim_command('wincmd k')
        M.open = true
    end
end

M.winmax = function()
    -- Toggles the current window between full and equal space
    if M.iswinmax then
        api.nvim_command('wincmd =')
        M.iswinmax = false
    else
        api.nvim_command('wincmd |')
        api.nvim_command('wincmd _')
        M.iswinmax = true
    end
end

return M


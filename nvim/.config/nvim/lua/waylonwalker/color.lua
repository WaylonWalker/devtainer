--            _            _             
--   ___ ___ | | ___  _ __| |_   _  __ _ 
--  / __/ _ \| |/ _ \| '__| | | | |/ _` |
-- | (_| (_) | | (_) | | _| | |_| | (_| |
--  \___\___/|_|\___/|_|(_)_|\__,_|\__,_|
--

local M = {}
local api = vim.api

vim.o.termguicolors = true
vim.o.background = 'dark'


require('colorbuddy').colorscheme('onebuddy')

vim.cmd('highlight Normal ctermbg=NONE')
vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
vim.cmd('highlight CursorLineNr ctermbg=NONE guibg=NONE ')
vim.cmd('highlight SignColumn ctermbg=3')
vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE ')

M.nobg = function()
    vim.cmd('highlight Normal guibg=None ctermbg=NONE')
    vim.cmd('highlight CursorLineNr ctermbg=NONE guibg=NONE')
    vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')
    vim.cmd('nohl')
end

api.nvim_set_keymap('n', '<leader><cr>', ":lua require'waylonwalker.color'.nobg()<cr>", { noremap = true, silent = true })

return M

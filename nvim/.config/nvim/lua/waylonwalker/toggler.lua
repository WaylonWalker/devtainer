local foo = 1
local M = {}
M.open = false
M.iswinmax = false
local api = vim.api


M.openqf = function()
    if M.open then
        api.nvim_command('cclose')
        M.open = false
    else
        api.nvim_command('bel copen')
        api.nvim_command('wincmd k')
        M.open = true
    end
end

M.winmax = function()
    if M.iswinmax then
        api.nvim_command('wincmd =')
        M.iswinmax = false
    else
        api.nvim_command('wincmd |')
        api.nvim_command('wincmd _')
        M.iswinmax = true
    end
end

api.nvim_set_keymap('n', '<c-q>', ":lua require'waylonwalker.toggler'.openqf()<cr>", { noremap = true, silent = true })
api.nvim_set_keymap('n', '<c-w><c-w>', ":lua require'waylonwalker.toggler'.winmax()<cr>", { noremap = true, silent = true })
-- :nnoremap <silent> <Leader><Space> :set hlsearch<CR>
return M


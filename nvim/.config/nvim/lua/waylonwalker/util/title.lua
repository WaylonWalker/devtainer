local M = {}
local api = vim.api
local Path = require("plenary.path")

M.write_title = function()
    title = vim.api.nvim_get_current_line():gsub('#', '')
    print(title)
    Path:new('~/.config/title/title.txt'):write(title, 'w')
    local pipe = io.popen('tmux source-file ~/.tmux.conf')
    vim.defer_fn(function()
        pipe:flush()
        pipe:close()
    end, 250)
end

api.nvim_set_keymap('n', '<leader><leader>t', ":lua require'waylonwalker.title'.write_title()<cr>", { noremap = true, silent = true })

return M

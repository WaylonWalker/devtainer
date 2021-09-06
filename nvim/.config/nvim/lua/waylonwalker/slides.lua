
-- session_name=`tmux display-message -p '#S'`
-- tmux new-session -Ad -s "${session_name}-slides" -c "#{pane_current_path}" "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme /home/u_walkews/git/waylonwalker.com/pages/blog/nvim-ides-are-slow.md" 
-- tmux switch-client -t "${session_name}-slides"
--
local M = {}
local api = vim.api
local Path = require("plenary.path")

M.get_session_name = function()
    return io.popen("tmux display-message -p '#S'"):read()
end

M.open_slides= function()
    local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) 
    local filename = filepath:match("^.+/(.+)$"):gsub('.md', '')
    local current_session_name = M.get_session_name()
    local session_name = current_session_name .. '-' .. filename .. '-slides'
    print(filename)
    print(session_name)
    -- print('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme ' .. filepath .. ' --live-reload --style gruvbox-dark"')
    os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme ' .. filepath .. ' --live-reload --style gruvbox-dark"')
    os.execute('tmux switch-client -t "' .. session_name .. '"')
end

api.nvim_set_keymap('n', '<leader><leader>s', ":lua require'waylonwalker.slides'.open_slides()<cr>", { noremap = true, silent = true })

return M


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

default_config = {
    cmd = "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme",
    opts = "--live-reload --style gruvbox-dark",
    use_tmux = true
}

SlidesConfig = SlidesConfig or default_config

M.open_slides= function(config)
    local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) 
    local filename = filepath:match("^.+/(.+)$"):gsub('.md', '')
    local current_session_name = M.get_session_name()
    local session_name = current_session_name .. '-' .. filename .. '-slides'
    config = config or {}
    cmd = config.cmd or SlidesConfig.cmd or default_config.cmd
    opts = config.opts or SlidesConfig.opts or default_config.opts
    
    if config.use_tmux ~= nil then
        use_tmux = config.use_tmux
    elseif SlidesConfig.use_tmux ~= nil then
        use_tmux = SlidesConfig.use_tmux
    else
        use_tmux = default_config.use_tmux
    end

    if use_tmux then
        os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "' .. cmd .. " " .. filepath .. " " .. opts .. '"')
        os.execute('tmux switch-client -t "' .. session_name .. '"')
    else
        vim.cmd('term ' .. cmd .. "  " .. filepath .. " " .. opts)
        vim.cmd('startinsert')
    end


    -- end
end

-- api.nvim_set_keymap('n', '<leader><leader>s', ":lua require'waylonwalker.slides'.open_slides()<cr>", { noremap = true, silent = true })
vim.cmd("command! Slides lua require'waylonwalker.slides'.open_slides()")
vim.cmd("command! SlidesTmux lua require'waylonwalker.slides'.open_slides({use_tmux=true})")
vim.cmd("command! SlidesTerm lua require'waylonwalker.slides'.open_slides({use_tmux=false})")

M.setup = function(config)
    if not config then
        local config = default_config
    end
    SlidesConfig = config
end

return M

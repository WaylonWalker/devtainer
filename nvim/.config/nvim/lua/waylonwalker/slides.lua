
--  _____                     _   _             _     _   
-- | ____|_  _____  ___ _   _| |_(_) ___  _ __ (_)___| |_ 
-- |  _| \ \/ / _ \/ __| | | | __| |/ _ \| '_ \| / __| __|
-- | |___ >  <  __/ (__| |_| | |_| | (_) | | | | \__ \ |_ 
-- |_____/_/\_\___|\___|\__,_|\__|_|\___/|_| |_|_|___/\__|.nvim
                                                       
-- Waylon Walker
-- 
-- ## Example usage
--
-- ``` vim
-- nnoremap <leader><leader>m :ExecutionistTmuxPopup man
-- nnoremap <leader><leader>S :ExecutionistTmuxPopup pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>
-- nnoremap <leader><leader>s :ExecutionistTmux pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>
-- ```
--
-- ## Todo
--
-- Make Base command take arguments rather than having 3 different ones.  This
-- could get even worse if we start adding things like tmux window, or new
-- terminal

local M = {}
local api = vim.api
local Path = require("plenary.path")

M.get_session_name = function()
    return io.popen("tmux display-message -p '#S'"):read()
end

default_config = {
    cmd = "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark",
    session_name = '{current_session_name}-{filename}',
    how = 'term'
}

ExecutionistConfig = ExecutionistConfig or default_config

sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

local _get_parent = (function()
  local formatted = string.format("^(.+)%s[^%s]+", sep, sep)
  return function(abs_path)
    return abs_path:match(formatted)
  end
end)()


M.executionist= function(config)
    local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) 
    local filename = filepath:match("^.+/(.+)$")
    local current_session_name = M.get_session_name()
    config = config or {}
    cmd = config.cmd or ExecutionistConfig.cmd or default_config.cmd
    how = config.how or ExecutionistConfig.how or default_config.how
    local session_name = config.session_name or ExecutionistConfig.session_name or default_config.session_name
    
    local format_command = function(command_str)
        return (command_str
            :gsub("{filepath}", filepath)
            :gsub("{parent}", _get_parent(filepath))
            :gsub("{filename}", filename)
            :gsub("{current_session_name}", current_session_name)
            :gsub("{cword}", vim.fn.expand"<cword>")
            :gsub("{cWORD}", vim.fn.expand"<cWORD>")
            )
    end

    
    local command = format_command(cmd)
    local session_name = format_command(session_name):gsub("%.", '_')

    if how == 'tmux' then
        -- print(session_name)
        os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "' .. command .. '"')
        os.execute('tmux switch-client -t "' .. session_name .. '"')
        -- print('tmux switch-client -t "' .. session_name .. '"')
    elseif how == 'tmux-popup-session' or how == 'tmux_popup_session' then
        os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "' .. command .. '"')
        os.execute('tmux display-popup "tmux new-session -A -s ' .. session_name .. '"')
    elseif how == 'tmux_popup' or how == 'tmux-popup' then
        os.execute('tmux display-popup  -E ' .. command )
    else
        vim.cmd('term ' .. command)
        vim.cmd('startinsert')
    end


end

vim.cmd("command! -nargs=1 Executionist lua require'waylonwalker.slides'.executionist({cmd=<f-args>})")
vim.cmd("command! -nargs=1 ExecutionistTmux lua require'waylonwalker.slides'.executionist({cmd=<f-args>, how='tmux'})")
vim.cmd("command! -nargs=1 ExecutionistTmuxPopup lua require'waylonwalker.slides'.executionist({cmd=<f-args>, how='tmux_popup'})")

vim.cmd("nnoremap <leader><leader>m :ExecutionistTmuxPopup man ")
vim.cmd("nnoremap <leader><leader>S :ExecutionistTmuxPopup pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>")
vim.cmd("nnoremap <leader><leader>s :ExecutionistTmux pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>")

M.setup = function(config)
    if not config then
        local config = default_config
    end
    ExecutionistConfig = config
end

return M

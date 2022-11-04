
-- function! s:GitAdd()
--     exe "G add %"
--     " exe "G diff --staged"
--     " exe "only"
--     exe "G commit --verbose"
-- endfunction
-- :command! GitAdd :call s:GitAdd()
-- nnoremap gic :GitAdd<CR>

local M = {}

function M.git_add()
    vim.cmd('G add %')
    vim.cmd('G commit --verbose')
end

function M.get_remote()
    local remote = ''
    local result = io.popen('git config --get remote.origin.url'):read()
    if result then
        remote = result:gsub('https://github.com/', 'gh:'):gsub('.git', '') or ''
    end
    return remote
end

vim.api.nvim_create_user_command('GitAdd', M.git_add, { nargs = 0 })

return M

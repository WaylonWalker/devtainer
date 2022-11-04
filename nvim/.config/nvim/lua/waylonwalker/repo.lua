local M = {}

local function get_remote()
    local remote = ''
    local result = io.popen('git config --get remote.origin.url'):read()
    if result then
        remote = result:gsub('https://github.com/', 'gh:'):gsub('.git', '') or ''
    end
    return remote
end

M.get_remote = get_remote
return M


local M = {}
M.packer_auto_sync = true
function M.print()
    print(vim.inspect(M))
end

M.auto_format = {
    python=true,
}

return M


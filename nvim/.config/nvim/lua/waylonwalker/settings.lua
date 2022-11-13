local M = {}
M.packer_auto_sync = true
function M.print()
    print(vim.inspect(M))
end

M.auto_format = {
    python=true,
    markdown=true,
    html=true,
    javascript=true,
    json=true,
    yaml=true,
}

return M


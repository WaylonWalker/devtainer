local M = {}
M.packer_auto_sync = true
M.lazy_auto_sync = true
M.auto_format = true
M.pre_commit = false

function M.print()
	print(vim.inspect(M))
end

-- M.auto_format = {
--     python=true,
--     markdown=true,
--     html=true,
--     javascript=true,
--     json=true,
--     yaml=true,
-- }
--

return M

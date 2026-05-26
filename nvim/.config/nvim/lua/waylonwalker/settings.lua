local M = {}
M.lazy_auto_sync = true
M.auto_format = false
M.pre_commit = true
M.use_copilot = os.getenv("NVIM_COPILOT_ENABLED") == "true" or false
M.docker_build = os.getenv("DOCKER_BUILD") == "true" or false
M.use_codeium = os.getenv("NVIM_CODEIUM_ENABLED") == "true" or false

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

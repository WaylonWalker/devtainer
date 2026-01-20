local M = {}

function M.yank_slug()
	-- Get current file name (without path and extension)
	local file_name = vim.fn.expand("%:t:r")
	
	-- Create slug by:
	-- 1. Converting to lowercase
	-- 2. Replacing non-alphanumeric characters with hyphens
	-- 3. Removing consecutive hyphens
	-- 4. Removing leading/trailing hyphens
	local slug = file_name:lower()
		:gsub("[^a-z0-9]+", "-")
		:gsub("^%-+", "")
		:gsub("%-+$", "")
		:gsub("%-+", "-")
	
	-- Copy to system clipboard and vim register
	vim.fn.setreg("+", slug)
	vim.fn.setreg('"', slug)
	
	-- Show notification
	print("Yanked slug: " .. slug)
end

return M
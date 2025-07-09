-- Dependencies: os.date, vim.fn, vim.cmd

local M = {}

function M.check_and_open_daily_note()
	local daily_dir = "pages/daily"
	local today = os.date("%Y-%m-%d")
	local pattern = string.format("%s/%s*-notes.md", daily_dir, today)

	-- Check if today's note exists
	local files = vim.fn.glob(pattern, false, true)

	if vim.tbl_isempty(files) then
		-- Create new note via copier
		os.execute("copier copy ~/.copier-templates/daily .")

		-- Re-glob to get the new file (may need to wait a moment for creation)
		vim.wait(500, function()
			return not vim.tbl_isempty(vim.fn.glob(pattern, false, true))
		end, 10)

		files = vim.fn.glob(pattern, false, true)
	end

	-- Open the note (if multiple, just pick the first)
	if not vim.tbl_isempty(files) then
		vim.cmd("edit " .. files[1])
	else
		print("Failed to find or create today's note.")
	end
	vim.cmd("mode")
end

vim.api.nvim_create_user_command("DailyNote", function()
	M.check_and_open_daily_note()
end, {})

vim.api.nvim_create_user_command("Daily", function()
	M.check_and_open_daily_note()
end, {})

vim.api.nvim_create_user_command("DailyFiles", function()
	require("telescope.builtin").find_files({
		cwd = "pages/daily",
		sorting_strategy = "ascending",
	})
end, {})

vim.keymap.set("n", "<leader>dn", M.check_and_open_daily_note)
vim.keymap.set("n", "<leader>df", function()
	require("telescope.builtin").find_files({
		cwd = "pages/daily",
		sorting_strategy = "ascending",
	})
end)

return M

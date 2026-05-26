-- markata-go lint integration
-- Provides workspace-wide diagnostics from markata-go lint command

local M = {}

local function parse_lint_output(output)
	local diagnostics = {}
	local current_file = nil
	local root = vim.loop.cwd()

	for line in output:gmatch("[^\n]+") do
		-- Match file header: "path/to/file.md:"
		local file_match = line:match("^([^:]+):$")
		if file_match then
			current_file = file_match
		end

		-- Match diagnostic line: "  warning [line X, col Y]: message"
		local severity, line_num, col_num, message = line:match(
			"%s+(warning|error|note)%s+%[line%s+(%d+),%s+col%s+(%d+)%]:%s+(.*)"
		)

		if severity and current_file then
			line_num = tonumber(line_num)
			col_num = tonumber(col_num)

			-- Convert severity to LSP severity codes
			local severity_code = 2 -- Warning
			if severity == "error" then
				severity_code = 1
			elseif severity == "note" then
				severity_code = 3
			end

			table.insert(diagnostics, {
				file = current_file,
				line = line_num - 1, -- LSP uses 0-based line numbers
				col = col_num - 1,   -- LSP uses 0-based columns
				severity = severity_code,
				message = message,
				source = "markata-go lint",
			})
		end
	end

	return diagnostics
end

M.get_all_diagnostics = function()
	local diagnostics = {}

	-- Find the markata project root by looking for markata.toml or markata-go.toml
	local root = vim.fn.getcwd()
	local found_root = false
	
	local function has_markata_toml(dir)
		return vim.fn.filereadable(vim.fn.fnamemodify(dir .. "/markata.toml", ":p")) == 1 or
		       vim.fn.filereadable(vim.fn.fnamemodify(dir .. "/markata-go.toml", ":p")) == 1
	end
	
	-- Search up the directory tree
	local current = root
	for _ = 1, 10 do
		if has_markata_toml(current) then
			root = current
			found_root = true
			break
		end
		local parent = vim.fn.fnamemodify(current, ":h")
		if parent == current then break end -- reached filesystem root
		current = parent
	end

	-- Run markata-go lint from the project root
	local cmd = string.format("cd %s && markata-go lint 2>&1", vim.fn.shellescape(root))
	local handle = io.popen(cmd)
	if not handle then
		return diagnostics
	end

	local output = handle:read("*a")
	handle:close()

	return parse_lint_output(output)
end

M.telescope_picker = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local diagnostics = M.get_all_diagnostics()

	-- Format diagnostics for display
	local entries = {}
	for _, diag in ipairs(diagnostics) do
		table.insert(entries, {
			display = string.format(
				"%s:%d:%d: [%s] %s",
				diag.file,
				diag.line + 1,
				diag.col + 1,
				diag.severity == 1 and "ERROR" or (diag.severity == 2 and "WARN" or "INFO"),
				diag.message
			),
			file = diag.file,
			line = diag.line,
			col = diag.col,
			message = diag.message,
		})
	end

	local picker = pickers.new({}, {
		prompt_title = "Markata Lint Issues",
		finder = finders.new_table({
			results = entries,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry.display,
					ordinal = entry.display,
				}
			end,
		}),
		previewer = false,
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					local entry = selection.value
					-- Open file and go to location
					vim.cmd("edit " .. entry.file)
					vim.api.nvim_win_set_cursor(0, { entry.line + 1, entry.col })
				end
			end)
			return true
		end,
	})

	picker:find()
end

return M

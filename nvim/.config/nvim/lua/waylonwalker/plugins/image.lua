local M = {}

local function is_image_url(url)
	if type(url) ~= "string" or url == "" then
		return false
	end

	local lowered = url:lower()
	return lowered:match("%.png$") ~= nil
		or lowered:match("%.jpe?g$") ~= nil
		or lowered:match("%.gif$") ~= nil
		or lowered:match("%.webp$") ~= nil
		or lowered:match("%.svg$") ~= nil
		or lowered:match("%.avif$") ~= nil
		or lowered:match("^https?://") ~= nil
end

local function install_markdown_integration()
	local document = require("image/utils/document")

	package.loaded["image/integrations/markdown"] = document.create_document_integration({
		name = "markdown",
		default_options = {
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			only_render_image_at_cursor_mode = "popup",
			floating_windows = false,
			filetypes = { "markdown", "vimwiki" },
		},
		query_buffer_images = function(buffer)
			local buf = buffer or vim.api.nvim_get_current_buf()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local images = {}

			local function add_match(row, start_col, end_col, url)
				if not is_image_url(url) then
					return
				end

				table.insert(images, {
					node = nil,
					range = {
						start_row = row,
						start_col = start_col,
						end_row = row,
						end_col = end_col,
					},
					url = url,
				})
			end

			for row, line in ipairs(lines) do
				local search_from = 1
				while true do
					local s, e, url = line:find("!%b[]%(([^)]+)%)", search_from)
					if not s then
						break
					end

					add_match(row - 1, s - 1, e, url)
					search_from = e + 1
				end

				search_from = 1
				while true do
					local s, e, url = line:find("%b[]%(([^)]+)%)", search_from)
					if not s then
						break
					end

					if s == 1 or line:sub(s - 1, s - 1) ~= "!" then
						add_match(row - 1, s - 1, e, url)
					end
					search_from = e + 1
				end
			end

			return images
		end,
	})
end

function M.setup()
	install_markdown_integration()

	require("image").setup({
		backend = "kitty",
		processor = "magick_cli",
		tmux_show_only_in_active_window = true,
	})
end

function M.toggle()
	local image = require("image")
	if image.is_enabled() then
		image.disable()
		vim.notify("Inline markdown images disabled", vim.log.levels.INFO, { title = "image.nvim" })
		return
	end

	image.enable()
	vim.notify("Inline markdown images enabled", vim.log.levels.INFO, { title = "image.nvim" })
end

return M

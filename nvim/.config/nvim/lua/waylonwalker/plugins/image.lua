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

local function install_focus_redraw()
	vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter" }, {
		group = vim.api.nvim_create_augroup("waylonwalker.image_redraw", { clear = true }),
		callback = function()
			local ok, image = pcall(require, "image")
			if not ok or not image.is_enabled() then
				return
			end

			vim.schedule(function()
				for _, img in ipairs(image.get_images()) do
					img:render()
				end
			end)
		end,
	})
end

local function tmux_pane_is_visible()
	local tmux_pane = vim.env.TMUX_PANE
	if not tmux_pane then
		return true
	end

	local output = vim.fn.systemlist({
		"tmux",
		"display-message",
		"-p",
		"-t",
		tmux_pane,
		"#{session_attached}:#{window_active}:#{pane_active}",
	})

	if vim.v.shell_error ~= 0 or #output == 0 then
		return true
	end

	local session_attached, window_active, pane_active = output[1]:match("^(%d+):(%d+):(%d+)$")
	return session_attached ~= "0" and window_active == "1" and pane_active == "1"
end

local function install_tmux_visibility_watcher()
	if not vim.env.TMUX_PANE then
		return
	end

	local timer = vim.uv.new_timer()
	if not timer then
		return
	end

	local images_hidden = false
	timer:start(
		750,
		750,
		vim.schedule_wrap(function()
			local ok, image = pcall(require, "image")
			if not ok or not image.is_enabled() then
				return
			end

			local images = image.get_images()
			if #images == 0 then
				return
			end

			if not tmux_pane_is_visible() then
				for _, img in ipairs(images) do
					img:clear(true)
				end
				images_hidden = true
				return
			end

			if images_hidden then
				for _, img in ipairs(images) do
					img:render()
				end
				images_hidden = false
			end
		end)
	)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("waylonwalker.image_tmux_visibility", { clear = true }),
		callback = function()
			timer:stop()
			timer:close()
		end,
	})
end

function M.setup()
	install_markdown_integration()

	require("image").setup({
		backend = "kitty",
		processor = "magick_cli",
		tmux_show_only_in_active_window = true,
		editor_only_render_when_focused = false,
	})

	install_focus_redraw()
	install_tmux_visibility_watcher()
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

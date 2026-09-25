local M = {}

local DEFAULTS = {
	base_url = "https://dropper.waylonwalker.com",
	token_env = "DROPPER_TOKEN",
	default_keymap = "<leader>md",
}

local config = vim.deepcopy(DEFAULTS)

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "dropper-markdown" })
end

local function canonicalize_dropper_url(url)
	return (url:gsub("^https://dropper%.wayl%.one", "https://dropper.waylonwalker.com"))
end

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function is_remote_path(path)
	return path:match("^https?://") or path:match("^ftp://")
end

local function is_dropper_path(path)
	return path:match("^https?://dropper%.waylonwalker%.com") or path:match("^https?://dropper%.wayl%.one")
end

local function resolve_path(markdown_path)
	local expanded = vim.fn.expand(markdown_path)
	if vim.fn.filereadable(expanded) == 1 then
		return expanded
	end

	local buffer_dir = vim.fn.expand("%:p:h")
	if buffer_dir == "" then
		buffer_dir = (vim.uv or vim.loop).cwd()
	end

	return vim.fn.fnamemodify(buffer_dir .. "/" .. markdown_path, ":p")
end

local function find_env_file()
	local start_dir = vim.fn.expand("%:p:h")
	if start_dir == "" then
		start_dir = (vim.uv or vim.loop).cwd()
	end

	local env_path = vim.fs.find(".env", {
		path = start_dir,
		upward = true,
		type = "file",
	})[1]

	if env_path and vim.fn.filereadable(env_path) == 1 then
		return env_path
	end
end

local function parse_env_line(line)
	local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
	if not key then
		key, value = line:match("^%s*export%s+([%w_]+)%s*=%s*(.-)%s*$")
	end
	if not key then
		return nil
	end

	if value:match('^".*"$') or value:match("^'.*'$") then
		value = value:sub(2, -2)
	end

	return key, value
end

local function read_env_var(name)
	local env_path = find_env_file()
	if not env_path then
		return nil
	end

	for line in io.lines(env_path) do
		if line and line ~= "" and not line:match("^%s*#") then
			local key, value = parse_env_line(line)
			if key == name then
				return value
			end
		end
	end

	return nil
end

local function resolve_env_var(name)
	local local_value = trim(read_env_var(name) or "")
	if local_value ~= "" then
		return local_value
	end

	local process_value = trim(os.getenv(name) or "")
	if process_value ~= "" then
		return process_value
	end

	return nil
end

local function parse_destination(destination)
	local wrapped_path, wrapped_suffix = destination:match("^%s*<([^>]+)>(.*)$")
	if wrapped_path then
		return wrapped_path, wrapped_suffix or ""
	end

	local plain_path, plain_suffix = destination:match("^%s*(%S+)(.*)$")
	return plain_path, plain_suffix or ""
end

local function basename_from_url(url)
	local without_query = url:match("^[^?#]+") or url
	local name = without_query:match("/([^/]+)$") or "upload.bin"
	name = name:gsub("%%20", " ")
	if name == "" then
		return "upload.bin"
	end
	return name
end

local function is_fence_line(line)
	return line:match("^%s*```") or line:match("^%s*~~~")
end

local function download_remote_file(url)
	if vim.fn.executable("curl") ~= 1 then
		error("curl is required")
	end

	local tmpdir = vim.fn.tempname()
	vim.fn.mkdir(tmpdir, "p")
	local output_path = tmpdir .. "/" .. basename_from_url(url)

	local result = vim.system({
		"curl",
		"--silent",
		"--show-error",
		"--fail",
		"--globoff",
		"--location",
		"--output",
		output_path,
		url,
	}, { text = true }):wait()

	if result.code ~= 0 then
		error((result.stderr or "download failed"):gsub("%s+$", ""))
	end

	return output_path
end

local function upload_file(file_path)
	if vim.fn.executable("curl") ~= 1 then
		error("curl is required")
	end

	local token = resolve_env_var(config.token_env)
	if not token then
		error("Missing " .. config.token_env)
	end

	local result = vim.system({
		"curl",
		"--silent",
		"--show-error",
		"--fail",
		"-X",
		"POST",
		config.base_url .. "/api/upload?format=json",
		"-H",
		"Authorization: Bearer " .. token,
		"-F",
		"file=@" .. file_path,
	}, { text = true }):wait()

	if result.code ~= 0 then
		error((result.stderr or "upload failed"):gsub("%s+$", ""))
	end

	local ok, payload = pcall(vim.json.decode, result.stdout)
	if not ok or type(payload) ~= "table" or type(payload.url) ~= "string" then
		error("Dropper response did not include a url")
	end

	return canonicalize_dropper_url(payload.url)
end

local function replace_markdown_images_in_lines(lines)
	local uploads = {}
	local downloads = {}
	local changed = 0
	local skipped = 0
	local in_code_fence = false

	for index, line in ipairs(lines) do
		if is_fence_line(line) then
			in_code_fence = not in_code_fence
			goto continue
		end

		if in_code_fence then
			goto continue
		end

		lines[index] = line:gsub("!%[([^%]]*)%]%(([^)]+)%)", function(alt, destination)
			local markdown_path, suffix = parse_destination(destination)
			if not markdown_path or markdown_path == "" then
				skipped = skipped + 1
				return string.format("![%s](%s)", alt, destination)
			end

			if is_dropper_path(markdown_path) then
				skipped = skipped + 1
				return string.format("![%s](%s)", alt, destination)
			end

			local resolved_path = markdown_path
			local ok, err = pcall(function()
				if is_remote_path(markdown_path) then
					resolved_path = downloads[markdown_path]
					if not resolved_path then
						resolved_path = download_remote_file(markdown_path)
						downloads[markdown_path] = resolved_path
					end
				else
					resolved_path = resolve_path(markdown_path)
				end
			end)
			if not ok then
				skipped = skipped + 1
				notify(err, vim.log.levels.WARN)
				return string.format("![%s](%s)", alt, destination)
			end

			if vim.fn.filereadable(resolved_path) ~= 1 then
				skipped = skipped + 1
				notify("File not found: " .. markdown_path, vim.log.levels.WARN)
				return string.format("![%s](%s)", alt, destination)
			end

			local uploaded_url = uploads[resolved_path]
			if not uploaded_url then
				local upload_ok, upload_err = pcall(function()
					uploaded_url = upload_file(resolved_path)
				end)
				if not upload_ok then
					skipped = skipped + 1
					notify(upload_err, vim.log.levels.WARN)
					return string.format("![%s](%s)", alt, destination)
				end
				uploads[resolved_path] = uploaded_url
			end

			changed = changed + 1
			return string.format("![%s](%s%s)", alt, uploaded_url, suffix)
		end)
		::continue::
	end

	return lines, changed, skipped
end

function M.upload_buffer_markdown_images()
	local filetype = vim.bo.filetype
	if filetype ~= "markdown" and filetype ~= "md" then
		notify("Current buffer is not markdown", vim.log.levels.WARN)
		return
	end

	local start_line = 0
	local end_line = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

	local ok, new_lines, changed, skipped = pcall(replace_markdown_images_in_lines, lines)
	if not ok then
		notify(new_lines, vim.log.levels.ERROR)
		return
	end

	if changed == 0 then
		notify("No uploadable markdown image links found", vim.log.levels.INFO)
		return
	end

	vim.api.nvim_buf_set_lines(0, start_line, end_line, false, new_lines)
	local message = string.format("Uploaded %d image link%s", changed, changed == 1 and "" or "s")
	if skipped > 0 then
		message = message .. string.format(" (%d skipped)", skipped)
	end
	notify(message)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULTS), opts or {})

	if vim.fn.exists(":DropperUploadMarkdownImages") == 0 then
		vim.api.nvim_create_user_command("DropperUploadMarkdownImages", function()
			M.upload_buffer_markdown_images()
		end, { desc = "Upload markdown images to dropper and replace links" })
	end

	if config.default_keymap and config.default_keymap ~= "" then
		vim.keymap.set("n", config.default_keymap, M.upload_buffer_markdown_images, {
			desc = "Upload markdown images to dropper",
		})
	end
end

return M

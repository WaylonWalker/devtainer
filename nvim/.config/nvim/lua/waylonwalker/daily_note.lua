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
    vim.cmd("mode")
  end

  -- Open the note (if multiple, just pick the first)
  if not vim.tbl_isempty(files) then
    vim.cmd("edit " .. files[1])
  else
    print("Failed to find or create today's note.")
  end
end

--- Helper to get wiki link under cursor, or fallback to cWORD
local function get_link_or_word()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local start_pos, end_pos, match = line:find("%[%[%s*([%w%-%_ ]+)%s*%]%]")
  if start_pos and col + 1 >= start_pos and col + 1 <= end_pos then
    return match
  end
  -- fallback to <cWORD> for more inclusive "word"
  return vim.fn.expand("<cWORD>")
end

--- Create a new task using copier and use the full word or wiki link under cursor as title.
function M.CreateTask()
  local word = get_link_or_word()
  if word == nil or word == "" then
    print("No word under cursor to use as task title.")
    return
  end

  local clean_word = word:gsub("[%-_%s]+$", ""):gsub('"', '\\"')
  local safe_word = clean_word:gsub('"', '\\"')
  local cmd = string.format('copier copy ~/.copier-templates/todo . -d "title=%s"', safe_word)
  local result = os.execute(cmd)
  if result ~= 0 then
    print("Failed to create task with copier.")
  else
    print("Task created with title: " .. word)
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

vim.api.nvim_create_user_command("CreateTask", function()
  M.CreateTask()
end, {})

vim.keymap.set("n", "<leader>dn", M.check_and_open_daily_note)
vim.keymap.set("n", "<leader>df", function()
  require("telescope.builtin").find_files({
    cwd = "pages/daily",
    sorting_strategy = "ascending",
  })
end)

vim.keymap.set("n", "<leader>ct", M.CreateTask)

-- require("telekasten").setup({
--   home = vim.fn.expand("~/work/notes"), -- Put the name of your notes directory here
-- })
---- Lua script for Neovim to copy the slug (filename without extension) of the current file to the clipboard

function M.copy_slug()
  -- Get the full path of the current file
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("No file name detected!", vim.log.levels.WARN)
    return
  end

  -- Extract the filename
  local filename = vim.fn.fnamemodify(filepath, ":t")
  -- Remove the extension to get the slug
  local slug = filename:match("(.+)%..+$") or filename
  local slug = "[[ " .. slug .. " ]]"

  -- Copy to system clipboard
  vim.fn.setreg("+", slug)
  vim.notify("Copied slug to clipboard: " .. slug)
end

-- Create a user command :CopySlug
vim.api.nvim_create_user_command("CopySlug", M.copy_slug, {})

vim.keymap.set("n", "<leader>ys", M.copy_slug)

-- Optionally, you can map a key for convenience, for example:
-- vim.keymap.set('n', '<leader>s', copy_slug, { desc = "Copy file slug to clipboard" })
function M.telescope_livegrep_slug()
  -- Get the current file name
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("No file name detected!", vim.log.levels.WARN)
    return
  end
  local filename = vim.fn.fnamemodify(filepath, ":t")
  local slug = filename:match("(.+)%..+$") or filename

  -- Build the pattern: \[\[\s*slug\s*\]\]
  local pattern = string.format("\\[\\[[\\s]*%s[\\s]*\\]\\]", slug)

  -- Call Telescope live_grep with the pattern as the default text
  require("telescope.builtin").live_grep({
    default_text = pattern,
    prompt_title = "Live Grep for links to [[ " .. slug .. " ]]",
  })
end

function M.telescope_livegrep_slug_word()
  -- Get the current file name
  local slug = get_link_or_word()
  -- Build the pattern: \[\[\s*slug\s*\]\]
  local pattern = string.format("\\[\\[[\\s]*%s[\\s]*\\]\\]", slug)

  -- Call Telescope live_grep with the pattern as the default text
  require("telescope.builtin").live_grep({
    default_text = pattern,
    prompt_title = "Live Grep for links to [[ " .. slug .. " ]]",
  })
end

function M.telescope_findfiles_slug_word()
  -- Get the current file name
  local slug = get_link_or_word()
  slug = slug:gsub("^%s*(.-)%s*$", "%1")
  -- Build the pattern: \[\[\s*slug\s*\]\]
  local pattern = string.format(slug)

  -- Call Telescope live_grep with the pattern as the default text
  require("telescope.builtin").find_files({
    default_text = pattern,
    prompt_title = "Live Grep for links to [[ " .. slug .. " ]]",
  })
end

-- Optional: create a command or keymap
vim.api.nvim_create_user_command("GrepSlug", M.telescope_livegrep_slug, {})
vim.api.nvim_create_user_command("GrepSlugWord", M.telescope_livegrep_slug_word, {})
vim.api.nvim_create_user_command("FindSlugWord", M.telescope_findfiles_slug_word, {})

vim.keymap.set("n", "<leader>gs", M.telescope_livegrep_slug)
vim.keymap.set("n", "<leader>gw", M.telescope_livegrep_slug_word)
vim.keymap.set("n", "<leader>fw", M.telescope_findfiles_slug_word)

-- Surround word under cursor with double brackets [[word]]
vim.keymap.set("n", "<leader>[[", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("normal! ciw[[ " .. word .. " ]]")
end, { noremap = true, silent = true, desc = "Surround word with [[ ]]" })

return M


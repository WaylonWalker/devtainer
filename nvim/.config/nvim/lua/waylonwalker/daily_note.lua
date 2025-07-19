-- # Daily Note Neovim Plugin - Features & Usage
--
-- ## Features
--
-- - **Automatic Daily Note Creation & Opening**
--   - Checks for today's note in `pages/daily` (filename: `YYYY-MM-DD*-notes.md`).
--   - If missing, creates a new note using a Copier template (`~/.copier-templates/daily`).
--   - Opens the note in Neovim.
--
-- - **Task Creation from Word or Wiki Link**
--   - Creates a new "task" note using Copier (`~/.copier-templates/todo`).
--   - Uses the word under cursor or selected wiki link (`[[link]]`) as the task title.
--
-- - **Telescope Integration**
--   - Find files in the daily notes directory (`pages/daily`).
--   - Live grep for links to the current file's slug or a word/link under cursor.
--   - Find files by word or wiki link under cursor.
--
-- - **Slug Copying**
--   - Copies the current file's slug (filename without extension, wrapped as `[[slug]]`) to the system clipboard.
--
-- - **Wiki Link Insertion**
--   - Surrounds the word under cursor with double brackets (`[[word]]`) for easy wiki linking.
--
-- ## Usage
--
-- ### Commands
--
-- | Command         | Description                                                    |
-- |-----------------|----------------------------------------------------------------|
-- | `:DailyNote`    | Open (or create) today's daily note.                           |
-- | `:Daily`        | Alias for `:DailyNote`.                                        |
-- | `:DailyFiles`   | Open Telescope to search daily notes in `pages/daily`.         |
-- | `:CreateTask`   | Create a new task note from the word or wiki link under cursor.|
-- | `:CopySlug`     | Copy current file's slug as `[[slug]]` to the clipboard.       |
-- | `:GrepSlug`     | Telescope live_grep for links to the current file's slug.      |
-- | `:GrepSlugWord` | Telescope live_grep for links to word/link under cursor.       |
-- | `:FindSlugWord` | Telescope find_files for the word/link under cursor.           |
--
-- ### Keymaps
--
-- | Mode | Mapping         | Action                                                        |
-- |------|----------------|---------------------------------------------------------------|
-- | n    | `<leader>dn`   | Open (or create) today's daily note.                          |
-- | n    | `<leader>df`   | Telescope find files in `pages/daily`.                        |
-- | n    | `<leader>ct`   | Create a new task note from word/link under cursor.           |
-- | n    | `<leader>ys`   | Copy current file's slug as `[[slug]]` to clipboard.          |
-- | n    | `<leader>gs`   | Telescope live_grep for links to current file's slug.         |
-- | n    | `<leader>gw`   | Telescope live_grep for links to word/link under cursor.      |
-- | n    | `<leader>fw`   | Telescope find_files for word/link under cursor.              |
-- | n    | `<leader>[[`   | Surround word under cursor with double brackets (`[[word]]`). |
--
-- ### Dependencies
--
-- - **os.date** (Lua stdlib): for date formatting.
-- - **vim.fn** (Neovim API): for file globbing, clipboard, etc.
-- - **vim.cmd** (Neovim API): to execute Neovim commands.
-- - **Telescope.nvim**: for `find_files` and `live_grep` functionality.
-- - **copier** (external CLI): for using note/task templates (`copier copy ...`).
--
-- > **Note:** The plugin expects `copier` templates at `~/.copier-templates/daily` and `~/.copier-templates/todo` and relies on the external `copier` binary being available in your shell.
--
-- ---
--
-- ## Example Workflow
--
-- 1. Press `<leader>dn` or run `:DailyNote` to open today's note. If it doesn't exist, it is created.
-- 2. Position cursor on a word or link and press `<leader>ct` or run `:CreateTask` to make a new task note.
-- 3. Use `<leader>df` or `:DailyFiles` to browse all daily notes.
-- 4. Copy the current file's slug with `<leader>ys` or `:CopySlug`.
-- 5. Search for links to the current file or word/link with `<leader>gs`, `<leader>gw`, `<leader>fw`.
--
-- ---

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

function M.CreateContact()
  local word = get_link_or_word()
  if word == nil or word == "" then
    print("No word under cursor to use as contact title.")
    return
  end

  local clean_word = word:gsub("[%-_%s]+$", ""):gsub('"', '\\"')
  local safe_word = clean_word:gsub('"', '\\"')
  local cmd = string.format('copier copy ~/.copier-templates/contact . -d "name=%s"', safe_word)
  local result = os.execute(cmd)
  if result ~= 0 then
    print("Failed to create contact with copier.")
  else
    print("contact created with title: " .. word)
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

vim.api.nvim_create_user_command("CreateContact", function()
  M.CreateContact()
end, {})

vim.keymap.set("n", "<leader>dn", M.check_and_open_daily_note)
vim.keymap.set("n", "<leader>df", function()
  require("telescope.builtin").find_files({
    cwd = "pages/daily",
    sorting_strategy = "ascending",
  })
end)

vim.keymap.set("n", "<leader>ct", M.CreateTask)
vim.keymap.set("n", "<leader>cc", M.CreateContact)

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

local M = {}

local daily_dir = "pages/daily"
local calendar_ns = vim.api.nvim_create_namespace("waylonwalker.daily.calendar")
local month_names = {
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
}

local function daily_note_pattern(date)
  return string.format("%s/%s*-notes.md", daily_dir, date)
end

local function daily_note_files()
  local files = vim.fn.globpath(daily_dir, "*.md", false, true)
  table.sort(files, function(a, b)
    return a > b
  end)
  return files
end

local function daily_note_index()
  local notes = {}
  for _, file in ipairs(daily_note_files()) do
    local date = vim.fn.fnamemodify(file, ":t"):match("^(%d%d%d%d%-%d%d%-%d%d)")
    if date and notes[date] == nil then
      notes[date] = file
    end
  end
  return notes
end

local function open_file(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function get_link_or_word()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local start_pos, end_pos, match = line:find("%[%[%s*([%w%-%_ ]+)%s*%]%]")
  if start_pos and col + 1 >= start_pos and col + 1 <= end_pos then
    return match
  end
  return vim.fn.expand("<cWORD>")
end

function M.open_today()
  local today = os.date("%Y-%m-%d")
  M.open_date(today, { create_missing = true })
end

function M.open_date(date, opts)
  opts = opts or {}
  local files = vim.fn.glob(daily_note_pattern(date), false, true)

  if vim.tbl_isempty(files) and opts.create_missing then
    os.execute("copier copy ~/.copier-templates/daily .")
    vim.wait(500, function()
      return not vim.tbl_isempty(vim.fn.glob(daily_note_pattern(date), false, true))
    end, 10)
    files = vim.fn.glob(daily_note_pattern(date), false, true)
    vim.cmd("mode")
  end

  if vim.tbl_isempty(files) then
    vim.notify("No daily note for " .. date .. ".", vim.log.levels.WARN)
    return
  end

  open_file(files[1])
end

function M.find_files()
  require("telescope.builtin").find_files({
    cwd = daily_dir,
    sorting_strategy = "ascending",
  })
end

local function days_in_month(year, month)
  return os.date("*t", os.time({ year = year, month = month + 1, day = 0, hour = 12 })).day
end

local function normalize_month(year, month)
  while month < 1 do
    month = month + 12
    year = year - 1
  end
  while month > 12 do
    month = month - 12
    year = year + 1
  end
  return year, month
end

local function shift_month(year, month, delta)
  return normalize_month(year, month + delta)
end

local function make_date(year, month, day)
  return string.format("%04d-%02d-%02d", year, month, day)
end

local function first_weekday(year, month)
  return os.date("*t", os.time({ year = year, month = month, day = 1, hour = 12 })).wday
end

local function calendar_cells(year, month)
  local cells = {}
  local first = first_weekday(year, month)
  local first_col = first - 1
  local days = days_in_month(year, month)
  local prev_year, prev_month = shift_month(year, month, -1)
  local next_year, next_month = shift_month(year, month, 1)
  local prev_days = days_in_month(prev_year, prev_month)

  for i = 1, 42 do
    local offset = i - 1
    local day = offset - first_col + 1
    local cell = { current_month = true }

    if day < 1 then
      cell.current_month = false
      cell.year = prev_year
      cell.month = prev_month
      cell.day = prev_days + day
    elseif day > days then
      cell.current_month = false
      cell.year = next_year
      cell.month = next_month
      cell.day = day - days
    else
      cell.year = year
      cell.month = month
      cell.day = day
    end

    cell.date = make_date(cell.year, cell.month, cell.day)
    table.insert(cells, cell)
  end

  return cells
end

local function calendar_dimensions()
  local width = 30
  local height = 12
  local columns = vim.o.columns
  local lines = vim.o.lines
  return {
    width = width,
    height = height,
    row = math.floor((lines - height) / 2) - 1,
    col = math.floor((columns - width) / 2),
  }
end

local function ensure_calendar_highlights()
  vim.api.nvim_set_hl(0, "DailyCalendarToday", { link = "Title", default = true })
  vim.api.nvim_set_hl(0, "DailyCalendarNote", { link = "String", default = true })
  vim.api.nvim_set_hl(0, "DailyCalendarOtherMonth", { link = "Comment", default = true })
  vim.api.nvim_set_hl(0, "DailyCalendarSelected", { link = "Visual", default = true })
end

local function selected_day_in_month(date, year, month)
  local y, m, d = date:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if tonumber(y) == year and tonumber(m) == month then
    return tonumber(d)
  end
end

local function render_calendar(buf, state)
  local lines = {}
  local positions = {}
  local title = string.format("     %s %d", month_names[state.month], state.year)
  table.insert(lines, title)
  table.insert(lines, " Su  Mo  Tu  We  Th  Fr  Sa")

  local cells = calendar_cells(state.year, state.month)
  state.cells = cells

  for week = 0, 5 do
    local parts = {}
    for col = 0, 6 do
      local idx = week * 7 + col + 1
      local cell = cells[idx]
      local text = string.format(" %2d ", cell.day)
      positions[cell.date] = { row = week + 2, col = col * 4 }
      table.insert(parts, text)
    end
    table.insert(lines, table.concat(parts, ""))
  end

  table.insert(lines, "")
  table.insert(lines, " <CR> open  h/j/k/l move  H/L month  t today  q close")

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, calendar_ns, 0, -1)

  local today = os.date("%Y-%m-%d")
  for _, cell in ipairs(cells) do
    local pos = positions[cell.date]
    local group = nil

    if not cell.current_month then
      group = "DailyCalendarOtherMonth"
    elseif state.notes[cell.date] then
      group = "DailyCalendarNote"
    end

    if cell.date == today then
      group = "DailyCalendarToday"
    end

    if cell.date == state.selected_date then
      group = "DailyCalendarSelected"
    end

    if group then
      vim.api.nvim_buf_add_highlight(buf, calendar_ns, group, pos.row, pos.col, pos.col + 4)
    end
  end

  local pos = positions[state.selected_date]
  if pos then
    vim.api.nvim_win_set_cursor(state.win, { pos.row + 1, pos.col + 1 })
  end
end

local function move_selection(state, delta)
  local current = os.date("*t", os.time({
    year = tonumber(state.selected_date:sub(1, 4)),
    month = tonumber(state.selected_date:sub(6, 7)),
    day = tonumber(state.selected_date:sub(9, 10)),
    hour = 12,
  }) + delta * 24 * 60 * 60)

  state.selected_date = make_date(current.year, current.month, current.day)
  state.year = current.year
  state.month = current.month
  render_calendar(state.buf, state)
end

local function change_month(state, delta)
  local year, month = shift_month(state.year, state.month, delta)
  local day = selected_day_in_month(state.selected_date, state.year, state.month) or 1
  day = math.min(day, days_in_month(year, month))
  state.year = year
  state.month = month
  state.selected_date = make_date(year, month, day)
  render_calendar(state.buf, state)
end

function M.pick_calendar()
  ensure_calendar_highlights()

  local today = os.date("*t")
  local buf = vim.api.nvim_create_buf(false, true)
  local dims = calendar_dimensions()
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = dims.width,
    height = dims.height,
    row = dims.row,
    col = dims.col,
  })

  local state = {
    buf = buf,
    win = win,
    year = today.year,
    month = today.month,
    selected_date = make_date(today.year, today.month, today.day),
    notes = daily_note_index(),
  }

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "waylonwalker-daily-calendar"
  vim.wo[win].cursorline = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].foldcolumn = "0"

  local function close_calendar()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function open_selected()
    close_calendar()
    M.open_date(state.selected_date)
  end

  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "q", close_calendar, opts)
  vim.keymap.set("n", "<Esc>", close_calendar, opts)
  vim.keymap.set("n", "<CR>", open_selected, opts)
  vim.keymap.set("n", "h", function() move_selection(state, -1) end, opts)
  vim.keymap.set("n", "l", function() move_selection(state, 1) end, opts)
  vim.keymap.set("n", "j", function() move_selection(state, 7) end, opts)
  vim.keymap.set("n", "k", function() move_selection(state, -7) end, opts)
  vim.keymap.set("n", "<Left>", function() move_selection(state, -1) end, opts)
  vim.keymap.set("n", "<Right>", function() move_selection(state, 1) end, opts)
  vim.keymap.set("n", "<Down>", function() move_selection(state, 7) end, opts)
  vim.keymap.set("n", "<Up>", function() move_selection(state, -7) end, opts)
  vim.keymap.set("n", "H", function() change_month(state, -1) end, opts)
  vim.keymap.set("n", "L", function() change_month(state, 1) end, opts)
  vim.keymap.set("n", "[m", function() change_month(state, -1) end, opts)
  vim.keymap.set("n", "]m", function() change_month(state, 1) end, opts)
  vim.keymap.set("n", "t", function()
    state.year = today.year
    state.month = today.month
    state.selected_date = make_date(today.year, today.month, today.day)
    render_calendar(buf, state)
  end, opts)

  render_calendar(buf, state)
end

function M.goto_daily(direction)
  local current = vim.fn.expand("%:p")
  local files = daily_note_files()

  for idx, file in ipairs(files) do
    if file == current then
      local target
      if direction == "next" and idx > 1 then
        target = files[idx - 1]
      elseif direction == "prev" and idx < #files then
        target = files[idx + 1]
      end

      if target then
        open_file(target)
      else
        vim.notify("No " .. direction .. " daily note file.", vim.log.levels.INFO)
      end
      return
    end
  end

  vim.notify("Current file is not a daily note.", vim.log.levels.WARN)
end

function M.create_task()
  local word = get_link_or_word()
  if word == nil or word == "" then
    vim.notify("No word under cursor to use as task title.", vim.log.levels.WARN)
    return
  end

  local clean_word = word:gsub("[%-_%s]+$", ""):gsub('"', '\\"')
  local cmd = string.format('copier copy ~/.copier-templates/task . -d "title=%s"', clean_word)
  local result = os.execute(cmd)
  if result ~= 0 then
    vim.notify("Failed to create task with copier.", vim.log.levels.ERROR)
    return
  end

  vim.notify("Task created with title: " .. word)
  vim.cmd("mode")
end

function M.create_contact()
  local word = get_link_or_word()
  if word == nil or word == "" then
    vim.notify("No word under cursor to use as contact title.", vim.log.levels.WARN)
    return
  end

  local clean_word = word:gsub("[%-_%s]+$", ""):gsub('"', '\\"')
  local cmd = string.format('copier copy ~/.copier-templates/contact . -d "name=%s"', clean_word)
  local result = os.execute(cmd)
  if result ~= 0 then
    vim.notify("Failed to create contact with copier.", vim.log.levels.ERROR)
    return
  end

  vim.notify("Contact created with title: " .. word)
  vim.cmd("mode")
end

function M.copy_slug()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("No file name detected!", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  local slug = filename:match("(.+)%..+$") or filename
  slug = "[[ " .. slug .. " ]]"
  vim.fn.setreg("+", slug)
  vim.notify("Copied slug to clipboard: " .. slug)
end

function M.telescope_livegrep_slug()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("No file name detected!", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  local slug = filename:match("(.+)%..+$") or filename
  local pattern = string.format("\\[\\[[\\s]*%s[\\s]*\\]\\]", slug)

  require("telescope.builtin").live_grep({
    default_text = pattern,
    prompt_title = "Live Grep for links to [[ " .. slug .. " ]]",
  })
end

function M.telescope_livegrep_slug_word()
  local slug = get_link_or_word()
  local pattern = string.format("\\[\\[[\\s]*%s[\\s]*\\]\\]", slug)

  require("telescope.builtin").live_grep({
    default_text = pattern,
    prompt_title = "Live Grep for links to [[ " .. slug .. " ]]",
  })
end

function M.telescope_findfiles_slug_word()
  local slug = get_link_or_word():gsub("^%s*(.-)%s*$", "%1")

  require("telescope.builtin").find_files({
    default_text = slug,
    prompt_title = "Find Files for " .. slug,
  })
end

vim.api.nvim_create_user_command("DailyNote", M.open_today, {})
vim.api.nvim_create_user_command("Daily", M.open_today, {})
vim.api.nvim_create_user_command("DailyFiles", M.find_files, {})
vim.api.nvim_create_user_command("DailyCalendar", M.pick_calendar, {})
vim.api.nvim_create_user_command("CreateTask", M.create_task, {})
vim.api.nvim_create_user_command("CreateContact", M.create_contact, {})
vim.api.nvim_create_user_command("CopySlug", M.copy_slug, {})
vim.api.nvim_create_user_command("GrepSlug", M.telescope_livegrep_slug, {})
vim.api.nvim_create_user_command("GrepSlugWord", M.telescope_livegrep_slug_word, {})
vim.api.nvim_create_user_command("FindSlugWord", M.telescope_findfiles_slug_word, {})

vim.keymap.set("n", "<leader>dn", M.open_today, { desc = "Open today's daily note" })
vim.keymap.set("n", "<leader>df", M.find_files, { desc = "Find daily notes" })
vim.keymap.set("n", "<leader>dc", M.pick_calendar, { desc = "Pick daily note from calendar" })
vim.keymap.set("n", "<leader>dl", M.pick_calendar, { desc = "List daily notes by date" })
vim.keymap.set("n", "<leader>d]", function()
  M.goto_daily("next")
end, { desc = "Open newer daily note" })
vim.keymap.set("n", "<leader>d[", function()
  M.goto_daily("prev")
end, { desc = "Open older daily note" })
vim.keymap.set("n", "<leader>ct", M.create_task, { desc = "Create task note" })
vim.keymap.set("n", "<leader>cc", M.create_contact, { desc = "Create contact note" })
vim.keymap.set("n", "<leader>ys", M.copy_slug, { desc = "Copy file slug" })
vim.keymap.set("n", "<leader>gs", M.telescope_livegrep_slug, { desc = "Grep current slug" })
vim.keymap.set("n", "<leader>gw", M.telescope_livegrep_slug_word, { desc = "Grep slug under cursor" })
vim.keymap.set("n", "<leader>fw", M.telescope_findfiles_slug_word, { desc = "Find files for slug under cursor" })
vim.keymap.set("n", "<leader>[[", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("normal! ciw[[ " .. word .. " ]]")
end, { noremap = true, silent = true, desc = "Surround word with [[ ]]" })

return M

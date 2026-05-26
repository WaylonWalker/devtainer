-- '<,'>s/nnoremap \v(\w+) \v(.*)/ set('n', '\1', '\2')
-- '<,'>s/nnoremap \(<leader>\)\v(\w+) \v(.*)/ set('n', '\1\2', '\3')
--

local set = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local M = {}

local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
		-- vim.api.nvim_set_keymap(op, lhs, rhs, opts)
	end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

-- scrolling zz
-- quickfix
set("n", "<c-d>", "<c-d>zz")
set("n", "<c-u>", "<c-u>zz")

-- quickfix
set("n", "<c-j>", "<cmd>cnext<cr>")
set("n", "<c-k>", "<cmd>cprev<cr>")
-- set("n", "<F4>", "<cmd>cnext<cr>")
-- set("n", "<F5>", "<cmd>cprev<cr>")

-- Reselect visual selection after indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

-- Paste replace visual selection without copying it
vim.keymap.set("v", "p", '"_dP')

set("n", "gwc", "vap<cmd>'<,'>w !wc -c<CR>")
set("n", "ZR", "zR")
set("n", "ZM", "zM")
set("n", "U", "<cmd>redo<cr>")

-- stupid Terminals map <c-^> to other things
set("n", "<leader>6", "<c-^>")
set("n", "<c-y>", "<c-^>")
set("i", "<c-y>", "<c-o><c-^>")

-- set("i", "gqq", "<esc>gqqA")

-- git commits
set("n", "ga", "<cmd>G add %<CR>")

set("n", "ga", "<cmd>G add %<CR>")
set("n", "gid", "<cmd>Gdiff<CR>")
set("n", "gpp", "<cmd>G push<CR>")
set("n", "gPP", "<cmd>G pull<CR>")
set("n", "gil", "<cmd>GcLog<CR>")
set("n", "giL", "<cmd>GcLog %<CR>")
set("n", "gib", "<cmd>G blame<CR>")
set("n", "git", "<cmd>G<CR>")

set("t", "<c-\\><c-\\>", "<c-\\><c-n>")
set("t", "<c-j><c-j>", "<c-\\><c-n>")
set("t", "<c-c><c-c>", "<c-\\><c-n>")
set("t", "<c-h>", "<c-\\><c-n><c-w>h")
set("t", "<c-l>", "<c-\\><c-n><c-w>l")
set("t", "<c-^>", "<c-\\><c-n><c-^>")

-- window shortcuts
set("n", "<c-l>", "<c-w>l")
set("n", "<c-h>", "<c-w>h")

-- edit hidden files
set("n", "geh", "<cmd>Telescope find_files hidden=true<CR>")
-- open nvim tree
set("n", "gej", "<cmd>NvimTreeToggle<CR>")
-- edit nvim dotfiles
set("n", "gen", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>")
--
set("n", "gez", "<CMD>e ~/.zshrc<CR>")
set("n", "gea", "<CMD>e ~/.alias<CR>")
-- edit public projects
set("n", "geg", "<cmd>Telescope find_files cwd=~/git/<CR>")
-- edit private projects
set("n", "gew", "<cmd>Telescope find_files cwd=~/work/<CR>")
-- edit vim config
set("n", "<leader>en", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>")
-- edit vim keymap
set("n", "gek", "<cmd>e ~/.config/nvim/lua/waylonwalker/keymap.lua<CR>")
-- edit lsp-config
set("n", "gec", "<cmd>e ~/.config/nvim/lua/waylonwalker/plugins/lsp-config.lua<CR>")
-- edit plugins list
set("n", "gep", "<cmd>e ~/.config/nvim/lua/waylonwalker/lazy.lua<CR>")
--edit next to me
set("n", "gee", ":e %:h<C-Z>")
-- edit nvim settings
set("n", "ges", "<cmd>e ~/.config/nvim/lua/waylonwalker/options.lua<CR>")
-- edit tmuux config
set("n", "get", "<cmd>e ~/.tmux.conf<CR>")
set("n", "ger", "<cmd>e ~/.config/inlog.csv<CR>")
-- edit zshrc
--
-- edit pyflyby
set("n", "gef", "<cmd>e ~/.pyflyby<CR>")
-- edit ipython config
set("n", "gel", "<cmd>Telescope find_files cwd=~/.config/nvim/lua/waylonwalker/<CR>")

-- go edit my website
-- edit blog posts
set("n", "gei", "<cmd>Telescope find_files cwd=~/git/waylonwalker.com<CR>")
-- edit today's post
set("n", "geit", "<cmd>Telescope find_files find_command=markata,list,--map,path,--filter,date==today,--fast<cr>")
-- edit drafts
set(
	"n",
	"geid",
	"<cmd>Telescope find_files find_command=markata-go,list,posts,--feed,draft,--format,path<cr>"
)

-- edit posts by feed (two-stage picker)
vim.keymap.set("n", "geif", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")

	-- Custom previewer that displays images using kitty graphics protocol
	local function make_image_previewer()
		return previewers.new_buffer_previewer({
			title = "File Preview",
			dyn_title = function(self, entry)
				return "Preview: " .. entry.value
			end,
			define_preview = function(self, entry, status)
				local filepath = entry.value
				local file = io.open(filepath, "r")
				if not file then return end

				local content = file:read("*a")
				file:close()

				local lines = {}
				local found_image = false
				local image_path = nil

				-- Extract frontmatter and look for image
				for line in content:gmatch("[^\r\n]+") do
					if line:match("^image:") then
						image_path = line:match("^image:%s*(.+)$")
						if image_path then
							-- Try to resolve relative paths
							local dir = vim.fn.fnamemodify(filepath, ":h")
							local full_image_path = image_path
							if not vim.fn.filereadable(full_image_path) then
								full_image_path = dir .. "/" .. image_path
							end
							if vim.fn.filereadable(full_image_path) then
								table.insert(lines, "📷 Image: " .. image_path)
								table.insert(lines, "")
								-- Try to display image with kitty graphics protocol
								local bufnr = self.state.bufnr
								vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"Loading image...", ""})
								
								-- Use kitty's graphics protocol to display image
								local cmd = string.format("kitty +kitten icat --print-window-id %s", vim.fn.shellescape(full_image_path))
								local handle = io.popen(cmd .. " 2>/dev/null")
								if handle then
									local output = handle:read("*a")
									handle:close()
									if output and output ~= "" then
										table.insert(lines, output)
									end
								end
								found_image = true
							end
						end
					elseif line == "---" and found_image then
						break -- End of frontmatter
					end
				end

				-- Add file content
				local file_lines = vim.split(content, "\n")
				for _, l in ipairs(file_lines) do
					table.insert(lines, l)
				end

				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
			end,
		})
	end

	-- Get list of feeds
	local handle = io.popen("markata-go list feeds --format path 2>/dev/null")
	local feeds = {}
	if handle then
		for feed in handle:lines() do
			table.insert(feeds, feed)
		end
		handle:close()
	end

	pickers.new({}, {
		prompt_title = "Pick a Feed",
		finder = finders.new_table({ results = feeds }),
		sorter = conf.generic_sorter({}),
		previewer = previewers.cat.new({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					local feed = selection[1]
					-- Now pick a post from the selected feed
					local post_handle = io.popen("markata-go list posts --feed " .. feed .. " --format path 2>/dev/null")
					local posts = {}
					if post_handle then
						for post in post_handle:lines() do
							table.insert(posts, post)
						end
						post_handle:close()
					end

					pickers.new({}, {
						prompt_title = "Pick a Post from " .. feed,
						finder = finders.new_table({ results = posts }),
						sorter = conf.generic_sorter({}),
						previewer = make_image_previewer(),
						attach_mappings = function(post_prompt_bufnr, post_map)
							actions.select_default:replace(function()
								actions.close(post_prompt_bufnr)
								local post_selection = action_state.get_selected_entry()
								if post_selection then
									vim.cmd("edit " .. post_selection[1])
								end
							end)
							return true
						end,
					}):find()
				end
			end)
			return true
		end,
	}):find()
end, { desc = "Edit post by feed" })

-- edit tils
set(
	"n",
	"geil",
	"<cmd>Telescope find_files find_command=markata,list,--map,path,--filter,templateKey=='til',--sort,date,--reverse,--fast<cr>"
)
-- edit gratitude journals
set(
	"n",
	"geig",
	"<cmd>Telescope find_files find_command=markata,list,--map,path,--filter,templateKey=='gratitude',--sort,date,--fast<cr>"
)
-- edit kedro posts
set(
	"n",
	"geik",
	"<cmd>lua require('telescope.builtin').find_files({find_command={'markata', 'list', '--map', 'path', '--filter', ''kedro' in tags', '--sort', 'date', '--reverse'}})<cr>"
)
-- edit draft kedro
set(
	"n",
	"geidk",
	"<cmd>lua require('telescope.builtin').find_files({find_command={'markata', 'list', '--map', 'path', '--filter', ''kedro' in tags and status != 'published'', '--sort', 'date', '--reverse'}})<cr>"
)

-- go to the internet
set(
	"n",
	"gow",
	"<cmd>lua os.execute('xdg-open https://waylonwalker.com/' .. vim.api.nvim_buf_get_name(0):match(\"^.+/(.+)$\"):gsub('.md', '') .. '/ > /dev/null 2>&1')<cr>"
)
set("n", "goo", "<cmd>Telegraph 'xdg-open \"{cWORD}\"'<cr>")

set("n", "<leader>e", ":e %:h<C-Z>")

set(
	"n",
	"gpu",
	"<cmd>lua require'telegraph'.telegraph({how='tmux_popup', cmd='nvim --headless -c \"autocmd User PackerComplete quitall\" -c \"PackerSync\"'})<cr>"
)

set("n", "Q", "@@")

-- bad habits
set("i", "jj", "<esc>")
set("i", "jk", "<esc>")
set("i", "JJ", "<esc>")
set("i", "jJ", "<esc>")
set("i", "Jj", "<esc>")

set("n", "<leader>w", "<cmd>w<cr>")
set("n", "<leader>q", "<cmd>q<cr>")
set("n", "<leader>x", "<cmd>x<cr>")

set("n", "<leader>p", "<cmd>Telescope find_files<cr>")
set("n", "<leader>F", "<cmd>Telescope<cr>")
-- set("n", "<leader>o", "<cmd>Telescope old_files<cr>")
set("n", "<leader>di", "<cmd>Telescope diagnostics<cr>")
set("n", "<leader>da", function() require("waylonwalker.plugins.markata-lint").telescope_picker() end, { desc = "All markata lint issues" })
set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
set("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>")
set("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>")
set("n", "<leader>fg", "<cmd>Telescope git_files<cr>")
-- set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>")
set("n", "<leader>fl", "<cmd>Telescope live_grep<cr>")
set("n", "<leader>fhl", "<cmd>Telescope live_grep hidden=true<CR>")
set("n", "<leader>fhh", "<cmd>Telescope old_files<cr>")
set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
set("n", "<leader>fq", "<cmd>Telescope quickfix<cr>")
set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>")

set("n", "gR", "<cmd>Telescope lsp_references<cr>")
set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
set("n", "gD", "<cmd>Telescope lsp_definitions<cr>")
set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<cr>")
set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>")
set("n", "gH", "<cmd>Lspsaga hover_doc<cr>")
set("n", "gb", "<cmd>Telescope git_branches<cr>")
-- set("n", "gs", "<cmd>Git<cr>")

set("n", "<leader>p", "<cmd>Telescope find_files<cr>")
set("n", "<leader>F", "<cmd>Telescope<cr>")
set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
set("n", "<leader>fl", "<cmd>Telescope live_grep<cr>")
set("n", "<leader>m", "<cmd>Telescope marks<cr>")
set("n", "<leader>M", "<cmd>Telescope man_pages<cr>")
set("n", "<leader>F", "<cmd>Telescope<cr>")
set("n", "gR", "<cmd>Telescope lsp_references<cr>")
set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")

-- leader window
set("n", "<leader>h", "<C-W>h")
set("n", "<leader>j", "<C-W>j")
set("n", "<leader>k", "<C-W>k")
set("n", "<leader>l", "<C-W>l")

-- leader splits
set("n", "<leader>s", "<cmd>sp<cr>")
set("n", "<leader>v", "<cmd>vsp<cr>")

-- visual line bubbling
set("v", "K", ":m '<-2<CR>gv=gv")
set("v", "J", ":m '>+1<CR>gv=gv")

-- leader bubbling current line
set("n", "<leader>k", ":m .-2<CR>==")
set("n", "<leader>j", ":m .+1<CR>==")

-- lsp help
set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
set("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

-- telegraphs

-- lookatme slides for the current file in a tmux session
set(
	"n",
	"<leader><leader>s",
	"<cmd>lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})<CR>"
)
-- lookatme slides for the current file in a tmux popup
set(
	"n",
	"<leader><leader>S",
	"<cmd>lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})<CR>"
)
-- visidata the current word in a tmux session
set(
	"n",
	"<leader><leader>vd",
	"<cmd>lua require'telegraph'.telegraph({cmd='pipx run visidata {cWORD}', how='tmux'})<CR>"
)
-- open a manpage
set("n", "<leader><leader>m", ":Telegraph man")
-- open a manpage in a tmux popup
set("n", "<leader><leader>M", ":lua require'telegraph'.telegraph({how='tmux_popup', cmd='man '})<Left><Left><Left>")
-- open the image under the cursor in feh
set("n", "<leader><leader>i", "<cmd>Telegraph feh {cWORD}<CR>")
-- run the current file in ipython in a tmux popup
set(
	"n",
	"<leader><leader>e",
	"<cmd>lua require'telegraph'.telegraph({cmd='lockhart prompt run edit --edit --file=\"{filepath}\" --overwrite'})<cr>"
)

set(
	"n",
	"<leader><leader>r",
	"<cmd>lua require'telegraph'.telegraph({cmd='zsh -c \"ipython {filepath} -i\"', how='tmux_popup'})<CR>"
)
-- run zsh in a popup
set("n", "<leader><leader>z", "<cmd>lua require'telegraph'.telegraph({cmd='zsh', how='tmux_popup'})<CR>")
-- set the title
set(
	"n",
	"<leader>t",
	"<cmd>lua require'telegraph'.telegraph({how='execute', cmd='echo \"{cline}\" > ~/.config/title/title.txt'})<cr>"
)
-- open the current word in brave
set("n", "<leader><leader>b", "<cmd>lua  require'telegraph'.telegraph({cmd='brave {cWORD}', how='subprocess'})<CR>")
-- open image in feh
set("n", "<leader><leader>i", "<cmd>lua  require'telegraph'.telegraph({cmd='feh {cWORD}', how='subprocess'})<CR>")
-- open current word using xdg-open
set("n", "goo", "<cmd>lua require'telegraph'.telegraph({cmd='xdg-open {cWORD}', how='execute'})<cr>")

-- fugitive
set("n", "gic", "<cmd>lua waylonwalker.plugins.fugitive.git_add()<cr>")

-- color
set("n", "<leader><cr>", ":lua 'waylonwalker.util.color'.nobg()<cr>", { noremap = true, silent = true })

-- toggler
set("n", "<c-q>", "<cmd>lua require'waylonwalker.util.toggler'.openqf()<cr>", { noremap = true, silent = true })
set("n", "<c-w><c-w>", "<cmd>lua require'waylonwalker.util.toggler'.winmax()<cr>", { noremap = true, silent = true })

-- temp fix for gqq not working while pylsp is running
set("n", "<leader>qq", "yy<cmd>lua require'waylonwalker.util.window'.open_window()<cr>pkddgqqggyG:q<cr>Vp")
set("v", "<leader>qq", "d<cmd>lua require'waylonwalker.util.window'.open_window()<cr>pkddgqqggyG:q<cr>P")

set("n", "((", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
set("n", "))", "<cmd>lua vim.diagnostic.goto_next()<CR>")

set("n", "<c-n>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
set("n", "<c-p>", "<cmd>lua vim.diagnostic.goto_next()<CR>")

set("n", "<leader>a", "<cmd>AerialToggle!left<CR>")

-- Keyboard users
vim.keymap.set("n", "<C-t>", function()
	require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set("n", "<RightMouse>", function()
	vim.cmd.exec('"normal! \\<RightMouse>"')

	local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
	require("menu").open(options, { mouse = true })
end, {})

set("i", "<C-g>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true })
set("i", "<c-;>", function()
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true })
set("i", "<c-,>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true })
set("i", "<c-x>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true })

vim.api.nvim_create_user_command("PreCommit", "!pre-commit run --files %", {})
vim.api.nvim_create_user_command("QQ", "q!", {})

set("n", "<f4>", "]s")
set("n", "<f5>", "[s")
set("n", "<f6>", "<cmd>Telescope spell_suggest<cr>")

local function insert_at_cursor(str)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  vim.api.nvim_set_current_line(before .. str .. after)
end

vim.keymap.set("n", "<leader>dt", function()
  insert_at_cursor(os.date("%Y-%m-%d %H:%M:%S"))
end, { desc = "Insert current date and time" })

vim.keymap.set("n", "<leader>dd", function()
  insert_at_cursor(os.date("%Y-%m-%d"))
end, { desc = "Insert current date" })

vim.keymap.set("n", "<leader>dw", function()
  insert_at_cursor(os.date("%A %Y-%m-%d %H:%M:%S"))
end, { desc = "Insert current weekday, date and time" })

set("n", "<leader>k", "<cmd>Telescope keymaps<CR>")

vim.api.nvim_create_user_command(
  'DeleteFile',
  function()
    -- Delete the current file from disk
    vim.cmd('!rm %')
    -- Close the buffer without saving
    vim.cmd('bdelete!')
  end,
  {}
)

local Path = require("plenary.path")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- Helper: get contact files from the directory
local function get_contacts()
  local contacts = {}
  local contact_dir = "pages/contact/"
  for _, file in ipairs(vim.fn.glob(contact_dir .. "*.md", 0, 1)) do
    local contact = Path:new(file):make_relative(contact_dir):gsub("%.md$", "")
    table.insert(contacts, contact)
  end
  return contacts
end

-- Telescope picker for contacts
local function pick_contact(callback)
  local contacts = get_contacts()
  pickers.new({}, {
    prompt_title = "Pick a Contact",
    finder = finders.new_table { results = contacts },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection and callback then
          callback(selection[1])
        end
      end)
      return true
    end,
  }):find()
end

local function chat_admonition(admonition, wikilink)
  -- Wrap the paragraph (like 'gwap')
  vim.cmd('normal! gwap')
  -- Indent the paragraph by 4 spaces
  vim.cmd('normal! >ap')
  vim.cmd('normal! >ap') -- twice for 4 spaces (each > is 2 spaces by default)
  -- Move to the start of the paragraph
  vim.cmd('normal! [ap')
  -- Insert a new line above
  vim.cmd('normal! O')
  -- Insert the admonition
  if admonition == "chat" then
    vim.api.nvim_put({string.format("!!! chat [[ %s ]]", wikilink or "")}, 'l', false, true)
    -- Move cursor inside the wikilink
    if wikilink and #wikilink > 0 then
      -- If we inserted a contact, put cursor at end of name
      vim.cmd('normal! 0f[l')
      for _ = 1, #wikilink do
        vim.cmd('normal! l')
      end
      vim.cmd('startinsert')
    else
      -- If blank, put cursor in the middle
      vim.cmd('normal! 0f[la')
    end
  elseif admonition == "chat-reply" then
    vim.api.nvim_put({string.format("!!! chat-reply")}, 'l', false, true)
    -- Move cursor to end of the line (if user wants to type after)
    vim.cmd('normal! $a')
  end
end

vim.keymap.set('n', '<leader>ch', function()
  pick_contact(function(contact)
    vim.schedule(function()
      chat_admonition("chat", contact)
    end)
  end)
end, { desc = "Chat Contact Admonition" })

vim.keymap.set('n', '<leader>cr', function()
  chat_admonition('chat-reply')
end, { desc = "Chat Reply Admonition" })

return M

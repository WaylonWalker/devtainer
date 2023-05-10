-- vim.opt.hlsearch = true -- keep matches highlighted
-- vim.opt.incsearch = true -- " Highlight while searching with / or ?.
vim.api.nvim_command('set path+=**')
vim.o.winbar = " %{%v:lua.vim.fn.expand('%F')%}  %{%v:lua.require'nvim-navic'.get_location()%} %= %{%v:lua.waylonwalker.plugins.fugitive.get_remote()%}"
vim.opt.background = 'dark'
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.backup = true -- automatically save a backup file
vim.opt.backupdir:remove('.') -- keep backups out of the current directory
vim.opt.breakindent = true -- maintain indent when wrapping indented lines
vim.opt.clipboard = 'unnamedplus' -- Use Linux system clipboard
vim.opt.cmdheight = 0
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.confirm = false -- ask for confirmation instead of erroring
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit' -- Live highlighting of search term during substitution
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.mouse = 'nv' -- enable mouse for all normal and visual, this lets tmux use the mouse when insert mode is active
vim.opt.number = true
vim.opt.number = true
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftround = true -- >> indents to next multiple of 'shiftwidth'.
vim.opt.shiftwidth = 4
vim.opt.shortmess:append({ I = true }) -- disable the splash screen
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.spell = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.undofile = true -- persistent undo
-- vim.opt.updatetime = 4001 -- Set updatime to 1ms longer than the default to prevent polyglot from changing it
vim.opt.wildmode = 'longest:full,full' -- complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.wrap = false -- soft line wraps
vim.opt.wrapscan = true -- searches wrap around the file
vim.cmd('filetype plugin on')

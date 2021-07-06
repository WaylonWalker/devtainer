"             _   _   _                       _           
"    ___  ___| |_| |_(_)_ __   __ _ _____   _(_)_ __ ___  
"   / __|/ _ \ __| __| | '_ \ / _` / __\ \ / / | '_ ` _ \ 
"   \__ \  __/ |_| |_| | | | | (_| \__ \\ V /| | | | | | |
"   |___/\___|\__|\__|_|_| |_|\__, |___(_)_/ |_|_| |_| |_|
"                             |___/                       
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let g:instant_username = "walkews"

set clipboard+=unnamedplus

let g:python_lint_config = '~/pylint.rc'
let g:python_lint_config = '~/pylint.rc'
let g:python3_host_prog = '~/miniconda3/bin/python'
let g:python3_host_prog = '~/miniconda3/envs/nvim3/bin/python'

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1 

let g:ale_fixers = {'python': ['isort', 'black', 'remove_trailing_lines', 'trim_whitespace']}
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" require'nvim-biscuits'.setup{}

nnoremap <leader>vat :VtrAttachToPane<CR>
vnoremap <leader>vs :'<,'>VtrSendLinesToRunner<CR>
nnoremap <leader>vs :VtrSendLinesToRunner<CR>
nnoremap <leader>vpy :VtrSendCommandToRunner ipython<CR>

nnoremap <leader>vpy VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'ipython'}
" general stuff

set noerrorbells
set autoread
au CursorHold * checktime
set shortmess=iot
set guioptions-=m
set guioptions-=t
set guioptions-=r
set guioptions-=l
syntax on
filetype plugin on
set path+=**
set mouse=nv

set tabstop=4
set shiftwidth=4
set expandtab

set noswapfile
set backupdir=~/.local/share/nvim/backup//
set directory=~/.local/share/nvim/swap//
set undodir=~/.local/share/nvim/undo//
set undofile
set scrolloff=8


set fillchars+=vert:\│

autocmd filetype html setlocal ts=2 sts=2 sw=2
autocmd filetype javascript setlocal ts=2 sts=2 sw=2


let g:pymode_lint_config='~/pylint.rc'
let g:black_virtualenv='/usr/local/bin/black'

autocmd bufwritepre *.py execute 'PyPreSave'
autocmd bufwritepost .tmux.conf execute ':!tmux source-file %'
autocmd bufwritepost *.vim execute ':source %'
autocmd bufwritepost *.lua execute ':source %'

let g:ctrl_map   = '<c-p>'
let g:ctrl_cmd   = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules|git'

let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = {'javascript': ['eslint']}

set encoding=utf-8

" set Line Numbers
:set number relativenumber

set nocompatible
filetype off

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.
if has('nvim')
    set inccommand=nosplit     " Live highlighting of search term during substitution
endif

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.


set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.
set nowrap

set list                   " Show non-printable characters.

set completeopt=menuone,noinsert,noselect
set signcolumn=yes

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:? ,extends:?,precedes:?,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

if &shell =~# 'fish$'
  set shell=/bin/bash
endif

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""' 
endif

" keep nerdtree open when opening files with nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

if system('uname -r') =~ "Microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
        augroup END
endif


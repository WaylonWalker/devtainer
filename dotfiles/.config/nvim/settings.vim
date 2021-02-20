"             _   _   _                       _           
"    ___  ___| |_| |_(_)_ __   __ _ _____   _(_)_ __ ___  
"   / __|/ _ \ __| __| | '_ \ / _` / __\ \ / / | '_ ` _ \ 
"   \__ \  __/ |_| |_| | | | | (_| \__ \\ V /| | | | | | |
"   |___/\___|\__|\__|_|_| |_|\__, |___(_)_/ |_|_| |_| |_|
"                             |___/                       
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

let g:python_lint_config = '~/pylint.rc'
let g:python3_host_prog = '~/miniconda3/bin/python'
let g:python3_host_prog = '~/miniconda3/envs/nvim3/bin/python'

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1 

nnoremap <leader>a :VtrAttachToPane<CR>
vnoremap <leader>a :'<,'>VtrSendLinesToRunner<CR>


" general stuff

set autoread
au CursorHold * checktime
set shortmess=iot
set guioptions-=m
set guioptions-=t
set guioptions-=r
set guioptions-=l
set guifont=inconsolata_nf:h11
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


set fillchars+=vert:\│

autocmd filetype html setlocal ts=2 sts=2 sw=2
autocmd filetype javascript setlocal ts=2 sts=2 sw=2


" let $path = 'c:/python+/64bit/envs/adhoc/;c:/python+/64bit/envs/adhoc/lib;c:/python+/64bit/envs/adhoc/lib/site-packaes/;' . $path
" let $pythonpath = 'c:/python+/64bit/envs/adhoc/;c:/python+/64bit/envs/adhoc/dlls;c:/python+/64bit/envs/adhoc/lib;c:/python+/64bit/envs/adhoc/lib/site-packages/'
let g:pymode_lint_config='~/pylint.rc'
" let g:black_virtualenv='/usr/local/bin/black'

" jsx
let g:jsx_ext_required = 0
let g:mta_filetypes = {
    \ 'javascript.jsx': 1,
    \}
let g:closetag_filenames = "*html,*.xhtml,*.phtml,*.php,*.js,*.jsx"
" let g:prettier#config#parser = 'babylon'
" let g:user_emmet_leader_key='<c-l>'
let g:user_emmet_settings = {
    \ 'javascript.jsx' : {
    \     'extends' : 'jsx',
    \ },
    \}

" let g:ultisnipsexpandtrigger="<tab>"
let g:ultisnipsjumpforwardtrigger="<c-b>"
let g:ultisnipsjumpbackwardtrigger="<c-z>"
let g:ultisnipsexpandtrigger="<c-l>"

let g:syntastic_javascript_checkers = ['eslint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineflag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'
let g:syntastic_javascript_eslint_exe = 'eslint % --fix'



" autocmd bufwritepost *.js asyncrun -post=checktime eslint --fix %
" autocmd bufwritepre *.js execute ':!eslint --fix %'
autocmd bufwritepre *.py execute ':Black'
autocmd bufwritepost .tmux.conf execute ':!tmux source-file %'
autocmd bufwritepost *.vim execute ':source %'

" set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrl_map   = '<c-p>'
let g:ctrl_cmd   = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules|git'

let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = {'javascript': ['eslint']}

" autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %

let g:lightline = {
  \ 'colorscheme': 'one',
  \ }

" map <C-p> :CtrlSpace O<CR>
set encoding=utf-8


" set Line Numbers
:set number relativenumber


" :set LineNr ctermfg=65
" :set CursorLineNr ctermfg=109
" :highlight LineNr ctermfg=5
" highlight LineNr ctermfg=grey ctermbg=black
" highlight CursorLineNr ctermfg=red
" hi clear LineNr
highlight Visual ctermbg=8

"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
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
set inccommand=nosplit     " Live highlighting of search term during substitution

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.


set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.
set nowrap

set list                   " Show non-printable characters.

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:? ,extends:?,precedes:?,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
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

let g:airline_powerline_fonts=1

" keep nerdtree open when opening files with nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

silent! color one
" Fix highlighting issues
" on my terminal pop up menus disapper into the background
"
" hi Visual ctermbg=magenta ctermfg=black
hi Normal guibg=NONE ctermbg=NONE
hi Pmenu ctermbg=None guibg=None ctermfg=magenta guifg=magenta
hi CursorLineNr ctermbg=NONE guibg=NONE 
hi LineNr ctermbg=NONE guibg=NONE 
hi SignColumn ctermbg=NONE guibg=NONE 

" Get UltiSnipsExpandTrigger to work
" https://github.com/ycm-core/YouCompleteMe/issues/420
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ?  "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" WhichKey
autocmd FileType which_key highlight WhichKey ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeySeperator ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeyGroup cterm=bold ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeyDesc ctermbg=12 ctermfg=7

" --------------------------------------------------------
" SETTINGS START

set completeopt=longest,menuone

" SETTINGS END
" --------------------------------------------------------

" --------------------------------------------------------
" COC-VIM TAB SETTINGS START

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" COC-VIM TAB SETTINGS END
" --------------------------------------------------------


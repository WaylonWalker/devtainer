"       l_                                         _           
"      | | _____ _   _ _ __ ___   __ _ _ ____   _(_)_ __ ___  
"      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \ 
"      |   <  __/ |_| | | | | | | (_| | |_) \ V /| | | | | | |
"      |_|\_\___|\__, |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                |___/                |_|                     
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

"unsorted
" nnoremap <leader>tp <cmd>let py = termopen('zsh')<CR>
vnoremap <leader>sp <cmd>'<,'>call chansend(py, [getline('.') . "<c-v><cr>"])<cr>
nnoremap <leader>sp <cmd>call chansend(py, [getline('.') . "<c-v><cr>"])<cr>

" get word count
nnoremap gwc vap<cmd>'<,'>w !wc -c<CR>

" toggle floatterm
nnoremap <c-\> <cmd>FloatermToggle<CR>
nnoremap <leader>ft :FloatermToggle<CR>

nnoremap ZR zR
nnoremap ZM zM

command! Xs :mks! | :xa 
nnoremap U <cmd>redo<cr>
"stupid Terminals map <c-^> to other things
nnoremap <leader>6 <c-^>
nnoremap <c-y> <c-^>
nnoremap zy <c-^>
inoremap gqq <esc>gqqA
inoremap mm. ->
nnoremap <leader>: :lua<space>

" git commits
nnoremap ga <cmd>G add %<CR>
nnoremap gic <cmd>G add %<CR>:sleep 500m<CR>:only<CR>:G commit<CR>
nnoremap gii <cmd>G add l%<CR>:sleep 500m<CR>:only<CR>:G commit<CR>
nnoremap gid <cmd>Gdiff<CR>
nnoremap gpp <cmd>G push<CR>
nnoremap gPP <cmd>G pull<CR>
nnoremap gil <cmd>GcLog<CR>
nnoremap giL <cmd>GcLog %<CR>
nnoremap gib <cmd>G blame<CR>

nnoremap gD <cmd>diffthis<CR>
set diffopt=vertical

autocmd TermOpen * setlocal nonumber norelativenumber

function! s:GitAdd()
    exe "G add %"
    exe "G diff --staged"
    exe "only"
    exe "G commit"
endfunction
:command! GitAdd :call s:GitAdd()
nnoremap gic :GitAdd<CR>

" window shortcuts
tnoremap <c-\><c-\> <c-\><c-n>
tnoremap <c-j><c-j> <c-\><c-n>
tnoremap <c-c><c-c> <c-\><c-n>
" tnoremap jj <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-l> <c-\><c-n><c-w>l
tnoremap <c-^> <c-\><c-n><c-^>
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Vtr
nnoremap <leader>vat <cmd>VtrAttachToPane<CR>
vnoremap <leader>vs <cmd>'<,'>VtrSendLinesToRunner<CR>
nnoremap <leader>vs <cmd>VtrSendLinesToRunner<CR>
nnoremap <leader>vv <cmd>VtrSendCommandToRunner 

nnoremap <tab> <cmd>bnext<cr>
nnoremap <s-tab> <cmd>bprevious<cr>

nmap <Leader>g <cmd>call TermOpen('gitui', 't')<CR>
nmap gtg <cmd>call TermOpen('gitui', 't')<CR>
nmap gtg :call TermOpen('gitui', 'v')<CR><C-w>H:vertical resize 160<CR>i
nmap gtf :call TermOpen('vifm', 'v')<CR><C-w>H:vertical resize 80<CR>i

" nnoremap <leader><leader>d "_d
" vnoremap <leader>d "_d

nnoremap <leader>ghw <cmd>h <C-R>=expand("<cword>")<CR><CR>

map <c-c> <cmd>qall<cr>
map <c-x> <cmd>xall<cr>
map <c-n> <cmd>NERDTreeToggle<cr>
map <c-/> <cmd>Commentary
inoremap <c-/> <cmd>Commentary

" edit things
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" source current file
nnoremap <leader>so <cmd>source %<CR>
nnoremap gso <cmd>source %<CR>
" edit hidden files
nnoremap geh <cmd>Telescope find_files hidden=true<CR>
" edit nvim dotfiles
nnoremap gen <cmd>Telescope find_files cwd=~/.config/nvim<CR>
" edit blog posts
nnoremap gei <cmd>Telescope find_files cwd=~/git/waylonwalker.com<CR>
" edit public projects
nnoremap geg <cmd>Telescope find_files cwd=~/git/<CR>
" edit private projects
nnoremap gew <cmd>Telescope find_files cwd=~/work/<CR>
" edit vim config
nnoremap <leader>en <cmd>Telescope find_files cwd=~/.config/nvim<CR>
" edit vim keymap
nnoremap gek <cmd>e ~/.config/nvim/keymap.vim<CR>
" edit lsp-config
nnoremap gel <cmd>e ~/.config/nvim/lua/waylonwalker/lsp-config.lua<CR>
" edit plugins list
nnoremap gep <cmd>e ~/.config/nvim/plugins.vim<CR>
"edit next to me
nnoremap gee <cmd>e %:h<C-Z>
" edit nvim settings
nnoremap ges <cmd>e ~/.config/nvim/settings.vim<CR>
" edit tmuux config
nnoremap get <cmd>e ~/.tmux.conf<CR>
" edit zshrc
"
" edit ipython config
nnoremap gel <cmd>Telescope find_files cwd=~/.config/nvim<CR>
"
nnoremap geit <cmd>Telescope find_files find_command=markata,list,--map,path,--filter,date==today<cr>
nnoremap geid <cmd>Telescope find_files find_command=markata,list,--map,path,--filter,status=='draft',--sort,date,--reverse<cr>
nnoremap geil <cmd>Telescope find_files find_command=markata,list,--map,path,--filter,templateKey=='til',--sort,date,--reverse<cr>
nnoremap geig <cmd>Telescope find_files find_command=markata,list,--map,path,--filter,templateKey=='gratitude',--sort,date,--reverse<cr>
" nnoremap geik <cmd>Telescope find_files find_command=markata,list,--map,path,--filter,'kedro' in tags,--sort,date,--reverse<cr>
nnoremap geid <cmd>lua require('telescope.builtin').find_files({find_command={"markata", "list", "--map", "path", "--filter", "status=='draft' and templateKey!='gratitude'", "--sort", "date", "--reverse"}})<cr>
nnoremap geik <cmd>lua require('telescope.builtin').find_files({find_command={"markata", "list", "--map", "path", "--filter", "'kedro' in tags", "--sort", "date", "--reverse"}})<cr>
nnoremap geidk <cmd>lua require('telescope.builtin').find_files({find_command={"markata", "list", "--map", "path", "--filter", "'kedro' in tags and status != 'published'", "--sort", "date", "--reverse"}})<cr>
nnoremap gec <cmd>Telescope find_files find_command=nnoremap,g,ec,<cmd>Telescope,find_files,find_command=nnoremap,gec<cmd>Telescope,find_files,find_command=",nnoremapmanifest,gec,<cmd>Telescope,find_files,find_commannnoremap,cc,<cmd>Telescope,find_files,find_command=git,status,--porcelain,\|,sed,s\/^...\\/\/<c\r\>l<cr><cr><cr><cr>

nnoremap gez :e ~/.zshrc<CR>
nnoremap gea :e ~/.alias<CR>

nnoremap gow <cmd>lua os.execute('xdg-open https://waylonwalker.com/' .. vim.api.nvim_buf_get_name(0):match("^.+/(.+)$"):gsub('.md', '') .. '/ > /dev/null 2>&1')<cr>

nnoremap goo <cmd>lua print(vim.fn.expand('<cword>'))<cr>
vnoremap goo <cmd>lua print(vim.fn.expand('<cword>'))<cr>

" edit from parent directory
set wcm=<C-Z>
nnoremap <leader>e :e %:h<C-Z>
cnoremap <C-f> %<C-Z>
cnoremap <C-p> %:h<C-Z>

" Plug
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap gpi :PlugInstall<CR>
nnoremap gpu :PlugInstall<CR>
nnoremap gpc :PlugClean<CR>

" insert mode mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
imap jj <esc>
imap jk <esc>
imap JJ <esc>
imap jJ <esc>
imap Jj <esc>
imap <c-_> <esc>:Commentary<cr>i

" normal mode mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

" toggle coomments with tpope
nnoremap <c-/> :Commentary
nnoremap <c-_> <cmd>Commentary<cr>


" ??? these have been here forever
nnoremap ` '
nnoremap ' `
noremap Q @@


" <c-w> cavemmands without <c-w>
" i commonly use cmder on windows which uses <c-w> to close a tab
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
" nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" Replace Mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-r>r :%s/<C-R>////g<Left><Left>
nnoremap <c-r><space> :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
nnoremap <c-r>w :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <c-r>r :%s/\<<C-r><C-/>\>//gI<Left><Left><Left>
nnoremap <c-r><c-r> :%s/\<<C-r><C-/>\>/<C-r><C-/>/gI<Left><Left><Left>

nnoremap <c-r>pr :vim <c-r><c-/> **/*<cr>:cdo s/\<<c-r><c-/>\>/<c-r><c-/>/gc<Left><Left><Left>
nnoremap <c-r><c-p><c-r> :vim <c-r><c-/> **/*%:e<cr>:cdo s/\<<c-r><c-/>\>//gc<Left><Left><Left>


" replace visual star
vnoremap <c-r><space> :s/<C-R>///g<Left><Left>
vnoremap <c-r>r :s/<C-R>//<C-R>//g<Left><Left>

" vnoremap <c-R> <cr>s///g<Left><Left><Left>
" type a replacement term and press . to repeat the replacement on the next
" match.
nnoremap <silent> s* <cr>let @/='\<'.expand('<cword>').'\>'<cr>cgn
xnoremap <silent> s* "sy: let @/=@s<cr>cgn

" nnoremap <leader>prw <cr>CocSearch <C-R>=expand("<cword>")<CR><CR>

" nvim spectre
nnoremap <leader>SS <cmd>lua require('spectre').open()<CR>

"search current word
nnoremap <leader>SW viw<cmd>lua require('spectre').open_visual()<CR>zR
vnoremap <leader>S <cmd>lua require('spectre').open_visual()<CR>zR
"  search in current file
nnoremap <leader>SP viw<cmd>lua require('spectre').open_file_search()<cr>zR

" leader keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let mapleader = " "
let g:maplocalleader = ','

" generic
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent> <leader>d :put =strftime('%Y-%m-%dT%H:%M:%S')<CR>
let s:pastemode = 0
function! s:TogglePasteMode()
    if s:pastemode  == 1
        let s:pastemode = 0
        set nopaste
    else
        let s:pastemode = 1
        set paste
    endif
endfunction
nnoremap <silent> <leader>y :call s:TogglePasteMode()<CR>

:command! TogglePasteMode :call s:TogglePasteMode()
nnoremap gtp :TogglePasteMode<CR>

" let s:winmax = 0
" function! s:ToggleWinMax()

"     if s:winmax  == 1
"         let s:winmax = 0
"         exe "normal \<c-w>\|\<c-w>_"
"     else
"         let s:winmax = 1
"         exe "normal \<c-w>="
"     endif
" endfunction

" :command! ToggleWinMax :call s:ToggleWinMax()
" nnoremap <silent> <c-w><c-w> :ToggleWinMax<CR>

function! s:PyPreSave()
    Black
endfunction

function! s:PyPostSave()
    execute "!tidy-imports --black --quiet --replace-star-imports --action REPLACE " . bufname("%")
    execute "!isort " . bufname("%")
    execute "e"
endfunction

:command! PyPreSave :call s:PyPreSave()
:command! PyPostSave :call s:PyPostSave()

" ToggleLocationList
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let s:syntastic_auto_loc_list = 0
let syntastic_auto_loc_list = 0

function! s:ToggleLocationList()
    if s:syntastic_auto_loc_list == 1
        let s:syntastic_auto_loc_list = 0
        let syntastic_auto_loc_list = 0
        :lclose
    else
        let s:syntastic_auto_loc_list = 1
        let syntastic_auto_loc_list = 1
        :lopen
    endif
endfunction

:command! ToggleLocationList :call s:ToggleLocationList()
nnoremap gtl <cmd>ToggleLocationList<CR>
nnoremap glp <cmd>lprevious<CR>
nnoremap gln <cmd>lnext<CR>

" nnoremap <c-s-j> :GitGutterNextHunk<CR>
" nnoremap <c-s-k> :GitGutterPrevHunk<CR>


" quickfix
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-j> <cmd>copen<cr><cmd>cnext<CR>
nnoremap <c-k> <cmd>copen<cr><cmd>cprev<CR>

let s:cisopen = 0

function! s:ToggleQuickFix()

    if s:cisopen  == 1
        let s:cisopen = 0
        :bel copen
        :wincmd k

    else
        let s:cisopen = 1
        :cclose
    endif
endfunction

:command! ToggleQuickFix <cmd>call s:ToggleQuickFix()
nnoremap gtj <cmd>ToggleQuickFix<CR>
" nnoremap <c-q> <cmd>ToggleQuickFix<CR>

nnoremap <silent> <leader>c <cmd>ToggleQuickFix<CR>


" nnoremap <C-S-L> <cmd>cnext<CR>

" git
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>go <cmd>G<cr>
nnoremap <silent><leader>gd <cmd>Gdiff<cr>
nnoremap <silent><leader>gs <cmd>Gstatus<cr>
nnoremap <silent><leader>gc <cmd>Gcommit<cr>
" nnoremap <silent><c-]> <cmd>GitGutterNextHunk<cr>
" nnoremap <silent><c-[> <cmd>GitGutterPrevHunk<cr>

" nnoremap gpg <cmd>GitGutterPrevHunk<CR>
" nnoremap gng <cmd>GitGutterNextHunk<CR>
" nnoremap gfg <cmd>GitGutterFold<CR>
" nnoremap gcg <cmd>GitGutterQuickFix<CR><cmd>copen<CR><C-w>L


" shortcuts
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>w <cmd>w<cr>
nnoremap <silent><leader>q <cmd>q<cr>
nnoremap <silent><leader>x <cmd>x<cr>

" formatting
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <leader><leader>p <cmd>!prettier % --write l<cr>
" nnoremap <leader>f <cmd>black<cr>
" nnoremap <leader>c <cmd>Commentary<cr>
" nnoremap <leader>u gu
nnoremap <leader>f8 <cmd>call flake8#Flake8()<cr>

" visual mode remap
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
command! Vb normal! <C-v>
nnoremap <leader>b <cmd>Vb<CR>

" retain visual selection after indent
" > indent
" < unindent
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" vnoremap < <gv
" vnoremap > >gv

" give a few extra lines after zt/zb
" zt scroll current line to top
" zb scroll current line to bottom
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" corrected with scrolloff
" nnoremap zt zt<C-Y><C-Y><C-Y>
" nnoremap zb zb<C-e><C-e><C-e>

" navigation
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
command! -bang -nargs=? -complete=dir HFiles
  " \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
nnoremap <leader>p <cmd>GFiles<cr>

nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>F <cmd>Telescope<cr>
nnoremap <leader>o <cmd>Telescope old_files<cr>
nnoremap <leader>q <cmd>Telescope lsp_document_diagnostics<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fc <cmd>Telescope colorscheme<cr>
nnoremap <leader>fg <cmd>Telescope git_files<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fl <cmd>Telescope live_grep<cr>
nnoremap <leader>fhl <cmd>Telescope live_grep hidden=true<CR>
nnoremap <leader>fhh <cmd>Telescope old_files<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>

nnoremap gR <cmd>Telescope lsp_references<cr>
nnoremap gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap gD <cmd>Telescope lsp_definitions<cr>
nnoremap gn <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap gh <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap gH <cmd>Lspsaga hover_doc<cr>
nnoremap gb <cmd>Telescope git_branches<cr>
nnoremap gs <cmd>Git<cr>

nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>F <cmd>Telescope<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fl <cmd>Telescope live_grep<cr>
nnoremap <leader>m <cmd>Telescope marks<cr>
nnoremap <leader>M <cmd>Telescope man_pages<cr>
nnoremap <leader>F <cmd>Telescope<cr>
nnoremap gR <cmd>Telescope lsp_references<cr>
nnoremap gr <cmd>lua vim.lsp.buf.references()<cr>

nnoremap <leader>r <cmd>Rg<cr>

nnoremap <leader>n <cmd>b#<cr>
nnoremap \ <cmd>b#<cr>
nnoremap <D-A-LEFT> <C-W>h
nnoremap <D-A-DOWN> <C-W>j
nnoremap <D-A-UP> <C-W>k
nnoremap <D-A-RIGHT> <C-W>l
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l

nnoremap <leader>s <cmd>sp<cr>
nnoremap <leader>v <cmd>vsp<cr>

nnoremap <leader>H <c-w>H
nnoremap <leader>J <c-w>J
nnoremap <leader>K <c-w>K
nnoremap <leader>L <c-w>L
nnoremap <leader>i <cmd>TagbarToggle<CR>

" interface
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <silent> <leader><leader>l <cmd>Limelight!!<cr>

" Zen Mode
nnoremap <silent> <leader><leader>z <cmd>Goyo<CR>
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        set nonumber
        set norelativenumber
        set scl=no
        " GitGutterDisable
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
        set relativenumber
        set scl=yes
        " GitGutterEnable
    endif
endfunction
nnoremap <silent> <leader>z <cmd>call ToggleHiddenAll()<CR>

" Function Keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <F6> <cmd>setlocal spell! spelllang=expand("<cword>")<cr><cr>



" Saga

nnoremap <silent><leader>ca <cmd>Lspsaga code_action<CR>
vnoremap <silent><leader>ca <cmd><C-U>Lspsaga range_code_action<CR>

" Harpoon
"
nnoremap <c-h><c-h> <cmd>lua require("harpoon.mark").toggle_file()<CR>
nnoremap <c-h><c-e> <cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <c-h><c-a> <cmd>lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <c-h><c-s> <cmd>lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <c-h><c-d> <cmd>lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <c-h><c-f> <cmd>lua require("harpoon.ui").nav_file(4)<CR>
" nnoremap <c-u> <cmd>lua require("harpoon.ui").nav_next()<CR>
" nnoremap <c-k> <cmd>lua require("harpoon.ui").nav_prev()<CR>


nnoremap <TAB> <cmd>lua require("harpoon.ui").nav_next()<CR>
nnoremap <S-TAB> <cmd>lua require("harpoon.ui").nav_prev()<CR>
nnoremap <leader>aj <cmd>lua require("harpoon.ui").nav_file(1)<CR>
nnoremap zj <cmd>lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>ak <cmd>lua require("harpoon.ui").nav_file(2)<CR>
nnoremap zk <cmd>lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>al <cmd>lua require("harpoon.ui").nav_file(3)<CR>
nnoremap zl <cmd>lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>a; <cmd>lua require("harpoon.ui").nav_file(4)<CR>
nnoremap z; <cmd>lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>aa <cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap zx <cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>ap <cmd>lua require("harpoon.ui").nav_prev()<CR>
nnoremap zp <cmd>lua require("harpoon.ui").nav_prev()<CR>
nnoremap <leader><leader>n <cmd>lua require("harpoon.ui").nav_next()<CR>
nnoremap zn <cmd>lua require("harpoon.ui").nav_next()<CR>

nnoremap <c-m-m> <cmd>lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader><leader>m <cmd>lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader><leader>m <cmd>lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader>am <cmd>lua require("harpoon.mark").toggle_file()<cr>
nnoremap zm <cmd>lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader><leader>c <cmd>lua require("harpoon.mark").clear_all()<cr>
nnoremap zc <cmd>lua require("harpoon.mark").clear_all()<cr>

" terminals
" nnoremap <leader>tj :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <leader>tk :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cjp <cmd>lua require("harpoon.term").sendCommand(1, 'ipython\n')<CR>
nnoremap <leader>ckp <cmd>lua require("harpoon.term").sendCommand(1, 'ipython\n')<CR>
nnoremap <leader>cj :lua require("harpoon.term").sendCommand(1, vim.api.nvim_get_current_line() .. "\n")<cr>j
nnoremap <leader>ck :lua require("harpoon.term").sendCommand(2, vim.api.nvim_get_current_line() .. "\n")<cr>j
" nnoremap <leader>lint <cmd>lua require("harpoon.term").sendCommand(1,  "flake8 ." .. "\n")<cr><cmd>lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>gk <cmd>lua require("harpoon.term").sendCommand(2,  "pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme "  .. vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) .. "\n")<cr>:lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>vd <cmd>lua require("harpoon.term").sendCommand(1, "direnv reload\n" .. "vd "  .. vim.api.nvim_get_current_line():gsub('filepath:', '') .. "\n")<cr>:lua require("harpoon.term").gotoTerminal(1)<CR>
" require("harpoon.term").sendCommand(1, "ls -la")

" moving text
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
inoremap <C-k> <esc>:m .-2<CR>==
inoremap <C-j> <esc>:m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" something was overriding c-i

nnoremap <C-_> <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy(), {sorting_strategy='ascending', theme='ivy', prompt_position='top'})<cr>
inoremap <silent><expr> <C-Space> compe#complete()

imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" lsp
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>dp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <leader>dn <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gh <cmd>Lspsaga lsp_finder<CR>
nnoremap <silent>K <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> gs <cmd>lua vim.lsp.buf.signature_help()<CR>

" something hijacked escape to escape and scroll up
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <esc> <esc>
" c-i was also hijacked
nnoremap <c-i> <c-i>

" Telegraph

nnoremap <leader><leader>s <cmd>lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})<CR>
nnoremap <leader><leader>S <cmd>lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})<CR>

nnoremap <leader><leader>vd <cmd>lua require'telegraph'.telegraph({cmd='pipx run visidata {cWORD}', how='tmux'})<CR>
nnoremap <leader><leader>m :Telegraph man
nnoremap <leader><leader>M :lua require'telegraph'.telegraph({how='tmux_popup', cmd='man '})<Left><Left><Left>

nnoremap <leader><leader>i <cmd>Telegraph feh {cWORD}<CR>

nnoremap <leader><leader>r <cmd>lua require'telegraph'.telegraph({cmd='zsh -c "ipython {filepath} -i"', how='tmux_popup'})<CR>
nnoremap <leader><leader>z <cmd>lua require'telegraph'.telegraph({cmd='zsh', how='tmux_popup'})<CR>

nnoremap <leader>t <cmd>lua require'telegraph'.telegraph({how='execute', cmd='echo "{cline}" > ~/.config/title/title.txt'})<cr>

nnoremap <leader>ma <cmd>lua require'telegraph'.telegraph({cmd='notify-send TheBoss "Get it Done"', how='execute'})<cr>
nnoremap <leader>ms <cmd>lua require'telegraph'.telegraph({cmd='notify-send TheBoss "Get it Done"', how='execute'})<cr>

nnoremap <leader><leader>b <cmd>lua  require'telegraph'.telegraph({cmd='google-chrome {cWORD}', how='subprocess'})<CR> command! -nargs=1 T lua require'telegraph'.telegraph({cmd=<f-args>})

nnoremap <leader><leader>c I[//]: <> (<esc>A)<esc>

nnoremap <leader><leader>j <cmd>w

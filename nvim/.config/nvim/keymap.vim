"       _                                         _           
"      | | _____ _   _ _ __ ___   __ _ _ ____   _(_)_ __ ___  
"      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \ 
"      |   <  __/ |_| | | | | | | (_| | |_) \ V /| | | | | | |
"      |_|\_\___|\__, |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                |___/                |_|                     
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

"unsorted
nnoremap <leader>tp :let py = termopen('zsh')<CR>
vnoremap <leader>sp :'<,'>call chansend(py, [getline('.') . "<c-v><cr>"])<cr>
nnoremap <leader>sp :call chansend(py, [getline('.') . "<c-v><cr>"])<cr>

" get word count
nnoremap gwc vap:'<,'>w !wc -c<CR>

" toggle floatterm
nnoremap <c-\> :FloatermToggle<CR>
nnoremap <leader>ft :FloatermToggle<CR>

nnoremap ZR zR
nnoremap ZM zM

command! Xs :mks! | :xa 
nnoremap U :redo<cr>
"stupid Terminals map <c-^> to other things
nnoremap <leader>6 <c-^>
nnoremap <c-y> <c-^>
nnoremap zy <c-^>
inoremap gqq <esc>gqqA
nnoremap <leader>: :lua<space>

" git commits
nnoremap ga :G add %<CR>
nnoremap gic :G add %<CR>:sleep 500m<CR>:only<CR>:G commit<CR>
nnoremap gii :G add l%<CR>:sleep 500m<CR>:only<CR>:G commit<CR>
nnoremap gid :Gdiff<CR>
nnoremap gpp :G push<CR>
nnoremap gPP :G pull<CR>

nnoremap gD :diffthis<CR>
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
tnoremap jj <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-l> <c-\><c-n><c-w>l
tnoremap <c-^> <c-\><c-n><c-^>
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Vtr
nnoremap <leader>vat :VtrAttachToPane<CR>
vnoremap <leader>vs :'<,'>VtrSendLinesToRunner<CR>
nnoremap <leader>vs :VtrSendLinesToRunner<CR>
nnoremap <leader>vv :VtrSendCommandToRunner 

nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprevious<cr>

nmap <Leader>g :call TermOpen('gitui', 't')<CR>
nmap gtg :call TermOpen('gitui', 't')<CR>
nmap gtg :call TermOpen('gitui', 'v')<CR><C-w>H:vertical resize 160<CR>i
nmap gtf :call TermOpen('vifm', 'v')<CR><C-w>H:vertical resize 80<CR>i

" nnoremap <leader><leader>d "_d
" vnoremap <leader>d "_d

nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>

map <c-c> :qall<cr>
map <c-x> :xall<cr>
map <c-n> :NERDTreeToggle<cr>
map <c-/> :Commentary
inoremap <c-/> :Commentary

" edit things
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" source current file
nnoremap <leader>so :source %<CR>
nnoremap gso :source %<CR>
" edit hidden files
nnoremap geh :Telescope find_files hidden=true<CR>
" edit nvim dotfiles
nnoremap gen :Telescope find_files cwd=~/.config/nvim<CR>
" edit blog posts
nnoremap gei :Telescope find_files cwd=~/git/waylonwalker.com<CR>
" edit public projects
nnoremap geg :Telescope find_files cwd=~/git/<CR>
" edit private projects
nnoremap gew :Telescope find_files cwd=~/work/<CR>
" edit vim config
nnoremap <leader>en :Telescope find_files cwd=~/.config/nvim<CR>
" edit vim keymap
nnoremap gek :e ~/.config/nvim/keymap.vim<CR>
" edit lsp-config
nnoremap gel :e ~/.config/nvim/lsp-config.lua<CR>
" edit plugins list
nnoremap gep :e ~/.config/nvim/plugins.vim<CR>
" edit nvim settings
nnoremap ges :e ~/.config/nvim/settings.vim<CR>
" edit tmuux config
nnoremap get :e ~/.tmux.conf<CR>
" edit zshrc
nnoremap gez :e ~/.zshrc<CR>

nnoremap gow <cmd>lua os.execute('xdg-open https://waylonwalker.com/' .. vim.api.nvim_buf_get_name(0):match("^.+/(.+)$"):gsub('.md', '') .. '/ > /dev/null 2>&1')<cr>

" edit from parent directory
set wcm=<C-Z>
nnoremap <leader>e :e %:h<C-Z>
cnoremap <C-f> %<C-Z>
cnoremap <C-p> %:h<C-Z>

" Plug
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap gpi :PlugInstall<CR>
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
nnoremap <c-_> :Commentary<cr>


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

nnoremap <c-r><c-p><c-r> :vim <c-r><c-/> **/*%:e<cr>:cdo s/\<<c-r><c-/>\>//gc<Left><Left><Left>
nnoremap <c-r>pr :vim <c-r><c-/> **/*<cr>:cdo s/\<<c-r><c-/>\>/<c-r><c-/>/gc<Left><Left><Left>

" replace visual star
vnoremap <c-r><space> :s/<C-R>///g<Left><Left>
vnoremap <c-r>r :s/<C-R>//<C-R>//g<Left><Left>

" vnoremap <c-R> :s///g<Left><Left><Left>
" type a replacement term and press . to repeat the replacement on the next
" match.
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<cr>cgn
xnoremap <silent> s* "sy: let @/=@s<cr>cgn

nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

" nvim spectre
nnoremap <leader>S :lua require('spectre').open()<CR>

"search current word
nnoremap <leader>SW viw:lua require('spectre').open_visual()<CR>zR
vnoremap <leader>S :lua require('spectre').open_visual()<CR>zR
"  search in current file
nnoremap <leader>SP viw:lua require('spectre').open_file_search()<cr>zR

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
    " Isort
    " call flake8#Flake8()
endfunction

:command! PyPreSave :call s:PyPreSave()

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
nnoremap gtl :ToggleLocationList<CR>
nnoremap glp :lprevious<CR>
nnoremap gln :lnext<CR>

nnoremap <c-s-j> :GitGutterNextHunk<CR>
nnoremap <c-s-k> :GitGutterPrevHunk<CR>


" quickfix
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-j> :copen<cr>:cnext<CR>
nnoremap <c-k> :copen<cr>:cprev<CR>

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

:command! ToggleQuickFix :call s:ToggleQuickFix()
nnoremap gtj :ToggleQuickFix<CR>
" nnoremap <c-q> :ToggleQuickFix<CR>

nnoremap <silent> <leader>c :ToggleQuickFix<CR>


" nnoremap <C-S-L> :cnext<CR>

" git
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>gd :Gdiff<cr>
nnoremap <silent><leader>gs :Gstatus<cr>
nnoremap <silent><leader>gc :Gcommit<cr>
nnoremap <silent><c-]> :GitGutterNextHunk<cr>
nnoremap <silent><c-[> :GitGutterPrevHunk<cr>

nnoremap gpg :GitGutterPrevHunk<CR>
nnoremap gng :GitGutterNextHunk<CR>
nnoremap gfg :GitGutterFold<CR>
nnoremap gcg :GitGutterQuickFix<CR>:copen<CR><C-w>L


" shortcuts
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>w :w<cr>
nnoremap <silent><leader>q :q<cr>
nnoremap <silent><leader>x :x<cr>

" formatting
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <leader><leader>p :!prettier % --write l<cr>
" nnoremap <leader>f :black<cr>
" nnoremap <leader>c :Commentary<cr>
" nnoremap <leader>u gu
nnoremap <leader>f8 :call flake8#Flake8()<cr>

" visual mode remap
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
command! Vb normal! <C-v>
nnoremap <leader>b :Vb<CR>

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
nnoremap <leader>p :GFiles<cr>

nnoremap <leader>p :Telescope find_files<cr>
nnoremap <leader>F :Telescope<cr>
nnoremap <leader>o :Telescope old_files<cr>
nnoremap <leader>q :Telescope lsp_document_diagnostics<cr>
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fc :Telescopecopen colorscheme<cr>
nnoremap <leader>fg :Telescope git_files<cr>
nnoremap <leader>fs :Telescope grep_string<cr>
nnoremap <leader>fl :Telescope live_grep<cr>
nnoremap <leader>fh :Telescope old_files<cr>
nnoremap <leader>fr :Telescope lsp_references<cr>
nnoremap <leader>fq :Telescope quickfix<cr>
nnoremap gR :Telescope lsp_references<cr>
nnoremap gr :lua vim.lsp.buf.references()<cr>
nnoremap gd :Telescope lsp_definitions<cr>
nnoremap gh :Lspsaga hover_doc<cr>
nnoremap gb :Telescope git_branches<cr>
nnoremap gs :Git<cr>

nnoremap <leader>p :Telescope find_files<cr>
nnoremap <leader>F :Telescope<cr>
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fl :Telescope live_grep<cr>
nnoremap <leader>m :Telescope marks<cr>
nnoremap <leader>M :Telescope man_pages<cr>
nnoremap <leader>F :Telescope<cr>
nnoremap gR :Telescope lsp_references<cr>
nnoremap gr :lua vim.lsp.buf.references()<cr>
nnoremap gd :Telescope lsp_definitions<cr>

nnoremap <leader>r :Rg<cr>

nnoremap <leader>n :b#<cr>
nnoremap \ :b#<cr>
nnoremap <D-A-LEFT> <C-W>h
nnoremap <D-A-DOWN> <C-W>j
nnoremap <D-A-UP> <C-W>k
nnoremap <D-A-RIGHT> <C-W>l
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l

nnoremap <leader>s :sp<cr>
nnoremap <leader>v :vsp<cr>

nnoremap <leader>H <c-w>H
nnoremap <leader>J <c-w>J
nnoremap <leader>K <c-w>K
nnoremap <leader>L <c-w>L
nnoremap <leader>i :TagbarToggle<CR>

" interface
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent> <leader><leader>l :Limelight!!<cr>

" Zen Mode
nnoremap <silent> <leader><leader>z :Goyo<CR>
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
nnoremap <silent> <leader>z :call ToggleHiddenAll()<CR>

" Function Keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <F6> :setlocal spell! spelllang=expand("<cword>")<cr><cr>



" Saga

nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>

" Harpoon
nnoremap <TAB> :lua require("harpoon.ui").nav_next()<CR>
nnoremap <S-TAB> :lua require("harpoon.ui").nav_prev()<CR>
nnoremap <leader>aj :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap zj :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>ak :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap zk :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>al :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap zl :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>a; :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap z; :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>aa :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap zx :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>ap :lua require("harpoon.ui").nav_prev()<CR>
nnoremap zp :lua require("harpoon.ui").nav_prev()<CR>
nnoremap <leader><leader>n :lua require("harpoon.ui").nav_next()<CR>
nnoremap zn :lua require("harpoon.ui").nav_next()<CR>

nnoremap <c-m-m> :lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader><leader>m :lua require("harpoon.mark").toggle_file()<cr>
nnoremap zm :lua require("harpoon.mark").toggle_file()<cr>
nnoremap <leader><leader>c :lua require("harpoon.mark").clear_all()<cr>
nnoremap zc :lua require("harpoon.mark").clear_all()<cr>

" terminals
nnoremap <leader>tj :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>tk :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cjp :lua require("harpoon.term").sendCommand(1, 'ipython\n')<CR>
nnoremap <leader>ckp :lua require("harpoon.term").sendCommand(1, 'ipython\n')<CR>
nnoremap <leader>cj :lua require("harpoon.term").sendCommand(1, vim.api.nvim_get_current_line() .. "\n")<cr>j
nnoremap <leader>ck :lua require("harpoon.term").sendCommand(2, vim.api.nvim_get_current_line() .. "\n")<cr>j

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
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
nnoremap <silent> gs <cmd>lua vim.lsp.buf.signature_help()<CR>

" something hijacked escape to escape and scroll up
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <esc> <esc>
" c-i was also hijacked
nnoremap <c-i> <c-i>

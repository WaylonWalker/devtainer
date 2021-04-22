"       _                                         _           
"      | | _____ _   _ _ __ ___   __ _ _ ____   _(_)_ __ ___  
"      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \ 
"      |   <  __/ |_| | | | | | | (_| | |_) \ V /| | | | | | |
"      |_|\_\___|\__, |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                |___/                |_|                     
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

"unsorted

"stupid Terminals map <c-^> to other things
nnoremap <leader>6 <c-^>
inoremap gqq <esc>gqqA

autocmd TermOpen * setlocal nonumber norelativenumber


" window shortcuts
tnoremap <c-\><c-\> <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-l> <c-\><c-n><c-w>l
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

nnoremap <leader><leader>d "_d
vnoremap <leader>d "_d

nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>

" map <c-w> :q<cr>
map <c-c> :qall<cr>
map <c-x> :xall<cr>
map <c-n> :NERDTreeToggle<cr>
map <c-/> :Commentary
inoremap <c-/> :Commentary
map <c-s> :w<cr>

" edit things
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" source current file
nnoremap <leader>so :source %<CR>
nnoremap gso :source %<CR>
" edit nvim dotfiles
nnoremap gek :e ~/.config/nvim/keymap.vim<CR>
nnoremap gep :e ~/.config/nvim/plugins.vim<CR>
nnoremap ges :e ~/.config/nvim/settings.vim<CR>
" edit tmuux config
nnoremap get :e ~/.tmux.conf<CR>
" edit zshrc
nnoremap gez :e ~/.zshrc<CR>
" edit from parent directory
set wcm=<C-Z>
nnoremap <leader>e :e %:h<C-Z>
cnoremap <C-f> %<C-Z>
cnoremap <C-p> %:h<C-Z>

" Plug
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap gpi :PlugInstall<CR>
nnoremap gpc :PlugClean<CR>

" nnoremap gp :Maps<CR>
nnoremap gwc vap:'<,'>w !wc -c<CR>


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
nnoremap <c-/> :Commentary
nnoremap <c-_> :Commentary<cr>
nnoremap ` '
nnoremap ' `
noremap Q @@
nnoremap <silent> <c-s> :<c-u>update<cr>


" <c-w> cavemmands without <c-w>
" i commonly use cmder on windows which uses <c-w> to close a tab
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
" nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" Replace Mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-r> :%s/<C-R>////g<Left><Left>
vnoremap <c-r> :s///g<Left><Left><Left><C-R>/<Right>  # replace visual star
" replace visual star
vnoremap <c-r> :s/<C-R>//g<Left><Left>
" vnoremap <c-R> :s///g<Left><Left><Left>
" type a replacement term and press . to repeat the replacement on the next
" match.
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<cr>cgn
xnoremap <silent> s* "sy: let @/=@s<cr>cgn

nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
" leader keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let mapleader = " "
let g:maplocalleader = ','
" nnoremap <silent> <leader> :whichkey '<Space>'<cr>

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

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

function! s:PyPreSave()
    Black
    " Isort
    " call flake8#Flake8()
endfunction

:command! PyPreSave :call s:PyPreSave()


function! s:NoBg()
    highlight Normal ctermbg=NONE
    highlight CursorLineNr ctermbg=NONE guibg=NONE 
    highlight SignColumn ctermbg=NONE guibg=NONE 
endfunction

:command! NoBg :call s:NoBg()
nnoremap <silent> <leader><cr> :NoBg<cr>:noh<cr>

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
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>fb :Telescope file_browser<cr>
nnoremap <leader>fg :Telescope git_files<cr>
nnoremap <leader>fs :Telescope grep_string<cr>
nnoremap <leader>fh :Telescope old_files<cr>


nnoremap <leader>P :HFiles<cr>
nnoremap <C-p> :GFiles<cr>
nnoremap <leader>t :Files<cr>
nnoremap <C-S-P> :Maps<cr>
nnoremap <C-S-P> :CocList<cr>
nnoremap <C-S-P> :Commands<cr>
nnoremap <leader>r :Rg<cr>
" nnoremap <C-R> :Rg<cr>
nnoremap <cr> :Buffers<cr>
nnoremap <leader>m :Marks<cr>

nnoremap <leader>n :b#<cr>
nnoremap \ :b#<cr>
nnoremap <D-A-LEFT> <C-W>h
nnoremap <D-A-DOWN> <C-W>j
nnoremap <D-A-UP> <C-W>k
" nnoremap <Alt-j> <C-W>j
" nnoremap <Alt-k> <C-W>k
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
nnoremap <silent><leader>o :CtrlSpace O<CR>
" map <silent> <leader><cr> :noh<cr>
nnoremap <silent> <leader>\ :highlight LineNr ctermfg=8 ctermbg=black<cr> :highlight CursorLineNr ctermfg=red<cr> :highlight Visual ctermbg=8<cr>

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
        GitGutterDisable
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
        set relativenumber
        GitGutterEnable
    endif
endfunction
nnoremap <silent> <leader>z :call ToggleHiddenAll()<CR>

" Function Keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>


" bubbling
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nmap <C-k> ddkP
" nmap <C-j> ddp

vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" Navigate to definition
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap gd :YcmCompleter GoTo<CR>
" nnoremap gh :YcmCompleter GetDoc<CR>

nnoremap gd :call CocActionAsync('jumpDefinition')<CR>
nnoremap gd :call CocActionAsync('doHover')<CR>

nmap <silent> gd <Plug>(coc-definition)

" ALE
nnoremap <leader>at :ALEToggle<CR>
nnoremap <leader>ah :ALEHover<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR>
nnoremap <leader>a/ :ALESymbolSearch <c-r>=expand("<cword>")<cr><cr>

" swapped smooth-scroll for comfortable-motion
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 1)<CR>
" noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 1)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>


" something hijacked escape to escape and scroll up
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <esc> <esc>

" Saga

nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>


" Harpoon

nnoremap <TAB> :lua require("harpoon.ui").nav_next()<CR>
nnoremap <S-TAB> :lua require("harpoon.ui").nav_prev()<CR>
nnoremap <CR>b :Telescope buffers<CR>
nnoremap <CR>a :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <CR>s :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <CR>d :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <CR>f :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <CR>g :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <CR>n :lua require("harpoon.ui").nav_next()<CR>
nnoremap <CR>p :lua require("harpoon.ui").nav_prev()<CR>


nnoremap <CR><CR> :lua require("harpoon.mark").toggle_file()<CR>
nnoremap <CR>c :lua require("harpoon.mark").rm_file()<CR>
nnoremap <CR>C :lua require("harpoon.mark").clear_all()<CR>
" nnoremap <CR>S :lua require("harpoon.mark").add_file()<CR>
" nnoremap <CR>D :lua require("harpoon.mark").add_file()<CR>
" nnoremap <CR>F :lua require("harpoon.mark").add_file()<CR>



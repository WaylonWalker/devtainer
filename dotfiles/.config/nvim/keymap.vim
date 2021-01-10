"       _                                         _           
"      | | _____ _   _ _ __ ___   __ _ _ ____   _(_)_ __ ___  
"      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \ 
"      |   <  __/ |_| | | | | | | (_| | |_) \ V /| | | | | | |
"      |_|\_\___|\__, |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                |___/                |_|                     
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

nnoremap <tab> :bnext<cr>                       # Next Buffej
nnoremap <s-tab> :bprevious<cr>                 # Previous Buffer

map <c-w> :q<cr>                                # quit
map <c-c> :qall<cr>                             # quit all
map <c-x> :xall<cr>                             # quit all
map <c-n> :NERDTreeToggle<cr>                   # sidebar
map <c-/> :Commentary                           # comment
inoremap <c-/> :Commentary                      # comment
map <c-s> :w<cr>                                # comment

nnoremap <leader>so :source %<CR>
nnoremap gso :source %<CR>
nnoremap gek :e ~/.config/nvim/keymap.vim<CR>   # edit keymap
nnoremap gep :e ~/.config/nvim/plugins.vim<CR>  # edit plugins
nnoremap gpi :PlugInstall<CR>                   # install plugins
nnoremap gpc :PlugClean<CR>                     # clean plugins
nnoremap ges :e ~/.config/nvim/settings.vim<CR> # edit settings

nnoremap gp :Maps<CR>
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
nnoremap <c-/> :Commentary                     # comment
" nnoremap <tab> :undotreetoggle
nnoremap <c-_> :Commentary<cr>                 # comment
nnoremap ` '
nnoremap ' `
noremap Q @@                                   # run last macro
nnoremap <silent> <c-s> :<c-u>update<cr>       # save


" <c-w> commands without <c-w>
" i commonly use cmder on windows which uses <c-w> to close a tab
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
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


" ToggleLocationList
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let s:syntastic_auto_loc_list = 1
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


" git
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>gd :Gdiff<cr>
nnoremap <silent><leader>gs :Gstatus<cr>
nnoremap <silent><leader>gc :Gcommit<cr>
nnoremap <silent><c-]> :GitGutterNextHunk<cr>
nnoremap <silent><c-[> :GitGutterPrevHunk<cr>

" shortcuts
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>w :w<cr>
nnoremap <silent><leader>q :q<cr>
nnoremap <silent><leader>x :x<cr>

" formatting
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
" nnoremap <leader><leader>p :!prettier % --write l<cr>
nnoremap <leader>f :black<cr>
nnoremap <leader>c :Commentary<cr>
nnoremap <leader>u gu

" visual mode remap
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
command! Vb normal! <C-v>
nnoremap <leader>b :Vb<CR>

" retain visual selection after indent
" > indent
" < unindent
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
vnoremap < <gv
vnoremap > >gv

" give a few extra lines after zt/zb
" zt scroll current line to top
" zb scroll current line to bottom
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap zt zt<C-Y><C-Y><C-Y>
nnoremap zb zb<C-e><C-e><C-e>

" navigation
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
nnoremap <leader>p :GFiles<cr>
nnoremap <leader>P :HFiles<cr>
nnoremap <C-p> :GFiles<cr>
nnoremap <leader>t :Files<cr>
nnoremap <C-S-P> :Maps<cr>
nnoremap <C-S-P> :CocList<cr>
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
map <silent> <leader><cr> :noh<cr>
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
        :GitGutterDisable<CR>
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
        set relativenumber
        :GitGutterEnable<CR>
    endif
endfunction
nnoremap <silent> <leader>z :call ToggleHiddenAll()<CR>

" Function Keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
map <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>


" bubbling
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nmap <C-k> ddkP
nmap <C-j> ddp

vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" Navigate to definition
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap gd :YcmCompleter GoTo<CR>
nnoremap gh :YcmCompleter GetDoc<CR>

nmap <silent> gd <Plug>(coc-definition)

" swapped smooth-scroll for comfortable-motion
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 1)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 1)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

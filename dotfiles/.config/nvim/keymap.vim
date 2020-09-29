"       _                                         _           
"      | | _____ _   _ _ __ ___   __ _ _ ____   _(_)_ __ ___  
"      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \ 
"      |   <  __/ |_| | | | | | | (_| | |_) \ V /| | | | | | |
"      |_|\_\___|\__, |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                |___/                |_|                     
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 

nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprevious<cr>

map <c-w> :q<cr>
map <c-c> :qall<cr>
map <c-n> :NERDTreeToggle<cr>
map <c-/> :Commentary
inoremap <c-/> :Commentary
map <c-s> :w<cr>

" insert mode mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
imap jj <esc>
imap jj <esc>
imap jj <esc>
imap jj <esc>
imap <c-_> <esc>:Commentary<cr>i

" normal mode mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-/> :Commentary
" nnoremap <tab> :undotreetoggle
nnoremap <c-_> :Commentary<cr>
nnoremap ` '
nnoremap ' `
noremap q @@
nnoremap <silent> <c-s> :<c-u>update<cr>


" <c-w> commands without <c-w>
" i commonly use cmder on windows which uses <c-w> to close a tab
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" Replace Mappings
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <c-r> :%s///g<Left><Left><Left><C-R>/<Right> " replace visual star
nnoremap <c-R> :%s///g<Left><Left><Left>
vnoremap <c-r> :s///g<Left><Left><Left><C-R>/<Right> " replace visual star
vnoremap <c-R> :s///g<Left><Left><Left>
" type a replacement term and press . to repeat the replacement on the next
" match.
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<cr>cgn
xnoremap <silent> s* "sy: let @/=@s<cr>cgn

" leader keys
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
let mapleader = " "
nnoremap <silent> <leader> :whichkey '<space>'<cr>


" git
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>gd :Gdiff<cr>
nnoremap <silent><leader>gs :Gstatus<cr>
nnoremap <silent><leader>gc :Gcommit<cr>

" shortcuts
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <silent><leader>w :w<cr>
nnoremap <silent><leader>q :q<cr>
nnoremap <silent><leader>x :x<cr>
nnoremap <c-h> <c-w><c-h>

" formatting
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
nnoremap <leader><leader>p :!prettier % --write l<cr>
nnoremap <leader>f :black<cr>
nnoremap <leader>c :Commentary<cr>
nnoremap <leader>u gu

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
nnoremap <leader>r :Rg<cr>
" nnoremap <C-R> :Rg<cr>
nnoremap <cr> :Buffers<cr>
nnoremap <leader>m :Marks<cr>

nnoremap <leader>n :b#<cr>
nnoremap \ :b#<cr>
nnoremap <leader>s :sp<cr>
nnoremap <leader>v :vsp<cr>
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
nnoremap <leader>H :vsp<cr><c-w>h
nnoremap <leader>J :sp<cr>
nnoremap <leader>K :sp<cr><c-w>k
nnoremap <leader>L :vsp<cr>
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

" swapped smooth-scroll for comfortable-motion
"―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― 
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 1)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 1)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

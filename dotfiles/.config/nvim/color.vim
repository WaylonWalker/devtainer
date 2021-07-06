"            _                  _           
"   ___ ___ | | ___  _ ____   _(_)_ __ ___  
"  / __/ _ \| |/ _ \| '__\ \ / / | '_ ` _ \ 
" | (_| (_) | | (_) | | _ \ V /| | | | | | |
"  \___\___/|_|\___/|_|(_) \_/ |_|_| |_| |_|
"                                           

set termguicolors

set background=dark

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif


" highlight Normal ctermbg=NONE
" highlight Normal guibg=NONE ctermbg=NONE
" highlight CursorLineNr ctermbg=NONE guibg=NONE 
" highlight SignColumn ctermbg=3
" highlight SignColumn ctermbg=NONE guibg=NONE 

function! s:NoBg()
    highlight Normal guibg=None ctermbg=NONE
    highlight CursorLineNr ctermbg=NONE guibg=NONE 
    highlight SignColumn ctermbg=NONE guibg=NONE 
endfunction

:command! NoBg :call s:NoBg()
nnoremap <silent> <leader>\ :highlight LineNr ctermfg=8 ctermbg=black<cr> :highlight CursorLineNr ctermfg=red<cr> :highlight Visual ctermbg=8<cr>
nnoremap <silent> <leader><cr> :NoBg<cr>:noh<cr>

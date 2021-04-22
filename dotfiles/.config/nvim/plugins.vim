
call plug#begin('~/.local/share/nvim/plugged')
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'TaDaa/vimade'
" Plug 'VundleVim/Vundle.vim'
" Plug 'bling/vim-airl1ne'
" Plug 'captbaritone/repo-vimrc'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'davidhalter/jedi-vim'
" Plug 'dbext.vim'
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'digitaltoad/vim-pug'
" Plug 'djoshea/vim-autoread'
" Plug 'flazz/vim-colorschemes'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'jlanzarotta/bufexplorer'
" Plug 'joshdick/onedark.vim'
" Plug 'josudoey/vim-eslint-fix'
" Plug 'lambdalisue/fern.vim'
" Plug 'majutsushi/tagbar'
" Plug 'maksimr/vim-jsbeautify'
" Plug 'malithsen/trello-vim'
" Plug 'maralla/completor.vim'
" Plug 'mattn/emmet-vim', {'for': 'html'}
" Plug 'mhinz/vim-grepper'
" Plug 'mhinz/vim-startify'
" Plug 'michalliu/sourcebeautify.vim'
" Plug 'mileszs/ack.vim'
" Plug 'mxw/vim-jsx', {'for': 'javascript'}
" Plug 'othree/html5.vim', {'for': 'html'}
" Plug 'pangloss/vim-javascript', {'for': 'javascript'}
" Plug 'plasticboy/vim-markdown'
" Plug 'powerline/powerline'
" Plug 'prettier/vim-prettier'
" Plug 'rking/ag.vim'
" Plug 'ryanoasis/vim-devicons'
" Plug 'ryanoasis/vim-devicons'
" Plug 'shime/livedown'
" Plug 'skywind3000/asyncrun.vim'
" Plug 'styled-components/vim-styled-components'
" Plug 'suan/vim-instant-markdown'
" Plug 'tpope/vim-dadbod'
" Plug 'tpope/vim-markdown'
" Plug 'tpope/vim-vinegar'
" Plug 'valloric/youcompleteme', {'do': './install.py'}
" Plug 'vim-ctrlspace/vim-ctrlspace'
" Plug 'vim-scripts/AutoComplPop'
" Plug 'vwxyutarooo/nerdtree-devicons-syntax'
" Plug 'yuttie/comfortable-motion.vim'
Plug 'SirVer/ultisnips'
" Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-signify'
Plug 'ambv/black'
Plug 'amix/vim-zenroom2'
Plug 'easymotion/vim-easymotion'
Plug 'epilande/vim-es2015-snippets', {'for': 'javascript'}
Plug 'epilande/vim-react-snippets', {'for': 'javascript'}
Plug 'honza/vim-snippets'
" Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': 'yes \| ./install'  }
Plug 'junegunn/fzf.vim'
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
Plug 'justinmk/vim-sneak'
" Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'michaeljsmith/vim-indent-object'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rakr/vim-one'
Plug 'scrooloose/nerdtree'
" Plug 'scrooloose/syntastic' 
Plug 'sheerun/vim-polyglot'
" Plug 'terryma/vim-smooth-scroll'
Plug 'thinca/vim-visualstar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
" Plug 'valloric/matchtagalways'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-quicklink'
" Plug 'kana/vim-fakeclip'
Plug 'voldikss/vim-floaterm'
" Plug 'zxqfl/tabnine-vim'
" Plug 'wfxr/minimap.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'
Plug 'smitajit/bufutils.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'gruvbox-community/gruvbox'
" Plug 'joshdick/onedark.vim'
Plug 'fabi1cazenave/termopen.vim'
Plug 'ThePrimeagen/harpoon'
Plug 'sainnhe/sonokai'
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'code-biscuits/nvim-biscuits'
Plug 'hoob3rt/lualine.nvim'
" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'ryanoasis/vim-devicons'
" Plug 'romainl/vim-qf'
" Plug 'nvie/vim-flake8'
" Plug 'flebel/vim-mypy', { 'for': 'python', 'branch': 'bugfix/fast_parser_is_default_and_only_parser' }
Plug 'jeetsukumaran/vim-pythonsense'
" Plug 'TimUntersberger/neogit'
Plug 'hkupty/iron.nvim'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'Th3Whit3Wolf/onebuddy'
call plug#end()



let g:coc_global_extensions = [
    \'coc-marketplace',
    \'coc-fzf-preview',
    \'coc-tsserver',
    \'coc-markdownlint',
    \'coc-highlight',
    \'coc-python',
    \'coc-explorer',
    \'coc-json', 
    \'coc-git',
    \'coc-snippets'
    \]
    " \'coc-pyright',
    " \'coc-tabnine',

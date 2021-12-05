call plug#begin('~/.local/share/nvim/plugged')


Plug 'AndrewRadev/diffurcate.vim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'andersevenrud/compe-tmux', { 'branch': 'cmp' }

Plug 'waylonwalker/Telegraph.nvim'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

Plug 'waylonwalker/Telegraph.nvim'
Plug 'ThePrimeagen/vim-be-good'
" Plug 'ThePrimeagen/refactoring.nvim'

Plug 'jbyuki/instant.nvim'
Plug 'windwp/nvim-spectre'

" color
Plug 'Th3Whit3Wolf/onebuddy'
Plug 'hoob3rt/lualine.nvim'
Plug 'mhinz/vim-signify'
" Plug 'sainnhe/sonokai'
" Plug 'sheerun/vim-polyglot'
Plug 'tjdevries/colorbuddy.nvim'

" formatter
Plug 'ambv/black'

" navigation
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'christoomey/vim-quicklink'
Plug 'christoomey/vim-tmux-runner'
Plug 'fabi1cazenave/termopen.vim'
Plug 'junegunn/fzf', { 'do': 'yes \| ./install'  }
Plug 'junegunn/fzf.vim'

Plug 'justinmk/vim-sneak'
Plug 'mbbill/undotree'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'smitajit/bufutils.vim'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'

Plug 'lewis6991/gitsigns.nvim'
" objects
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'thinca/vim-visualstar'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-commentary'

" lsp
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
" Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
Plug 'kabouzeid/nvim-lspinstall'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'ray-x/lsp_signature.nvim'


" Plug 'ray-x/lsp_signature.nvim'
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'

Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
Plug 'eddyekofo94/gruvbox-flat.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'mfussenegger/nvim-dap-python'

Plug 'hrsh7th/vim-vsnip/'
" Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'ckipp01/stylua-nvim'

call plug#end()

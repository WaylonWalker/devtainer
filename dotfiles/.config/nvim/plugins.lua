require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lualine'.setup{
    options = {
        theme='onedark',
    section_separators = {'', ''},
    component_separators = {'|', '|'},
    sections = {
    -- lualine_a = {'mode'},
    -- lualine_b = {'branch'},
    -- lualine_c = {'filename'},
    -- lualine_x = {'encoding', 'fileformat', 'filetype'},
    -- lualine_y = {'progress'},
    -- lualine_z = {'location'}
    },
    inactive_sections = {
    -- lualine_a = {},
    -- lualine_b = {},
    -- lualine_c = {'filename'},
    -- lualine_x = {'location'},
    -- lualine_y = {},
    -- lualine_z = {}
    }
    }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "python",
    "regex",
    "lua",
    "javascript",
    "bash",
    "toml",
    "rst",
    "html",
    "json",
    "yaml"
  } -- one of "all", "maintained" (parsers with maintainers), or a list of languages
}

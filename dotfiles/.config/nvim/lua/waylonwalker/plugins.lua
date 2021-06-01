nvim_lsp = require('lspconfig')
-- toggler = require'toggler'
-- telescope = require'telescope.builtin'
-- telescope = require'telescope.actions'
-- require'lspconfig'.pyright.setup{}
-- require'navigator'.setup()
--
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities,
}

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

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    snippets = true;
  };
}

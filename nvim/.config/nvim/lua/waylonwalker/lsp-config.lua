-- SETUP
local navic = require("nvim-navic")

local function on_attach(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end
local M = {}

-- Active LSP's

require'lspconfig'.pylsp.setup{
        enable = true,
        settings = {
            pylsp = {
                configurationSources = {"flake8"},
                plugins = {
                    pycodestyle = {enabled = false},
                    flake8 = {enabled = true},
                    mypy = {
                        enabled = true,
                        live_mode =true,
                        strict = true
                    },
                    jedi_completion = {fuzzy = true},
                    jedi_completion = {fuzzy = true, enabled=true},
                    jedi_hover = {enabled = true},
                    jedi_references = {enabled = true},
                    jedi_signature_help = {enabled = true},
                    jedi_symbols = {enabled = true, all_scopes = true},
                }
            }
        },
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }


require'lspconfig'.sumneko_lua.setup{on_attach=on_attach}
require'lspconfig'.jedi_language_server.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'lspconfig'.cssls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require'lspconfig'.bashls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require('telescope').load_extension('dap')

require('dap-python').setup('~/miniconda3/envs/markata/bin/python')

require'lspconfig'.yamlls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"]= "conf/**/*catalog*",
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
            }
        }
    }
}

-- Disabled LSP's

-- require'lspconfig.configs'.kedro = {
--     default_config = {
--         cmd = {"kedro-lsp"};
--         filetypes = {"python", 'yaml'};
--         root_dir = function(fname)
--             return vim.fn.getcwd()
--         end;
--     };
-- };


-- require'lspconfig'.kedro.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }

-- require'lspconfig'.html.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- }
-- require'lspconfig'.cssls.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- }

local remote = io.popen('git config --get remote.origin.url'):read():gsub('https://github.com/', 'gh:'):gsub('.git', '') or ''
-- %F gave full path, vim.fn.expand gets rid of cwd
vim.o.winbar = " %{%v:lua.vim.fn.expand('%F')%}  %{%v:lua.require'nvim-navic'.get_location()%} %= " .. remote

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
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    }



require'lspconfig'.sumneko_lua.setup{on_attach=on_attach}

require'lspconfig'.jedi_language_server.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require'lspconfig'.cssls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require'lspconfig'.bashls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require('telescope').load_extension('dap')

require('dap-python').setup('~/miniconda3/envs/markata/bin/python')

require'lspconfig'.yamlls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }

-- require'lspconfig'.html.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- }
-- require'lspconfig'.cssls.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- }
--

-- require 'lspconfig.configs'.kedro = {
--     default_config = {
--         cmd = {"kedro-lsp"};
--         filetypes = {"python"};
--         root_dir = function(fname)
--             return vim.fn.getcwd()
--         end;
--     };
-- };

-- local has_kedro = os.execute('command -v kedro-lsp')

-- if (has_kedro == 256 )
-- then
-- require'lspconfig'.kedro.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }
-- else
--     -- does not have kedro lsp
--     if ( io.popen('pip show kedro'):read('*a'):match('Name: kedro') ~= nil)
--     then
--         print('kedro is installed without the lsp')
--     else
--         -- kedro is not installed
--         -- no need for kedro_lsp
--     end
-- end


-- require 'lspconfig.configs'.markata = {
--     default_config = {
--         cmd = {"markata-lsp"};
--         filetypes = {"markdown"};
--         root_dir = function(fname)
--             return vim.fn.getcwd()
--         end;
--     };
-- };

-- require'lspconfig'.markata.setup{
--     on_attach=on_attach,
--     capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }

return M


-- require'lspconfig'.pyright.setup{}
local function on_attach() end
local M = {}

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
                    -- jedi_completion = {fuzzy = true},
                    -- jedi_completion = {fuzzy = true, enabled=true},
                    -- jedi_hover = {enabled = true},
                    -- jedi_references = {enabled = true},
                    -- jedi_signature_help = {enabled = true},
                    -- jedi_symbols = {enabled = true, all_scopes = true},
                }
            }
        },
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
local configs = require 'lspconfig/configs'

local has_kedro = os.execute('command -v kedro-lsp')

configs.kedro = {
    default_config = {
        cmd = {"kedro-lsp"};
        filetypes = {"python"};
        root_dir = function(fname)
            return vim.fn.getcwd()
        end;
    };
};

function M.install_kedro(lang)

  local lang = 'kedro'

  local function onExit(_, code)
    if code ~= 0 then
      error("Could not install language server for " .. lang)
    end
    vim.notify("Successfully installed language server for " .. lang)
  end

  vim.cmd("new")
  local shell = vim.o.shell
  vim.o.shell = "/usr/bin/env bash"
  vim.fn.termopen("set -e\n" .. "pip install kedro-lsp", { cwd = path, on_exit = onExit })
  vim.o.shell = shell
  vim.cmd("startinsert")
end

if (has_kedro == 256 )
then
    require'lspconfig'.kedro.setup{
        on_attach=on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
else
    -- does not have kedro lsp
    if ( io.popen('pip show kedro'):read('*a'):match('Name: kedro') ~= nil)
    then
        print('kedro is installed without the lsp')
        vim.cmd("command! KedroLspInstall lua require 'waylonwalker.lsp-config'.install_kedro()")
    else
        -- kedro is not installed
        -- no need for kedro_lsp
    end
end

require'lspconfig'.sumneko_lua.setup{on_attach=on_attach}
require'lspconfig'.jedi_language_server.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'lspconfig'.cssls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'lspconfig'.yamlls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'lspconfig'.bashls.setup{
    on_attach=on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require('telescope').load_extension('dap')
require('dap-python').setup('~/miniconda3/envs/markata/bin/python')
-- require "lsp_signature".setup()
-- require('trouble').setup{}
-- require('navigator').setup({
--  pyls={filetype={}}
-- })

return M

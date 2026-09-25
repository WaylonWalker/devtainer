-- YAML filetype plugin
-- Ensure LSP starts for YAML files
local yamlls_path = "/home/waylon/.local/share/nvim/mason/packages/yaml-language-server/node_modules/.bin/yaml-language-server"

if vim.fn.filereadable(yamlls_path) == 1 then
  vim.lsp.start({
    name = "yamlls-ftplugin",
    cmd = {yamlls_path, "--stdio"},
    root_dir = vim.fn.getcwd(),
    filetypes = {"yaml", "yml"},
    settings = {
      yaml = {
        schemas = {
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.4-standalone-strict/all.json"] = "/home/waylon/git/homelab-argo/**/*.yaml",
        },
        validate = true,
        completion = true,
        hover = true,
      }
    }
  })
end
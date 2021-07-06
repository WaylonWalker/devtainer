-- require'lspconfig'.pyright.setup{}
local function on_attach()
end
-- require'lspconfig'.pyls.setup(on_attach=on_attach)
require'lspconfig'.pyright.setup(on_attach=on_attach)
require'lspconfig'.cssls.setup(on_attach=on_attach)
require'lspconfig'.yamlls.setup(on_attach=on_attach)

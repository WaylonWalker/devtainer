-- lua/plugins/lsp/init.lua (or similar)
local servers = {
	"ruff",
	-- "ty",
	"ts_ls",
	"lua_ls",
	"jsonls",
	"yamlls",
}

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
})

local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

for _, server in ipairs(servers) do
	lspconfig[server].setup({
		on_attach = function(client, bufnr)
			-- map keys, format on save, etc.
		end,
		capabilities = capabilities,
	})
end

vim.lsp.config("ty", {
	init_options = {
		settings = {
			-- ty language server settings go here
		},
	},
})

-- Required: Enable the language server
vim.lsp.enable("ty")

-- vim.fn.sign_define("LspCodeActionSign", { text = "", texthl = "" })

-- lua/plugins/lsp/init.lua (or similar)
local servers = {
	-- "ty",
	-- "ruff",
	"ts_ls",
	"lua_ls",
	"jsonls",
	"yamlls",
}

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
})

-- NO MORE: local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function on_attach(client, bufnr)
	-- map keys, format on save, etc.
	-- example:
	-- local opts = { buffer = bufnr, silent = true }
	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
end

for _, server in ipairs(servers) do
	-- define the config for this server
	vim.lsp.config(server, {
		on_attach = on_attach,
		capabilities = capabilities,
		-- you can add per-server settings here if you want:
		-- settings = { ... },
	})

	-- enable it
	vim.lsp.enable(server)
end

-- ty server already using the new API – this is fine as-is
vim.lsp.config("ty", {
	init_options = {
		settings = {
			-- ty language server settings go here
		},
	},
})

vim.lsp.enable("ty")

-- vim.fn.sign_define("LspCodeActionSign", { text = "", texthl = "" })
-- (rest of your diagnostic config / keymaps can stay the same)

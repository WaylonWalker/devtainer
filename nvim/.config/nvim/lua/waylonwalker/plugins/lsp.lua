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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function on_attach(client, bufnr)
	print("LSP client " .. client.name .. " attached to buffer " .. bufnr)
	local opts = { buffer = bufnr, silent = true }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
end

for _, server in ipairs(servers) do
	local config = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	-- Special configuration for yaml language server
	if server == "yamlls" then
		config.settings = {
			yaml = {
				schemas = {
					-- Target only your homelab-argo manifests with proper Kubernetes schema
					["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.4-standalone-strict/all.json"] = "/home/waylon/git/homelab-argo/**/*.yaml",
					-- Other common schemas
					["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.yml",
					["https://json.schemastore.org/docker-compose"] = "docker-compose*.yml",
				},
				validate = true,
				completion = true,
				hover = true,
			}
		}
		-- Add filetypes for yamlls
		config.filetypes = {"yaml", "yml"}
	end

	-- Setup the server using the new Neovim LSP API
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end

-- vim.fn.sign_define("LspCodeActionSign", { text = "", texthl = "" })
-- (rest of your diagnostic config / keymaps can stay the same)

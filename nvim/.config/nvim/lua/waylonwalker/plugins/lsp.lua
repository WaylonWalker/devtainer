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

local function notify_lines(title, lines, level)
	vim.notify(table.concat(lines, "\n"), level or vim.log.levels.INFO, { title = title })
end

vim.api.nvim_create_user_command("LspClients", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if vim.tbl_isempty(clients) then
		return notify_lines("LSP Clients", { "No LSP clients attached to the current buffer." }, vim.log.levels.WARN)
	end

	local lines = { "Attached LSP clients:" }
	for _, client in ipairs(clients) do
		table.insert(lines, string.format("- %s (id=%d)", client.name, client.id))
	end

	notify_lines("LSP Clients", lines)
end, { desc = "Show LSP clients attached to the current buffer" })

vim.api.nvim_create_user_command("MarkataLspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = "markata" })
	local lines = {
		"filetype: " .. vim.bo.filetype,
		"cwd: " .. vim.fn.getcwd(),
	}

	if vim.tbl_isempty(clients) then
		table.insert(lines, "markata: not attached")
		return notify_lines("Markata LSP", lines, vim.log.levels.WARN)
	end

	for _, client in ipairs(clients) do
		table.insert(lines, "markata: attached")
		table.insert(lines, string.format("id: %d", client.id))
		table.insert(lines, "root: " .. (client.config.root_dir or "nil"))
		table.insert(lines, "cmd: " .. table.concat(client.config.cmd or {}, " "))
	end

	notify_lines("Markata LSP", lines)
end, { desc = "Show markata LSP status for the current buffer" })

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
					["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.4-standalone-strict/all.json"] =
					"/home/waylon/git/homelab-argo/**/*.yaml",
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
		config.filetypes = { "yaml", "yml" }
	end

	-- Setup the server using the new Neovim LSP API
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end

require('waylonwalker.plugins.markata-lsp').setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
-- vim.fn.sign_define("LspCodeActionSign", { text = "", texthl = "" })
-- (rest of your diagnostic config / keymaps can stay the same)

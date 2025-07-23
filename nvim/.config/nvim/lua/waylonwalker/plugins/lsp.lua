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

local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

for _, server in ipairs(servers) do
	if not lspconfig[server].manager then
		lspconfig[server].setup({
			on_attach = function(client, bufnr)
				-- map keys, format on save, etc.
			end,
			capabilities = capabilities,
		})
	end
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
--
-- Display diagnostics at end of line using virtual lines (Neovim 0.10+)
-- if vim.diagnostic.config then
-- 	vim.diagnostic.config({
-- 		virtual_text = false,
-- 		virtual_lines = {
-- 			only_current_line = false,
-- 			highlight_whole_line = false,
-- 		},
-- 		signs = true,
-- 		underline = true,
-- 		update_in_insert = false,
-- 		severity_sort = true,
-- 	})
--
-- 	-- Toggle inline diagnostics with <leader>ld
-- 	vim.keymap.set("n", "<leader>ld", function()
-- 		local current = vim.diagnostic.config().virtual_lines
-- 		vim.diagnostic.config({ virtual_lines = not current })
-- 	end, { desc = "Toggle virtual line diagnostics" })
-- end

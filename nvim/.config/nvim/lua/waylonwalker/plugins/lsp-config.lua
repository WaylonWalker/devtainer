local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local FORMATTING = methods.internal.FORMATTING
local h = require("null-ls.helpers")
local settings = require("waylonwalker.settings")
local lsp = require("lsp-zero")
-- lsp.extend_lspconfig()
-- -- -- [[ Configure LSP ]]
-- --  This function gets run when an LSP connects to a particular buffer.
--
-- require("conform").setup({
-- 	formatters_by_ft = {
-- 		lua = { "stylua" },
-- 		-- Conform will run multiple formatters sequentially
-- 		-- python = { "ruff", },
-- 		html = { "djlint", "djhtml" },
-- 		python = function(bufnr)
-- 			if require("conform").get_formatter_info("ruff_format", bufnr).available then
-- 				return { "ruff_fix", "ruff_format" }
-- 			else
-- 				return { "isort", "black" }
-- 			end
-- 		end,
-- 		-- Use a sub-list to run only the first available formatter
-- 		javascript = { { "prettierd", "prettier" } },
-- 	},
-- })

-- vim.api.nvim_create_user_command("Format", function(_)
-- 	require("fidget").notify("Formatting with conform...")
-- 	require("conform").format()
-- end, { desc = "Format current buffer with conform" })

-- vim.api.nvim_create_user_command("FormatToggle", function(_)
-- 	settings.auto_format = not settings.auto_format
-- 	require("fidget").notify("Auto format is now " .. (settings.auto_format and "on" or "off"))
-- end, { desc = "Format current buffer with conform" })

local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", function()
		vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
	end, "[C]ode [A]ction")

	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- document existing key chains
-- require("which-key").register({
--     ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
--     ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
--     ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
--     ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
--     ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
--     ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
--     ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
--     ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
-- })
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
-- require("which-key").register({
--     ["<leader>"] = { name = "VISUAL <leader>" },
--     ["<leader>h"] = { "Git [H]unk" },
-- }, { mode = "v" })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	tsserver = {},
	html = { filetypes = { "html", "twig", "hbs" } },
	ruff_lsp = { filetypes = { "py", "python" } },
	pylsp = { filetypes = { "py", "python" } },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

null_ls.builtins.formatting.tidy_import = h.make_builtin({
	name = "tidy_import",
	meta = {
		url = "https://github.com/deshaw/pyflyby",
		description = "automatic imports for python",
	},
	method = FORMATTING,
	filetypes = { "python" },
	generator_opts = {
		command = "tidy-imports",
		args = {
			"--black",
			"--quiet",
			"--replace-star-imports",
			"--add-missing",
			"--replace",
			"--remove-unused",
			"$FILENAME",
		},
		to_stdin = false,
		to_temp_file = true,
	},
	factory = h.formatter_factory,
})
null_ls.builtins.formatting.djhtml = h.make_builtin({
	name = "djhtml",
	meta = {
		url = "https://github.com/rtts/djhtml",
		description = "",
	},
	method = FORMATTING,
	filetypes = { "html", "htmldjango" },
	generator_opts = {
		command = "djhtml",
		args = {
			"$FILENAME",
		},
		to_stdin = false,
		to_temp_file = true,
	},
	factory = h.formatter_factory,
})

null_ls.builtins.formatting.rustywind = h.make_builtin({
	name = "rustywind",
	meta = {
		url = "",
		description = "",
	},
	method = FORMATTING,
	filetypes = { "html", "htmldjango" },
	generator_opts = {
		command = "rustywind",
		args = {
			"--write",
			"$FILENAME",
		},
		to_stdin = false,
		to_temp_file = true,
	},
	factory = h.formatter_factory,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		-- -- formatting
		-- null_ls.builtins.formatting.beautysh,
		-- null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
		null_ls.builtins.formatting.isort,
		-- null_ls.builtins.formatting.json_tool,
		-- null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.markdownlint,
		-- null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.djhtml,
		null_ls.builtins.formatting.rustywind,
		null_ls.builtins.formatting.sqlformat,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.tidy_import,
		-- null_ls.builtins.formatting.trim_newlines,
		-- null_ls.builtins.formatting.trim_whitespace,
		null_ls.builtins.formatting.yamlfmt,
		-- null_ls.builtins.formatting.ruff,
		-- null_ls.builtins.formatting.ruff_format,

		-- diagnostics
		-- null_ls.builtins.diagnostics.alex,
		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.markdownlint,
		-- null_ls.builtins.diagnostics.proselint,
		-- null_ls.builtins.diagnostics.pydocstyle,
		-- null_ls.builtins.diagnostics.vale,

		-- completions
		null_ls.builtins.completion.spell,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "!*.jinja" },
				-- group = M.waylonwalker_augroup,
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- vim.lsp.buf.format({ bufnr = bufnr })
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_sources = {
	{ name = "luasnip" },
	{ name = "nvim_lsp" },
	{ name = "nvim_lsp_signature_help" },
	{ name = "nvim_lua" },
	{ name = "treesitter" },
	{ name = "buffer" },
	{ name = "path" },
	{ name = "tmux" },
	{ name = "spell" },
}

local lspkind = require("lspkind")
local cmp_formatting = {
	format = lspkind.cmp_format({
		mode = "symbol", -- show only symbol annotations
		maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
		ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
	}),
}
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
	["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
	["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
	["<C-d>"] = cmp.mapping.scroll_docs(4), -- yes 4 is down
	["<C-f>"] = cmp.mapping.scroll_docs(-4), --yes -4 is up
	["<C-e>"] = cmp.mapping.close(),
	["<CR>"] = cmp.mapping.confirm({
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	}),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

cmp.setup({
	snippet = {
		expand = function(args)
			-- For `luasnip` user.
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
	},
})

--- CREDIT THEPRIMEAGEN -> PYPEADAY
local nnoremap = require("waylonwalker.keymap").nnoremap

lsp.preset("recommended")

cmp.setup({
	sources = cmp_sources,
})
-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings,
-- 	sources = cmp_sources,
-- 	formatting = cmp_formatting,
-- })

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "",
		warn = "",
		-- hint = "",
		info = "",
	},
})

local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local FORMATTING = methods.internal.FORMATTING
local h = require("null-ls.helpers")
local settings = require("waylonwalker.settings")

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

null_ls.builtins.formatting.ruff_check = h.make_builtin({
	name = "ruff_check",
	meta = {
		url = "https://github.com/astral-sh/ruff",
		description = "ruff --check for python",
	},
	method = FORMATTING,
	filetypes = { "python" },
	generator_opts = {
		command = "ruff",
		args = {
			"check",
			"--fix",
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
		null_ls.builtins.formatting.shfmt,
		-- null_ls.builtins.formatting.beautysh,
		-- null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
		-- null_ls.builtins.formatting.isort,
		-- null_ls.builtins.formatting.json_tool,
		-- null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.markdownlint,
		-- null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.djhtml,
		-- null_ls.builtins.formatting.rustywind,
		null_ls.builtins.formatting.sqlformat,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.tidy_import,
		null_ls.builtins.formatting.ruff_check,
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
				-- buffer = bufnr,
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
	automatic_setup = true,
})

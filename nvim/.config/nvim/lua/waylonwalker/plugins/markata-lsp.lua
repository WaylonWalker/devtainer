-- markata-go LSP configuration
-- Provides wikilink and @mention autocomplete, diagnostics, hover, and go-to-definition
-- for markata-go static site projects

local M = {}

M.setup = function()
	-- Register with vim.lsp.config (Neovim 0.11+)
	vim.lsp.config("markata", {
		cmd = { "markata-go", "lsp" },
		filetypes = { "markdown" },
		root_markers = { "markata-go.toml", "markata.toml" },
		handlers = {
			["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
				-- Filter out nil diagnostics which cause crashes in Neovim 0.11+
				if result and result.diagnostics then
					result.diagnostics = vim.tbl_filter(function(diagnostic)
						return diagnostic ~= nil
					end, result.diagnostics)
				elseif result then
					-- If diagnostics is nil, set to empty table to prevent crash
					result.diagnostics = result.diagnostics or {}
				end
				return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
			end,
		},
	})

	-- Enable the LSP - this handles auto-starting for matching filetypes/roots
	vim.lsp.enable("markata")
end

return M

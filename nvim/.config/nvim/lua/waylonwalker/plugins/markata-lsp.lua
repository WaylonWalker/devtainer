local M = {}

M.setup = function()
	vim.lsp.config('markata', {
		cmd = { 'markata-go', 'lsp' },
		filetypes = { 'markdown' },
		root_markers = { 'markta-go.toml', 'markata.toml' },
	})

	vim.lsp.enable('markata')
end

return M

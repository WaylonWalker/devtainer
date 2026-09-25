local M = {}

M.setup = function(opts)
	local config = vim.tbl_extend('force', opts or {}, {
		cmd = { 'markata-go', 'lsp' },
		filetypes = { 'markdown' },
		root_markers = { 'markata-go.toml', 'markata.toml' },
	})

	vim.lsp.config('markata', config)

	vim.lsp.enable('markata')
end

return M

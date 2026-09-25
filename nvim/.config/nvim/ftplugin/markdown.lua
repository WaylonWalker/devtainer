-- Work around a Neovim 0.12 Tree-sitter Markdown highlighter crash.
vim.schedule(function()
	pcall(vim.treesitter.stop, vim.api.nvim_get_current_buf())
end)

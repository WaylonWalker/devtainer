local settings = require("waylonwalker.settings")
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local M = {}

M.waylonwalker_augroup = augroup("waylonwalker", { clear = true })

M.sync_packer = function()
	print("syncing")
	vim.cmd("runtime lua/waylonwalker/packer.lua")
	require("packer").sync()
end

M.sync_lazy = function()
	print("syncing")
	require("lazy").sync()
end

-- automatically run PackerSync on save of plugins.lua
if settings.packer_auto_sync then
	-- source plugins.lua and run PackerSync on save
	autocmd({ "BufWritePost" }, {
		group = M.waylonwalker_augroup,
		pattern = { "packer.lua" },
		callback = M.sync_packer,
	})
end

-- automatically run PackerSync on save of plugins.lua
if settings.lazy_auto_sync then
	-- source plugins.lua and run PackerSync on save
	autocmd({ "BufWritePost" }, {
		group = M.waylonwalker_augroup,
		pattern = { "lazy.lua" },
		callback = M.sync_lazy,
	})
end

M.pre_commit = function()
	vim.api.nvim_command("PreCommit")
end

if settings.pre_commit then
	-- source plugins.lua and run PackerSync on save
	autocmd({ "BufWritePost" }, {
		group = M.waylonwalker_augroup,
		pattern = { "*.py" },
		callback = M.pre_commit,
	})
end

autocmd("BufWritePre", {
	group = M.waylonwalker_augroup,
	pattern = "*",
	callback = function(args)
		if settings.auto_format == false then
			return
		end
		-- require("conform").format({ bufnr = args.buf })
		vim.lsp.buf.format({ bufnr = args.buf })
	end,
})

return M

local modules = {
	cmp = "waylonwalker.plugins.cmp",
	fugitive = "waylonwalker.plugins.fugitive",
	null_ls = "waylonwalker.plugins.null-ls",
	autoformat = "waylonwalker.plugins.autoformat",
	lualine = "waylonwalker.plugins.lualine",
	image = "waylonwalker.plugins.image",
	treesitter = "waylonwalker.plugins.treesitter",
	alpha_nvim = "waylonwalker.plugins.alpha-nvim",
	navbuddy = "waylonwalker.plugins.navbuddy",
}

return setmetatable({}, {
	__index = function(t, key)
		local module = modules[key]
		if not module then
			return nil
		end

		local value = require(module)
		rawset(t, key, value)
		return value
	end,
})

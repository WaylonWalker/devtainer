local modules = {
	cmp = "waylonwalker.plugins.cmp",
	fugitive = "waylonwalker.plugins.fugitive",
	autoformat = "waylonwalker.plugins.autoformat",
	lualine = "waylonwalker.plugins.lualine",
	treesitter = "waylonwalker.plugins.treesitter",
	alpha_nvim = "waylonwalker.plugins.alpha-nvim",
	navbuddy = "waylonwalker.plugins.navbuddy",
	mini_ai = "waylonwalker.plugins.mini-ai",
}

return setmetatable({}, {
	__index = function(self, key)
		local module = modules[key]
		if not module then
			return nil
		end

		local value = require(module)
		rawset(self, key, value)
		return value
	end,
})

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		client.focus = c
		c:raise()
	end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			-- focus = true,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	{ rule = { name = "Microsoft Teams" }, properties = { tag = "6", floating = false, switchtotag = true } },

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
			},
			class = {
				"Arandr",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer",
			},

			name = {
				"Event Tester", -- xev.
				"YAD",
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	-- { rule_any = {type = { "normal", "dialog" }
	--   }, properties = { titlebars_enabled = true }
	-- },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

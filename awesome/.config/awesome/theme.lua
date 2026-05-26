local beautiful = require("beautiful")
local awful = require("awful")

beautiful.useless_gap = 4
beautiful.border_width = 2
beautiful.font = "Ubuntu 16"
beautiful.notification_bg = '#160e28'
beautiful.notification_fg = '#d8d4e8'
beautiful.notification_border_color = '#3a2f5c'
beautiful.notification_border_width = 1

local naughty = require("naughty")
naughty.config.presets.normal.bg       = '#0d0818'
naughty.config.presets.normal.fg       = '#8a84a0'
naughty.config.presets.normal.border_color = '#241b3d'
naughty.config.presets.normal.opacity  = 0.75
naughty.config.presets.low.bg          = '#0a0614'
naughty.config.presets.low.fg          = '#6b6585'
naughty.config.presets.low.border_color = '#1a1330'
naughty.config.presets.low.opacity     = 0.65
naughty.config.presets.critical.bg     = '#3a1420'
naughty.config.presets.critical.fg     = '#f0d0d8'
naughty.config.presets.critical.border_color = '#8a4a5a'
naughty.config.presets.critical.timeout = 15
naughty.config.defaults.timeout = 8

-- Demote Chrome's "critical" notifications (Teams, Slack web, etc.) to normal.
naughty.config.notify_callback = function(args)
	local app = tostring(args.appname or ""):lower()
	if app:find("chrome") or app:find("chromium") or app:find("google%-chrome") then
		args.preset = naughty.config.presets.normal
		args.timeout = args.timeout and args.timeout > 0 and math.min(args.timeout, 8) or 8
	end
	return args
end

awful.layout.layouts = {
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

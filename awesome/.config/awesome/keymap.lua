local gears = require("gears")
local awful = require("awful")
local xrandr = require("xrandr")

local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup").widget

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- mostly default
globalkeys = gears.table.join(
	-- awful.key({ modkey }, "s", hotkeys_popup.show_help, {
	--  description = "show help",
	--  group = "awesome",
	-- }),
	--

	awful.key({ modkey }, "Left", awful.tag.viewprev, {
		description = "view previous",
		group = "tag",
	}),

	awful.key({ modkey }, "Right", awful.tag.viewnext, {
		description = "view next",
		group = "tag",
	}),

	awful.key({ modkey }, "Escape", awful.tag.history.restore, {
		description = "go back",
		group = "tag",
	}),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, {
		description = "focus next by index",
		group = "client",
	}),

	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, {
		description = "focus previous by index",
		group = "client",
	}),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, {
		description = "swap with next client by index",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, {
		description = "swap with previous client by index",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, {
		description = "focus the next screen",
		group = "screen",
	}),

	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, {
		description = "focus the previous screen",
		group = "screen",
	}),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto, {
		description = "jump to urgent client",
		group = "client",
	}),

	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, {
		description = "go back",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "r", awesome.restart, {
		description = "reload awesome",
		group = "awesome",
	}),

	awful.key({ modkey, "Shift" }, "q", awesome.quit, {
		description = "quit awesome",
		group = "awesome",
	}),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, {
		description = "increase master width factor",
		group = "layout",
	}),

	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, {
		description = "decrease master width factor",
		group = "layout",
	}),

	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, {
		description = "increase the number of master clients",
		group = "layout",
	}),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, {
		description = "decrease the number of master clients",
		group = "layout",
	}),

	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, {
		description = "increase the number of columns",
		group = "layout",
	}),

	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, {
		description = "decrease the number of columns",
		group = "layout",
	}),

	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
		os.execute("echo " .. awful.layout.getname() .. " > ~/.config/awesome/layout.txt")
	end, {
		description = "select next",
		group = "layout",
	}),

	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
		os.execute("echo " .. awful.layout.getname() .. " > ~/.config/awesome/layout.txt")
	end, {
		description = "select previous",
		group = "layout",
	}),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end, {
		description = "restore minimized",
		group = "client",
	}),

	awful.key({ modkey }, "x", function()
		poppin.pop("terminal", "kitty -e htop", "top", { width = 1000, height = 300 })
	end, {
		description = "lua execute prompt",
		group = "awesome",
	})
)

-- mostly defaults
clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, {
		description = "toggle fullscreen",
		group = "client",
	}),

	awful.key({ modkey }, "c", function(c)
		c:kill()
	end, {
		description = "close",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, {
		description = "toggle floating",
		group = "client",
	}),

	awful.key({ modkey }, "d", awful.client.floating.toggle, {
		description = "toggle floating",
		group = "client",
	}),

	-- awful.key({ modkey,  }, "s", function(c)
	--  c:swap(awful.client.getmaster())
	-- end, {
	--  description = "move to master",
	--  group = "client",
	-- }),

	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, {
		description = "move to screen",
		group = "client",
	}),

	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, {
		description = "toggle keep on top",
		group = "client",
	}),

	-- awful.key({ modkey }, "n", function(c)
	--  -- The client currently has the input focus, so it cannot be
	--  -- minimized, since minimized clients can't have the focus.
	--  c.minimized = true
	-- end, {
	--  description = "minimize",
	--  group = "client",
	-- }),

	-- awful.key({ modkey }, "m", function(c)
	--  c.maximized = not c.maximized
	--  c:raise()
	-- end, {
	--  description = "(un)maximize",
	--  group = "client",
	-- }),

	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, {
		description = "(un)maximize vertically",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, {
		description = "(un)maximize horizontally",
		group = "client",
	}),

	awful.key({ modkey }, "p", function()
		xrandr.xrandr()
	end, {
		description = "xrandr",
		group = "client",
	}),

	awful.key({ modkey, "Mod1" }, "p", function()
		awful.spawn("flameshot gui")
	end, {
		description = "flameshot",
		group = "client",
	}),

	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, {
		description = "flameshot",
		group = "client",
	})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
			-- os.execute("echo " .. i .. " > ~/.config/awesome/activetag.tcxt")
		end, {
			description = "view tag #" .. i,
			group = "tag",
		}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, {
			description = "toggle tag #" .. i,
			group = "tag",
		}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, {
			description = "move focused client to tag #" .. i,
			group = "tag",
		}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, {
			description = "toggle focused client on tag #" .. i,
			group = "tag",
		})
	)
end

function tag_all() end

-- resize gaps
function useless_gaps_resize(thatmuch, s, t)
	local scr = s or awful.screen.focused()
	local tag = t or scr.selected_tag
	tag.gap = tag.gap + tonumber(thatmuch)
	awful.layout.arrange(scr)
end

function useless_gaps_set_size(thatmuch, s, t)
	local scr = s or awful.screen.focused()
	local tag = t or scr.selected_tag
	tag.gap = tonumber(thatmuch)
	awful.layout.arrange(scr)
end

globalkeys = gears.table.join(
	globalkeys,
	awful.key({ modkey, "Shift" }, "i", function()
		useless_gaps_set_size(0)
	end, {
		description = "resize gaps larger",
		group = "launcher",
	}),

	awful.key({ modkey }, "i", function()
		useless_gaps_resize(2)
	end, {
		description = "resize gaps larger",
		group = "launcher",
	}),

	awful.key({ modkey, "Control" }, "i", function()
		useless_gaps_resize(-2)
	end, {
		description = "resize gaps smaller",
		group = "launcher",
	})
)

-- app launcher

globalkeys = gears.table.join(
	globalkeys,
	awful.key({ modkey }, "Return", function()
		os.execute(terminal)
	end, {
		description = "go back",
		group = "tag",
	}),
	awful.key({ modkey }, "s", function(c)
		c.sticky = not c.sticky
	end),
	-- Media Keys
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute("pactl set-sink-volume 0 +5%")
	end, {
		description = "raise volume",
		group = "media",
	}),
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute("pactl set-sink-volume 0 -5%")
	end, {
		description = "lower volume",
		group = "media",
	}),
	awful.key({}, "XF86AudioMute", function()
		os.execute("pactl set-sink-mute 0 toggle")
	end, {
		description = "mute-volume",
		group = "media",
	}),
	awful.key({}, "XF86AudioPlay", function()
		os.execute("playerctl play-pause")
	end, {
		description = "play-pause",
		group = "media",
	}),
	awful.key({}, "XF86AudioNext", function()
		os.execute("playerctl next")
	end, {
		description = "media next",
		group = "media",
	}),
	awful.key({}, "XF86AudioPrev", function()
		os.execute("playerctl previous")
	end, {
		description = "media previous",
		group = "media",
	}),

	awful.key({ modkey }, "s", function(c)
		c.sticky = not c.sticky
	end, {
		description = "make client sticky",
		group = "client",
	})
)

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		client.focus = c
		c:raise()
	end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)

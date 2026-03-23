local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local webcam_geometry_file = os.getenv("HOME") .. "/.config/awesome/webcam_geometry.txt"
local webcam_pip_border_width = 2
local webcam_pip_border_color = "#1e1e1e"

local function has_fragment(text, fragment)
	return type(text) == "string" and text:lower():find(fragment, 1, true) ~= nil
end

local function is_webcam_pip(c)
	if not c then
		return false
	end

	local class = type(c.class) == "string" and c.class:lower() or ""
	local instance = type(c.instance) == "string" and c.instance:lower() or ""
	local name = type(c.name) == "string" and c.name:lower() or ""

	return class == "webcam-pip"
		or instance == "webcam-pip"
		or name == "webcam-pip"
		or name == "webcam pip"
		or (class == "ffplay" and has_fragment(name, "webcam"))
end

local function webcam_pip_shape(cr, width, height)
	if gears.shape.squircle then
		gears.shape.squircle(cr, width, height)
		return
	end

	if gears.shape.superellipse then
		gears.shape.superellipse(cr, width, height, 2.2)
		return
	end

	gears.shape.rounded_rect(cr, width, height, math.floor(math.min(width, height) * 0.40))
end

local function disable_webcam_glow(c)
	if c.set_xproperty then
		c:set_xproperty("_COMPTON_SHADOW", 0)
		c:set_xproperty("_PICOM_SHADOW", 0)
		c:set_xproperty("_COMPTON_BLUR", 0)
		c:set_xproperty("_PICOM_BLUR", 0)
	end
end

local function apply_webcam_pip_properties(c)
	if not is_webcam_pip(c) then
		return
	end

	if not c.floating then
		c.floating = true
	end
	if not c.ontop then
		c.ontop = true
	end
	if not c.sticky then
		c.sticky = true
	end
	if c.shape ~= webcam_pip_shape then
		c.shape = webcam_pip_shape
	end
	if c.border_width ~= webcam_pip_border_width then
		c.border_width = webcam_pip_border_width
	end
	if c.border_color ~= webcam_pip_border_color then
		c.border_color = webcam_pip_border_color
	end
	disable_webcam_glow(c)

	awful.placement.no_offscreen(c)
end

local function read_webcam_geometry()
	local file = io.open(webcam_geometry_file, "r")
	if not file then
		return nil
	end

	local line = file:read("*l")
	file:close()
	if not line then
		return nil
	end

	local x, y, width, height = line:match("^(-?%d+),(-?%d+),(%d+),(%d+)$")
	if not x then
		return nil
	end

	return {
		x = tonumber(x),
		y = tonumber(y),
		width = tonumber(width),
		height = tonumber(height),
	}
end

local function write_webcam_geometry(c)
	if not c.valid then
		return
	end

	local file = io.open(webcam_geometry_file, "w")
	if not file then
		return
	end

	file:write(string.format("%d,%d,%d,%d\n", c.x, c.y, c.width, c.height))
	file:close()
end

local function apply_webcam_geometry(c)
	if not is_webcam_pip(c) or c._webcam_geometry_applied then
		return
	end

	local geometry = read_webcam_geometry()
	if geometry then
		c:geometry(geometry)
		awful.placement.no_offscreen(c)
		c._webcam_geometry_applied = true
	else
		write_webcam_geometry(c)
	end
end

local function apply_webcam_pip_state(c)
	apply_webcam_pip_properties(c)
	apply_webcam_geometry(c)
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	apply_webcam_pip_state(c)
end)

client.connect_signal("property::name", apply_webcam_pip_state)
client.connect_signal("property::class", apply_webcam_pip_state)
client.connect_signal("property::instance", apply_webcam_pip_state)
client.connect_signal("property::floating", apply_webcam_pip_properties)
client.connect_signal("property::ontop", apply_webcam_pip_properties)

local last_focus
client.connect_signal("unfocus", function(c)
	last_focus = c
end)
client.connect_signal("focus", function(c)
	last_focus = nil
end)

client.connect_signal("unmanage", function(c)
	if is_webcam_pip(c) then
		write_webcam_geometry(c)
	end

	if client.focus == c and c.transient_for then
		client.focus = c.transient_for
		c.transient_for:raise()
	end
end)


-- write tag name and layout to file for polybar
client.connect_signal("focus", function(c)
	local name = client.focus and client.focus.first_tag.name or nil
	local layout = client.focus and client.focus.first_tag.layout.name or nil
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text="unfocus"})
	-- naughty.notify({preset=naughty.config.presets.normal, title="screen tag", text=tostring(layout)})
	os.execute("echo " .. name .. " > ~/.config/awesome/activetag.txt")
	-- naughty.notify({preset=naughty.config.presets.normal, title="focus", text=name})
	os.execute("echo " .. layout .. " > ~/.config/awesome/layout.txt")
	-- naughty.notify({preset=naughty.config.presets.normal, title="screen focused - name", text=tostring(c.name)})
	-- naughty.notify({preset=naughty.config.presets.normal, title="screen focused - title", text=tostring(c.title)})
	-- naughty.notify({preset=naughty.config.presets.normal, title="screen focused - class", text=tostring(c.class)})
end)

screen.connect_signal("tag::history::update", function(s)
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update'})
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-' .. type(s.selected_tag)})
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update' .. s.selected_tag.name})
	-- local name = awful.tag.selected(1).name
	-- local layout = screen.focus.first_tag.layout.name or nil
	local name = s.selected_tag.name
	-- local name = awful.tag.selected(s).getproperty("name")
	-- local t = client.focus.first_tag or nil
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-screen-name' .. t})
	-- local name = t.name
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-' .. name})

	os.execute("echo " .. name .. " > ~/.config/awesome/activetag.txt")
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update'})
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug-tag-history-update--name", text=name})
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug-tag-history-update--layout", text=layout})
end)

tag.connect_signal("property::selected", function()
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-screen-name'})
	-- name = awful.tag.selected(1).name
	-- name = awful.first_tag.layout.name or nil
	-- os.execute("echo " .. name .. " > ~/.config/awesome/activetag.txt")
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-screen-name' .. name})
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='tag::history::update-screen-layout' .. layout})
end)

client.connect_signal("property::geometry", function(c)
	if is_webcam_pip(c) and c.floating then
		write_webcam_geometry(c)
	end
end)

client.connect_signal("property::floating", function(c)
    if is_webcam_pip(c) then
        c.border_width = webcam_pip_border_width
        c.border_color = webcam_pip_border_color
        disable_webcam_glow(c)
        return
    end
    if c.floating then
        c.border_color = "#FFCC00"
    else
        c.border_color = "#6e5bae"
    end
end)

client.connect_signal("focus", function(c)
    if is_webcam_pip(c) then
        c.border_width = webcam_pip_border_width
        c.border_color = webcam_pip_border_color
        disable_webcam_glow(c)
        return
    end
    if c.floating then
        c.border_color = "#FFCC00"
    else
        c.border_color = "#6e5bae"
    end
end)

client.connect_signal("unfocus", function(c)
	if is_webcam_pip(c) then
		c.border_width = webcam_pip_border_width
		c.border_color = webcam_pip_border_color
		disable_webcam_glow(c)
		return
	end
	c.border_color = "#003b4e"
end)

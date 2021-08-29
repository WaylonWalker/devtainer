local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

local last_focus
client.connect_signal("unfocus", function(c) last_focus = c end)
client.connect_signal("focus", function(c) last_focus = nil end)

client.connect_signal("unmanage", function(c)
    if client.focus == c and c.transient_for then
        client.focus = c.transient_for
        c.transient_for:raise()
    end
end)



client.connect_signal("focus", function(c) c.border_color = "#6e5bae" end)
client.connect_signal("focus", function(c) c.border_color = "##ff66c4" end)
client.connect_signal("unfocus", function(c) c.border_color = "#003b4e" end)

-- write tag name and layout to file for polybar
client.connect_signal("focus", 
    function(c) 

            local name = client.focus and client.focus.first_tag.name or nil
            local layout = client.focus and client.focus.first_tag.layout.name or nil
            -- naughty.notify({preset=naughty.config.presets.normal, title="debug", text="unfocus"}) 
            -- naughty.notify({preset=naughty.config.presets.normal, title="screen focused", text=tostring(c.name)}) 
            -- naughty.notify({preset=naughty.config.presets.normal, title="screen tag", text=tostring(layout)}) 
            os.execute("echo " .. name .. " > ~/.config/awesome/activetag.txt")
            os.execute("echo " .. layout .. " > ~/.config/awesome/layout.txt")
    end
)


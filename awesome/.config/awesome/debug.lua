client.connect_signal("request::select", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "request::select" })
end)

client.connect_signal("request::default_layouts", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "request::layouts" })
end)

client.connect_signal("request::layouts", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "request::layouts" })
end)

client.connect_signal("tagged", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "tagged" })
end)

client.connect_signal("property::active", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::active" })
end)

client.connect_signal("property::urgent", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::urgent" })
end)

client.connect_signal("property::screen", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::screen" })
end)

client.connect_signal("scanning", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "scanning" })
end)

client.connect_signal("signal", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "signal" })
end)

client.connect_signal("untagged", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "untagged" })
end)

screen.connect_signal("list", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "list" })
end)

client.connect_signal("property::name", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::name" })
end)

client.connect_signal("property::selected", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::selected" })
end)

client.connect_signal("property::activated", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "property::activated" })
end)

client.connect_signal("focus", function(c)
	-- gears.debug(c)
	-- naughty.notify({preset=naughty.config.presets.normal, title="debug", text='hi'})
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = gears.debug.dump(
		c,
		"border_color",
		2
	) })
end)

screen.connect_signal("tag::history::update", function(c)
	naughty.notify({ preset = naughty.config.presets.normal, title = "debug", text = "tag::history::update" })
end)

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")

require("keymap")
require("theme")
require("errors")
require("rules")

require("spawn")
require("signal")

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

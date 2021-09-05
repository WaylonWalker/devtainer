local awful = require("awful")

awful.spawn.with_shell("compton")
awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/wp2555882-space-background.jpg")
awful.spawn.with_shell("launch_polybar")
awful.spawn.with_shell("flameshot")

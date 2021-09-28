local awful = require("awful")

awful.spawn.with_shell("compton")
awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/wallpaper/wp2555882-space-background.jpg")
awful.spawn.with_shell("launch_polybar")
awful.spawn.with_shell("flameshot")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell('xbindkeys -f ~/.xbindkeysrc')

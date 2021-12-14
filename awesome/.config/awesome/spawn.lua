local awful = require("awful")

awful.spawn.with_shell("compton")
awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/wallpaper/backdrop-distort-color.png")
awful.spawn.with_shell("launch_polybar")
awful.spawn.with_shell("flameshot")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell('xbindkeys -f ~/.xbindkeysrc')

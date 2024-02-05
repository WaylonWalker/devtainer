
local awful = require("awful")

awful.spawn.with_shell("picom || compton")
awful.spawn.with_shell("xrandr-manager -d right")
awful.spawn.with_shell("launch_polybar")
awful.spawn.with_shell("flameshot")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell('xbindkeys -f ~/.xbindkeysrc')
awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/wallpaper/1440w5.png")

-- awful.spawn.with_shell('[[ `command -v steam` ]] && steam steam://open/bigpicture -fulldesktopres')

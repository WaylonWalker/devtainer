-- Autostart formerly in autostart.conf.
local focus_or_launch = "~/.config/hypr/scripts/focus_or_launch.sh"
local browser = "brave --password-store=basic"
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("bash -lc 'sleep 1; ~/.config/hypr/scripts/restore_wallpaper.sh >/dev/null 2>&1 || true'")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("swaync")
    hl.exec_cmd(focus_or_launch .. " brave-browser " .. browser)
    hl.exec_cmd(focus_or_launch .. " kitty kitty")
    hl.exec_cmd(focus_or_launch .. " Signal signal-desktop")
end)

-- Keybindings formerly in bindings.conf.
local main = "SUPER"
local terminal = "kitty"
local browser = "brave --password-store=basic --disable-gpu"
local webapp = function(url) return browser .. " --app=\"" .. url .. "\"" end
local focus_or_launch = "~/.config/hypr/scripts/focus_or_launch.sh"
local start = function(class, command) return focus_or_launch .. " " .. class .. " " .. command end
local bind = function(keys, command, flags) hl.bind(keys, hl.dsp.exec_cmd(command), flags) end

bind(main .. " + RETURN", start("kitty", "kitty"))
bind(main .. " + SHIFT + RETURN", terminal)
bind(main .. " + B", start("brave-browser", browser))
bind(main .. " + SHIFT + B", browser)
bind(main .. " + A", start("brave-chat.openai.com__-Default", webapp("https://chat.openai.com")))
bind(main .. " + SHIFT + A", webapp("https://chatgpt.com"))
bind(main .. " + D", start("brave-dropper.wayl.one__-Default", webapp("https://dropper.wayl.one")))
bind(main .. " + G", start("Signal", "signal-desktop"))
bind(main .. " + L", "hyprlock")
bind(main .. " + T", terminal .. " -e btop")
bind(main .. " + Y", start("brave-youtube.com__-Default", webapp("https://youtube.com")))
bind(main .. " + SHIFT + M", start("brave-music.youtube.com__-Default", webapp("https://music.youtube.com")))
bind(main .. " + I", start("brave-excalidraw.wayl.one__-Default", webapp("https://excalidraw.wayl.one")))
bind(main .. " + SHIFT + K", start("brave-argocd.wayl.one__-Default", webapp("https://argocd.wayl.one")))
bind(main .. " + SHIFT + Y", webapp("https://youtube.com/"))
bind(main .. " + C", "hyprctl dispatch killactive")
bind(main .. " + M", "hyprctl dispatch exit")
bind(main .. " + E", "uwsm app -- nautilus")
bind(main .. " + V", "hyprctl dispatch togglefloating")
bind(main .. " + R", "wofi --show drun --insensitive")
bind(main .. " + SEMICOLON", "/home/waylon/.local/bin/rofimoji --selector-args=\"-theme ~/.config/rofi/dracula.rasi\"")
bind(main .. " + F", "hyprctl dispatch fullscreen 1")
bind(main .. " + SHIFT + F", "hyprctl dispatch fullscreen 0")
bind(main .. " + P", "/usr/bin/hyprshot -m region")
bind(main .. " + CTRL + P", "/usr/bin/hyprshot -m region --freeze")
bind(main .. " + SHIFT + P", "~/.config/hypr/scripts/screenrecord.sh region")
bind(main .. " + S", "~/.config/hypr/scripts/screenrecord.sh region")
bind(main .. " + SHIFT + P", "wl-paste --type image/png > /tmp/clipboard.png && krita /tmp/clipboard.png")
bind(main .. " + I", "~/.config/hypr/scripts/hyprctl.sh dispatch change_gaps 10")
bind(main .. " + W", "rofi -show window -theme ~/.config/rofi/gruvbox-medium.rasi")
bind(main .. " + CTRL + SHIFT + W", "~/.config/hypr/scripts/wallpaper_fzf.sh")
bind(main .. " + SHIFT + W", "~/.config/hypr/scripts/cycle_wallpaper.sh prev")
bind(main .. " + CTRL + W", "~/.config/hypr/scripts/cycle_wallpaper.sh next")
bind(main .. " + X", webapp("https://x.com/"), { description = "Open X" })
bind(main .. " + SHIFT + X", webapp("https://x.com/compose/post"), { description = "Post to X" })
bind(main .. " + SPACE", "hyprlauncher")
bind(main .. " + SHIFT + S", "~/git/scripts/webcam_toggle.sh")

local directions = { left = "l", right = "r", up = "u", down = "d" }
for direction, value in pairs(directions) do bind(main .. " + " .. direction, "hyprctl dispatch movefocus " .. value) end
bind(main .. " + J", "hyprctl dispatch cyclenext prev")
bind(main .. " + K", "hyprctl dispatch cyclenext next")
for i = 1, 10 do
    local key = i % 10
    bind(main .. " + code:" .. (i + 9), "hyprctl dispatch workspace " .. i, { description = "Switch to workspace " .. i })
    bind(main .. " + SHIFT + " .. key, "hyprctl dispatch movetoworkspace " .. i)
end
bind(main .. " + mouse_down", "hyprctl dispatch workspace e+1")
bind(main .. " + mouse_up", "hyprctl dispatch workspace e-1")
bind(main .. " + mouse:272", "hyprctl dispatch movewindow", { mouse = true })
bind(main .. " + mouse:273", "hyprctl dispatch resizewindow", { mouse = true })

for _, item in ipairs({
    { "XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" },
    { "XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" },
    { "XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { "XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { "XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+" },
    { "XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-" },
}) do bind(item[1], item[2], { locked = true, repeating = true }) end
for _, item in ipairs({ { "XF86AudioNext", "playerctl next" }, { "XF86AudioPause", "playerctl play-pause" }, { "XF86AudioPlay", "playerctl play-pause" }, { "XF86AudioPrev", "playerctl previous" } }) do bind(item[1], item[2], { locked = true }) end
bind(main .. " + PERIOD", "pkill waybar || waybar &", { description = "Toggle top bar" })
bind(main .. " + ESCAPE", "~/.config/hypr/scripts/power_menu.sh", { description = "Power menu" })

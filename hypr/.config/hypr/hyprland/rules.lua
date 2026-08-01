-- Window rules formerly split between hyprland.conf and bindings.conf.
local function rule(_, match, effects)
    effects.match = match
    hl.window_rule(effects)
end

for _, item in ipairs({
    { "steam", "^(steam)$", "1" }, { "kitty", "^(kitty)$", "4" },
    { "firefox", "^(firefox)$", "5" }, { "brave", "^(brave-browser)$", "5" },
    { "chrome", "^(google-chrome)$", "5" }, { "signal", "^(signal)$", "6" },
    { "krita", "^(krita)$", "2" }, { "chatgpt", "^(brave-chat.openai.com__-Default)$", "8" },
    { "youtube", "^(brave-youtube.com__-Default)$", "8" },
    { "prism", "^(org.prismlauncher.PrismLauncher)$", "9" },
}) do
    rule("workspace-" .. item[1], { class = item[2] }, { workspace = item[3] })
end

rule("pavucontrol-float", { class = "^(org.pulseaudio.pavucontrol)$" }, { float = true })
rule("portal-float", { class = "^(xdg-desktop-portal-gtk)$" }, { float = true })
rule("prism-console-float", { class = "^(org.prismlauncher.PrismLauncher)$", title = "^(Console window.*)$" }, { float = true })
for _, name in ipairs({ "Btop", "Nvtop" }) do
    rule(name:lower() .. "-float", { class = "^(" .. name .. ")$" }, { float = true })
    rule(name:lower() .. "-size", { class = "^(" .. name .. ")$" }, { size = { 1600, 1000 } })
    rule(name:lower() .. "-position", { class = "^(" .. name .. ")$" }, { move = { 480, 220 } })
end
rule("webcam-float", { title = "^(Webcam Viewer - Toggle Script)$" }, { float = true })
-- Hyprland 0.56 caps per-window rounding at 20; 40 is rejected by the Lua API.
rule("webcam-rounding", { title = "^(Webcam Viewer - Toggle Script)$" }, { rounding = 20 })
rule("ffplay-float", { title = "^(Webcam Viewer - FFPlay Toggle)$" }, { float = true })
rule("ffplay-rounding", { title = "^(Webcam Viewer - FFPlay Toggle)$" }, { rounding = 20 })
rule("ffplay-size", { title = "^(Webcam Viewer - FFPlay Toggle)$" }, { size = { 640, 480 } })
rule("ffplay-position", { title = "^(Webcam Viewer - FFPlay Toggle)$" }, { move = { 1900, 60 } })

rule("floating-window", { tag = "floating-window" }, { float = true, center = true, size = { 800, 600 } })
rule("big-floating-window", { tag = "big-floating-window" }, { size = { 1920, 1080 } })
rule("floating-apps", { class = "(blueberry\\.py|Impala|Wiremix|org\\.gnome\\.NautilusPreviewer|com\\.gabm\\.satty|About|TUI\\.float|WallpaperPicker)" }, { tag = "+floating-window" })
rule("btop-tag", { class = "btop" }, { tag = "+big-floating-window" })
rule("file-dialogs", { class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org\\.gnome\\.Nautilus)", title = "^(Open.*Files?|Open Folder|Save.*Files?|Save.*As|Save|All Files)" }, { tag = "+floating-window" })
rule("wallpaper-picker", { class = "WallpaperPicker" }, { center = true, size = { 1400, 900 } })
rule("screensaver", { class = "Screensaver" }, { fullscreen = true })
rule("opaque-media", { class = "^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|com\\.github\\.PintaProject\\.Pinta|imv|org\\.gnome\\.NautilusPreviewer)$" }, { opacity = "1.0 override 1.0 override" })

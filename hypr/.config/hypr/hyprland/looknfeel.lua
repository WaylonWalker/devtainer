-- Look and feel formerly in looknfeel.conf.
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        shadow = { enabled = true, range = 2, render_power = 3, color = 0xee1a1a1a },
        blur = { enabled = true, size = 4, passes = 2, vibrancy = 0.1696 },
    },
    misc = { disable_hyprland_logo = true, disable_splash_rendering = true, focus_on_activate = true },
    cursor = { hide_on_key_press = true, enable_hyprcursor = false },
    dwindle = { preserve_split = true, force_split = 2 },
    master = { new_status = "master" },
    animations = { enabled = true },
})

local curves = {
    { "easeOutQuint", { { 0.23, 1 }, { 0.32, 1 } } },
    { "easeInOutCubic", { { 0.65, 0.05 }, { 0.36, 1 } } },
    { "linear", { { 0, 0 }, { 1, 1 } } },
    { "almostLinear", { { 0.5, 0.5 }, { 0.75, 1 } } },
    { "quick", { { 0.15, 0 }, { 0.1, 1 } } },
}
for _, curve in ipairs(curves) do hl.curve(curve[1], { type = "bezier", points = curve[2] }) end

local animations = {
    { leaf = "global", speed = 10, bezier = "default" },
    { leaf = "border", speed = 5.39, bezier = "easeOutQuint" },
    { leaf = "windows", speed = 4.79, bezier = "easeOutQuint" },
    { leaf = "windowsIn", speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" },
    { leaf = "windowsOut", speed = 1.49, bezier = "linear", style = "popin 87%" },
    { leaf = "fadeIn", speed = 1.73, bezier = "almostLinear" },
    { leaf = "fadeOut", speed = 1.46, bezier = "almostLinear" },
    { leaf = "fade", speed = 3.03, bezier = "quick" },
    { leaf = "layers", speed = 3.81, bezier = "easeOutQuint" },
    { leaf = "layersIn", speed = 4, bezier = "easeOutQuint", style = "fade" },
    { leaf = "layersOut", speed = 1.5, bezier = "linear", style = "fade" },
    { leaf = "fadeLayersIn", speed = 1.79, bezier = "almostLinear" },
    { leaf = "fadeLayersOut", speed = 1.39, bezier = "almostLinear" },
    -- The old `animation = workspaces, 0, 0, ease` disabled this animation.
    { leaf = "workspaces", enabled = false, speed = 1, bezier = "linear" },
}
for _, animation in ipairs(animations) do
    if animation.enabled == nil then animation.enabled = true end
    hl.animation(animation)
end

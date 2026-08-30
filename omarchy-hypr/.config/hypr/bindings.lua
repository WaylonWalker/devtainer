-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Personal overrides.
-- SUPER + B / A / E are free in Omarchy's defaults.
-- SUPER + SHIFT + S was bound to Google Maps by default; unbind before overriding.
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + A", "ChatGPT", { webapp = "https://chatgpt.com" })
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot region", "omarchy-capture-screenshot region")

-- Brought over from old devtainer config. Each key was bound by an Omarchy
-- default, so unbind before overriding.
hl.unbind("SUPER + J")
o.bind("SUPER + J", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Focus on next window", hl.dsp.window.cycle_next({ next = true }))
hl.unbind("SUPER + C")
o.bind("SUPER + C", "Close window", hl.dsp.window.close())
hl.unbind("SUPER + P")
o.bind("SUPER + P", "Screenshot region", "omarchy-capture-screenshot region")

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

-- Move the active window to the other monitor, following it there.
-- This replaces Omarchy's default Super+O "pop window out" action.
hl.unbind("SUPER + O")
o.bind("SUPER + O", "Move window to other monitor",
  hl.dsp.window.move({ monitor = "+1" }))

-- Present nine workspaces per monitor using the same Super+number keys.
-- The workspace IDs are different under the hood, but m~N means workspace N
-- relative to the currently focused monitor.
for workspace = 1, 9 do
  local key = "code:" .. tostring(workspace + 9)
  local target = "m~" .. tostring(workspace)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
  o.bind("SUPER + " .. key, "Switch to workspace " .. workspace .. " on this monitor",
    hl.dsp.focus({ workspace = target }))
  o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace .. " on this monitor",
    hl.dsp.window.move({ workspace = target }))
  o.bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace .. " on this monitor",
    hl.dsp.window.move({ workspace = target, follow = false }))
end

-- Disable Omarchy's tenth workspace binding; each monitor now has nine.
hl.unbind("SUPER + code:19")
hl.unbind("SUPER + SHIFT + code:19")
hl.unbind("SUPER + SHIFT + ALT + code:19")

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

-- Walker launchers.
-- SUPER+W was Omarchy's default close-window binding.
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Switch to open window", "omarchy-window-switcher")
o.bind("SUPER + R", "Launch application", "walker --provider desktopapplications")

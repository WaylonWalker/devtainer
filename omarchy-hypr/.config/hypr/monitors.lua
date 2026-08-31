-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- 4K laptop panel downscaled to 1440p to save battery. The panel only lists a
-- 4K DRM mode; Hyprland programs the 1440p mode and the panel upscales it.
-- Fractional scale 1.5 keeps text readable on the tight panel (188 logical
-- PPI at scale 1); bump toward 1.75 to match the external monitor's size.
hl.monitor({ output = "eDP-1", mode = "2560x1440@60", position = "2560x0", scale = 1.5 })

-- External monitor, flush left of the laptop panel. Uses the preferred mode
-- (2560x1440) so it matches the laptop's logical height.
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = 1 })

-- Keep nine persistent workspaces on each monitor. Workspace IDs are global,
-- so the external display uses 10-18 while bindings expose both sets as 1-9
-- relative to the currently focused monitor.
for workspace = 1, 9 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "eDP-1",
    persistent = true,
    default = workspace == 1,
  })
end

for workspace = 10, 18 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "DP-1",
    persistent = true,
    default = workspace == 10,
  })
end

-- Fallback for any other output.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

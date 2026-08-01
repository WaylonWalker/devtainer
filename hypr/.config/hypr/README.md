# Hyprland configuration

`hyprland.lua` is the active configuration for Hyprland 0.55 and newer. The
`.conf` files in this directory are deprecated hyprlang sources retained during
the migration window so that rollback remains straightforward.

Do not edit the deprecated `.conf` files for new changes. Update the Lua
modules under `hyprland/` instead. Once the Lua configuration has been stable
for an agreed period, the deprecated files can be removed in a separate change.

## Rollback

Move the Lua entrypoint and module directory out of the active configuration,
then reload Hyprland:

```bash
rm -f ~/.config/hypr/hyprland.lua
rm -rf ~/.config/hypr/hyprland
hyprctl reload
```

The pre-migration configuration is also preserved in
`legacy-conf-backup-20260801.tar.gz`. The snapshot of the configuration that
was live before migration is in `live-home-backup-20260801.tar.gz`.

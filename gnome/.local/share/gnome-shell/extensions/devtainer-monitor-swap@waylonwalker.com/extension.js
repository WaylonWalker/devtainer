import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class DevtainerMonitorSwapExtension extends Extension {
    enable() {
        this._settings = this.getSettings();
        Main.wm.addKeybinding(
            'swap-focused-window-monitor',
            this._settings,
            Meta.KeyBindingFlags.NONE,
            Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
            () => this._swapFocusedWindowMonitor()
        );
    }

    disable() {
        Main.wm.removeKeybinding('swap-focused-window-monitor');
        this._settings = null;
    }

    _swapFocusedWindowMonitor() {
        const window = global.display.get_focus_window();
        const monitorCount = global.display.get_n_monitors();

        if (!window || monitorCount < 2)
            return;

        window.move_to_monitor((window.get_monitor() + 1) % monitorCount);
    }
}

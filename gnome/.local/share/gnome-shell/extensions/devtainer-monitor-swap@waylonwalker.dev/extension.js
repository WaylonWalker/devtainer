import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class DevtainerMonitorSwapExtension extends Extension {
    enable() {
        this._settings = this.getSettings();
        Main.wm.addKeybinding(
            'monitor-swap',
            this._settings,
            Meta.KeyBindingFlags.NONE,
            Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
            this._swapFocusedWindow.bind(this),
        );
    }

    disable() {
        Main.wm.removeKeybinding('monitor-swap');
        this._settings = null;
    }

    _swapFocusedWindow() {
        const window = global.display.get_focus_window();
        if (!window)
            return;

        const monitorCount = global.display.get_n_monitors();
        if (monitorCount < 2)
            return;

        const currentMonitor = window.get_monitor();
        const nextMonitor = (currentMonitor + 1) % monitorCount;

        window.move_to_monitor(nextMonitor);
        window.activate(global.get_current_time());
    }
}

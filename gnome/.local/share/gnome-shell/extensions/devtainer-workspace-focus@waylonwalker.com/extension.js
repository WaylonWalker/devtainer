import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const WORKSPACE_SHORTCUTS = Array.from({length: 9}, (_, index) =>
    `switch-to-workspace-${index + 1}`);

export default class DevtainerWorkspaceFocusExtension extends Extension {
    enable() {
        this._settings = this.getSettings();

        for (const [index, shortcut] of WORKSPACE_SHORTCUTS.entries()) {
            Main.wm.addKeybinding(
                shortcut,
                this._settings,
                Meta.KeyBindingFlags.NONE,
                Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
                () => this._switchWorkspace(index)
            );
        }
    }

    disable() {
        for (const shortcut of WORKSPACE_SHORTCUTS)
            Main.wm.removeKeybinding(shortcut);

        this._settings = null;
    }

    _switchWorkspace(index) {
        const workspaceManager = global.workspace_manager;
        const targetWorkspace = workspaceManager.get_workspace_by_index(index);

        if (!targetWorkspace)
            return;

        const focusedWindow = global.display.get_focus_window();
        const focusedMonitor = focusedWindow?.get_monitor();
        const timestamp = global.get_current_time();

        if (focusedMonitor === undefined) {
            targetWorkspace.activate(timestamp);
            return;
        }

        // get_tab_list is ordered by recency, so this keeps focus on the
        // source monitor while retaining GNOME's normal MRU-window behavior.
        const targetWindow = global.display
            .get_tab_list(Meta.TabList.NORMAL, targetWorkspace)
            .find(window => window.get_monitor() === focusedMonitor);

        if (targetWindow)
            targetWorkspace.activate_with_focus(targetWindow, timestamp);
        else
            targetWorkspace.activate(timestamp);
    }
}

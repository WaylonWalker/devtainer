import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "waylon.workspaces"

  function barMonitorName() {
    var window = root.QsWindow ? root.QsWindow.window : null
    return window && window.screen ? String(window.screen.name || "") : ""
  }

  function barMonitor() {
    var monitors = Hyprland.monitors.values
    var name = root.barMonitorName()
    for (var i = 0; i < monitors.length; i++) {
      if (String(monitors[i].name || "") === name) return monitors[i]
    }
    return null
  }

  function workspaceBySlot(slot) {
    var values = Hyprland.workspaces.values
    var monitorName = root.barMonitorName()
    var targetId = monitorName === "DP-1" ? slot + 9 : slot

    for (var i = 0; i < values.length; i++) {
      if (values[i].id === targetId) return values[i]
    }

    return null
  }

  function workspaceSlots() {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9]
  }

  function focusWorkspace(slot) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"m~" + slot + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)
  // Nerd Font's mask-like glyph keeps the focused slot in the Silksong visual language.
  readonly property string silkMask: "\uDB85\uDCFB"

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceSlots().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceSlots()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceBySlot(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: workspace !== null &&
          root.barMonitor() !== null &&
          root.barMonitor().activeWorkspace !== null &&
          root.barMonitor().activeWorkspace.id === workspace.id

        bar: root.bar
        text: focused ? root.silkMask : String(modelData)
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}

import Quickshell
import Quickshell.Wayland

ShellRoot {
  Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
      required property var modelData
      screen: modelData
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      WlrLayershell.namespace: "omarchy-greetd"
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      Main { anchors.fill: parent }
    }
  }
}

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import qs.Commons
import qs.Ui

Item {
  id: root

  readonly property string home: Quickshell.env("HOME")
  readonly property string stateHome: home + "/.local/state"
  readonly property string currentBackgroundLink: stateHome + "/omarchy/current/background"

  property string currentBackground: ""
  property string displayedBackground: ""
  property string incomingBackground: ""
  property string oldBackground: ""
  property bool finishingTransition: false
  property int backgroundVersion: 0
  property int revealStartedVersion: -1
  property int pendingThemeVersion: -1
  property string pendingColorsRaw: ""
  property string pendingShellRaw: ""
  property real revealProgress: 1
  property bool silksongActive: false

  function updateSilksongState() {
    silksongActive = String(themeNameFile.text() || "").trim().toLowerCase() === "silksong"
  }

  function imageUrl(path) {
    return Util.fileUrl(path)
  }

  FileView {
    id: themeNameFile
    path: root.home + "/.local/state/omarchy/current/theme.name"
    watchChanges: true
    printErrors: false
    onLoaded: root.updateSilksongState()
    onTextChanged: root.updateSilksongState()
    onFileChanged: reload()
  }

  function refreshBackground() {
    if (!readlinkProc.running) readlinkProc.running = true
  }

  function setBackground(path, instant) {
    transitionBackground("", path, path, instant, false)
  }

  function transitionBackground(fromPath, path, finalPath, instant, force) {
    path = String(path || "").trim()
    finalPath = String(finalPath || path).trim()
    fromPath = String(fromPath || "").trim()
    if (!path || (!force && finalPath === currentBackground)) return
    currentBackground = finalPath
    backgroundVersion += 1
    revealStartedVersion = -1

    revealAnimation.stop()
    finishingTransition = false

    if (instant || !displayedBackground) {
      oldBackground = ""
      incomingBackground = ""
      displayedBackground = path
      revealProgress = 1
      return
    }

    oldBackground = fromPath || displayedBackground
    incomingBackground = path
    revealProgress = 0
  }

  function setPendingTheme(colorsB64, shellB64) {
    pendingColorsRaw = Util.decodeBase64(colorsB64)
    pendingShellRaw = Util.decodeBase64(shellB64)
    pendingThemeVersion = backgroundVersion
    pendingThemeFallbackTimer.restart()
  }

  function applyPendingTheme() {
    // Background polling can advance backgroundVersion while a theme switch is
    // pending; the latest theme payload should still apply.
    if (pendingThemeVersion < 0) return
    pendingThemeFallbackTimer.stop()
    Color.loadColors(pendingColorsRaw)
    // Color.loadShell also refreshes Style so the type scale flips with the
    // background reveal instead of waiting for a separate reload path.
    Color.loadShell(pendingShellRaw)
    Style.scheduleRefresh()
    pendingThemeVersion = -1
    pendingColorsRaw = ""
    pendingShellRaw = ""
  }

  function transitionBackgroundWithTheme(fromPath, path, finalPath, colorsB64, shellB64) {
    transitionBackground(fromPath, path, finalPath, false, true)
    setPendingTheme(colorsB64, shellB64)
    if (!incomingBackground || revealProgress >= 1) applyPendingTheme()
  }

  function startReveal(panel) {
    if (!incomingBackground) return
    panel.maskReady = true
    if (revealStartedVersion === backgroundVersion) return
    revealStartedVersion = backgroundVersion
    applyPendingTheme()
    revealAnimation.restart()
  }

  function openSelector() {
    if (!bgSwitchProc.running) bgSwitchProc.running = true
  }

  function openThemeSwitcher() {
    if (!themeSwitchProc.running) themeSwitchProc.running = true
  }

  Process {
    id: bgSwitchProc
    command: ["bash", "-c", "background=$(omarchy-theme-bg-switcher); [[ -n $background ]] && omarchy-theme-bg-set \"$background\""]
    onExited: root.refreshBackground()
  }

  Process {
    id: themeSwitchProc
    command: ["bash", "-c", "theme=$(omarchy-theme-switcher); [[ -n $theme ]] && omarchy-theme-set \"$theme\" >/dev/null 2>&1 &"]
    onExited: root.refreshBackground()
  }

  Process {
    id: readlinkProc
    command: ["readlink", "-f", root.currentBackgroundLink]
    stdout: StdioCollector {
      onStreamFinished: root.setBackground(String(text || "").trim(), false)
    }
  }

  IpcHandler {
    target: "background"

    function refresh(): void {
      root.refreshBackground()
    }

    function set(path: string): void {
      root.setBackground(path, false)
    }

    function setInstant(path: string): void {
      root.setBackground(path, true)
    }

    function transition(fromPath: string, path: string): void {
      root.transitionBackground(fromPath, path, path, false, false)
    }

    function themeTransition(fromPath: string, path: string, finalPath: string, colorsB64: string, shellB64: string): void {
      root.transitionBackgroundWithTheme(fromPath, path, finalPath, colorsB64, shellB64)
    }
  }

  Timer {
    id: pendingThemeFallbackTimer
    interval: 300
    repeat: false
    onTriggered: root.applyPendingTheme()
  }

  NumberAnimation {
    id: revealAnimation
    target: root
    property: "revealProgress"
    from: 0
    to: 1
    duration: 420
    easing.type: Easing.InOutCubic
    onFinished: {
      if (root.incomingBackground) {
        root.displayedBackground = root.currentBackground || root.incomingBackground
        root.finishingTransition = true
      }
      root.revealProgress = 1
    }
  }

  Component.onCompleted: refreshBackground()

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: !remapGuard.remapping
      anchors { top: true; bottom: true; left: true; right: true }

      ScreenMoveRemap {
        id: remapGuard
        window: panel
      }
      color: "transparent"
      // Keep render updates enabled. The background layer has been observed to
      // lose its committed buffer while parked with updatesEnabled=false,
      // leaving a black desktop until omarchy-shell is restarted. The wallpaper
      // itself is static, so this favors correctness over a small render-loop
      // optimization.
      updatesEnabled: true

      property bool maskReady: false

      function maybeStartReveal() {
        if (!root.incomingBackground || root.revealProgress !== 0 || maskReady) return
        if (incomingFrame.status !== Image.Ready) return
        Qt.callLater(function() {
          if (!root.incomingBackground || root.revealProgress !== 0 || maskReady) return
          if (incomingFrame.status !== Image.Ready) return
          root.startReveal(panel)
        })
      }

      WlrLayershell.namespace: "omarchy-background"
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      Image {
        id: base
        anchors.fill: parent
        source: root.imageUrl(root.displayedBackground)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        onStatusChanged: {
          if (status === Image.Ready && root.finishingTransition) {
            root.incomingBackground = ""
            root.oldBackground = ""
            root.finishingTransition = false
          }
        }
      }

      Image {
        id: oldFrame
        anchors.fill: parent
        source: root.imageUrl(root.oldBackground)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        smooth: true
        mipmap: true
        visible: root.oldBackground !== "" && root.revealProgress < 1
        onStatusChanged: panel.maybeStartReveal()
      }

      Item {
        id: incomingLayer
        anchors.fill: parent
        visible: root.incomingBackground !== "" && incomingFrame.status === Image.Ready && (root.revealProgress >= 1 || panel.maskReady)
        layer.enabled: root.incomingBackground !== "" && root.revealProgress < 1
        layer.smooth: true
        layer.effect: MultiEffect {
          maskEnabled: true
          maskSource: revealMask
          maskThresholdMin: 0.5
          maskSpreadAtMin: 0.02
        }

        Image {
          id: incomingFrame
          anchors.fill: parent
          source: root.imageUrl(root.incomingBackground)
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: false
          smooth: true
          mipmap: true
          onStatusChanged: panel.maybeStartReveal()
        }
      }

      // Pharloom spores and silk motes live in the same background surface as
      // the wallpaper, so they remain above the image but below the bar.
      Item {
        id: silksongParticles
        anchors.fill: parent
        visible: root.silksongActive
        enabled: visible

        Repeater {
          model: 36

          Item {
            id: mote
            required property int modelData
            readonly property int motionType: modelData % 6
            readonly property int route: modelData % 4
            readonly property real driftX: 54 + (modelData % 5) * 18
            readonly property real driftY: 42 + (modelData % 7) * 13
            readonly property color moteColor: modelData % 9 === 0 ? "#d35b67" : "#a0e0dc"
            readonly property real seedX: ((modelData * 137) % 101) / 100
            readonly property real seedY: ((modelData * 67) % 103) / 100
            readonly property real baseX: silksongParticles.width * seedX
            readonly property real baseY: silksongParticles.height * seedY
            readonly property real startX: route === 0 ? -32 : route === 1 ? silksongParticles.width + 32 : silksongParticles.width * seedX
            readonly property real endX: route === 0 ? silksongParticles.width + 32 : route === 1 ? -32 : silksongParticles.width * seedX + (route === 2 ? driftX : -driftX)
            readonly property real startY: route === 2 ? -32 : route === 3 ? silksongParticles.height + 32 : silksongParticles.height * seedY
            readonly property real endY: route === 2 ? silksongParticles.height + 32 : route === 3 ? -32 : silksongParticles.height * seedY + (route === 0 ? -driftY : driftY)

            x: baseX
            y: baseY
            width: 2 + ((modelData * 11) % 6) * 0.8
            height: width

            Rectangle {
              anchors.centerIn: parent
              width: parent.width * 3.4
              height: width
              radius: width / 2
              color: parent.moteColor
              opacity: 0.14
            }

            Rectangle {
              anchors.centerIn: parent
              width: parent.width * 0.55
              height: width
              radius: width / 2
              color: parent.moteColor
              opacity: 0.7
            }

            PathAnimation {
              target: mote
              loops: Animation.Infinite
              running: root.silksongActive && mote.motionType === 5
              duration: 18000 + ((modelData * 977) % 14000)
              path: Path {
                startX: mote.startX
                startY: mote.startY
                PathCubic {
                  x: (mote.startX + mote.endX) / 2
                  y: (mote.startY + mote.endY) / 2 + (modelData % 5 - 2) * 90
                  control1X: mote.startX + (mote.endX - mote.startX) * 0.22
                  control1Y: mote.startY + (mote.endY - mote.startY) * 0.22 + (modelData % 7 - 3) * 110
                  control2X: mote.startX + (mote.endX - mote.startX) * 0.38
                  control2Y: mote.startY + (mote.endY - mote.startY) * 0.38 - (modelData % 6 - 2) * 95
                }
                PathCubic {
                  x: mote.endX
                  y: mote.endY
                  control1X: (mote.startX + mote.endX) / 2 + (modelData % 6 - 3) * 110
                  control1Y: (mote.startY + mote.endY) / 2 + (modelData % 7 - 3) * 95
                  control2X: mote.startX + (mote.endX - mote.startX) * 0.82
                  control2Y: mote.startY + (mote.endY - mote.startY) * 0.82 - (modelData % 5 - 2) * 110
                }
              }
            }

            SequentialAnimation on x {
              loops: Animation.Infinite
              running: root.silksongActive && mote.motionType < 5
              NumberAnimation { from: mote.baseX - 34; to: mote.baseX + 34; duration: 6200 + (modelData % 5) * 900; easing.type: Easing.InOutSine }
              NumberAnimation { from: mote.baseX + 34; to: mote.baseX - 34; duration: 6800 + (modelData % 4) * 850; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on y {
              loops: Animation.Infinite
              running: root.silksongActive && mote.motionType < 3
              NumberAnimation { from: mote.baseY - 22; to: mote.baseY + 22; duration: 7100 + (modelData % 6) * 700; easing.type: Easing.InOutSine }
              NumberAnimation { from: mote.baseY + 22; to: mote.baseY - 22; duration: 7700 + (modelData % 5) * 800; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on y {
              loops: Animation.Infinite
              running: root.silksongActive && mote.motionType >= 3 && mote.motionType < 5
              PauseAnimation { duration: (modelData % 4) * 900 }
              NumberAnimation { from: mote.baseY - 70; to: mote.baseY + 150; duration: 7600 + (modelData % 5) * 950; easing.type: Easing.InQuad }
              NumberAnimation { from: mote.baseY + 150; to: mote.baseY - 70; duration: 9800 + (modelData % 4) * 900; easing.type: Easing.OutQuad }
            }

            SequentialAnimation on opacity {
              loops: Animation.Infinite
              running: root.silksongActive
              NumberAnimation { to: 0.35; duration: 1800; easing.type: Easing.InOutSine }
              NumberAnimation { to: 1.0; duration: 2200; easing.type: Easing.InOutSine }
              PauseAnimation { duration: (modelData % 5) * 500 }
            }
          }
        }

        Repeater {
          model: 8

          Rectangle {
            required property int modelData
            x: silksongParticles.width * ((modelData * 211) % 106) / 100
            y: silksongParticles.height * ((modelData * 83) % 100) / 100
            width: 48 + (modelData % 4) * 28
            height: 1
            radius: 1
            rotation: -18 + (modelData % 3) * 12
            color: "#d35b67"
            opacity: 0.2
            transformOrigin: Item.Left

            SequentialAnimation on opacity {
              loops: Animation.Infinite
              running: root.silksongActive
              PauseAnimation { duration: modelData * 700 }
              NumberAnimation { to: 0.3; duration: 2600; easing.type: Easing.InOutSine }
              NumberAnimation { to: 0.05; duration: 3400; easing.type: Easing.InOutSine }
            }
          }
        }

        // A few warm fireflies keep the scene alive without turning it into a
        // screensaver. Their halos stay deliberately softer than the motes.
        Repeater {
          model: 6

          Item {
            id: firefly
            required property int modelData
            readonly property int motionType: modelData % 3
            readonly property int route: (modelData + 1) % 4
            readonly property real driftX: 35 + (modelData % 3) * 22
            readonly property real driftY: 28 + (modelData % 4) * 16
            readonly property real seedX: ((modelData * 173 + 21) % 101) / 100
            readonly property real seedY: ((modelData * 47 + 18) % 84) / 100
            readonly property real baseX: silksongParticles.width * seedX
            readonly property real baseY: silksongParticles.height * seedY
            readonly property real startX: route === 0 ? -48 : route === 1 ? silksongParticles.width + 48 : silksongParticles.width * seedX
            readonly property real endX: route === 0 ? silksongParticles.width + 48 : route === 1 ? -48 : silksongParticles.width * seedX + (route === 2 ? driftX : -driftX)
            readonly property real startY: route === 2 ? -48 : route === 3 ? silksongParticles.height + 48 : silksongParticles.height * seedY
            readonly property real endY: route === 2 ? silksongParticles.height + 48 : route === 3 ? -48 : silksongParticles.height * seedY + (route === 0 ? -driftY : driftY)

            x: baseX
            y: baseY
            width: 4 + (modelData % 3)
            height: width

            Rectangle {
              anchors.centerIn: parent
              width: parent.width * 4.5
              height: width
              radius: width / 2
              color: "#ebd28d"
              opacity: 0.12
            }

            Rectangle {
              anchors.centerIn: parent
              width: parent.width * 0.65
              height: width
              radius: width / 2
              color: "#ebd28d"
              opacity: 0.9
            }

            PathAnimation {
              target: firefly
              loops: Animation.Infinite
              running: root.silksongActive && firefly.motionType === 2
              duration: 26000 + modelData * 1800
              path: Path {
                startX: firefly.startX
                startY: firefly.startY
                PathCubic {
                  x: (firefly.startX + firefly.endX) / 2
                  y: (firefly.startY + firefly.endY) / 2 + (modelData % 3 - 1) * 160
                  control1X: firefly.startX + (firefly.endX - firefly.startX) * 0.2
                  control1Y: firefly.startY + (firefly.endY - firefly.startY) * 0.2 + (modelData % 5 - 2) * 150
                  control2X: firefly.startX + (firefly.endX - firefly.startX) * 0.4
                  control2Y: firefly.startY + (firefly.endY - firefly.startY) * 0.4 - (modelData % 4 - 1) * 130
                }
                PathCubic {
                  x: firefly.endX
                  y: firefly.endY
                  control1X: (firefly.startX + firefly.endX) / 2 + (modelData % 5 - 2) * 140
                  control1Y: (firefly.startY + firefly.endY) / 2 + (modelData % 4 - 1) * 130
                  control2X: firefly.startX + (firefly.endX - firefly.startX) * 0.82
                  control2Y: firefly.startY + (firefly.endY - firefly.startY) * 0.82 - (modelData % 5 - 2) * 140
                }
              }
            }

            SequentialAnimation on x {
              loops: Animation.Infinite
              running: root.silksongActive && firefly.motionType < 2
              NumberAnimation { from: firefly.baseX - 52; to: firefly.baseX + 52; duration: 10500 + modelData * 700; easing.type: Easing.InOutSine }
              NumberAnimation { from: firefly.baseX + 52; to: firefly.baseX - 52; duration: 11800 + modelData * 650; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on y {
              loops: Animation.Infinite
              running: root.silksongActive && firefly.motionType < 2
              NumberAnimation { from: firefly.baseY - 38; to: firefly.baseY + 38; duration: 9800 + modelData * 750; easing.type: Easing.InOutSine }
              NumberAnimation { from: firefly.baseY + 38; to: firefly.baseY - 38; duration: 11200 + modelData * 600; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on opacity {
              loops: Animation.Infinite
              running: root.silksongActive
              PauseAnimation { duration: modelData * 850 }
              NumberAnimation { to: 0.35; duration: 1500; easing.type: Easing.InOutSine }
              NumberAnimation { to: 1.0; duration: 1900; easing.type: Easing.InOutSine }
              NumberAnimation { to: 0.55; duration: 1200; easing.type: Easing.InOutSine }
            }
          }
        }

        // Fine dust is almost still at a glance, then reveals itself through
        // slow diagonal drift when the desktop is watched for a few seconds.
        Repeater {
          model: 18

          Item {
            id: dust
            required property int modelData
            readonly property int motionType: modelData % 5
            readonly property int route: (modelData + 2) % 4
            readonly property real seedX: ((modelData * 89 + 9) % 103) / 100
            readonly property real seedY: ((modelData * 131 + 31) % 101) / 100
            readonly property real baseX: silksongParticles.width * seedX
            readonly property real baseY: silksongParticles.height * seedY
            readonly property real startX: route === 0 ? -12 : route === 1 ? silksongParticles.width + 12 : silksongParticles.width * seedX
            readonly property real endX: route === 0 ? silksongParticles.width + 12 : route === 1 ? -12 : silksongParticles.width * seedX + (route === 2 ? 22 : -22)
            readonly property real startY: route === 2 ? -12 : route === 3 ? silksongParticles.height + 12 : silksongParticles.height * seedY
            readonly property real endY: route === 2 ? silksongParticles.height + 12 : route === 3 ? -12 : silksongParticles.height * seedY + (route === 0 ? -12 : 12)

            x: baseX
            y: baseY
            width: 1.2 + (modelData % 3) * 0.6
            height: width

            Rectangle {
              anchors.fill: parent
              radius: width / 2
              color: modelData % 4 === 0 ? "#ebd28d" : "#d6e2df"
              opacity: 0.22
            }

            PathAnimation {
              target: dust
              loops: Animation.Infinite
              running: root.silksongActive && dust.motionType === 4
              duration: 34000 + modelData * 1200
              path: Path {
                startX: dust.startX
                startY: dust.startY
                PathCubic {
                  x: (dust.startX + dust.endX) / 2
                  y: (dust.startY + dust.endY) / 2 + (modelData % 4 - 2) * 55
                  control1X: dust.startX + (dust.endX - dust.startX) * 0.24
                  control1Y: dust.startY + (dust.endY - dust.startY) * 0.24 + (modelData % 5 - 2) * 60
                  control2X: dust.startX + (dust.endX - dust.startX) * 0.42
                  control2Y: dust.startY + (dust.endY - dust.startY) * 0.42 - (modelData % 4 - 1) * 50
                }
                PathCubic {
                  x: dust.endX
                  y: dust.endY
                  control1X: (dust.startX + dust.endX) / 2 + (modelData % 5 - 2) * 55
                  control1Y: (dust.startY + dust.endY) / 2 + (modelData % 4 - 1) * 50
                  control2X: dust.startX + (dust.endX - dust.startX) * 0.78
                  control2Y: dust.startY + (dust.endY - dust.startY) * 0.78 - (modelData % 5 - 2) * 55
                }
              }
            }

            SequentialAnimation on x {
              loops: Animation.Infinite
              running: root.silksongActive && dust.motionType !== 4
              NumberAnimation { from: dust.baseX - 18; to: dust.baseX + 18; duration: 14500 + modelData * 500; easing.type: Easing.InOutSine }
              NumberAnimation { from: dust.baseX + 18; to: dust.baseX - 18; duration: 15800 + modelData * 450; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on y {
              loops: Animation.Infinite
              running: root.silksongActive && dust.motionType < 3
              NumberAnimation { from: dust.baseY - 16; to: dust.baseY + 16; duration: 15000 + modelData * 520; easing.type: Easing.InOutSine }
              NumberAnimation { from: dust.baseY + 16; to: dust.baseY - 16; duration: 16600 + modelData * 440; easing.type: Easing.InOutSine }
            }

            SequentialAnimation on y {
              loops: Animation.Infinite
              running: root.silksongActive && dust.motionType === 3
              PauseAnimation { duration: (modelData % 4) * 1100 }
              NumberAnimation { from: dust.baseY - 45; to: dust.baseY + 85; duration: 13000 + modelData * 700; easing.type: Easing.InQuad }
              NumberAnimation { from: dust.baseY + 85; to: dust.baseY - 45; duration: 17600 + modelData * 650; easing.type: Easing.OutQuad }
            }
          }
        }
      }

      Item {
        id: revealMask
        anchors.fill: parent
        visible: false
        layer.enabled: true

        readonly property real slant: -0.18
        readonly property real centerTop: width / 2 - slant * height / 2
        readonly property real centerBottom: width / 2 + slant * height / 2
        readonly property real reach: width / 2 + Math.abs(slant) * height / 2 + 4
        readonly property real spread: reach * root.revealProgress

        Shape {
          anchors.fill: parent
          antialiasing: true
          preferredRendererType: Shape.CurveRenderer
          ShapePath {
            fillColor: "white"
            strokeColor: "transparent"
            startX: revealMask.centerTop - revealMask.spread; startY: 0
            PathLine { x: revealMask.centerTop + revealMask.spread; y: 0 }
            PathLine { x: revealMask.centerBottom + revealMask.spread; y: revealMask.height }
            PathLine { x: revealMask.centerBottom - revealMask.spread; y: revealMask.height }
            PathLine { x: revealMask.centerTop - revealMask.spread; y: 0 }
          }
        }
      }

      Connections {
        target: root
        function onIncomingBackgroundChanged() {
          panel.maskReady = false
          panel.maybeStartReveal()
        }
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onDoubleClicked: function(mouse) {
          if (mouse.button === Qt.RightButton) root.openThemeSwitcher()
          else root.openSelector()
          mouse.accepted = true
        }
      }
    }
  }
}

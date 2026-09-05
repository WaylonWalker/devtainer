import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd

Item {
  id: root
  width: 1920
  height: 1080
  focus: true

  property string selectedUser: "waylon"
  property string password: ""
  property string statusText: ""
  property bool choosingUser: false
  property bool authenticating: false
  property color bg: "#1a1b26"
  property color fg: "#c0caf5"
  property color accent: "#7aa2f7"
  property color dim: "#565f89"
  property string wallpaper: ""
  property date now: new Date()

  function selectUser(name) {
    selectedUser = name
    password = ""
    statusText = ""
    choosingUser = false
    input.forceActiveFocus()
  }

  function login() {
    if (password.length === 0 || authenticating) return
    authenticating = true
    statusText = "Checking…"
    Greetd.createSession(selectedUser)
  }

  function parseUser(line) {
    var p = line.split(":")
    if (p.length < 7) return
    var uid = Number(p[2])
    var shell = p[6]
    if (uid >= 1000 && uid < 60000 && shell.indexOf("nologin") < 0 && shell.indexOf("false") < 0)
      users.append({name: p[0], realName: p[4].split(",")[0]})
  }

  FileView {
    path: "/tmp/omarchy-greetd-theme.json"
    printErrors: false
    watchChanges: true
    onLoaded: applyTheme()
    onFileChanged: reload()
    function applyTheme() {
      try {
        var t = JSON.parse(String(text()))
        if (t.background) root.bg = t.background
        if (t.foreground) root.fg = t.foreground
        if (t.accent) root.accent = t.accent
        if (t.dim) root.dim = t.dim
        if (t.wallpaper) root.wallpaper = t.wallpaper
      } catch (e) {}
    }
  }

  ListModel { id: users }
  Process {
    command: ["/usr/bin/getent", "passwd"]
    running: true
    stdout: SplitParser { onRead: data => root.parseUser(String(data).trim()) }
  }

  Connections {
    target: Greetd
    function onAuthMessage(message, error, responseRequired, echoResponse) {
      if (responseRequired) Greetd.respond(root.password)
    }
    function onAuthFailure(message) {
      root.authenticating = false
      root.password = ""
      root.statusText = message || "Login incorrect"
      input.forceActiveFocus()
    }
    function onReadyToLaunch() {
      Greetd.launch(["/usr/bin/start-hyprland"])
    }
    function onError(error) {
      root.authenticating = false
      root.statusText = error
    }
  }

  Rectangle { anchors.fill: parent; color: root.bg }
  Image {
    anchors.fill: parent
    source: root.wallpaper.length > 0 ? "file://" + root.wallpaper : ""
    fillMode: Image.PreserveAspectCrop
    visible: status === Image.Ready
    opacity: 0.82
  }
  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#66000000" }
      GradientStop { position: 0.48; color: "#22000000" }
      GradientStop { position: 1.0; color: "#99000000" }
    }
  }

  Column {
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: Math.round(Math.min(root.width, root.height) * 0.08)
    anchors.topMargin: Math.round(Math.min(root.width, root.height) * 0.048)
    spacing: 6
    Text { anchors.right: parent.right; text: Qt.formatTime(root.now, "HH"); color: root.fg; font.pixelSize: 210; font.weight: Font.Black; font.letterSpacing: -8 }
    Text { anchors.right: parent.right; text: Qt.formatTime(root.now, "mm"); color: root.accent; font.pixelSize: 210; font.weight: Font.Black; font.letterSpacing: -8 }
    Text { anchors.right: parent.right; text: Qt.formatDate(root.now, "dddd").toUpperCase(); color: root.fg; font.pixelSize: 28; font.letterSpacing: 6 }
    Text { anchors.right: parent.right; text: Qt.formatDate(root.now, "d MMMM yyyy").toUpperCase(); color: Qt.alpha(root.fg, 0.7); font.pixelSize: 20; font.letterSpacing: 4 }
  }

  Column {
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: Math.round(Math.min(root.width, root.height) * 0.08)
    anchors.bottomMargin: Math.round(Math.min(root.width, root.height) * 0.08)
    spacing: 14

    Row {
      spacing: 12
      Text { text: selectedUser.charAt(0).toUpperCase(); color: root.accent; font.pixelSize: 42; font.bold: true; width: 44; horizontalAlignment: Text.AlignHCenter }
      Column {
        Text { text: root.selectedUser; color: root.fg; font.pixelSize: 28; font.bold: true }
        Text { text: root.statusText.length > 0 ? root.statusText : "omarchy"; color: root.statusText.length > 0 ? "#f7768e" : Qt.alpha(root.fg, 0.6); font.pixelSize: 18 }
      }
    }

    Rectangle {
      width: 360; height: 56; radius: 10
      color: Qt.alpha(root.bg, 0.78)
      border.width: 2; border.color: root.statusText.length > 0 ? "#f7768e" : root.accent
      TextInput {
        id: input
        anchors.fill: parent; anchors.leftMargin: 48; anchors.rightMargin: 18
        verticalAlignment: TextInput.AlignVCenter
        echoMode: TextInput.Password; color: root.fg; font.pixelSize: 22
        text: root.password
        onTextChanged: root.password = text
        Keys.onReturnPressed: root.login()
        Keys.onEnterPressed: root.login()
      }
      Text { anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "󰌾"; color: root.dim; font.pixelSize: 25 }
      Text { anchors.fill: parent; anchors.leftMargin: 48; verticalAlignment: Text.AlignVCenter; text: "Password"; color: root.dim; font.pixelSize: 20; visible: input.text.length === 0 }
    }

    Item {
      width: 360; height: choosingUser ? Math.min(260, users.count * 34 + 12) : 24
      Text { anchors.horizontalCenter: parent.horizontalCenter; text: choosingUser ? "select user" : "switch user"; color: root.dim; font.pixelSize: 15 }
      MouseArea { anchors.fill: parent; onClicked: { root.choosingUser = !root.choosingUser; if (root.choosingUser) root.focus = true } }
      Rectangle {
        visible: choosingUser
        anchors.top: parent.top
        anchors.topMargin: 28
        width: parent.width
        height: parent.height - 28
        color: Qt.alpha(root.bg, 0.94)
        radius: 8
        border.color: Qt.alpha(root.fg, 0.18)
        border.width: 1

        ListView {
          anchors.fill: parent
          anchors.margins: 6
          model: users

          delegate: Rectangle {
            required property string name
            required property string realName
            width: ListView.view.width
            height: 32
            radius: 5
            color: name === root.selectedUser ? Qt.alpha(root.accent, 0.24) : "transparent"

            Text {
              anchors.fill: parent
              anchors.leftMargin: 12
              verticalAlignment: Text.AlignVCenter
              text: realName.length > 0 ? realName + "  (" + name + ")" : name
              color: name === root.selectedUser ? root.accent : root.fg
              font.pixelSize: 15
            }

            MouseArea {
              anchors.fill: parent
              onClicked: root.selectUser(name)
            }
          }
        }
      }
    }
  }
  Timer { interval: 1000; running: true; repeat: true; onTriggered: root.now = new Date() }
  Component.onCompleted: input.forceActiveFocus()
}

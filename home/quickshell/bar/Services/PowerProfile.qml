pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  readonly property var profiles: ["power-saver", "balanced", "performance"]
  property string current: ""
  property bool available: false

  function setProfile(p) {
    if (!available)
      return
    Quickshell.execDetached(["powerprofilesctl", "set", p])
    root.current = p
    refresh.restart()
  }

  function iconFor(p) {
    return p === "power-saver" ? "leaf"
         : p === "performance" ? "rocket"
         :                       "scale"
  }

  function labelFor(p) {
    return p === "power-saver" ? "Power Saver"
         : p === "performance" ? "Performance"
         :                       "Balanced"
  }

  Process {
    id: probe
    command: ["sh", "-c", "command -v powerprofilesctl"]
    running: true
    onExited: (code) => {
      root.available = (code === 0)
      if (root.available)
        getProc.running = true
    }
  }

  Process {
    id: getProc
    command: ["powerprofilesctl", "get"]
    stdout: StdioCollector { onStreamFinished: root.current = text.trim() }
  }

  Timer { id: refresh; interval: 400; onTriggered: if (root.available) getProc.running = true }
  Timer { interval: 8000; running: true; repeat: true; onTriggered: if (root.available) getProc.running = true }
}

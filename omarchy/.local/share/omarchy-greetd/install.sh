#!/usr/bin/env bash
set -euo pipefail

src="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install -d -m 755 /usr/local/share/omarchy-greetd
install -Dm644 "$src/Main.qml" /usr/local/share/omarchy-greetd/Main.qml
install -Dm644 "$src/shell.qml" /usr/local/share/omarchy-greetd/shell.qml
install -Dm755 "$src/launcher" /usr/local/bin/omarchy-greetd-launcher

install -d -m 755 /etc/greetd
if [[ -f /etc/greetd/config.toml && ! -f /etc/greetd/config.toml.omarchy-sddm-backup ]]; then
  cp -a /etc/greetd/config.toml /etc/greetd/config.toml.omarchy-sddm-backup
fi
install -Dm644 "$src/config.toml" /etc/greetd/config.toml

echo "Installed the staged Omarchy Quickshell greeter."
echo "SDDM is still active; switch display managers only after testing."

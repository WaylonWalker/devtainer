#!/usr/bin/env bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1; then
	SUDO="sudo"
else
	SUDO=""
fi
# Universal packages across Arch, Alpine, Debian, Ubuntu, Fedora
PACKAGES=(
	bat
	ca-certificates
	cargo
	chromium
	curl
	entr
	fd
	ffmpeg
	fzf
	git
	go
	make
	pciutils
	podman
	ripgrep
	sqlite
	stow
	tmux
	unzip
	vlc
	xclip
	zsh
	nodejs
	npm
	python3
	pip
)

install_arch() {
	$SUDO pacman -Syu --noconfirm
	$SUDO pacman -S --noconfirm base-devel "${PACKAGES[@]/pip/python-pip}"
}

install_alpine() {
	$SUDO apk update
	$SUDO apk add --no-cache alpine-sdk \
		bash \
		"${PACKAGES[@]/pip/py3-pip}" \
		python3 \
		sqlite-dev \
		readline-dev \
		openssl-dev \
		bzip2-dev \
		musl-dev
}

install_debian() {
	$SUDO apt-get update
	$SUDO apt-get install -y --no-install-recommends \
		build-essential \
		"${PACKAGES[@]/pip/python3-pip}" \
		libbz2-dev \
		libc6-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev
	$SUDO apt-get clean
	$SUDO rm -rf /var/lib/apt/lists/*
}

install_fedora() {
	$SUDO dnf groupinstall -y "Development Tools"
	$SUDO dnf install -y \
		"${PACKAGES[@]/pip/python3-pip}" \
		bzip2-devel \
		glibc-devel \
		readline-devel \
		sqlite-devel \
		openssl-devel
}

detect_distro_and_install() {
	if [[ -f /etc/os-release ]]; then
		. /etc/os-release
		case "$ID" in
		arch) install_arch ;;
		alpine) install_alpine ;;
		debian | ubuntu) install_debian ;;
		fedora) install_fedora ;;
		*) echo "Unsupported distro: $ID" && exit 1 ;;
		esac
	else
		echo "Cannot detect OS. /etc/os-release missing." && exit 1
	fi
}

main() {
	mkdir -p ~/.local/bin
	detect_distro_and_install
	echo "✔️ Base system packages + dev tools installed successfully."
}

main "$@"

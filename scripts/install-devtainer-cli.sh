#!/usr/bin/env bash
set -euo pipefail

REPO="waylonwalker/devtainer"
BINARY_NAME="devtainer"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"
BASE_URL="${BASE_URL:-https://github.com/${REPO}/releases}"

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "$arch" in
  x86_64|amd64)
    arch="amd64"
    ;;
  aarch64|arm64)
    arch="arm64"
    ;;
  *)
    printf 'Unsupported architecture: %s\n' "$arch" >&2
    exit 1
    ;;
esac

case "$os" in
  linux|darwin)
    ;;
  *)
    printf 'Unsupported operating system: %s\n' "$os" >&2
    exit 1
    ;;
esac

asset="${BINARY_NAME}_${os}_${arch}.tar.gz"

if [ "$VERSION" = "latest" ]; then
  url="${BASE_URL}/latest/download/${asset}"
else
  url="${BASE_URL}/download/${VERSION}/${asset}"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

printf 'Downloading %s\n' "$url" >&2
if ! curl -fsSL "$url" -o "$tmp_dir/$asset"; then
  printf 'Failed to download %s\n' "$url" >&2
  printf 'Make sure the GitHub Release exists and includes asset %s.\n' "$asset" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
tar -xzf "$tmp_dir/$asset" -C "$tmp_dir"
install -m 0755 "$tmp_dir/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"

printf 'Installed %s to %s\n' "$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME" >&2
printf 'Run `%s version` to verify.\n' "$INSTALL_DIR/$BINARY_NAME" >&2

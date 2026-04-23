#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# ///

from __future__ import annotations

import sys


def get_release_notes(version):
    with open("CHANGELOG.md", "r") as f:
        content = f.read()

    sections = content.split("\n## ")
    # First section won't start with ## since it's split on that
    sections = ["## " + s if i > 0 else s for i, s in enumerate(sections)]

    for section in sections:
        if section.startswith(f"## {version}"):
            install_instructions = f"""## Install CLI

Install the latest `devtainer` CLI release:

```bash
curl -fsSL https://github.com/waylonwalker/devtainer/releases/latest/download/devtainer-install.sh | sh
```

Install this specific release:

```bash
curl -fsSL https://github.com/waylonwalker/devtainer/releases/latest/download/devtainer-install.sh | VERSION=v{version} sh
```

## Bootstrap

```bash
bw-unlock
devtainer config init --profile personal
devtainer bootstrap bitwarden
devtainer doctor
```

## Container Images

Container images are published to GitHub Container Registry (GHCR).

- `latest`: Ubuntu 24.04 daily-driver image
- `slim`: lighter Ubuntu 24.04 image
- `alpine`: Alpine Edge image for smaller environments and compatibility checks
- `alpine-slim`: smaller Alpine core shell/editor image
- `arch`: full-featured Arch Linux image
- `arch-slim`: leaner Arch Linux image with the same base distro

Release tags include:

- `ghcr.io/waylonwalker/devtainer:{version}`
- `ghcr.io/waylonwalker/devtainer:slim-{version}`
- `ghcr.io/waylonwalker/devtainer:alpine-{version}`
- `ghcr.io/waylonwalker/devtainer:alpine-slim-{version}`
- `ghcr.io/waylonwalker/devtainer:arch-{version}`
- `ghcr.io/waylonwalker/devtainer:arch-slim-{version}`

Use GHCR as the canonical registry.

## Run One Container

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:{version}
```

## Use One Distrobox

```bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini --name devtainer
distrobox enter devtainer
```
"""

            return (
                f"{section.strip()}\n\n{install_instructions.format(version=version)}"
            )

    return None


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: get_release_notes.py VERSION", file=sys.stderr)
        sys.exit(1)

    version = sys.argv[1]
    notes = get_release_notes(version)
    if notes:
        print(notes)
    else:
        print(f"Error: No release notes found for version {version}", file=sys.stderr)
        sys.exit(1)

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
            install_instructions = f"""## Containers

Container images are published to GitHub Container Registry (GHCR). `latest`
and `slim` use Ubuntu 24.04, `alpine` and `alpine-slim` use Alpine Edge, and
`arch` and `arch-slim` use Arch Linux.

### Pull And Run

Use `podman` or `docker` with the tag that fits your base distro and size.

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:latest
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:{version}
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:slim
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:alpine
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:alpine-slim
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:arch
```

```bash
podman run --rm -it ghcr.io/waylonwalker/devtainer:arch-slim
```

### Distrobox

Use the repo's distrobox manifest to create a persistent dev environment.

```bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini --name devtainer
distrobox enter devtainer
```

```bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini --name devtainer-arch
distrobox enter devtainer-arch
```

```bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini --name devtainer-slim
distrobox enter devtainer-slim
```

```bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini --name devtainer-alpine
distrobox enter devtainer-alpine
```

### Tags

Release tags include:

- `ghcr.io/waylonwalker/devtainer:{version}`
- `ghcr.io/waylonwalker/devtainer:slim-{version}`
- `ghcr.io/waylonwalker/devtainer:alpine-{version}`
- `ghcr.io/waylonwalker/devtainer:alpine-slim-{version}`
- `ghcr.io/waylonwalker/devtainer:arch-{version}`
- `ghcr.io/waylonwalker/devtainer:arch-slim-{version}`

Docker Hub mirrors the same tags (`docker.io/waylonwalker/devtainer:*`) for
compatibility, but GHCR is the canonical registry for releases and docs.

## Neovim Config

Install the repo's Neovim config as a separate app with `nvim-manager`.

```bash
export NVIM_MANAGER_GITHUB_REPO=https://github.com/WaylonWalker/devtainer
export NVIM_CONFIG_PATH=nvim/.config/nvim
export NVIM_MANAGER_INSTALL_DIR=$HOME/.config
export NVIM_MANAGER_PREFIX="nvim-waylonwalker-"
export NVIM_APPNAME="nvim-waylonwalker-{version}"

nvim-manager install v{version}
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

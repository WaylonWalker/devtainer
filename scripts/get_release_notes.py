#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# ///

import sys


def get_release_notes(version):
    with open("CHANGELOG.md", "r") as f:
        content = f.read()

    sections = content.split("\n## ")
    # First section won't start with ## since it's split on that
    sections = ["## " + s if i > 0 else s for i, s in enumerate(sections)]

    for section in sections:
        if section.startswith(f"## {version}"):
            install_instructions = f"""## Installation

To run devtainer with docker.

```
docker run --rm waylonwalker/devtainer:{version}
```

To use devtainer with distrobox.

``` bash
distrobox assemble create --file ~/devtainer/distrobox/distrobox.ini -n devtainer
distrobox-enter devtainer
```

To use my nvim dotfiles.

``` bash
export NVIM_MANAGER_GITHUB_REPO=https://github.com/WaylonWalker/devtainer
export NVIM_CONFIG_PATH=nvim/.config/nvim
export NVIM_MANAGER_INSTALL_DIR=$HOME/.config
export NVIM_MANAGER_PREFIX="nvim-waylonwalker-"
export NVIM_APPNAME="nvim-waylonwalker-{version}"

nvim-manager install v{version}
```
"""

        return f"{section.strip()}\n\n{install_instructions.format(version=version)}"

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

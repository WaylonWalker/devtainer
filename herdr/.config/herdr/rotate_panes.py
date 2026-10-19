#!/usr/bin/env python3
import json
import os
import subprocess
import sys


def rotate(herdr: str, pane: str) -> None:
    response = subprocess.check_output(
        [herdr, "pane", "layout", "--pane", pane], text=True
    )
    panes = [
        item["pane_id"] for item in json.loads(response)["result"]["layout"]["panes"]
    ]
    if not panes:
        raise ValueError("the tab has no panes")

    # tmux rotate-window moves the last pane into the first layout position.
    for target in reversed(panes[:-1]):
        subprocess.run(
            [herdr, "pane", "swap", "--source-pane", panes[-1],
             "--target-pane", target],
            check=True,
            stdout=subprocess.DEVNULL,
        )


if __name__ == "__main__":
    try:
        pane = os.environ.get("HERDR_ACTIVE_PANE_ID") or os.environ["HERDR_PANE_ID"]
        rotate(os.environ.get("HERDR_BIN_PATH", "herdr"), pane)
    except (KeyError, ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"Herdr pane rotation failed: {error}", file=sys.stderr)
        sys.exit(1)

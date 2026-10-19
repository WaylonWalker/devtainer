import importlib.util
import json
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).parents[2] / "herdr/.config/herdr/rotate_panes.py"


class RotatePanesTests(unittest.TestCase):
    def setUp(self):
        spec = importlib.util.spec_from_file_location("rotate_panes", SCRIPT)
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)

    def test_rotates_down_without_changing_layout_or_processes(self):
        panes = ["w1:p1", "w1:p2", "w1:p3", "w1:p4"]
        original = panes.copy()
        layout = {"result": {"layout": {"panes": [
            {"pane_id": pane} for pane in panes
        ]}}}

        def swap(command, **kwargs):
            self.assertEqual(command[:3], ["herdr-test", "pane", "swap"])
            self.assertEqual(command[3::2], ["--source-pane", "--target-pane"])
            source, target = command[4::2]
            left, right = panes.index(source), panes.index(target)
            panes[left], panes[right] = panes[right], panes[left]

        with patch.object(self.module.subprocess, "check_output",
                          return_value=json.dumps(layout)) as read:
            with patch.object(self.module.subprocess, "run", side_effect=swap):
                self.module.rotate("herdr-test", "w1:p2")

        read.assert_called_once_with(
            ["herdr-test", "pane", "layout", "--pane", "w1:p2"], text=True
        )
        self.assertEqual(panes, [original[-1], *original[:-1]])

    def test_single_pane_does_not_swap(self):
        layout = {"result": {"layout": {"panes": [{"pane_id": "w1:p1"}]}}}
        with patch.object(self.module.subprocess, "check_output",
                          return_value=json.dumps(layout)):
            with patch.object(self.module.subprocess, "run") as swap:
                self.module.rotate("herdr-test", "w1:p1")
        swap.assert_not_called()

    def test_failed_swap_stops_rotation(self):
        layout = {"result": {"layout": {"panes": [
            {"pane_id": f"w1:p{i}"} for i in range(1, 4)
        ]}}}
        with patch.object(self.module.subprocess, "check_output",
                          return_value=json.dumps(layout)):
            with patch.object(
                self.module.subprocess, "run",
                side_effect=subprocess.CalledProcessError(1, "swap"),
            ) as swap:
                with self.assertRaises(subprocess.CalledProcessError):
                    self.module.rotate("herdr-test", "w1:p1")
        self.assertEqual(swap.call_count, 1)


if __name__ == "__main__":
    unittest.main()

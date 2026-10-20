"""Prepare the private closure/value pair, never the production/private pair."""
from pathlib import Path
import argparse
import json
import subprocess
import sys

archive = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument("--workspace", default="/workspace")
parser.add_argument("--baseline-root", default="/baseline")
parser.add_argument("--output", default="/evidence/paired")
args = parser.parse_args()
assert Path(args.workspace).resolve() != Path(args.baseline_root).resolve(), "roles need distinct checkout paths"
output = Path(args.output).resolve()
output.mkdir(parents=True, exist_ok=False)
replacements = {}
for variant, workspace, role in [
    ("token-start", args.baseline_root, "before"),
    ("value-restore", args.workspace, "after"),
]:
    destination = output / role
    subprocess.run([
        sys.executable, str(archive / "prepare-replay.py"), variant,
        "--workspace", workspace, "--output", str(destination),
    ], check=True)
    replacements.update(json.loads((destination / "overlay.json").read_text())["Replace"])
    # Both roles retain the same private-protocol work pins and production
    # source/deep-tree pins. The production benchmark itself stays untouched.
    replacements[str(Path(workspace).resolve() / "zz_dispatch_restore_pair_bench_test.go")] = str(
        archive / "value-restore/restore_pair_bench_test.go.txt"
    )
(output / "overlay.json").write_text(json.dumps({"Replace": replacements}, indent=2) + "\n")
print("Prepared private token-start/value-restoration pair:", output / "overlay.json")

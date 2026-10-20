"""Reconstruct a private protocol in external storage without editing the checkout."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import subprocess

archive = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument("variant")
parser.add_argument("--baseline", action="store_true")
parser.add_argument("--workspace", default="/workspace")
parser.add_argument("--output", default="/evidence/replay")
args = parser.parse_args()
workspace = Path(args.workspace).resolve()
output = Path(args.output).resolve()
variant = archive / args.variant

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

baseline = json.loads((archive / "baseline-source-pins.json").read_text())
assert len(baseline) == 3512
for name, expected in baseline.items():
    assert digest(workspace / name) == expected, ("baseline", name)
output.mkdir(parents=True, exist_ok=False)
replacements = {}
if not args.baseline:
    runtime = output / "runtime"
    runtime.mkdir()
    pins = json.loads((variant / "source-pins.json").read_text())
    for name in pins:
        source, target = workspace / name, runtime / name
        if source.exists():
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
    subprocess.run(
        ["git", "apply", "--unidiff-zero", str(variant / "runtime.patch")],
        cwd=runtime, check=True,
    )
    for name, expected in pins.items():
        assert digest(runtime / name) == expected, ("runtime", name)
        replacements[str(workspace / name)] = str(runtime / name)

probes = json.loads((variant / "probe-pins.json").read_text())
for name, expected in probes.items():
    assert digest(variant / name) == expected, ("probe", name)
targets = {
    "cgo_probe_test.go.txt": "cgo_harness/zz_go_generic_frontier_test.go",
    "expanded_probe_test.go.txt": "cgo_harness/zz_go_token_turn_expanded_test.go",
    "edit_sessions_test.go.txt": "cgo_harness/zz_go_version_turn_edits_test.go",
    "cohort_regression_test.go.txt": "zz_cohort_frontier_regression_test.go",
    "root-negative_test.go.txt": "zz_dfa_restore_negative_test.go",
    "canonical_work_census_test.go.txt": "zz_canonical_work_census_test.go",
    "profile_probe_test.go.txt": "zz_diagnostic_cohort_frontier_profile_test.go",
    "restore_pair_bench_test.go.txt": "zz_dispatch_restore_pair_bench_test.go",
    "counter_main.go.txt": "cmd/perfcounterledger/main.go",
}
for name, target in targets.items():
    if name in probes and not (args.baseline and name == "root-negative_test.go.txt"):
        replacements[str(workspace / target)] = str(variant / name)
(output / "overlay.json").write_text(json.dumps({"Replace": replacements}, indent=2) + "\n")
print("All 3512 baseline hashes and selected runtime/probe hashes match:", output / "overlay.json")

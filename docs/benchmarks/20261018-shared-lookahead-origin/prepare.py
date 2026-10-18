#!/usr/bin/env python3
"""Install archived diagnostic inputs in an explicitly isolated baseline checkout."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument('--root', type=Path, required=True)
p.add_argument('--variant', choices=['origin', 'eager', 'reduction-entry', 'late-fork', 'pending-origin', 'phase-counter', 'ledger'], required=True)
p.add_argument('--output-dir', type=Path, required=True)
a = p.parse_args()
evidence = Path(__file__).resolve().parent
root = a.root.resolve()
ref = json.loads((evidence / 'baseline-reference.json').read_text())
revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
if revision != ref['baseline_runtime']:
    raise SystemExit('Use an isolated checkout at the exact baseline runtime.')
if subprocess.check_output(['git', 'status', '--porcelain'], cwd=root, text=True):
    raise SystemExit('The isolated checkout must be clean.')
manifest_path = (evidence / ref['baseline_source_pins_reference']).resolve()
assert hashlib.sha256(manifest_path.read_bytes()).hexdigest() == ref['baseline_source_pins_sha256']
for name, expected in json.loads(manifest_path.read_text()).items():
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == expected, name
patches = {'origin': 'origin-census', 'eager': 'eager-ownership', 'reduction-entry': 'reduction-entry', 'late-fork': 'late-fork', 'pending-origin': 'pending-origin', 'phase-counter': 'phase-counter', 'ledger': 'reduction-entry'}
patch = evidence / (patches[a.variant] + '.patch')
files = {}
if a.variant == 'origin':
    files = {'shared_origin_export_test.go.txt': 'zz_shared_origin_export_test.go', 'shared_origin_trace_test.go.txt': 'zz_shared_origin_trace_test.go'}
    command = "cd /workspace\ngo test . -tags gts_parsercorephase0 -run '^TestYAMLSharedLookaheadOriginTrace$' -count=1 -v -timeout=8m"
else:
    probes = {'eager': 'eager_probe.go.txt', 'reduction-entry': 'reduction_entry_probe.go.txt', 'late-fork': 'late_fork_probe.go.txt', 'pending-origin': 'pending_origin_probe.go.txt', 'phase-counter': 'reduction_entry_probe.go.txt', 'ledger': 'reduction_entry_probe.go.txt'}
    files[probes[a.variant]] = 'zz_actual_shared_request_probe.go'
    if a.variant == 'phase-counter':
        files.update({'work_capture.go.txt': 'zz_actual_shared_work_capture.go', 'phase_counter_test.go.txt': 'zz_actual_shared_phase_counter_test.go', 'invariant_init_test.go.txt': 'zz_actual_shared_invariant_init_test.go'})
        command = "cd /workspace\ngo test . -tags gts_parsercorephase0 -run '^TestActualSharedRequestPhaseCounters$' -count=1 -v -timeout=8m\nGTS_ACTUAL_SHARED_INVARIANT=1 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=yaml go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=8m"
    elif a.variant == 'ledger':
        files['counter_main.go.txt'] = 'cmd/perfcounterledger/main.go'
        command = 'cd /workspace\nfor role in ordinary owned actual; do\n GTS_ACTUAL_SHARED_ROLE=$role go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > /evidence/$role-ledger.json\ndone'
    else:
        fixture = 'pending_origin_locked_c_test.go.txt' if a.variant == 'pending-origin' else 'locked_c_test.go.txt'
        files[fixture] = 'cgo_harness/zz_actual_shared_request_locked_c_test.go'
        command = "cd /workspace/cgo_harness\ngo test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestActualSharedRequestLockedC$' -count=1 -v -timeout=12m"
for target in files.values():
    if (root / target).exists() and not (a.variant == 'ledger' and target == 'cmd/perfcounterledger/main.go'):
        raise SystemExit('Refusing to overwrite ' + target)
if a.output_dir.exists():
    raise SystemExit('Output directory must be new.')
subprocess.run(['git', 'apply', '--check', str(patch)], cwd=root, check=True)
subprocess.run(['git', 'apply', str(patch)], cwd=root, check=True)
for source, target in files.items():
    (root / target).write_bytes((evidence / source).read_bytes())
a.output_dir.mkdir(parents=True)
(a.output_dir / 'run.sh').write_text("#!/usr/bin/env bash\nset -euo pipefail\nexport GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false'\n" + command + '\n')
print('Prepared', a.variant, 'in', root, 'with runner', a.output_dir / 'run.sh')

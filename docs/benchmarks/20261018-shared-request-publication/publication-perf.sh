#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/atomic-root-complete.txt
test -f /evidence/paired-c-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/perf-overlay.json'
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml GIT_OPTIONAL_LOCKS=0
python3 - <<'GATE'
import json
from pathlib import Path
p=Path('/evidence');assert json.loads((p/'atomic-counter-gate.json').read_text())['status']=='pass_against_unpromoted_prototype';assert json.loads((p/'paired-ledger-gate.json').read_text())['equal']
GATE
git config --global --add safe.directory /workspace
git config --global --add safe.directory /baseline
cd /workspace
bash scripts/run_randomized_benchmarks.sh --output /evidence/publication-head.txt --baseline-root /baseline --baseline-output /evidence/publication-base.txt --bench-regex '^BenchmarkSharedRequestPublication(R4|8KiB|LegacyControl)$' --require-benchmarks BenchmarkSharedRequestPublicationR4,BenchmarkSharedRequestPublication8KiB,BenchmarkSharedRequestPublicationLegacyControl --runs 20 --seed-start 33901 --benchtime 750ms > /evidence/publication-perf.log 2>&1
printf 'complete\n' > /evidence/publication-perf-complete.txt

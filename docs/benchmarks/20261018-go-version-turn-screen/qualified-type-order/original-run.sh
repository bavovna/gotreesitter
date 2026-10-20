#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/baseline-overlay.json'
cd /workspace/cgo_harness
base_status=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoTokenTurnExpandedLockedCProbe$' -count=1 -v -timeout=8m > /evidence/baseline-expanded.log 2>&1 || base_status=$?
printf '%s\n' "$base_status" > /evidence/baseline-exit.txt
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
probe_status=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoDFASelectionOracleEvidence|TestGoGenericCallFrontierLockedCProbe)$' -count=1 -v -timeout=8m > /evidence/qualified.log 2>&1 || probe_status=$?
printf '%s\n' "$probe_status" > /evidence/probe-exit.txt
exit $((base_status || probe_status))

#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/baseline-control-overlay.json'
export GTS_PARITY_C_REF_BUILD_CACHE=/workspace/harness_out/parity_c_ref_cache/linux_amd64
cd /reference/cgo_harness
status=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe)$' -count=1 -v -timeout=8m > /evidence/baseline-go-c-control.log 2>&1 || status=$?
printf '%s\n' "$status" > /evidence/baseline-go-c-control-exit.txt
test "$status" = 1
if grep -q "Could not resolve host\|clone pinned repo" /evidence/baseline-go-c-control.log; then exit 1; fi
export GOFLAGS='-p=1 -buildvcs=false' GIT_OPTIONAL_LOCKS=0
export GIT_DIR=/workspace/.git GIT_WORK_TREE=/evidence/candidate-source
git config --global --add safe.directory /workspace
git config --global --add safe.directory /evidence/candidate-source
cd /evidence/candidate-source
go run ./cmd/v1layout -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/candidate-layout.log 2>&1
go run ./cmd/v1guard -root /evidence/candidate-source -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/candidate-v1guard.log 2>&1
go run ./cmd/citestplan -stale-run-names -repo-root /evidence/candidate-source > /evidence/candidate-selectors.log 2>&1
printf 'complete\n' > /evidence/baseline-control-complete.txt

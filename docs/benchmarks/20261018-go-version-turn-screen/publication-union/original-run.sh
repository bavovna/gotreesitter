#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace/cgo_harness
status0=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoGenericCallFrontierLockedCProbe$' -count=1 -v -timeout=8m > /evidence/frontier.log 2>&1 || status0=$?
printf '%s\n' "$status0" > /evidence/frontier-exit.txt
status=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoTokenTurnExpandedLockedCProbe$' -count=1 -v -timeout=8m > /evidence/expanded.log 2>&1 || status=$?
printf '%s\n' "$status" > /evidence/expanded-exit.txt
status2=0
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestStage6GoCompactCertification|TestGoCompactIncrementalExecutionParity|TestGoCompactIncrementalExecutionRepeatedSameWidthParity|TestGoCompactRecoveryVersionTurnsLockedC|TestGoCompactNestedReuseLockedC|TestGoCompactNestedReuseBoundaryLockedC|TestGoCompactNestedReuseChangedLookaheadLockedC)$' -count=1 -v -timeout=8m > /evidence/existing.log 2>&1 || status2=$?
printf '%s\n' "$status2" > /evidence/existing-exit.txt
exit $((status0 || status || status2))

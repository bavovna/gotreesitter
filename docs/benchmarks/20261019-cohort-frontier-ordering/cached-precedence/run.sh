#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^Test(PrecedenceMaximum|FreshDFATerminalIdentity|ReconvergedReductionChildSelection)' -count=1 -v -timeout=8m > /evidence/core-focused.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestStage6GoCompactCertification|TestGoCompactIncrementalExecutionParity|TestGoCompactIncrementalExecutionRepeatedSameWidthParity|TestGoCompactRecoveryVersionTurnsLockedC|TestGoCompactNestedReuseLockedC|TestGoCompactNestedReuseBoundaryLockedC|TestGoCompactNestedReuseChangedLookaheadLockedC)$' -count=1 -v -timeout=8m > /evidence/c.log 2>&1
printf 'complete\n' > /evidence/complete.txt

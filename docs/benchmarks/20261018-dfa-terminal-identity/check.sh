#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^Test(FreshDFATerminalIdentity|ReconvergedReductionChildSelection)' -count=1 -v -timeout=5m > /evidence/core-focused.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(GoGenericCallFrontierProbe|PrototypeDFATerminalSourceRejectsChangedOrigin)$' -count=1 -v -timeout=8m > /evidence/frontier.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoGenericCallFrontierLockedCProbe$' -count=1 -v -timeout=8m > /evidence/c.log 2>&1
printf 'complete\n' > /evidence/check-complete.txt

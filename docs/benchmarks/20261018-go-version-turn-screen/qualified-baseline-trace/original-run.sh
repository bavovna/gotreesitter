#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoGenericCallFrontierLockedCProbe$/^qualified_type_multi$' -count=1 -v -timeout=8m > /evidence/baseline-trace.log 2>&1

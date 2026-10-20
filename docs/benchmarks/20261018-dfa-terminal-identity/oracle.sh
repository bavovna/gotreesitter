#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/oracle-overlay.json'
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoDFASelectionOracleEvidence|TestGoGenericCallFrontierLockedCProbe)$/^single_identifier$' -count=1 -v -timeout=8m > /evidence/oracle.log 2>&1

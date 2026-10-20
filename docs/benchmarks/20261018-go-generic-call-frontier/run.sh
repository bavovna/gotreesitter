#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestGoGenericCallFrontierProbe$' -count=1 -v -timeout=8m > /evidence/frontier.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoGenericCallFrontierLockedCProbe$' -count=1 -v -timeout=8m > /evidence/c.log 2>&1
printf 'complete\n' > /evidence/complete.txt
echo 'Go generic-call unobserved/observed frontier and public locked-C probes completed; no selector or limit changes'

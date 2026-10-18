#!/usr/bin/env bash
set -euo pipefail
bash /evidence/check.sh
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestParserCoreCorridor(RuntimeEquivalence|PassMixReceipt|DefaultOn|ReduceShiftPreservesDispatchPolls)$' -count=1 -v -timeout=6m > /evidence/root-corridor.log 2>&1
cd /workspace/cgo_harness
GTS_ADMISSION_CANDIDATE=1 go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestCompactYAMLDocumentStreamLockedC$' -count=1 -v -timeout=8m > /evidence/owned-yaml-c.log 2>&1
python3 /evidence/check-counters.py
printf 'complete\n' > /evidence/screen-complete.txt

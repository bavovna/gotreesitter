#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^TestShiftOwner' -count=1 -v -timeout=5m > /evidence/owner-unit.log 2>&1
go test . -tags gts_parsercorephase0 -run '^TestParserCoreCorridor(RuntimeEquivalence|PassMixReceipt|DefaultOn|ReduceShiftPreservesDispatchPolls)$' -count=1 -v -timeout=5m > /evidence/root-corridor.log 2>&1
printf 'complete\n' > /evidence/behavior-complete.txt

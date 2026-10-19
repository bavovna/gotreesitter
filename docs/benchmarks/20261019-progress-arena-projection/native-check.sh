#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/owned-invariant-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false' GIT_OPTIONAL_LOCKS=0
cd /workspace
git config --global --add safe.directory /workspace
git config --global --add safe.directory /evidence/native-source
go test ./internal/parsercorephase0 -run '^Test(ProjectRecordArenas|RecordArenaProjection)' -count=1 -v -timeout=8m > /evidence/native-core.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^Test(ProjectRecordArenas|RecordArenaProjection)' -count=1 -v -timeout=8m > /evidence/native-core-386.log 2>&1
go run ./cmd/v1layout -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/native-layout.log 2>&1
GIT_DIR=/workspace/.git GIT_WORK_TREE=/evidence/native-source go run ./cmd/v1guard -root /evidence/native-source -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/native-v1guard.log 2>&1
go run ./cmd/citestplan -stale-run-names -repo-root /evidence/native-source > /evidence/native-selectors.log 2>&1
go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --write --output /evidence/native-ledger.json > /evidence/native-ledger.log 2>&1
GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 -overlay /evidence/native-owned-overlay.json ./cmd/perfcounterledger --langs yaml > /evidence/native-owned-ledger.json 2> /evidence/native-owned-ledger.log
printf 'complete\n' > /evidence/native-complete.txt

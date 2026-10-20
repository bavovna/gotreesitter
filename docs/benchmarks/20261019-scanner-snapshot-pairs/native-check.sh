#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/local/go/bin:$PATH GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false'
cd /candidate
go run ./cmd/v1layout > /evidence/native-layout.log 2>&1
go run ./cmd/v1guard -root /candidate > /evidence/native-v1guard.log 2>&1
go run ./cmd/citestplan -stale-run-names -repo-root /candidate > /evidence/native-selectors.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(FreshSnapshotPages.*|SnapshotPairFootprint.*|DiagnosticParserCoreVersionLexerSnapshot.*|ParserCoreFreshFullRunnerRepeatedCanonicalLifecycle)$' -count=1 -v -timeout=8m > /evidence/native-root.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test . -tags gts_parsercorephase0 -run '^Test(FreshSnapshotPages.*|SnapshotPairFootprint.*)$' -count=1 -v -timeout=8m > /evidence/native-root-386.log 2>&1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/native-overlay.json'
go build -tags gts_parsercorephase0 -o /evidence/native-counter ./cmd/perfcounterledger > /evidence/native-counter-build.log 2>&1
/evidence/native-counter --write --output /evidence/native-ledger.json > /evidence/native-ledger.log 2>&1
GTS_LAYOUT_OWNED_PROBE=1 /evidence/native-counter --langs yaml > /evidence/native-owned-ledger.json 2> /evidence/native-owned-ledger.log
printf 'complete\n' > /evidence/native-complete.txt

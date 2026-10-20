#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false' GIT_OPTIONAL_LOCKS=0
cd /workspace
git config --global --add safe.directory /workspace
go test . -run '^TestCompactLegacyReadHistoryPublicationDemand$' -count=1 -v -timeout=8m > /evidence/native-default.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadHistoryPublicationDemand|CompactCanonicalNoReplayReadHistory|ParserCoreFreshFullRunnerRepeatedCanonicalLifecycle)$' -count=1 -v -timeout=8m > /evidence/native-tagged.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test . -tags gts_parsercorephase0 -run '^TestCompactLegacyReadHistoryPublicationDemand$' -count=1 -v -timeout=8m > /evidence/native-386.log 2>&1
go run ./cmd/v1layout -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/native-layout.log 2>&1
go run ./cmd/v1guard -root /workspace -base a03d0842994a85aa26cf494c8c67404e1e64e999 > /evidence/native-v1guard.log 2>&1
go run ./cmd/citestplan -stale-run-names -repo-root /workspace > /evidence/native-selectors.log 2>&1
go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --write --output /evidence/native-ledger.json > /evidence/native-ledger.log 2>&1
printf 'complete\n' > /evidence/native-complete.txt

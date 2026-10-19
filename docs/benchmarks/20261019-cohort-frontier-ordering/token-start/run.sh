#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m > /evidence/c.log 2>&1
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > "/evidence/$role-canonical-work.log" 2>&1
done
printf 'complete\n' > /evidence/complete.txt

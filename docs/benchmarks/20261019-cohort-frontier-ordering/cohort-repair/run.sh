#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestOrdinaryShiftCohortPreservesAlreadyShiftedSibling$' -count=1 -v -timeout=8m > /evidence/cohort-regression.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoTokenTurnExpandedLockedCProbe$/^n[01]_t5_a[14]_c[012]$' -count=1 -v -timeout=8m > /evidence/qualified-c.log 2>&1
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoVersionTurnEditSessionsLockedC$/^n[01]_t3_c[012]$' -count=1 -v -timeout=8m > /evidence/qualified-edits.log 2>&1
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 status=0
 go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > "/evidence/$role-canonical-work.log" 2>&1 || status=$?
 printf '%s\n' "$status" > "/evidence/$role-canonical-work-exit.txt"
 for lang in go yaml;do
  go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > "/evidence/$role-$lang-ledger.json" 2> "/evidence/$role-$lang-ledger.log"
 done
 GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > "/evidence/$role-owned-yaml-ledger.json" 2> "/evidence/$role-owned-yaml-ledger.log"
done
printf 'complete\n' > /evidence/complete.txt

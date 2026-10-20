#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/correctness-pass.json
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/counter-resume-overlay.json'
cd /baseline
status=0
go test . -tags gts_parsercorephase0 -run '^TestOrdinaryShiftCohortPreservesAlreadyShiftedSibling$' -count=1 -v -timeout=8m > /evidence/baseline-cohort-negative-control.log 2>&1 || status=$?
printf '%s\n' "$status" > /evidence/baseline-cohort-negative-control-exit.txt
grep -q 'want all three incoming histories' /evidence/baseline-cohort-negative-control.log
test "$status" -ne 0
result=0
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 status=0
 go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > "/evidence/$role-canonical-work-final.log" 2>&1 || status=$?
 printf '%s\n' "$status" > "/evidence/$role-canonical-work-exit.txt"
 result=$((result || status))
 for lang in go yaml;do
  go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > "/evidence/$role-$lang-ledger.json" 2> "/evidence/$role-$lang-ledger.log"
 done
 GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > "/evidence/$role-owned-yaml-ledger.json" 2> "/evidence/$role-owned-yaml-ledger.log"
done
printf 'complete\n' > /evidence/counter-collection-complete.txt
exit "$result"

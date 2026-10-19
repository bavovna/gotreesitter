#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/qualification-overlay.json'
cd /baseline
status=0
go test . -tags gts_parsercorephase0 -run '^TestOrdinaryShiftCohortPreservesAlreadyShiftedSibling$' -count=1 -v -timeout=8m > /evidence/baseline-cohort-regression.log 2>&1 || status=$?
printf '%s\n' "$status" > /evidence/baseline-cohort-regression-exit.txt
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestOrdinaryShiftCohortPreservesAlreadyShiftedSibling$' -count=1 -v -timeout=8m > /evidence/cohort-regression.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoVersionTurnEditSessionsLockedC$' -count=1 -v -timeout=8m > /evidence/edit-sessions.log 2>&1
cd /workspace
go test ./internal/parsercorephase0 -count=1 -timeout=8m > /evidence/core-all.log 2>&1
go test ./internal/parsercorephase0 -tags gts_parsercorephase0,gts_parsercorephase0a -count=1 -timeout=8m > /evidence/core-phase0a.log 2>&1
for lang in go yaml;do
 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE="$lang" go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=6m > "/evidence/$lang-invariant.log" 2>&1
 cd /workspace/cgo_harness
 GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive go test . -tags gts_parsercorephase0,treesitter_c_parity -run "^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^${lang}$" -count=1 -v -timeout=6m > "/evidence/$lang-c.log" 2>&1
 cd /workspace
done
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > "/evidence/$role-canonical-work.log" 2>&1
 for lang in go yaml;do
  go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > "/evidence/$role-$lang-ledger.json" 2> "/evidence/$role-$lang-ledger.log"
 done
 GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > "/evidence/$role-owned-yaml-ledger.json" 2> "/evidence/$role-owned-yaml-ledger.log"
done
printf 'complete\n' > /evidence/qualification-complete.txt

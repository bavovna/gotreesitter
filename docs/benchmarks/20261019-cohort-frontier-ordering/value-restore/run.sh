#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^Test(PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling)$' -count=1 -v -timeout=8m > /evidence/root-focused.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m > /evidence/c.log 2>&1
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > /evidence/candidate-canonical-work.log 2>&1
for lang in go yaml;do
 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > "/evidence/candidate-$lang-ledger.json" 2> "/evidence/candidate-$lang-ledger.log"
done
GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > /evidence/candidate-owned-yaml-ledger.json 2> /evidence/candidate-owned-yaml-ledger.log
printf 'complete\n' > /evidence/complete.txt

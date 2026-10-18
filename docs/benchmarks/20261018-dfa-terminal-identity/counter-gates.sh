#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/check-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/counter-overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -count=1 -timeout=8m > /evidence/core-all.log 2>&1
go test ./internal/parsercorephase0 -tags gts_parsercorephase0,gts_parsercorephase0a -count=1 -timeout=8m > /evidence/core-phase0a.log 2>&1
go test ./internal/parsercorephase0 -race -run '^Test(FreshDFATerminalIdentity|ReconvergedReductionChildSelection)' -count=1 -timeout=8m > /evidence/core-race.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^Test(FreshDFATerminalIdentity|ReconvergedReductionChildSelection)' -count=1 -timeout=8m > /evidence/core-386.log 2>&1
for lang in go yaml;do
 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=$lang go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=6m > /evidence/$lang-invariant.log 2>&1
 cd /workspace/cgo_harness
 GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive go test . -tags gts_parsercorephase0,treesitter_c_parity -run "^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^${lang}$" -count=1 -v -timeout=6m > /evidence/$lang-c.log 2>&1
 cd /workspace
 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > /evidence/$lang-ledger.raw 2> /evidence/$lang-ledger.log
 echo "$lang correctness and ledger collected"
done
GTS_LAYOUT_OWNED_PROBE=1 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=yaml go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=6m > /evidence/owned-yaml-invariant.log 2>&1
GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > /evidence/owned-yaml-ledger.raw 2> /evidence/owned-yaml-ledger.log
printf 'complete\n' > /evidence/counter-check-complete.txt

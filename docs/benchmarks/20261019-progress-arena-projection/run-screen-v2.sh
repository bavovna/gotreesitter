#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay-v2.json'
cd /workspace
go test ./internal/parsercorephase0 -count=1 -timeout=8m > /evidence/screen-v2/core-all.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^Test(ProjectRecordArenas|RecordArenaProjectionBudget)' -count=1 -v -timeout=8m > /evidence/screen-v2/core-386.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(CompactArenaReserve.*|CompactStaged.*|CompactIncrementalDoesNotReserveFullSource|CompactMemoryBudgetDetectsGrowthAfterSmallPoll|CompactAcceptance.*(Budget|StopControl)|ParserCoreFreshFullRunnerRepeatedCanonicalLifecycle|CompactLegacyReadScratch.*)$' -count=1 -v -timeout=8m > /evidence/screen-v2/root-focused.log 2>&1
for language in go yaml; do
 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE="$language" go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=8m > "/evidence/screen-v2/$language-invariant.log" 2>&1
done
go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > /evidence/screen-v2/canonical-work.log 2>&1
go test . -tags gts_parsercorephase0 -run '^TestGoRuntimeMemoryAttribution$' -count=1 -v -memprofile=/evidence/screen-v2/projected.mem -o /evidence/screen-v2/projected.test -timeout=8m > /evidence/screen-v2/go-memory-attribution.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestCompactLineageLargeGoLockedC$' -count=1 -v -timeout=8m > /evidence/screen-v2/large-go-c.log 2>&1
for language in go yaml; do
 GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive go test . -tags gts_parsercorephase0,treesitter_c_parity -run "^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^${language}$" -count=1 -v -timeout=8m > "/evidence/screen-v2/$language-c.log" 2>&1
done
printf 'complete\n' > /evidence/screen-v2/screen-complete.txt

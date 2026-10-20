#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/screen-v2/screen-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay-v2.json'
mkdir -p /evidence/out/candidate
cd /workspace
go test ./internal/parsercorephase0 -tags gts_parsercorephase0,gts_parsercorephase0a -count=1 -timeout=8m > /evidence/out/candidate/core-phase0a.log 2>&1
go test ./internal/parsercorephase0 -tags gts_parsercorephase0_selectedstore_onepass -count=1 -timeout=8m > /evidence/out/candidate/core-onepass.log 2>&1
go test . -run '^TestCompact(ArenaReserve.*|Staged.*|IncrementalDoesNotReserveFullSource)$' -count=1 -v -timeout=8m > /evidence/out/candidate/root-default.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test . -tags gts_parsercorephase0 -run '^TestCompactStagedArenaReserve$' -count=1 -v -timeout=8m > /evidence/out/candidate/root-386.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(CompactMemoryBudgetDetectsGrowthAfterSmallPoll|CompactAcceptance.*(MemoryBudget|RetentionBound|RebuildBudget)|CompactArenaReserve.*(Budget|RetentionCap)|CompactExternalScannerCheckpointCopyMemoryBudget|CompactRecoveryMemoMemoryBudget|CompactBorrowedMaterializationProjectionMemoryBudget|G18RefSetSchedulerMemoryBudgetAccounting|ParserCoreFreshFullRunnerRepeatedCanonicalLifecycle|CompactLegacyReadScratchPooledLargeThenSmall)$' -count=1 -v -timeout=8m > /evidence/out/candidate/memory-pooling.log 2>&1
go test -c -tags gts_parsercorephase0 -o /evidence/out/candidate/root.test . > /evidence/out/candidate/root-build.log 2>&1
go build -tags gts_parsercorephase0 -o /evidence/out/candidate/counter ./cmd/perfcounterledger > /evidence/out/candidate/counter-build.log 2>&1
/evidence/out/candidate/counter --write --output /evidence/out/candidate/ledger.json > /evidence/out/candidate/ledger.log 2>&1
GTS_LAYOUT_OWNED_PROBE=1 /evidence/out/candidate/counter --langs yaml > /evidence/out/candidate/owned-yaml-ledger.json 2> /evidence/out/candidate/owned-yaml-ledger.log
while IFS= read -r grammar; do
 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE="$grammar" /evidence/out/candidate/root.test -test.run '^TestV1InvariantGateR4EditSession$' -test.count=1 -test.v -test.timeout=4m > "/evidence/out/candidate/invariant-$grammar.log" 2>&1
done < /evidence/languages.txt
GTS_ADMISSION_CANDIDATE=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/owned-invariant-overlay.json' go test . -tags gts_parsercorephase0 -run '^TestProgressArenaOwnedYAMLInvariant$' -count=1 -v -timeout=8m > /evidence/out/candidate/owned-yaml-invariant.log 2>&1
cd /workspace/cgo_harness
go test -c -tags gts_parsercorephase0,treesitter_c_parity -o /evidence/out/candidate/cgo.test . > /evidence/out/candidate/cgo-build.log 2>&1
while IFS= read -r grammar; do
 GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive /evidence/out/candidate/cgo.test -test.run "^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^${grammar}$" -test.count=1 -test.v -test.timeout=4m > "/evidence/out/candidate/c-$grammar.log" 2>&1
done < /evidence/languages.txt
python3 /evidence/strict.py candidate > /evidence/out/candidate/strict.log 2>&1
GTS_YAML_LARGE_PROBE=1 /evidence/out/candidate/cgo.test -test.run '^TestCompactYAMLDocumentStreamLockedC$' -test.count=1 -test.v -test.timeout=8m > /evidence/out/candidate/yaml-stream-c.log 2>&1
cd /workspace
go test . -race -tags gts_parsercorephase0 -run '^TestCompact(Staged.*|ArenaReserve.*|LegacyReadScratchPooledLargeThenSmall)$' -count=1 -v -timeout=8m > /evidence/out/candidate/root-race.log 2>&1
go test ./internal/parsercorephase0 -race -run '^Test(ProjectRecordArenas|RecordArenaProjectionBudget)' -count=1 -v -timeout=8m > /evidence/out/candidate/core-race.log 2>&1
printf 'complete\n' > /evidence/out/candidate/complete.txt
printf 'complete\n' > /evidence/qualify-complete.txt

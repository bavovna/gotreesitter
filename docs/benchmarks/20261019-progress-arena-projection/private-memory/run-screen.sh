#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^Test(ProjectRecordArenas|RecordArenaReserve|ReserveRecordArena|GrowRecordArena|FreshDFATerminal)' -count=1 -v -timeout=8m > /evidence/core-focused.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^TestProjectRecordArenas' -count=1 -v -timeout=8m > /evidence/core-386.log 2>&1
go test ./internal/parsercorephase0 -count=1 -timeout=8m > /evidence/core-all.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(CompactArenaReserve.*|CompactStaged.*|CompactIncrementalDoesNotReserveFullSource|CompactMemoryBudgetDetectsGrowthAfterSmallPoll|PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling|DiagnosticPrivateChangedSourceKeepsRebuildBudget|DiagnosticPrivateRepeatedCanonicalLifecycle)$' -count=1 -v -timeout=8m > /evidence/root-focused.log 2>&1
GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=go go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=8m > /evidence/go-invariant.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m > /evidence/generic-c-edits.log 2>&1
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > /evidence/canonical-work.log 2>&1
go test . -tags gts_parsercorephase0 -run '^TestGoRuntimeMemoryAttribution$' -count=1 -v -memprofile=/evidence/projected.mem -o /evidence/projected.test -timeout=8m > /evidence/go-memory-attribution.log 2>&1
printf 'complete\n' > /evidence/screen-complete.txt

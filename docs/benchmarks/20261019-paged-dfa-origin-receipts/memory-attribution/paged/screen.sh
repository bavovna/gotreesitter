#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/screen-overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^TestFreshDFATerminal' -count=1 -v -timeout=8m > /evidence/core-focused.log 2>&1
go test ./internal/parsercorephase0 -count=1 -timeout=8m > /evidence/core-all.log 2>&1
go test . -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadHistoryPublicationDemand|CompactCanonicalNoReplayReadHistory|PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling|DiagnosticPrivateChangedSourceKeepsRebuildBudget|DiagnosticPrivateRepeatedCanonicalLifecycle)$' -count=1 -v -timeout=8m > /evidence/root-focused.log 2>&1
GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=go go test . -tags gts_parsercorephase0 -run '^TestV1InvariantGateR4EditSession$' -count=1 -v -timeout=8m > /evidence/go-invariant.log 2>&1
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m > /evidence/generic-c-edits.log 2>&1
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > /evidence/canonical-work.log 2>&1
go test . -tags gts_parsercorephase0 -run '^TestGoRuntimeMemoryAttribution$' -count=1 -v -memprofile=/evidence/paged.mem -o /evidence/paged.test -timeout=8m > /evidence/go-memory-attribution.log 2>&1
go tool pprof -top -alloc_space -nodecount=24 -base /profile/candidate.mem /evidence/paged.test /evidence/paged.mem > /evidence/allocation-difference.txt
printf 'complete\n' > /evidence/screen-complete.txt

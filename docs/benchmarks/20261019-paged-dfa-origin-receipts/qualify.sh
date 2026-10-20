#!/usr/bin/env bash
set -euo pipefail
# Timing is separate and must have finished before this CPU-heavy run starts.
test -f /evidence/source-reference.json
export GOWORK=off GOMAXPROCS=1
mkdir /evidence/out
for role in candidate; do
  mkdir "/evidence/out/$role"
  export GOFLAGS="-p=1 -buildvcs=false -overlay=/evidence/overlay.json"
  cd /workspace
  go test . -run '^TestCompactLegacyReadHistoryPublicationDemand$' -count=1 -v -timeout=8m > "/evidence/out/$role/history-default.log" 2>&1
  go test . -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadHistoryPublicationDemand|CompactCanonicalNoReplayReadHistory|PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling)$' -count=1 -v -timeout=8m > "/evidence/out/$role/root-focused.log" 2>&1
  go test ./internal/parsercorephase0 -count=1 -timeout=8m > "/evidence/out/$role/core-all.log" 2>&1
  go test ./internal/parsercorephase0 -tags gts_parsercorephase0,gts_parsercorephase0a -count=1 -timeout=8m > "/evidence/out/$role/core-phase0a.log" 2>&1
  GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^Test(FreshDFATerminal|PrecedenceMaximum)' -count=1 -v -timeout=8m > "/evidence/out/$role/core-386.log" 2>&1
  go test ./internal/parsercorephase0 -tags gts_parsercorephase0_selectedstore_onepass -count=1 -timeout=8m > "/evidence/out/$role/core-onepass.log" 2>&1
  status=0
  go test . -tags gts_parsercorephase0 -run '^TestParserCoreFreshFullRunnerRepeatedCanonicalLifecycle$' -count=1 -v -timeout=8m > "/evidence/out/$role/production-pinned-lifecycle-negative.log" 2>&1 || status=$?
  printf '%s\n' "$status" > "/evidence/out/$role/production-pinned-lifecycle-exit.txt"
  test "$status" = 1
  grep -q 'compact work=' "/evidence/out/$role/production-pinned-lifecycle-negative.log"
  go test . -tags gts_parsercorephase0 -run '^TestDiagnosticPrivate(ChangedSourceKeepsRebuildBudget|RepeatedCanonicalLifecycle)$' -count=1 -v -timeout=8m > "/evidence/out/$role/diagnostic-budget-lifecycle.log" 2>&1
  go test . -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadScratchPooledLargeThenSmall|ParserCoreFreshFullRunnerReusesSchedulerStorage)$' -count=1 -v -timeout=8m > "/evidence/out/$role/pooled-lifecycle.log" 2>&1
  go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v -timeout=8m > "/evidence/out/$role/canonical-work.log" 2>&1
  go test -c -tags gts_parsercorephase0 -o "/evidence/out/$role/root.test" . > "/evidence/out/$role/root-build.log" 2>&1
  go build -tags gts_parsercorephase0 -o "/evidence/out/$role/counter" ./cmd/perfcounterledger > "/evidence/out/$role/counter-build.log" 2>&1
  "/evidence/out/$role/counter" --write --output "/evidence/out/$role/ledger.json" > "/evidence/out/$role/ledger.log" 2>&1
  GTS_LAYOUT_OWNED_PROBE=1 "/evidence/out/$role/counter" --langs yaml > "/evidence/out/$role/owned-yaml-ledger.json" 2> "/evidence/out/$role/owned-yaml-ledger.log"
  cd /workspace/cgo_harness
  go test -c -tags gts_parsercorephase0,treesitter_c_parity -o "/evidence/out/$role/cgo.test" . > "/evidence/out/$role/cgo-build.log" 2>&1
  if [[ $role == candidate ]]; then
    "/evidence/out/$role/cgo.test" -test.run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -test.count=1 -test.v -test.timeout=8m > "/evidence/out/$role/generic-c-edits.log" 2>&1
  fi
  cd /workspace
  while IFS= read -r grammar; do
    GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE="$grammar" "/evidence/out/$role/root.test" -test.run '^TestV1InvariantGateR4EditSession$' -test.count=1 -test.v -test.timeout=4m > "/evidence/out/$role/invariant-$grammar.log" 2>&1
    printf '%s invariant %s passed\n' "$role" "$grammar"
  done < /evidence/languages.txt
  GTS_LAYOUT_OWNED_PROBE=1 GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=yaml "/evidence/out/$role/root.test" -test.run '^TestV1InvariantGateR4EditSession$' -test.count=1 -test.v -test.timeout=4m > "/evidence/out/$role/owned-yaml-invariant.log" 2>&1
  cd /workspace/cgo_harness
  while IFS= read -r grammar; do
    GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive "/evidence/out/$role/cgo.test" -test.run "^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^${grammar}$" -test.count=1 -test.v -test.timeout=4m > "/evidence/out/$role/c-$grammar.log" 2>&1
    printf '%s C parity %s passed\n' "$role" "$grammar"
  done < /evidence/languages.txt
  python3 /evidence/strict.py "$role" > "/evidence/out/$role/strict.log" 2>&1
  cd /workspace
  "/evidence/out/$role/cgo.test" -test.run '^TestCompactLineageLargeGoLockedC$' -test.count=1 -test.v -test.timeout=8m > "/evidence/out/$role/large-go-c.log" 2>&1
  cd /workspace/cgo_harness
  GTS_YAML_LARGE_PROBE=1 "/evidence/out/$role/cgo.test" -test.run '^TestCompactYAMLDocumentStreamLockedC$' -test.count=1 -test.v -test.timeout=8m > "/evidence/out/$role/yaml-stream-c.log" 2>&1
  cd /workspace
  if [[ $role == candidate ]]; then
    go test . -race -tags gts_parsercorephase0 -run '^TestPrototype(DFATerminalSourceRejectsChangedOrigin|DFADispatchRestoresNestedPanicWithoutAllocating)$' -count=1 -v -timeout=8m > "/evidence/out/$role/root-race.log" 2>&1
  else
    go test . -race -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadHistoryPublicationDemand|CompactCanonicalNoReplayReadHistory|CompactLegacyReadScratch.*)$' -count=1 -v -timeout=8m > "/evidence/out/$role/root-race.log" 2>&1
  fi
  printf 'complete\n' > "/evidence/out/$role/complete.txt"
  printf '%s full correctness/counter screen complete\n' "$role"
done
printf 'complete\n' > /evidence/complete.txt

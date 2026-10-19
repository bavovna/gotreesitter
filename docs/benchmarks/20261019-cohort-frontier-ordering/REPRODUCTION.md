# Replay the cohort, ordering and allocation screens

Production is `b17ca367a85d419514554e88f4477a339fd3ecba`. All 3,512
production Go files remain unchanged. Use a complete checkout matching
`baseline-source-pins.json`; the earlier Go-only source snapshot is not a
complete module and cannot be used as the baseline working directory.
Copy this archive to a fresh writable external directory mounted at `/evidence`.
Do not apply these private patches to the working checkout.

Use the pinned Docker image and settings in `source-reference.json`: Go
1.25.14, one CPU on CPU 6, 6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`,
`GOWORK=off`, `-p=1`. Use the repository Docker runner and acquire the common
and Nightwatch locks. `offline-runner-reference.json` retains the exact
private runner patch adding `--network none` to the test and ownership-fixup
containers. The repository runner is unchanged. Cached dependencies and
locked C grammars suffice. `harness.json` retains exits and OOM/timeout fields.

## Latest private correctness screen

```sh
python3 /evidence/prepare-replay.py value-restore
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/replay/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^Test(PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling)$' -count=1 -v -timeout=8m
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m
```

Expected: six original plus 300 expanded C cases pass through compact;
24 generic edit sessions pass six steps each against fresh Go and locked C;
all 144 no-edit allocation checks remain zero. The root tests cover 19
origin/context negatives, nested panic restoration, zero-allocation context
restoration and preservation of an already-shifted sibling.

Use `^TestCanonicalMaskCensus$` in the root package to compare complete Core
and Scheduler vectors and the four unchanged canonical deep digests. The
latest vectors must equal `token-start`, not the production vectors. The
standard production canonical benchmark must still reject this protocol's
changed work; its failure is retained under `preflights/`.

## Causal control and intermediate variants

Use separate output folders for every role. The helper checks all baseline
hashes, reconstructs changed files outside the checkout using zero-context
patches, verifies every resulting runtime/probe hash, then emits an overlay.

```sh
python3 /evidence/prepare-replay.py cohort-repair --baseline --output /evidence/control
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/control/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestOrdinaryShiftCohortPreservesAlreadyShiftedSibling$' -count=1 -v
```

This negative control must fail: the production cohort loses one of three
live histories. `cohort-repair` preserves all three and passes the regression.
Its 12 qualified-type C checks and six edit sessions pass. `cohort-all-live`
is the earlier unconditional frontier repair; it passes 273/300 expanded
cases and retains the other 27 failures.
`cohort-plus-order` passes all 306 clean C cases. `cached-precedence` adds the
O(1) stored-precedence accessor and passes its archived Core, phase0A, Go/YAML
invariant and smoke-C checks. `token-start` additionally claims a version turn
at the beginning of a token even when only one version is present. Its
306 clean C cases and 144 edit steps pass.

The stored precedence accessor intentionally returns the existing running
stack value. It does not recompute the maximum over surviving paths; the
focused test distinguishes those values. Every variant's original scripts,
logs, source hashes and probe hashes remain beside its patch. Their absolute
paths document the original runs; use the replay helpers for new paths.
`cached-build-preflight` retains a compile failure and is not a parser result.

## Reproduce the allocation comparison

This is **private token-start with a closure versus the same protocol with
value restoration**. It is not a production throughput comparison. Bind a
second complete, matching checkout read-only at `/baseline`. After the
correctness and exact private-pair counter checks above, prepare both roles:

```sh
python3 /evidence/prepare-perf.py
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/paired/overlay.json'
mkdir /evidence/replayed-perf
cd /workspace
export GTS_ADMISSION_REAL_CORPUS_LANGS=go
bash scripts/run_randomized_benchmarks.sh --output /evidence/replayed-perf/go-after.txt --baseline-root /baseline --baseline-output /evidence/replayed-perf/go-before.txt --bench-regex '^Benchmark(DFADispatchRestoreCanonical|GoParseFullDFA|GoParseIncrementalSingleByteEditDFA|GoParseIncrementalNoEditDFA|AdmissionR4Compact)$' --require-benchmarks BenchmarkDFADispatchRestoreCanonical/rewrite,BenchmarkDFADispatchRestoreCanonical/query_compile,BenchmarkDFADispatchRestoreCanonical/language,BenchmarkDFADispatchRestoreCanonical/grammargen_lr,BenchmarkGoParseFullDFA,BenchmarkGoParseIncrementalSingleByteEditDFA,BenchmarkGoParseIncrementalNoEditDFA,BenchmarkAdmissionR4Compact --runs 20 --seed-start 34501 --benchtime 750ms
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml
bash scripts/run_randomized_benchmarks.sh --output /evidence/replayed-perf/yaml-after.txt --baseline-root /baseline --baseline-output /evidence/replayed-perf/yaml-before.txt --bench-regex '^Benchmark(AdmissionR4Compact|AdmissionR4OwnedExternalLexer|AdmissionYAMLDocumentStreamOwned)$' --require-benchmarks BenchmarkAdmissionR4Compact,BenchmarkAdmissionR4OwnedExternalLexer,BenchmarkAdmissionYAMLDocumentStreamOwned --runs 20 --seed-start 34601 --benchtime 750ms
```

Each process uses count 1 and `-benchmem`; the script shuffles role and
benchmark order for each seed. The four diagnostic canonical benchmarks keep
the same private-protocol work pins in both roles and the production source
and deep-tree pins. They do not replace or weaken the production benchmark.
`value-restore/perf/` retains all 440 completed rows, all benchstat metrics,
raw medians, analysis code and benchstat version/hash. Repoint the analysis
script's evidence path when replaying it elsewhere.

An earlier Docker service interruption produced **zero benchmark rows**.
Those incomplete headers and the authoritative exit metadata remain separate;
none entered the successful fresh 20-pair run. A considered private daemon
was never started. No host daemon, network or global configuration was changed.

## Limits

The private pair has equal four complete canonical vectors and six selected
Go/YAML/owned-YAML ledger rows. Compared with production, preserving the lost
histories raises work counters; `canonical-work.json` retains every direction.
No R3 owner exception is approved. Neither a passing private-pair comparison
nor the measured timing win authorizes promotion, changed pins or graduation.
No new all-206 invariant, 618-fixture C, 414-row ledger, full strict corpus,
386 or RSS qualification has run for this protocol family. Existing broad
qualification belongs to the unchanged production runtime only.

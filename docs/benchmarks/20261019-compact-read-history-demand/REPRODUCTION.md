# Replay the no-replay history-demand bucket

The baseline is `b17ca367a85d419514554e88f4477a339fd3ecba`. This bucket
contains one runtime guard and two additions to existing test files. It does
not contain the private DFA-origin/version-ordering protocol.

Use two complete clean checkouts whose 3,512 Go files match
`baseline-source-pins.json`, mounted at `/workspace` and `/baseline`. A
Go-only source snapshot is not a complete module. Copy the archive to a
fresh writable external folder mounted at `/evidence`; keep checkouts
unchanged. `prepare-replay.py` reconstructs the candidate outside them,
checks every resulting hash and emits one paired `/evidence/overlay.json`.

Use the pinned Docker image in `harness.json`, Go 1.25.14, one CPU on CPU 6,
6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`, `GOWORK=off`, count 1 and `-p=1`.
Acquire the common and Nightwatch locks. The private runner's network-none
patch and hashes are in `offline-runner-reference.json`; the repository
runner is unchanged. Use cached modules and locked C grammars.

## Preparation and causal check

```sh
python3 /evidence/prepare-replay.py
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /baseline
go test . -tags gts_parsercorephase0 -run '^TestCompactLegacyReadHistoryPublicationDemand$' -count=1 -v
```

The last command must fail only the known-no-replay subtest. Unknown context
and replay-enabled publication still collect reads. In `/workspace`, that
test and `TestCompactCanonicalNoReplayReadHistory` must pass. The latter
keeps the pinned canonical source/deep digest and verifies two fresh parses
stay reuse-disabled while collecting no unused history.

`runtime.patch` exactly reproduces the timed runtime. `native.patch` also
places the same two tests in their existing files. For native/default-tag
replay, use a fresh external output folder and `--native-tests`; do not
combine the native test additions with another copy of the virtual tests.
The original timed harness and all promoted source hashes are retained.

## Correctness and counters

`run-screen.sh` retains the focused baseline/candidate commands. The complete
qualified candidate results are in `qualification/`; every invariant and C
process uses one grammar. To reproduce the complete screen, compile the root
and C binaries once, then run these selectors separately for each of the
206 names in `languages.txt`:

```sh
cd /workspace
go test -c -tags gts_parsercorephase0 -o /evidence/root.test .
GTS_ADMISSION_CANDIDATE=1 GOTREESITTER_V1_INVARIANT_LANGUAGE=go /evidence/root.test -test.run '^TestV1InvariantGateR4EditSession$' -test.count=1 -test.v -test.timeout=4m
cd /workspace/cgo_harness
go test -c -tags gts_parsercorephase0,treesitter_c_parity -o /evidence/cgo.test .
GTS_ADMISSION_CANDIDATE=1 GTS_PARITY_MODE=exhaustive /evidence/cgo.test -test.run '^(TestParityFreshParse|TestParityIncrementalParse|TestParityHasNoErrors)$/^go$' -test.count=1 -test.v -test.timeout=4m
```

All 206 invariant sessions and 618 C checks must pass, including every
72-step edit session and zero-allocation no-edit checks. The separate owned
YAML invariant uses `GTS_LAYOUT_OWNED_PROBE=1`. The complete counter collector
already starts one child per grammar and route:

```sh
cd /workspace
go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --write --output /evidence/replayed-ledger.json
GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > /evidence/replayed-owned-ledger.json
go test . -tags gts_parsercorephase0 -run '^TestCanonicalMaskCensus$' -count=1 -v
```

Require all 412 ordinary plus two owned-YAML rows equal `production/`, and
all four complete Core/Scheduler vectors and deep digests equal
`canonical-work.json`. No production pin or exception changes.
The strict R4 selector `TestCompactR4StructuralLockedC` runs separately for
each committed sample with `GTS_ADMISSION_REAL_CORPUS_LANGS`. All 204 rows
must equal `production/strict-census.json`: 159 passes, including 120 compact
and 39 legacy, and the same 45 known legacy failures. Do not count those
known failures as C passes. `strict-original.py` retains the collecting
logic and original paths; repoint its output folder for a new run.

The archived native and qualification logs retain memory contracts,
large-then-small pooling, races, default/tagged/386 checks, large Go C
equality and the ordinary/owned YAML stream C probes. Native source checks
use a tracked-file snapshot for v1guard and CI selector analysis; historical
untracked worktrees are outside the source under review. The initial
unscoped guard failure remains recorded. The shared qualification container
later failed a separate protocol's production-work pin, after this bucket
completed successfully; that exit is not a failure of this candidate.

## Timing and RSS

After correctness and counter checks, `perf.sh` runs the repository randomized
runner for 20 Go and 20 YAML pairs, 750ms and benchmem. Go seeds are
34701–34720 and YAML seeds 34801–34820. The script creates `/evidence/perf`;
move the archived `perf/` elsewhere before replaying it. All 440 original
rows, every metric direction and all benchstat outputs are retained there.
`analyze.py` verifies all 20-sample medians independently; adjust its
`perf/` location if using another output directory. The benchstat binary's
version and hash are retained alongside the analysis.

The four canonical benchmarks disable replay. Public Go controls and all
YAML paths show no supported timing change. Do not describe the canonical
win as a public Go or YAML throughput improvement.

RSS uses the unchanged strong `rss/rss_root_test.go.txt` probe. It checks
the exact one-MiB sources, expected routes, completion and Go node/token
work. Run one grammar/process with `/usr/bin/time -v`: six initial probes
then 20 alternating pairs for each of Go, ordinary YAML and owned YAML.
`rss/repeat_rss.py` retains the exact loop, seeds 34901–34920 and all limits;
repoint its binary/initial-result paths when replaying. All 126 original
probes remain in `rss/`. Require no candidate above 400 B/source B and
each median ratio at most 1.10. This establishes safety, not an RSS win.

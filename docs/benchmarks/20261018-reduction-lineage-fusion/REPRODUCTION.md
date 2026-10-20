# Replaying this screen

Use separate clean copies of baseline
`6d5b0b07e44a8f4fd1ab66d3246a485fde303909` as `/baseline` and `/workspace`.
Apply `runtime.patch` only to `/workspace`; it adds two internal files and
changes the root reduction adapter. It contains no runtime promotion.

Copy this evidence directory outside the repository to a writable `/evidence`
mount, preserving the archived samples separately. Also copy the referenced
`20261017-shift-lineage-fusion/actual-source-pins.json` manifest as
`/evidence/baseline-source-pins.json`. Mount the prior local evidence from
`source-reference.json`'s qualified baseline at `/reference`; its two
`head-{ledger,owned-ledger}.json` files contain the unchanged reference values.
Alternatively generate those files from a clean baseline using the archived
owned-ledger shim. The complete values also exist at the counter-reference
link in the repository.

Reconstruct the normal overlay by mapping every baseline manifest Go path in
both `/baseline` and `/workspace` to the corresponding clean source. Override
only the three workspace files in `source-pins.json` with the patched candidate.
For both roles, map these shared diagnostic sources:

| Go path | Evidence source |
| --- | --- |
| `benchmark_admission_candidate_route_test.go` | `owned-benchmark.go.txt` |
| `cmd/perfcounterledger/main.go` | `owned-ledger.go.txt` |
| `deferred_publication_work_census_test.go` | `work-census.go.txt` |
| `compact_go_full_consume_test.go` | `consume-bench.go.txt` |

Verify all 3,510 baseline hashes, all unchanged candidate hashes, and all three
candidate file hashes. `go.mod` and `go.sum` match between roles. Use the pinned
Docker image in `source-reference.json`, Go 1.25.14, CPU 6, one CPU, 6 GiB memory,
`GOMAXPROCS=1`, `GOMEMLIMIT=5GiB` and both benchmark locks.

Run `screen.sh` inside Docker. Its phases run the scoped correctness checks,
then compare all 414 ledger rows and five complete construction/consumption
vectors. The owned-YAML C suite's large-input opt-in cases may skip in this
focused screen; no one-MiB qualification is claimed for the rejected trial.
After inspecting those results, `run-perf.sh` verifies the source pins and runs
`perf.sh`, which uses the repository randomized runner with 20 alternating
pairs per language, `750ms`, count one and benchmark memory metrics.

The original normal overlay points to `/evidence/baseline` and
`/evidence/runtime`; reconstruct those directories from the pinned sources if
using the scripts verbatim. Rename the two `.go.txt` diagnostic shims to `.go`
for those original paths. New outputs use `go-{base,head}.txt` and
`yaml-{base,head}.txt`; the archived originals use `before/after` filenames.
Run benchstat on each pair and `analyze.py` after generating the CSV files.
No fixed-order timing comparison is used.

Activation is separate from timing. `coverage.sh` uses a container-only bind
containing all effective candidate Core sources and emits count-mode profiles.
`coverage-source-pins.json` and `activation-blocks.json` retain their provenance.
The normal comparison omits that bind. Activation counts and one-iteration
coverage timings are not performance evidence.

The candidate stopped after this screen. The full 206-language invariant/C
fleets, strict census, RSS comparison and actual-source guards must run before
any future promotion; the checked-in focused results cannot stand in for them.

# Replaying the rejected scanner byte-field experiment

The production baseline is `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`.
Apply `runtime.patch` with `git apply --unidiff-zero` only to a separate
candidate checkout. The changed Go
sources are also retained as `.go.txt` files under `runtime/`; their hashes
are in `source-pins.json`. This patch was not promoted.

Use the repository Docker launcher and the image pinned in
`source-reference.json`, CPU 6, 6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`.
Mount the two checkouts as `/workspace` and `/baseline` and this evidence
folder as `/evidence`. Serialize with both locks used by `perf.sh`.

The archived check scripts use Go overlays. Map `counter_main.go.txt` to
`/workspace/cmd/perfcounterledger/main.go` and `owned_init_test.go.txt` to
`/workspace/zz_scanner_bytes_owned_init_test.go`. In both checkouts map
`work-census.go.txt` and `consume-bench.go.txt` to new `_test.go` files at
the package root. Use those mappings as `overlay.json` and
`perf-overlay.json`; a fresh baseline checkout needs no source replacement
for the candidate patch. The originals froze every tracked Go file through
an overlay; the complete runtime identity is the pinned baseline plus patch.

Run `check.sh`, then `consumed-check.sh`; their marker files and exact
414-row/five-vector checks precede `perf.sh`. The initial ledger-adapter
compile failure and corrected resumed checks remain in `gate-logs.json`.
The opt-in large YAML cases and full-fleet/RSS qualification were not run.

`perf.sh` calls `scripts/run_randomized_benchmarks.sh` with 20 alternating
pairs per language, 750ms, count=1 and benchmem. Go seeds are 34001–34020;
YAML seeds are 34101–34120. All 440 raw rows are retained. `analyze.py`
regenerates both benchstat tables and verifies all raw 20-sample medians.
It requires the completion marker from `perf.sh` and the candidate source
copies at `/evidence/runtime/<original-path>`; remove the archive `.txt`
suffix when arranging those private source copies.

`allocation-attribution/run.sh` is a separate profile and one-iteration
field census against the unmodified baseline. Arrange its baseline overlay
and its instrumented `census-state.go.txt` separately. The census prints
field lengths; archived logs add a `.txt` suffix. Its timing and the memory-profile timing are not performance
comparison evidence. `field-census.json` pins the resulting logs.

The decision is rejection: no supported throughput or YAML allocation gain.
Do not treat the prepared-but-unlaunched full qualification harness as a gate
result, extend the seed set, reset counters, or graduate a language here.

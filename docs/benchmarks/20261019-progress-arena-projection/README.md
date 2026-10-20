# Progress-based record capacity: reproducible evidence

Qualified baseline runtime: `5c463e567a3dec1d3f367f1a47ebaac03800a797`.
`runtime.patch` reconstructs the five measured candidate files, including two
new internal files. It does not include the private C-correct protocol.
The new one-MiB benchmark is identical in both timing roles.

`source-reference-v2.json`, `baseline-source-pins.json`, `runtime-pins.json`,
`canonical-work.json`, the two baseline ledgers and `perf-summary.json` pin the
inputs, complete work and results. `harness.json` records the final
containers: Go 1.25.14, the pinned image, 6 GiB, CPU 6, GOMAXPROCS=1,
GOMEMLIMIT=5GiB, no network and no OOM. Both repository locks serialize runs.

Raw correctness and per-process RSS logs are packed without modification in
`correctness-logs.tar.gz`, `rss-logs.tar.gz` and
`private-memory-rss-logs.tar.gz`. Entry names preserve their evidence paths.
`raw-log-bundles.json` pins each archive. JSON ledgers and audits stay unpacked.
No compiled test binary or heap-profile binary is committed.

## Replay

Use two complete clean checkouts with the baseline's 3512 Go files, mounted at
`/workspace` and `/reference`, and a fresh external output directory mounted at
`/evidence`. Mount this receipt directory separately at `/receipt:ro`.
Prepare inside the pinned Docker image:

```sh
python3 /receipt/prepare-replay.py
bash /evidence/run-screen-v2.sh
bash /evidence/qualify-v2.sh
python3 /receipt/analyze-correctness.py --evidence /evidence
```

Preparation verifies both complete source sets and reconstructs the candidate
outside either checkout. It creates the source, observer and RSS overlays.
Run the commands through the repository Docker runner under both locks, with
6 GiB, one CPU pinned to 6 and GOMEMLIMIT=5GiB. Keep the ordinary repository
runner unchanged; the original run used its archived offline test environment.

For the RSS step, mount `/evidence/rss-v2` at the container's `/evidence`, the
whole prepared output at `/candidate:ro`, the two checkouts at their same paths,
and `/receipt:ro`. Run `bash /evidence/run.sh`. Then restore the full output
mount at `/evidence` and run:

```sh
bash /evidence/perf-v2.sh
python3 /receipt/analyze-perf.py --evidence /evidence
python3 /receipt/prepare-replay.py --check
```

The runner uses 20 alternating shuffled pairs, one process per explicit seed,
count=1, 750ms and benchmem. Go uses seeds 35401..35420 and compact opt-in;
YAML uses 35501..35520. The three-case RSS seeds are 35301..35320, with six
initial probes retained. Prepare and check modes were exercised against the
frozen source and all five reconstructed hashes. See `replay-helper-check.log`.

`private-memory/` is a separate, earlier combined C-correct protocol screen.
Its 42 Go RSS processes pass, but its 65 canonical work increases remain
unapproved and its combined source has no full fleet/three-case RSS/timing
qualification. Do not transfer qualification between these sources.

## Owned-invariant evidence correction

The original extra YAML run set `GTS_LAYOUT_OWNED_PROBE`, which the ledger tool
reads but the invariant test process does not. Its raw bytes are retained as
`owned-yaml-invariant-env-only.log`. That run supplies ordinary-mode coverage.
A separate overlay adds `TestProgressArenaOwnedYAMLInvariant`, explicitly enables
ownership, requires compact=1/fallback=0 on the initial sample, and invokes all
72 edit-session steps. It passes, including no-edit zero allocations. The
corrected portable qualifier uses this wrapper. Timing overlays are unchanged;
the wrapper is never added to the timed binaries. The original qualification
script is retained as `qualify-v2-original.sh` for provenance.

# Replaying this bucket

Use separate clean checkouts of baseline `5e52cf2a2644f3d38785513eebc39f8cf8a506b2`
at `/baseline` and candidate `6d5b0b07e44a8f4fd1ab66d3246a485fde303909` at
`/workspace` inside the container. Copy this evidence directory outside the
repository and mount that writable copy at `/evidence`. Keep the archived
results intact. No packed-link experiment belongs in either checkout.

The pinned image is
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`.
Use Go 1.25.14, CPU 6, one CPU, 6 GiB memory, `GOMEMLIMIT=5GiB` and
`GOMAXPROCS=1`. Serialize with both repository benchmark locks. The original
Docker wrapper records no OOM or timeout for the screen, qualification and
successful actual-source runs. All correctness runs use Docker and one
grammar per process. Populate the normal C harness grammar caches before
the fleet; a skipped grammar is not a passing check.

`prepare-replay.py` verifies all 3,510 candidate and 3,508 baseline Go
sources against the manifest and baseline root-file hash. It reconstructs
only the shared diagnostic overlays and fleet probes; runtime files come
from the named commits. Run it inside the container, then establish fresh
baseline counter files:

```sh
python3 /evidence/prepare-replay.py
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /baseline
go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --write --output /evidence/reference/base-ledger.json
GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > /evidence/reference/base-owned-ledger.json
bash /evidence/behavior.sh
bash /evidence/check.sh
bash /evidence/perf.sh
```

`perf.sh` first compares all counter values and five full construction and
consumption vectors. It invokes `scripts/run_randomized_benchmarks.sh` with
the recorded 20 alternating shuffled pairs per language, `750ms`, `-count=1`
and `-benchmem`. Compare the resulting before/after files with `benchstat`;
the checked-in `measurement.json` preserves all metrics from the original
run, including inconclusive results and the default-edit regression.

After reviewing the counter and timing screen, run `fleet/run.sh`, then
`rss-matched.sh` and `qualification_audit.py`. The copied `screen-pass.json`
is the original decision, not a verdict on a new run. Remove the copied
`rss-matched` output directory if one exists before requesting a new RSS
run; the script refuses to overwrite one. Rebuild binaries in the new
environment and retain all six initial and 120 matched probes. The RSS
ceiling is 400 B/source B and the median candidate/baseline limit is 1.10.

The original actual-source guards use the physical candidate sources without
the broad diagnostic overlay, plus an identical tracked-source mirror for
v1guard and CI selectors. `actual-guards.sh` records their commands. Recreate
that mirror and make the base Git objects available before replaying them.
The owned ledger uses only its single explicit diagnostic override. The
manifest, gate-log hashes, per-language qualification records, strict census
rows and complete RSS records retain the original results and scope.

Coverage is separate from timing. The original overlay-only setup needed a
container-only bind of all pinned effective Core source files; its successful
count-mode probe reported 934 direct shifts and 934 combined publications.
With physical candidate files, `coverage.sh` can read those new files
directly. Coverage timings never enter the comparison.

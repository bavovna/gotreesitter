# Reproduce scanner record coallocation

Baseline: `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`.
Candidate: `b17ca367a85d419514554e88f4477a339fd3ecba`. Use separate checkouts at these exact commits, mounted at
`/baseline` and `/workspace`. Copy this evidence directory to a writable
external directory and mount it at `/evidence`. Do not mount this checked-in
receipt writable for a replay.

Use Go 1.25.14 and image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
CPU 6, one CPU, 6 GiB, `GOMEMLIMIT=5GiB`, and `GOMAXPROCS=1`.
Serialize runs with the common and Nightwatch benchmark locks. The original
container commands, resource limits and every failed launcher remain in
`harness-attempts.json`.

1. Inside the container, run `python3 /evidence/prepare-replay.py`. It checks
   every source file and creates only the diagnostic overlays and probes.
2. Run `bash /evidence/check.sh`, then `bash /evidence/consumed-check.sh`.
   `storage-binding-check.sh` covers the coallocation storage/reset test in
   normal, race and 386 builds; it must pass before timing.
3. Run `bash /evidence/perf.sh`, then analyze the same 20 Go and YAML seeds
   with benchstat. `analyze.py` checks all raw medians. No extra seeds were
   added to the original run. `measurement.json` records the private screen
   phase; `source-reference.json` records subsequent qualification/promotion.
4. `fleet/run.sh` runs 206 invariant sessions, 618 C fixture checks, strict
   censuses in both roles, one-MiB C probes and focused races. Its initial
   gate files must come from the preceding checks and verified measurement
   ratchets, not a copied completion marker.
5. Run `rss-matched.sh` once in a new output directory, preserving its six
   initial probes and all 120 matched probes. Do not replace an unfavorable
   initial observation with another sample. The ceiling remains 400 B/source B.

`gate-logs.json` contains complete text and hashes for correctness logs;
`qualification-audit.json` indexes all 206 invariant and 206 C logs. The
strict censuses retain the same 45 known legacy failures. `rss-raw.txt`
retains complete standalone RSS output. Complete ledger values and hashes,
full construction/consumption vectors, canonical vectors, all 440 timing
rows, source pins and the runtime patch are archived here.

Actual-source checks ran after atomic promotion, against all 3,512 tracked
Go files. Their v1 guard used a pinned mirror of tracked sources to exclude
ignored historical worktrees. Only the owned-ledger diagnostic shim differs
from the qualified runtime files. An initial host assertion expected two
historical shims; the benchmark wrapper is now identical, leaving one.
That launcher ran no test and exited 127; the corrected audited launch
passed. The protected worktree's 113 staged files and diff hash stayed intact.

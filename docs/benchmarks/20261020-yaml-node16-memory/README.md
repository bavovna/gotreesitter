# Combined ordinary YAML memory screen, 2026-10-20

All three candidates are **held**: ordinary YAML's matched median maximum RSS
ratios are 1.16443, 1.14617, and 1.16318 against a 1.10 limit. No timing comparison
or runtime promotion follows these failures. See the
[receipt](../../compact-yaml-node16-memory-screen-20261020.md) for the scope.

`archives.json` pins all five archives; `archive-members.json` pins every
extracted member by size and SHA-256. The archives were reopened and all 1,010
members checked after construction.

| Archive | Contents |
| --- | --- |
| `source-protocol.tar.gz` | Exact source manifests, 32-file candidate overlay, focused/counter/capacity/RSS protocols, helpers, and observational driver overlay |
| `qualification.tar.gz` | Scoped Core, YAML C and invariant results; all 50 work comparisons; initial build failures |
| `observations.tar.gz` | All six initial and 120 matched RSS logs/readings, audit and rows, capacity attribution, Go CPU/YAML allocation profiles, and the separate paired Go graph-reachability census |
| `projection-demand.tar.gz` | A two-file overlay over the first candidate, its 3,540-file manifest, separate scoped qualification/counter/capacity results, and all 126 additional RSS processes |
| `publication-retirement.tar.gz` | A four-file overlay over the reserve follow-up, its 3,542-file manifest, separate scoped results, and all 126 additional RSS processes |

Reconstruct the reference from commit
`2264c231a57bb1f22c93e4929b0a5e73ed6441e5`, then verify all 3,527 Go hashes in
`baseline-source-pins.json`. Copy it, apply `candidate-overlay/`, and verify all
3,539 hashes in `candidate-source-pins.json`. The separate capacity diagnostic
uses `protocol/reserve-attribution/overlay.json`; it does not alter the pinned
candidate. Profiler runs likewise remain separate from RSS runs.

Extract the archives into separate evidence directories, then copy the
`protocol/` contents into an empty experiment directory. Keep the retained
results separate so a replay cannot overwrite them.
The protocols use `/reference` and `/candidate` for the source trees. For
focused and counter runs, `/lab` and `/evidence` both refer to the experiment
directory; for RSS runs `/lab` is that directory and `/evidence` is its `rss/`
subdirectory. Preserve the helper paths in the overlay JSON. Execute
`focused.sh` before `census-and-capacity.sh`, then `rss/run.sh`.
The last command intentionally returns nonzero when
the relative RSS gate fails; retain every process result.

Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, `GOMAXPROCS=1`, CPU 6, 6 GiB memory, and `GOMEMLIMIT=5GiB`.
The offline runner supplies the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.
Serialize heavy runs with the repository's two Docker locks. Rebuild probe
binaries from the pinned source and overlays; binaries are not archived.

The candidate passed the focused checks stated in the receipt. A full fleet,
ledger/C sweep, race/386 validation, and randomized timing remain unperformed
on this combined source. The profiling runs are attribution, not comparison
evidence.

For the demand-covered reserve follow-up, reconstruct the first candidate,
apply the second archive's `candidate-overlay/`, and verify its 3,540 Go hashes.
Use a separate empty experiment directory for that archive's `protocol/`
contents. Keep the same node16 reference and mount layout; run the same focused,
counter/capacity, and RSS sequence. The first counter attempt's missing-driver
failure is retained; the included `census.sh` makes the normal replay complete.
Its RSS command also intentionally fails the relative gate.

For the graph-retirement follow-up, reconstruct the demand-covered reserve
candidate, then apply the four-file overlay in `publication-retirement.tar.gz`
and verify its 3,542 Go hashes. Use its own empty experiment directory and the
same node16 reference and protocol sequence. Its RSS command likewise fails
the relative gate. The three screens retain 378 processes in total and use
separate seeds; none is a timing run.

For the independent Go liveness census, mount the pinned node16 reference at
`/candidate` and extracted `go-live-graph/` at `/evidence`, then run its `run.sh`
in the same isolated environment. Verify `instrumentation-pins.json` first.
Its two-file overlay adds only observational code; each of five fixtures
compares work and deep trees with an unobserved parse. Header/boundary roots
are sampled every 64 elections; other historical owners remain unexamined.
These results support investigation, not reclamation or timing claims.

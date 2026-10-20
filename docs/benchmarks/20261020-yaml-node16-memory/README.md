# Combined ordinary YAML memory screen, 2026-10-20

The candidate is **held**: ordinary YAML's matched median maximum RSS ratio is
1.16443 against a 1.10 limit. No timing comparison or runtime promotion follows
this failure. See the [receipt](../../compact-yaml-node16-memory-screen-20261020.md)
for the scope and the next hypothesis.

`archives.json` pins all three archives; `archive-members.json` pins every
extracted member by size and SHA-256. The archives were reopened and all 377
members checked after construction.

| Archive | Contents |
| --- | --- |
| `source-protocol.tar.gz` | Exact source manifests, 32-file candidate overlay, focused/counter/capacity/RSS protocols, helpers, and observational driver overlay |
| `qualification.tar.gz` | Scoped Core, YAML C and invariant results; all 50 work comparisons; initial build failures |
| `observations.tar.gz` | All six initial and 120 matched RSS logs/readings, audit and rows, capacity attribution, Go CPU and YAML allocation profiles and their protocols |

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

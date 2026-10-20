# Ordinary YAML ownership: two held memory results

Neither experiment is promoted. Both complete ordinary YAML with explicit compact candidate routing and preserve locked-C output, but ordinary YAML exceeds the relative RSS ratchet. No counters, budgets, allowlists, or runtime defaults change in this receipt.

| Variant | Source Go files | Full correctness/work gate | Go RSS ratio | Ordinary YAML RSS ratio | Owned YAML RSS ratio | Decision |
|---|---:|---|---:|---:|---:|---|
| Immutable packed trial masks | 3,530 | Pass | 1.013884 | 1.337192 | 0.908040 | Hold |
| Packed masks plus paged publication | 3,532 | Pass, including scoped races and 386 publication checks | 0.999318 | 1.301437 | 0.898752 | Hold |

Ratios are candidate/baseline medians from twenty matched alternating RSS pairs per workload; each run retains six initial plus 120 matched probes. Every candidate is below 400 bytes/source byte. The ordinary YAML ratios exceed the 1.10 relative limit. The two separately shuffled experiments do not establish the causal size of the paging change. No before/after throughput timings were run for either rejected source.

Each gate covers 206 language edit sessions with 72 steps each and zero-allocation no-edit reparses; 618 C fixture checks; 204 strict real-corpus rows, retaining 45 known legacy failures; four exact canonical Go work vectors and tree digests; 306 expanded Go cases, retaining the same 39 known failures; and budget, pooling, and scoped race checks. YAML alone moves from fallback to compact while staying C-exact, including the 8 KiB EOF witness and 1 MiB document streams. Every other ordinary ledger row remains exact.

The 50 focused whole-request/public work comparisons pass in both experiments. Ordinary R4 public nodes fall 288→232; the 8 KiB fixture falls 1,156→925. Whole-request tokens, including the baseline failed compact attempt, fall 124→107 and 441→423. Diagnostic-owned R4 nodes fall 484→232. The baseline returned legacy tree alone understates its whole-request peak, so comparisons include the failed attempt. See each counter-gate.json for all values.

Reproduce from runtime commit `f28a3c1cfca394fa378bf5994fead01c3886e73b`, then apply the three baseline-overlay files from the source archive. They are the qualified prepared YAML scanner from PR #1491 (merged as `dd8698f2dabfd92faf14197dd54afc934b7a5b73`). Apply candidate-overlay on a second copy, verify candidate-source-pins.json, and mount the frozen trees as /reference and /candidate. The protocol scripts and overlays use /evidence (RSS additionally uses /lab); run them in the pinned Go 1.25.14 Docker image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`, with the repository's offline C cache and serialized Docker locks. The source archives contain the exact helpers and script inputs; the qualification and RSS archives contain raw outputs. archive-manifest.json verifies every extracted member. Binaries and build caches are excluded.

The packed variant's cold 1 MiB allocation profile attributes 20.94 MiB to checkpoint interning and 10.41 MiB to publication lookup-buffer growth. These are cumulative allocation attributions, not retained bytes or causal RSS measurements. Paging does not sufficiently close the observed RSS gap. Further work must address the overlap of live graph, checkpoint and publication storage without weakening ownership or authentication.

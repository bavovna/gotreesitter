# Dense suffix for full-width node precedence

A late wide score used to allocate an int64 slot for every earlier NodeID. On the pinned 1 MiB Go witness, the first wide score appears at NodeID 873,785. The earlier 873,784 scores already fit in the lineage record. Starting the exceptional array at its first wide NodeID removes that unused prefix without narrowing scores or changing identities.

The capacity census confirms **8,388,608→1,398,336 bytes** (6,990,272 bytes, about 6.67 MiB, removed). Core capacity falls **135,297,372→128,307,100 bytes**, with the same 903,086 public nodes and 158,311 wide entries. This is an allocated-capacity and memory-budget improvement. It is not an RSS or throughput estimate.

Full int64 arithmetic, sentinel handling and overflow errors remain unchanged. Transaction checkpoints restore both origin and length. Reset and retention-release paths clear the origin. The EOF shadow copies it and rejects an incorrect origin; its existing mutation and alias assertions remain. New tests cover a long narrow prefix, both int64 extremes, first-wide rollback, reset and reused NodeIDs.

## Correctness and work

All **414 complete ledger rows** and **four canonical Go work vectors/tree digests** remain exact. All **206 × 72-step edit sessions** pass, with zero-allocation no-edit reparses. All **618 language-specific C fixture subtests** matched by exact name and passed. All 204 strict corpus rows remain exact, retaining 45 known legacy failures; all 306 expanded Go statuses and 300 routes remain exact, retaining 39 known failures.

The 1 MiB Go check was explicitly rebuilt with its helper overlay and matched `TestCompactLineageLargeGoLockedC` before this timing run: accepted compact route, 903,086 nodes, 425,742 tokens, exact C digest `1464b53d73dd7d3ad9ff2b7e064235a4a68442ec7e1379d4c2c263fc6a9eef6c`. The earlier empty-run output is retained as a failed harness attempt, not a gate. The audit rejects empty runs. Large YAML C, memory-budget, pooling, race, API and scoped 386 gates also pass.

The public branch has exact qualified runtime bytes. Its three differing test files are already merged Kotlin-isolation, G18 ABI-portability and CI-planner updates; public native/386 precedence and ABI checks, canonical lifecycle and both repository guards pass. No held Go correctness repair, direct-fill experiment, YAML ownership experiment or allowlist change is included.

## Measurements and limits

Twenty alternating matched process pairs per language use GOMAXPROCS=1, count=1, 750 ms and benchmem, with ordinary pools. Seeds are Go 42901–42920 and YAML 42801–42820. All 480 rows pass the median ratchets; all custom counters are exact; each language has twenty distinct matched workload orders. All twelve time comparisons are inconclusive. Fresh Go's B/op median falls 516,638,972→509,651,128 (−1.35%), but benchstat is borderline at p=.051. Do not claim a statistically established heap or throughput win from that comparison. The deterministic capacity reduction above is the established result.

Directional results are all retained below, including Go single-edit time +4.20% (p=.738) and YAML time medians up to +4.17%. Every time difference is inconclusive. Non-large-file heap metrics are effectively unchanged; no-edit B/op and allocs/op stay zero.

| Workload | Time median change | B/op median change | allocs/op median change |
|---|---:|---:|---:|
| go/fresh_one_mib | -5.742% | -1.353% | -0.440% |
| go/full_dfa | -0.794% | -0.000% | +0.000% |
| go/grammargen_lr | -4.509% | +0.000% | +0.000% |
| go/no_edit_dfa | -1.371% | +0.000% | +0.000% |
| go/query_compile | -1.905% | +0.000% | +0.000% |
| go/single_byte_edit_dfa | +4.202% | +0.125% | +0.000% |
| yaml/eof8k_legacy | +0.575% | +0.000% | +0.000% |
| yaml/eof8k_ordinary | +2.012% | +0.000% | +0.000% |
| yaml/eof8k_owned | +4.171% | +0.000% | +0.000% |
| yaml/r4_legacy | +3.699% | +0.000% | +0.000% |
| yaml/r4_ordinary | +3.694% | +0.000% | +0.000% |
| yaml/r4_owned | -0.737% | +0.000% | +0.000% |

The RSS run retains six initial plus 120 matched probes, seeds 42701–42720. Median candidate/baseline ratios are Go **0.993526**, ordinary YAML **1.027637**, diagnostic-owned YAML **1.010708**. Every candidate stays below 400 bytes/source byte and every relative median stays below 1.10. These results establish safety, not a causal resident-memory improvement.

## Reproduction

The baseline is the qualified prepared-scanner source: runtime `f28a3c1cfca394fa378bf5994fead01c3886e73b` plus the three baseline-overlay files. Apply candidate-overlay to a second copy and verify all 3,525 Go pins. Public base `51f20c87c1a134e3ccf612a81e0097db222487e2` has the same runtime, with the three test updates recorded above. Mount source copies as /reference and /candidate, protocol/evidence as /evidence; RSS/capacity also use /lab. Use Go 1.25.14 Docker image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`, locked C cache and serialized Docker locks. No timing or pool settings are relaxed.

The original shadow test assumed physical NodeID indexing and failed after the representation change; that log is retained. Its indexing was adapted to the origin, all ownership assertions remain, and an origin-mismatch check was added. The full shadow suite then passed. The initially absent large-Go helper was also repaired and verified before timing. Binaries/caches are excluded. Three archives and 992 members were verified by SHA-256.

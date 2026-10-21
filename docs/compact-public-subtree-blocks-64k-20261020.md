# Public subtree blocks: 65,536-record geometry

This candidate reduces allocated bytes on the 1 MiB Go fixture by **17.52%** against PR #1502's qualified compact node-block implementation. Timing is inconclusive in all twelve cells. It is locally qualified. PR #1502 passed its final ready-event CI and merged as `356c980d58fc5c5e3fb8478d8eda50fa4f6ece58`. This successor carries the identical qualified runtime onto that merge; its own latest-head CI remains pending. Compact graduation remains unproven.

The reference is `98747629037d6934b9dcf6dfbb41db6d082a3078` (runtime code `647ea982cdf2f6accedce5cda0705949f957acb8`), now merged with identical runtime source. Candidate runtime code is `e91e0322f1b094c0995684449f9b90a1a08f4783`. Go source pins cover all 3,535 reference and 3,541 candidate files; 47 internal files differ.

## Change and rejected alternative

Store public subtree records in typed suffix blocks after the existing contiguous prefix. Growth adds blocks without copying all existing records. IDs, record order, capacity limits, rollback behavior, and EOF shadow cloning remain unchanged. Clone sizing reserves the exact additional EOF root, including a new block-table entry when needed.

The earlier 16,384-record geometry saved 18.42% of large-Go allocated bytes but increased heap objects 21.59%, violating the 10% ratchet; it remains rejected. This version changes only the block shift from 14 to 16. Each 65,536-record block holds 44-byte records (2.75 MiB), with no reclamation or pool changes. See [the rejected screen](compact-public-subtree-block-screen-20261020.md).

## Deterministic work and correctness

All 414 ledger rows, four canonical Go work/tree vectors, 204 strict C statuses, 306 expanded Go C statuses, and 300 expanded Go route outcomes match the reference. Existing strict differences remain 159 passes/45 known failures; expanded Go remains 267 passes/39 known failures.

All 206 languages pass 72-step incremental=fresh sessions and 618 named C fixture checks. Owned YAML, large YAML, and the actual 1 MiB Go locked-C digest pass. The five complete core build modes pass 588/600/624/722/600 tests. Focused race, 386, memory-budget, pool-retention, API, and layout gates pass. No no-edit parse allocates.

Logical node count (1,032,095), public nodes (903,086), tokens (425,742), and subtree record capacity (44,972,840 bytes) remain exact. The suffix table has 15 entries and costs 360 bytes. Reported core backing rises from 119,918,852 to 119,919,212 bytes; the fixed header rises from 4,320 to 4,368 bytes. These are charged metadata changes, not work-counter increases.

## Paired measurements

Twenty alternating matched pairs use the repository randomized runner, one process per explicit seed, `GOMAXPROCS=1`, `-count=1`, `-benchtime=750ms`, and `-benchmem`, with unchanged pools and budgets. Go seeds are 46801–46820; YAML seeds are 46701–46720. All 480 rows and matched workload orders are audited.

Large-Go allocated bytes fall **453,602,488 → 374,143,160 B/op** (−17.52%, p<0.001). Objects move **259.5 → 273 allocs/op** (+5.20%, p=0.197), within the 10% ratchet. Every timing comparison is inconclusive; directional changes remain recorded below.

| Workload | Time | Allocated bytes | Objects |
| --- | ---: | ---: | ---: |
| fresh_one_mib | -1.77% | -17.52% | +5.20% |
| full_dfa | -0.25% | -0.00% | +0.00% |
| grammargen_lr | +5.49% | +0.00% | +0.00% |
| no_edit_dfa | +0.36% | +0.00% | +0.00% |
| query_compile | -2.25% | +0.01% | +0.00% |
| single_byte_edit_dfa | +3.24% | +0.00% | +0.00% |
| eof8k_legacy | +0.02% | +0.00% | +0.00% |
| eof8k_ordinary | +0.41% | +0.00% | +0.00% |
| eof8k_owned | +3.42% | +0.00% | +0.00% |
| r4_legacy | +0.13% | +0.00% | +0.00% |
| r4_ordinary | +4.47% | +0.00% | +0.00% |
| r4_owned | +4.49% | +0.00% | +0.00% |

The retained RSS campaign includes six initial processes and 120 matched processes (seeds 46601–46620). Every candidate stays below 400 bytes/source byte; the maximum is 299.24. Candidate/reference median ratios are 0.96522 for Go, 0.98205 for ordinary YAML, and 0.99498 for owned YAML, all inside the 10% ratchet.

Ordinary YAML still declines to legacy in this candidate. This memory result does not establish compact graduation or a Go throughput improvement. The separate ordinary-YAML ownership composition requires its own counters, C, invariant, RSS, and timing evidence.

Raw output, source overlays, source pins, commands, failed build attempts, all RSS probes, and archive member hashes are in [the evidence bundle](benchmarks/20261020-public-subtree-blocks-64k/README.md).

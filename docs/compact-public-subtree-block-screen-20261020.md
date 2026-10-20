# Public subtree blocks: allocation-count rejection

The 16K-record subtree arena stays **held**. Fresh one-MiB Go allocated bytes fall **442,502,200→360,993,368 B/op (-18.42%, p<.001)**, but heap objects rise **238.5→290 (+21.59%, p<.001)**. That exceeds the 10% allocation ratchet. All 480 rows were retained and audited; the byte saving does not qualify this runtime for promotion.

The reference is the qualified graph-node arena in PR #1502: code commit `647ea982cdf2f6accedce5cda0705949f957acb8`, equivalent Go source at PR head `98747629037d6934b9dcf6dfbb41db6d082a3078`. The held candidate has 3,541 Go files, with 47 internal files changed relative to the 3,535-file reference. Its private Buckley code commit is `215dfb79063df1e9211ce5962a7d4a453a08b8b3`. This receipt publishes evidence only.

The candidate stores public subtree records in a contiguous prefix and 16,384-record suffix blocks. Logical SubtreeIDs, records, limits and rollback behavior stay intact. Reset retains buffers. Capacity and footprint use cached gauges and charge full block metadata. Detached EOF clones copy active data, reserve the appended recovery root exactly and charge any additional block metadata; original-record prefix comparisons and full-capacity alias checks remain.

The paired one-MiB Go capacity probe keeps 1,032,095 graph nodes, 903,086 public constructions and 44,972,840 subtree-record capacity bytes. The new subtree table has 62 suffix entries and costs 1,488 bytes. Core backing capacity rises 119,918,852→119,920,340; its fixed header grows 4,320→4,368 bytes. The allocation-byte reduction comes from avoiding repeated whole-arena growth copies. Final record capacity is unchanged.

All 414 ledger rows and four canonical Go work/tree vectors remain exact. All 206 × 72-step invariant sessions, explicit owned YAML and 618 exact named C fixture checks pass. The 204 strict corpus outcomes retain 45 known legacy failures. All 306 expanded Go outcomes and 300 routes remain exact, retaining 39 known failures. The actual one-MiB Go C tree digest remains `1464b53d73dd7d3ad9ff2b7e064235a4a68442ec7e1379d4c2c263fc6a9eef6c`; large YAML C tests pass too.

Default, shadow, phase-zero, phase-zero-A and one-pass Core modes pass with 588 / 600 / 624 / 722 / 600 named top-level tests. Scoped race, native/386, budget/pool, layout and API gates pass. All 3,541 candidate and 3,535 reference source hashes remain exact after timing. No production block retirement is enabled.

| Counter | Before→after |
| --- | ---: |
| Complete ordinary and owned ledger rows | 414→414, exact |
| Canonical Go tree/work vectors | 4→4, exact |
| Go R4 full nodes / tokens | 1,251→1,251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1,784→1,784 / 266→266 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go public constructions / tokens | 903,086→903,086 / 425,742→425,742 |

Twenty alternating matched pairs per language use GOMAXPROCS=1, count 1/process, 750 ms, benchmem, normal pools, CPU 6 and serialized six-GiB Docker. Go seeds are 46301–46320; YAML seeds are 46201–46220. Actual paired workload orders, route/work metrics and all 480 rows were audited. The only median-ratchet failure is the Go one-MiB heap-object count.

| Case | Time change | p | B/op change | Objects before→after |
| --- | ---: | ---: | ---: | ---: |
| go/fresh_one_mib | +0.095% | 0.841 | -18.420% | 238.5→290 |
| go/full_dfa | -2.314% | 0.738 | +0.000% | 37→37 |
| go/grammargen_lr | -7.533% | 0.102 | +0.000% | 1,706→1,706 |
| go/no_edit_dfa | +4.103% | 0.119 | +0.000% | 0→0 |
| go/query_compile | -6.393% | 0.018 | +0.000% | 121→121 |
| go/single_byte_edit_dfa | -0.904% | 0.862 | -0.125% | 5→5 |
| yaml/eof8k_legacy | -1.003% | 0.289 | +0.000% | 13→13 |
| yaml/eof8k_ordinary | +0.313% | 0.478 | +0.000% | 34→34 |
| yaml/eof8k_owned | -0.187% | 0.512 | +0.000% | 191→191 |
| yaml/r4_legacy | +1.172% | 0.659 | +0.000% | 16→16 |
| yaml/r4_ordinary | +1.042% | 0.947 | +0.000% | 37→37 |
| yaml/r4_owned | +0.520% | 0.547 | +0.000% | 72→72 |

Go query-compile time falls 6.39% (p=.018); one-MiB parse timing is inconclusive (p=.841). No-edit reparses allocate zero bytes and objects. Every direction is retained in the table, including controls; the allocation failure holds the entire candidate.

All 126 RSS processes pass, retaining the six initial and 120 matched processes. Candidate/baseline median ratios are 0.972676 Go / 0.972258 ordinary YAML / 1.029631 owned YAML. Maximum candidate RSS is 286.824 bytes/source byte, below 400. RSS seeds are 46101–46120. These establish safety, not a causal RSS reduction.

Initial compilation caught a borrowed record-store alias, a test receiver missed by the AST migration, and two detached-snapshot slice operations. Their source hashes, overlays and failed logs remain archived. The fixes preserve remap-error assertions, compare the original record prefix after shadow appends and reserve recovery-root capacity exactly. Native, race and 386 tests cover that reserve at block boundaries and reject interior/unused-buffer aliases.

The follow-up increases blocks to 65,536 records to reduce page-buffer allocations. It requires fresh correctness, memory and timing gates. No counter exception or production pin changes were requested. Ordinary YAML routing and graduation settings remain unchanged. The [replay bundle](benchmarks/20261020-public-subtree-blocks/README.md) contains exact sources, rejected attempts, executed protocols, all raw results and hashes.

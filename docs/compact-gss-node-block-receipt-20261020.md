# Blocked graph-node storage

Blocked graph-node storage reduces allocated bytes on fresh one-MiB Go **475,332,760→442,838,168 B/op (-6.84%, p<.001)**. The measured trade is **+2.38% time on grammargen/lr.go (p=0.028)**. All 414 ledger rows and four canonical Go work/tree vectors remain exact. This is a memory-allocation improvement; compact graduation and a general throughput improvement remain unproven.

Small node arenas keep a contiguous prefix. Larger ones use 65,536-record suffix blocks, so growth copies at most a partial block. Logical one-based NodeIDs, records, limits, path-count widths and rollback behavior remain intact. Reset retains reusable buffers; detached EOF snapshots copy active records and preserve the ID map. Footprint and capacity gauges read cached scalars, refreshed when backing storage changes. Budgets charge retained buffers and full pointer-table capacity.

The paired capacity probe keeps 1,032,095 graph nodes and 16,777,216 record-capacity bytes. Block metadata adds 360 bytes: backing capacity moves 119,918,492→119,918,852. The fixed Core header grows 4,240→4,320 bytes; this is reported separately because the existing footprint contract measures backing buffers. No production code calls block retirement. Reclamation still requires an owner proof.

All 206 × 72-step invariant sessions, explicit owned YAML, 618 exact language-specific C fixture checks, and 204 strict corpus rows pass their comparison gates. The 45 known strict legacy failures remain. All 306 expanded Go outcomes and 300 routes remain exact, retaining 39 known failures and 90 compact / 210 fallback routes. The actual one-MiB Go C test runs before timing and preserves tree digest `1464b53d73dd7d3ad9ff2b7e064235a4a68442ec7e1379d4c2c263fc6a9eef6c`. Large YAML C tests pass.

Default, shadow, phase-zero, phase-zero-A and one-pass Core suites pass with 584 / 595 / 619 / 717 / 595 named top-level tests. Native, 386, scoped race, budget/pool, layout and API guards pass. Both new 32-bit boundary regressions fail on the rejected prototype and pass on the final source, including race and 386 runs. All 3,535 candidate Go hashes remain exact.

| Counter | Before→after |
| --- | ---: |
| Complete ordinary and owned ledger rows | 414→414, exact |
| Canonical Go tree/work vectors | 4→4, exact |
| Go R4 full nodes / tokens | 1,251→1,251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1,784→1,784 / 266→266 |
| Owned YAML candidate full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go public constructions / tokens | 903,086→903,086 / 425,742→425,742 |

Twenty alternating matched pairs per language use GOMAXPROCS=1, count 1/process, 750 ms, benchmem, normal pools, CPU 6 and serialized six-GiB Docker. The repository randomized runner uses Go seeds 46001–46020 and YAML 45901–45920. All 480 rows, paired workload orders, route/work metrics and median ratchets pass.

All 126 RSS processes pass, retaining all six initial and 120 matched processes. Candidate/baseline median ratios are 0.972930 Go / 0.994199 ordinary YAML / 1.007250 owned YAML. Maximum candidate RSS is 305.226 bytes/source byte, below 400. RSS seeds are 45801–45820. These are safety results, not a causal RSS-reduction claim.

| Case | Time change | p | B/op change | Objects before→after |
| --- | ---: | ---: | ---: | ---: |
| go/fresh_one_mib | +0.536% | 0.640 | -6.836% | 230→244.5 |
| go/full_dfa | +1.337% | 0.060 | +0.000% | 37→37 |
| go/grammargen_lr | +2.378% | 0.028 | +0.000% | 1,706→1,706 |
| go/no_edit_dfa | -2.617% | <.001 | +0.000% | 0→0 |
| go/query_compile | -0.464% | 0.841 | +0.000% | 121→121 |
| go/single_byte_edit_dfa | +0.372% | 0.659 | +0.000% | 5→5 |
| yaml/eof8k_legacy | -2.709% | <.001 | +0.000% | 13→13 |
| yaml/eof8k_ordinary | -3.007% | 0.001 | +0.000% | 34→34 |
| yaml/eof8k_owned | -0.074% | 0.841 | +0.001% | 191→191 |
| yaml/r4_legacy | -1.669% | 0.001 | +0.000% | 16→16 |
| yaml/r4_ordinary | -2.111% | 0.033 | +0.000% | 37→37 |
| yaml/r4_owned | +0.910% | 0.398 | +0.000% | 72→72 |

Go one-MiB object medians move 230→244.5 (+6.30%, p=0.179); that comparison is inconclusive. No-edit samples allocate zero bytes and objects. A nanosecond-scale no-edit timing change does not establish a general parser speedup. All directional changes, including the grammargen regression, are retained above.

Ordinary YAML R4 / 8 KiB time medians move −2.11% / −3.01%, while legacy controls also move −1.67% / −2.71%. Those control shifts prevent attributing the observed YAML timing changes to the Core storage change.

The earlier uncached arena screen passed its original gates and reduced Go allocated bytes by 6.84%, but its budget gauges scanned block tables. The first cached prototype was stopped after a new 386 audit reproduced a maximum-width limit conversion panic and mistaken append-tail retirement. The final source clamps in uint64 before converting capacity to int and tests the remaining tail span without overflowing an end offset. Both rejected sources, partial results, expected failures and the uncached measurements remain archived. The final comparison uses the node16 main baseline directly; it is not an uncached-versus-cached timing comparison.

Ordinary YAML keeps its fallback route. The pending Go correctness exception, language allowlists, production ledger pins and graduation settings remain unchanged. The [replay bundle](benchmarks/20261020-gss-node-blocks/README.md) contains exact overlays, protocols, source hashes, all raw results and every archive-member hash.

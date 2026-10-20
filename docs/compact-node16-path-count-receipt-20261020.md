# Sixteen-byte graph headers preserve full path counts

The graph-header change reduces allocated bytes on fresh one-MiB Go **521,062,824→485,661,096 B/op (−6.79%, p<.001)**. Ordinary YAML allocated bytes fall **14,808→14,040 (−5.19%) / 49,065→45,737 (−6.78%)** on R4 / 8 KiB (both p<.001). All **414 ledger rows** and four canonical Go work/tree vectors remain exact. All twelve timing differences are inconclusive; no throughput improvement is claimed.

A read-only census of the qualified Go witness finds **1,032,095 graph nodes**: 980,491 have path count 1 and 51,604 have count 2. A uint64 in every physical node wastes eight bytes on this shape. The new header keeps state, byte offset, first link and link count in **16 bytes**, down from 24. Logical publication requests retain their complete values. Counts 0–61 occupy unused lineage flag bits, saturated uint64 remains exact, and other counts use a sorted sparse arena with their full uint64 value. IDs, scores, link ordering and limits keep their widths and meaning.

The lineage row stays 16 bytes. Publication and rollback preserve its count bits while changing owner, set, rank or recovery metadata. Reset, failed publication, capacity gauges, retention release and detached EOF clones include the sparse arena. Exceptional entries cost 16 bytes each on amd64; the measured Go witness needs **zero**. Full-width boundary values and 2,048 generated uint64 cases, reused IDs, saturation, lineage updates, rollback and clone mutation/alias checks pass. Existing corruption probes mutate the same logical counts through test-only accessors; their assertions remain.

The paired capacity probe confirms node storage **25,165,824→16,777,216 bytes**, exactly **8 MiB removed**. Core capacity falls **128,307,100→119,918,492 bytes**, with the same graph nodes, 903,086 public constructions and 425,742 tokens. Capacity, allocated-byte totals and RSS are separate measurements.

## Correctness and work

All **206 × 72-step edit sessions** plus explicit owned YAML pass, including zero-allocation no-edit reparses. All **618 language-specific C fixture checks** matched their exact names and passed. All 204 strict corpus rows remain exact, retaining 45 known legacy failures. All 306 expanded Go outcomes and 300 routes remain exact, retaining 39 known failures. The one-MiB Go test actually runs before timing, preserves the C tree digest `1464b53d73dd7d3ad9ff2b7e064235a4a68442ec7e1379d4c2c263fc6a9eef6c`, and rejects empty test runs. Large YAML C witnesses also pass.

Full default, shadow, parsercorephase0/phase-zero-A and one-pass Core modes pass, along with native/386, scoped race, budget/pool and API guards. The public working branch has all **3,527** qualified Go hashes exactly; the current-main baseline has all **3,525** main Go blobs. The later base advance adds documentation only. No held Go correctness repair, YAML ownership prototype, counter exception, production pin, allowlist or graduation change is included.

| Counter | Before→after |
| --- | ---: |
| Complete ordinary and owned ledger rows | 414→414, exact |
| Canonical Go tree/work vectors | 4→4, exact |
| Go R4 full nodes / tokens | 1,251→1,251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1,784→1,784 / 266→266 |
| Owned YAML candidate full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go public constructions / tokens | 903,086→903,086 / 425,742→425,742 |

## Matched measurements

Twenty alternating pairs per language use GOMAXPROCS=1, count 1/process, 750 ms and benchmem, normal pools, CPU 6 and serialized six-GiB Docker. The repository randomized runner uses Go seeds **44401–44420** and YAML **44301–44320**. Every paired workload order matches; Go has 20 distinct orders and YAML 19 across 20 explicit seeds. All **480 rows**, route/work metrics and median ratchets pass. Both source manifests remain exact after timing. All no-edit samples retain zero bytes and allocations.

All directions are retained below. Go query time moves +5.86% (p=.134) and YAML legacy R4 +6.15% (p=.414); both are inconclusive. Legacy controls do not establish a causal Core effect. Small byte rounding includes Go edit 399→400 B/op (p=.165). The large-Go allocation-count change 245.5→244.5 is inconclusive (p=.363); every other object median is equal.

| Case | Time median change | p | B/op change | Objects before→after |
| --- | ---: | ---: | ---: | ---: |
| go/fresh_one_mib | -0.928% | .904 | -6.794% | 245.5→244.5 |
| go/full_dfa | +3.033% | .072 | +0.000% | 37→37 |
| go/grammargen_lr | +2.251% | .925 | +0.000% | 1706→1706 |
| go/no_edit_dfa | +2.265% | .713 | +0.000% | 0→0 |
| go/query_compile | +5.863% | .134 | +0.000% | 121→121 |
| go/single_byte_edit_dfa | +4.754% | .211 | +0.251% | 5→5 |
| yaml/eof8k_legacy | -4.362% | .495 | +0.000% | 13→13 |
| yaml/eof8k_ordinary | -1.288% | .398 | -6.783% | 34→34 |
| yaml/eof8k_owned | +2.783% | .445 | +0.000% | 191→191 |
| yaml/r4_legacy | +6.151% | .414 | +0.000% | 16→16 |
| yaml/r4_ordinary | -3.525% | .414 | -5.186% | 37→37 |
| yaml/r4_owned | -1.980% | .989 | +0.000% | 72→72 |

All **126 RSS processes** pass, including the six initial probes and 20 matched pairs per case. Candidate/baseline median ratios are **0.983083 Go / 1.002976 ordinary YAML / 0.991763 owned YAML**; maximum candidate RSS is **304.367 B/source byte**, below 400. These establish safety, not a causal retained-memory claim. Seeds are **44201–44220**.

Initial compile attempts caught unused physical-header bindings and fixture types. A shadow regression missed an import; two size checks retained the old 24-byte expectation. Their outputs remain archived. The physical assertions were changed to 16; pointer-free, overflow, corruption and tree assertions remain intact.

[Exact source overlays, protocols, all raw results and hashes](benchmarks/20261020-node16-path-counts/README.md) retain the complete evidence. Ordinary YAML still uses fallback, Go's known C failures remain open, and compact graduation is not established.

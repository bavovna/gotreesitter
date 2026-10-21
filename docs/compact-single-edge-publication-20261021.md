# Single-edge graph publication result, 2026-10-21

**N stays held as an unproven experiment.** It passed correctness, exact work/reuse counters and memory qualification, but all 12 timing differences are nonsignificant and it demonstrated no Go throughput win. Go full parsing rises 2.25% directionally, LR rises 5.01%, and single-byte edit time rises 7.76%; query compilation rises 0.29% and the 1MiB parse rises 1.41%. These observations do not justify a runtime PR or promotion. No improvement or graduation is claimed.

N fuses fresh single-edge and node publication in `condenseDirectAppend`, avoiding the immediate edge readback and general adjacency walk when the just-created edge has a validated ordinary shape. Uncommon edge flags and general copied/multiple-edge cases retain the full validator. The original node write body is shared, with full-width precedence/path-count storage, checkpoint handling, journaling and work updates preserved. Failure ordering and the temporary link/work mutation before failed node publication remain unchanged for outer rollback. Five focused regressions cover 112 full-width cases, 17 malformed/error-priority cases, caps/overflows and nested rollback. Only three Go files differ; the root Go count remains 756.

The runtime commit is `a7de7da0a6f74e112bf1ad97c7bd97c07bf5bc66`, based on qualified D64 `e91e0322f1b094c0995684449f9b90a1a08f4783` (non-documentation code equivalent to PR1504 revision `d30639dd95af74197305ca76de645ea8d9c29c07`). The measured protocol authenticates all 3,543 candidate Go hashes and 3,541 baseline Go hashes before and after timing; it deliberately identifies frozen sources rather than claiming Git commit authentication. The experiment contains no held native-YAML, L or M overlay.

Every directional median change follows, including controls and nonsignificant increases. Positive time/byte/object changes are increases. All timing p-values are ≥0.05; exact medians, every paired sample and full benchstat tables remain in the archives.

| Workload | Time change | B/op change | Allocations/op change |
| --- | ---: | ---: | ---: |
| Go fresh_one_mib | +1.41% (p=0.211) | -0.000563% | 0% |
| Go full_dfa | +2.25% (p=0.583) | -0.000116% | 0% |
| Go grammargen_lr | +5.01% (p=0.242) | 0% | 0% |
| Go no_edit_dfa | -1.35% (p=0.369) | 0% | 0% |
| Go query_compile | +0.29% (p=0.968) | 0% | 0% |
| Go single_byte_edit_dfa | +7.76% (p=0.183) | 0% | 0% |
| YAML eof8k_legacy | -2.07% (p=0.165) | 0% | 0% |
| YAML eof8k_ordinary | -0.03% (p=0.698) | 0% | 0% |
| YAML eof8k_owned | +2.93% (p=0.398) | 0% | 0% |
| YAML r4_legacy | -2.33% (p=0.201) | 0% | 0% |
| YAML r4_ordinary | +0.20% (p=0.620) | 0% | 0% |
| YAML r4_owned | +4.03% (p=0.383) | 0% | 0% |

All allocation medians are unchanged except tiny full-parse byte decreases: Go DFA 429,372→429,371.5 B/op and 1MiB 386,179,384→386,177,208 B/op. These differences are nonsignificant and are not claimed as wins. All no-edit samples retain zero allocated bytes and objects. YAML legacy controls move down directionally while owned R4/8KiB time rises 4.03%/2.93%; their allocation medians stay unchanged. All 36 metric directions are retained, and the median 10% ratchets pass. Passing those screens does not establish a speedup.

Linux AMD64 correctness qualification preserves **414 complete ledger rows and four canonical Go work/tree vectors**, passes **206 languages ×72 edit steps** and **618 C fixture checks**, and preserves all 204 strict statuses (159 PASS/45 existing FAIL), 306 expanded Go statuses (39 existing failures) and 300 routes. Core mode pass counts are 593/605/629/727/605. Scoped race, actual 386 execution, API/layout, ownership, budget, pool and R6 checks pass. Ordinary YAML remains fallback and diagnostic-owned YAML remains compact; deterministic benchmark routes, nodes and tokens match for every sample.

All **126 RSS processes** are retained: six initial probes plus 20 matched pairs for each of Go, ordinary YAML and owned YAML, with seeds 48701–48720 and shuffled case order. Candidate/baseline median ratios are 0.999772/0.996277/1.034450; every candidate probe stays below 400 bytes/source byte. The owned-YAML RSS increase remains visible. These are memory gates, separate from timing.

Throughput uses pinned Go 1.25.14 Linux AMD64 Docker, CPU 6 with one CPU quota, 6GiB memory and 5GiB Go limit, GOMAXPROCS=1, one process/count per seed, 750ms and benchmem with normal pools/budgets. Go seeds 49301–49320 and YAML seeds 49201–49220 give **480 rows/80 processes**, alternating roles with matched shuffled workload order. Exact runner, benchmark fixtures, source pins, expected counters, pre/post qualification audits and statistical reports are archived. No ARM64 samples are pooled. The terminal Docker inspect records exit 0 and no OOM; its public derivation retains exact terminal state and resource fields. The earlier running-state inspection is retained separately as a configuration snapshot and is not treated as completion proof.

The initial focused screen interruption during 386 compilation is retained with the explicit remaining-check resume; completed source-pinned native/Core/race checks were reused. The first timing launch failed before samples because the common lock file was absent after a Linux restart. That mount failure is parent-reported from tool output without a separate raw capture; the valid launch touched the existing lock in the same command. No source, image, limit or seed changed, and no measured samples were replaced or excluded.

[Archive hashes](benchmarks/20261021-single-edge-publication/archives.json) and [member hashes](benchmarks/20261021-single-edge-publication/archive-members.json) cover the source delta, exact protocols, raw qualification/memory/performance observations, known failures and all directional results. Original preparation-time metadata remains historical alongside the authoritative completed receipts. N remains private and held; this receipt does not open a runtime PR, change routing, merge code or graduate compact.

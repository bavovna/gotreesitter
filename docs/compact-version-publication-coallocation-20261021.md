# Immutable version-publication allocation receipt, 2026-10-21

L reduces allocations on ordinary YAML while preserving the qualified parser behavior. On Linux ARM64, ordinary 8KiB parsing drops **71→39 allocations/op (−45.07%)** and **18,368→17,920 B/op (−2.44%)**; R4 drops **40→32 allocations/op (−20.00%)** and **5,520→5,456 B/op (−1.16%)**. These changes have p<0.001 across 20 matched pairs. All 12 timing differences are nonsignificant. No throughput improvement or compact graduation is claimed.

Clean immutable first publications share snapshot storage. Whole snapshot pages include these embedded bytes; separately allocated wrappers keep their own charge. Both current page shapes are charged even without a live publication, correcting the prior omission of the second page shape. Exact-value matching preserves snapshot/request/baseline ownership, recovery-bearing states retain the existing allocation path, and cloning clears self-referencing cached publications. Revision `1f0143fdbacc1ce6c5ece8a770e86ca0cd049fb5` is compared with I `e750600b2f657951b6ca99cf8fc1c7908c316da9`. The six new tests were moved into an existing test file to preserve the fixed 756-root-file cap; all 2,018 production Go files remain identical across that repair.

The table records every directional median change, including controls. Positive time/byte/object changes are increases. All timing p-values are ≥0.05; full raw medians, paired values and benchstat tables are archived.

| Workload | Time change | B/op change | Allocations/op change |
| --- | ---: | ---: | ---: |
| Go fresh_one_mib | +0.05% (p=0.904) | 0% | 0% |
| Go full_dfa | +0.60% (p=0.904) | +0.000116% | 0% |
| Go grammargen_lr | -0.41% (p=0.547) | 0% | 0% |
| Go no_edit_dfa | -0.02% (p=0.673) | 0% | 0% |
| Go query_compile | +0.10% (p=0.718) | 0% | 0% |
| Go single_byte_edit_dfa | +0.30% (p=0.301) | +0.25% | 0% |
| YAML eof8k_legacy | -0.12% (p=0.583) | 0% | 0% |
| YAML eof8k_ordinary | +0.10% (p=0.640) | -2.44% | -45.07% |
| YAML eof8k_owned | +0.80% (p=0.640) | +0.59% | 0% |
| YAML r4_legacy | -0.40% (p=0.231) | 0% | 0% |
| YAML r4_ordinary | +1.44% (p=0.495) | -1.16% | -20.00% |
| YAML r4_owned | +0.11% (p=0.383) | +0.49% | 0% |

Diagnostic-owned YAML increases allocated bytes: R4 **13,072→13,136 (+0.49%)** and 8KiB **43,296→43,552 (+0.59%)**, both p<0.001, with object counts unchanged. Go changes are nonsignificant, including edit bytes 405→406 B/op (p=0.170) and full-parse bytes 429,383.5→429,384 B/op (p=0.930). No-edit parsing retains zero allocated bytes and objects. These allocation results do not close the ordinary YAML throughput gap: native routing remains held against fallback from the [prior qualification](compact-native-node-slab-tail-20261021.md). Packed64 experiment M is separate and is not attributed to L.

Linux AMD64 qualification preserves **414 ledger rows and four canonical Go vectors**, passes **206 languages ×72 edit steps** with zero no-edit allocations and **618 C fixture checks**, preserves all 204 strict statuses (159 PASS/45 existing FAIL), and preserves 306 expanded Go statuses (39 existing failures) and 300 routes. Core mode pass counts are 611/626/650/748/626; scoped race, 386 execution, layout, ownership, budget and pool checks pass. All **189 RSS processes** are retained. Candidate/fallback median ratios are Go 0.972813, ordinary YAML 1.096911 and owned YAML 0.796546; all candidate probes stay below 400 bytes/source byte. These are memory-safety results, not throughput evidence.

ARM64 timing uses the Apple M1 Max host with pinned Linux ARM64 Go 1.25.14 image, GOMAXPROCS=1, one process/count per seed, 750ms and benchmem. Go seeds48301–48320 and YAML seeds48201–48220 give **480 rows/80 processes**, alternating roles with matched workload order. Counters, routes, no-edit zero allocations and median ratchets pass. AMD64 and ARM64 timing samples are never pooled. I/L manifests authenticate 4,352/4,354 input files, including 3,562/3,564 Go files; the exact randomized runner is pinned separately.

The retained v2 operational attempt stopped before samples because its runner script was absent (exit127); v3 mounts the unchanged exact runner. A pre-launch schema failure and initial temporary image-inspect miss are parent-reported events without separate raw capture; the final exact image verification is retained. Sources, image, seeds and limits did not change, and no measured samples were replaced or excluded.

[Archive hashes](benchmarks/20261021-version-publication-coallocation/archives.json) and [member hashes](benchmarks/20261021-version-publication-coallocation/archive-members.json) cover the frozen Linux qualification archives, all raw ARM64 rows/logs/audits/container state, statistical reports and sanitized replay protocol. No runtime/default/allowlist change, merge or graduation follows from this receipt.

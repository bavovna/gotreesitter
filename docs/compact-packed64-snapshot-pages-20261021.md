# Packed64 snapshot allocation receipt, 2026-10-21

M reduces ordinary YAML allocations on Linux ARM64: the 8KiB witness drops **39→35 allocations/op (−10.26%)**, and R4 drops **32→31 (−3.12%)**, with allocated bytes unchanged. Diagnostic-owned 8KiB parsing drops **197→195 allocations/op (−1.02%)**. These object reductions have p<0.001 across 20 matched pairs. Diagnostic-owned R4 bytes rise **13,136→13,712 (+4.38%, p<0.001)** with objects unchanged. All 12 timing differences are nonsignificant. This is an allocation tradeoff, with no throughput or compact graduation claim.

Revision `73556f21928e68712de2f08452d05620334fee9e` compares with qualified L `1f0143fdbacc1ce6c5ece8a770e86ca0cd049fb5`. M pairs two immutable snapshot records in one page, giving each record its own 64-byte field backing when its combined scanner fields occupy 33–64 bytes. The 32-byte page path and larger fallback remain intact. Full snapshot identity, field capacity separation, stable owners across rollover/reset, and all current/retired page storage accounting are preserved. Owner field reordering keeps the owner size unchanged. The six-file delta adds two internal Go files and preserves the 756-root-Go-file limit.

Every directional median and control is recorded below. Positive time/byte/object changes are increases. All timing p-values are ≥0.05; raw medians, matched seeds, counters and complete benchstat tables are archived.

| Workload | Time change | B/op change | Allocations/op change |
| --- | ---: | ---: | ---: |
| Go fresh_one_mib | +0.69% (p=0.211) | 0% | 0% |
| Go full_dfa | -0.88% (p=0.620) | +0.000116% | 0% |
| Go grammargen_lr | -0.000305% (p=0.659) | 0% | 0% |
| Go no_edit_dfa | +0.17% (p=0.151) | 0% | 0% |
| Go query_compile | -0.52% (p=0.512) | 0% | 0% |
| Go single_byte_edit_dfa | -0.11% (p=0.799) | 0% | 0% |
| YAML eof8k_legacy | -0.03% (p=0.758) | 0% | 0% |
| YAML eof8k_ordinary | +1.01% (p=0.583) | 0% | -10.26% |
| YAML eof8k_owned | -1.43% (p=0.060) | 0% | -1.02% |
| YAML r4_legacy | +0.46% (p=0.925) | 0% | 0% |
| YAML r4_ordinary | +0.81% (p=0.478) | 0% | -3.12% |
| YAML r4_owned | +0.09% (p=0.640) | +4.38% | 0% |

Ordinary R4/8KiB allocated bytes stay 5,456/17,920 B/op. Owned 8KiB median bytes stay 43,552.5 B/op. Go allocation changes are nonsignificant; full-parse bytes move 429,376→429,376.5 B/op (p=0.670), and the other Go allocation medians are unchanged. No-edit parsing retains zero bytes and objects. Legacy YAML controls retain their byte/object medians. The owned-R4 byte increase is retained as a measured tradeoff rather than hidden by the ordinary-YAML object win; all median 10% allocation/time ratchets pass.

Linux AMD64 qualification preserves **414 ledger rows and four canonical Go vectors**, passes **206 languages ×72 edit steps** and **618 C fixture checks**, preserves all 204 strict statuses (159 PASS/45 existing FAIL), and preserves 306 expanded Go statuses (39 existing failures) and 300 routes. Core mode pass counts are 614/629/653/751/629. Scoped race, 386 execution, API/layout, budget, ownership and pool checks pass. All **189 RSS processes** remain in the archives; candidate/fallback median ratios are Go 0.974754, ordinary YAML 1.097543 and owned YAML 0.811894. All candidate probes stay below 400 bytes/source byte. Candidate/L median RSS ratios are 1.001053/0.997038/0.991310. These figures establish memory safety and the retained ratchets; they are not throughput evidence.

The Mac tailnet worker supplied an Apple M1 Max host running the pinned Go 1.25.14 **Linux ARM64 Docker** image. Timing used GOMAXPROCS=1, one count/process per seed, 750ms, benchmem, normal pools/budgets and serialized workloads. Go seeds 48901–48920 and YAML seeds 48801–48820 give **480 rows/80 processes**, with alternating roles and identical shuffled workload order per pair. Deterministic counters, routes and no-edit zero allocations pass. ARM64 and AMD64 samples are never pooled. Complete manifests authenticate all 4,354/4,356 input files; all 3,564/3,566 manifested Go files match the actual L/M commits.

The focused ARM64 screen separately passes **92 top-level test executions**, including the native tests repeated under race, with no skips or failures. Its 386 packages compile to ELF32/i386 and are hashed; they were not executed on ARM64. Linux qualification contains actual 386 execution. The focused ARM64 screen contains neither the 206-language sweep nor C parity. Its pre-commit candidate manifest exactly matches committed M. The temporary pre-launch image-inspect miss is parent-reported without separate raw capture; the final exact image is verified, no samples existed before the lookup recovered, and no measured samples were replaced or excluded.

[Archive hashes](benchmarks/20261021-packed64-snapshot-pages/archives.json) and [member hashes](benchmarks/20261021-packed64-snapshot-pages/archive-members.json) cover three frozen Linux qualification archives, all raw ARM64 rows/logs, statistical reports, container/source/image receipts, sanitized replay, and focused screen evidence. Private worker identity, host paths, raw execution receipts and generated binaries are excluded. L/M native YAML routing remains held. A separate net comparison with the qualified fallback is outside this receipt; no net success, route promotion, merge or graduation is claimed here.

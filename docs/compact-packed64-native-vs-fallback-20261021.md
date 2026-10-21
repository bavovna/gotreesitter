# Native YAML versus qualified fallback: held, 2026-10-21

**The combined native-YAML/M candidate fails the net performance gate and stays held.** Against qualified D64, ordinary YAML R4 parsing takes **251,125.5→369,818 ns/op (+47.26%)** and the 8KiB witness **790,104.5→1,428,589.5 ns/op (+80.81%)**, both p<0.001. Diagnostic-owned R4 allocated bytes rise **11,848→13,712 B/op (+15.73%, p<0.001)**. These are the three failed 10% median ratchets. No runtime PR, route promotion or graduation follows.

The runtime container completed all **480 rows/80 processes** with exit 0 and no OOM. Source authentication, per-role counter policy, matched sample/order checks and no-edit zero allocations pass. The launcher exits 1 because the unchanged post-run audit rejects the three measured ratchets; it is not a parser crash, incomplete benchmark or correctness failure. The raw failure is preserved.

Baseline `d30639dd95af74197305ca76de645ea8d9c29c07` matches qualified D64 `e91e0322f1b094c0995684449f9b90a1a08f4783` for all transported files. Candidate `73556f21928e68712de2f08452d05620334fee9e` includes the full native-YAML architectural series and L/M allocation changes. This comparison assesses the combined candidate; it does not attribute each regression to one patch. The [L](compact-version-publication-coallocation-20261021.md) and [M](compact-packed64-snapshot-pages-20261021.md) relative allocation receipts remain valid allocation tradeoffs, with no net throughput claim.

Every directional median change, including controls, follows. Positive values are increases. All exact medians, paired rows and full significance tables are archived.

| Workload | Time change | B/op change | Allocations/op change |
| --- | ---: | ---: | ---: |
| Go fresh_one_mib | +4.05% (p=0.011) | -3.64% | +2.51% |
| Go full_dfa | +1.80% (p=0.038) | +0.000233% | 0% |
| Go grammargen_lr | +2.86% (p=0.005) | 0% | 0% |
| Go no_edit_dfa | -0.11% (p=0.542) | 0% | 0% |
| Go query_compile | +4.22% (p<0.001) | 0% | 0% |
| Go single_byte_edit_dfa | +0.37% (p=0.091) | 0% | 0% |
| YAML eof8k_legacy | -0.95% (p=0.046) | 0% | 0% |
| YAML eof8k_ordinary | +80.81% (p<0.001) | -60.82% | +2.94% |
| YAML eof8k_owned | +5.78% (p<0.001) | +6.10% | +2.09% |
| YAML r4_legacy | -0.89% (p=0.149) | 0% | 0% |
| YAML r4_ordinary | +47.26% (p<0.001) | -61.14% | -16.22% |
| YAML r4_owned | +6.18% (p<0.001) | +15.73% | +2.78% |

Go query compilation rises 4.22% (p<0.001), LR 2.86% (p=0.005), full DFA 1.80% (p=0.038), and 1MiB parsing 4.05% (p=0.011). Its 1MiB allocated bytes fall 353,761,144→340,889,336 (−3.64%, p=0.006), while object medians rise 239.5→245.5 (+2.51%, p=0.068). Single-byte edit timing and no-edit timing differences are nonsignificant; every no-edit sample allocates zero bytes and objects. Go allocation changes outside the 1MiB witness are nonsignificant.

Ordinary YAML R4/8KiB allocated bytes fall 61.14%/60.82%, but the timing failures hold both routes. R4 objects fall 37→31; 8KiB objects rise 34→35. Owned R4/8KiB time rises 6.18%/5.78%, allocated bytes rise 15.73%/6.10%, and objects rise 72→74/191→195, all p<0.001. Legacy 8KiB timing falls 0.95% (p=0.046); legacy R4 timing is nonsignificant and their byte/object medians remain exact. These controls and all 36 metric directions are retained.

Current work/reuse qualification preceded timing. **50 public/full/edit/declined-attempt comparisons pass**, with zero work increases and zero reuse decreases. Of 414 broad ledger rows, 412 are exact. The two changed YAML rows are fully retained: the ordinary candidate changes declined→accepted, and owned candidate full/first-edit nodes fall 484→232. All other 205 languages and the legacy/default YAML ledger remain unchanged. The current census includes work spent on declined compact attempts; the timing surface does not expose additional reuse counters.

The hashed per-role timing policy requires ordinary D64 compact/fallback 0/1→M 1/0; public nodes R4 288→232 and 8KiB 1,156→925, with tokens 107/423 unchanged. Owned routes stay compact 1/fallback 0; nodes 484→232 and 1,936→925, with tokens 102/403 unchanged. Go custom counters and legacy controls remain exact. These predeclared route/work differences are not a waiver of the throughput gate.

The existing [M qualification](compact-packed64-snapshot-pages-20261021.md) remains pinned by [archive links and hashes](benchmarks/20261021-packed64-native-vs-fallback/qualification-links.json): 206 languages ×72 edit steps, 618 C fixture checks, preserved 204 strict statuses (159 PASS/45 existing FAIL), 306 expanded Go statuses (39 existing failures) and 300 routes, scoped race, actual Linux 386 execution, API/layout/budgets, 189 RSS processes and 92 focused ARM64 test executions. Those correctness/memory results do not override these measured performance failures.

The Apple M1 Max tailnet worker ran pinned Go 1.25.14 **Linux ARM64 Docker**, GOMAXPROCS=1, count 1/process, 750ms, benchmem, normal pools/budgets, CPU quota 2/cpuset 2,3, 4GiB memory and 3GiB Go limit with serialized workloads. Go seeds 49101–49120 and YAML seeds 49001–49020 use 20 alternating matched pairs per language and identical shuffled workload orders. No AMD64 or other-host timing samples are pooled. Both complete source manifests are authenticated before and after timing.

The public forward replay contains **66 replacements and 25 additions**, all 91 changed Go files, rather than only M's six-file delta from L. Every transported file was freshly authenticated against frozen local bytes and actual Git blobs: 4,331 D64 files/3,541 Go against both baseline commits, and 4,356 M files/3,566 Go against its commit. Both root Go counts remain 756. The original reverse delta and its digest remain available. The first transfer attempt stopped before extraction because the Mac Python tarfile API lacked the filter keyword; no tests or timing started. The compatible retry validates every archive member before extraction. The existing Mac checkout remains clean and unchanged at `58671e4c22b07c56ceaa6c43447a95e9e1c1f544`; transports are separate.

[Archive hashes](benchmarks/20261021-packed64-native-vs-fallback/archives.json) and [member hashes](benchmarks/20261021-packed64-native-vs-fallback/archive-members.json) preserve all raw samples, failure/status logs, complete counters/changed ledgers, policy, statistical tables, source manifests, forward/reverse replay and public provenance derivations. Private worker identity/paths and raw execution metadata are omitted with original digests retained. The combined candidate and native YAML stay held; no improvement, runtime PR, promotion or compact graduation is claimed.

# Immutable snapshot pages: fewer objects, rejected byte cost

Fresh four-record pages preserve scanner snapshot ownership and reduce the
8 KiB owned-YAML allocation count **218→181 (−16.97%)**. They do not establish a
throughput improvement. R4 allocates only three fewer objects while bytes rise
**13032→18392 (+41.13%)**, so this layout is not promoted.

The [five-file proposal and complete evidence](benchmarks/20261019-fresh-scanner-snapshot-pages/README.md)
use runtime `54863cf280722c720bda81c2a8480f2398255730` as the baseline. Neither
rejected ordinary-YAML streaming nor the unapproved Go correctness proposal is
included. No compiled runtime, work pin, routing or graduation state changes.

## Storage and correctness

Pages coallocate four records and their small scanner fields. Every published
address stays immutable: reset drops current pages and never overwrites an old
slot. Only the current page of each shape remains retained by the allocator;
live records keep earlier pages reachable. An immutable storage identity lets
the memory gate charge a shared page once, including unused slots and unpublished
construction. Other shapes retain the exact existing constructor.

Root tests verify storage deduplication, unused-capacity charging, unchanged
published contents after reset, rejection of stale generations and independently
owned clones. All scanner binding, destination, contract and checkpoint checks
remain in place. The helper's native, 386 and race gates pass, including **64
records in 16 allocations**; this unit result is not a whole-parser estimate.

Full Core tests, canonical Go lifecycle work, memory-budget regressions and the
Go/ordinary-YAML/explicit-owned-YAML 72-step sessions pass. Each no-edit case
allocates nothing. The existing YAML document, prefix and scanner-cursor C/edit
suite passes. Six public full/edit work rows match the frozen baseline exactly;
no work exception is needed. Full-fleet, general race, API/layout, paired RSS and
large-file qualification are not transferred to this rejected proposal.

## Twenty shuffled pairs

The repository runner completes **440 rows**, twenty alternating pairs per
language, normal runner pooling, GOMAXPROCS=1, count=1, 750ms and benchmem in
serialized 6 GiB Docker on CPU 6. Work and route metrics remain exact throughout.

| Owned YAML | Time before → after | p | Bytes before → after | Allocations |
| --- | ---: | ---: | ---: | ---: |
| R4 | 410.908→404.216 µs | .947 | 13032→18392 (+41.13%) | 79→76 (−3.80%) |
| 8 KiB | 1.560→1.535 ms | .698 | 44952→47816 (+6.37%) | 218→181 (−16.97%) |

Ordinary YAML retains its fallback and exact bytes/allocations. Its R4 / 8 KiB
time directions are **−0.93% / −4.43%**, p=.989 / .174. Legacy controls retain
exact bytes/allocations; time directions are **+4.77% / +4.79%**, p=.968 / .478.
All YAML timings are inconclusive.

| Go control | Time direction | p |
| --- | ---: | ---: |
| Full DFA | −8.38% | .165 |
| Single-byte edit | +0.13% | .495 |
| No edit | −1.81% | .445 |
| Public query_compile | −2.57% | .659 |
| Public grammargen_lr | −2.16% | .841 |

All Go timings are inconclusive. Allocations remain exact; full-DFA bytes move
**429379→429380.5**, a 1.5-byte median direction. Every no-edit sample has zero
bytes and zero allocations. No time/object median exceeds the 10% ratchet, but
there is no supported timing benefit to justify the R4 byte cost.

This result narrows the next design requirement: amortize snapshot allocation
without reserving several unused full records for each payload shape. Any
successor must preserve published addresses, bounded retention and complete
capacity accounting, then pass its own gates.

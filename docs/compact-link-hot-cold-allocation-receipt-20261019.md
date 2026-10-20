# Graph links: qualified allocation reduction with an RSS cost

The [29-file split representation](benchmarks/20261019-link-hot-cold/README.md)
keeps identities and next links in 16 bytes and full-width score/order/flag
metadata in optional immutable shared records. Logical link IDs, all flags,
signed arithmetic and rollback retain their meaning. The control is runtime
`b7046b6c5385ec52a09fb8b8250c9d689754b74e`, before the latest main integration.
No compiled runtime changes in this receipt; the combined source needs fresh
qualification on main 88dc1d9c before promotion.

All 414 complete work/reuse ledger rows and four canonical trees/work vectors
match exactly. Representative before → after counters:

| Counter | Before → after |
| --- | ---: |
| Go R4 full nodes / tokens | 1251→1251 / 589→589 |
| Go first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

The source passes 206 ordinary 72-step sessions, explicit owned YAML, 618 C
fixture checks, unchanged strict census and 306 Go C outcomes / 300 routes,
large Go/YAML witnesses, memory/pooling/publication controls, Core modes,
386, scoped races and API/layout/R6/selector guards. Existing strict and Go
C failures remain open. No route, pin, exception or graduation changes.

Twenty alternating shuffled pairs produce all 480 rows. **Allocated bytes
fall 6.89% on one-MiB Go and 10.19–12.47% on ordinary YAML** (all p<.001).
All twelve timing differences are inconclusive; no speedup is claimed. Times
are ns/op. Every direction and object cost is retained below.

| Case | Time before → after | Direction | p | B/op before → after | Objects before → after |
| --- | ---: | ---: | ---: | ---: | ---: |
| GoParseCompactFreshOneMiB | 903,960,153.5→914,889,652.5 | +1.21% | .565 | 539,585,416→502,397,808 | 328→344 |
| GoParseFullDFA | 9,228,717.5→9,455,062.5 | +2.45% | .989 | 429,372.5→429,371 | 37→37 |
| GoParseIncrementalNoEditDFA | 3.5855→3.523 | -1.74% | .429 | 0→0 | 0→0 |
| GoParseIncrementalSingleByteEditDFA | 116,756.5→112,559.5 | -3.59% | .314 | 401→400.5 | 5→5 |
| StreamedPrefixGo/grammargen_lr | 116,242,469→115,966,511.5 | -0.24% | .925 | 1,155,600→1,155,600 | 1,706→1,706 |
| StreamedPrefixGo/query_compile | 10,679,575.5→11,247,975.5 | +5.32% | .820 | 8,112→8,112 | 121→121 |
| StreamedPrefixYAML/eof8k_legacy | 586,188→609,604.5 | +3.99% | .841 | 1,264→1,264 | 13→13 |
| StreamedPrefixYAML/eof8k_ordinary | 667,408.5→717,669.5 | +7.53% | .060 | 49,097→42,976 | 34→35 |
| StreamedPrefixYAML/eof8k_owned | 1,593,172→1,537,519 | -3.49% | .820 | 45,528→45,528 | 191→191 |
| StreamedPrefixYAML/r4_legacy | 171,666.5→168,182.5 | -2.03% | .718 | 1,440→1,440 | 16→16 |
| StreamedPrefixYAML/r4_ordinary | 221,300.5→217,206 | -1.85% | .495 | 14,840→13,328 | 37→38 |
| StreamedPrefixYAML/r4_owned | 397,573.5→412,135 | +3.66% | .461 | 13,032→13,032 | 72→72 |

Ordinary YAML adds one allocation per operation (p<.001). Large-Go object
medians rise 4.88% (p=.124), inconclusive. No time/object median exceeds its
10% ratchet. Every no-edit sample has zero bytes and allocations. Owned YAML
bytes and object medians stay exact; ordinary YAML still uses fallback.

All 126 RSS processes pass, maximum **308.558 B/source byte**. Median RSS
ratios are **1.060237 Go / 1.015017 ordinary YAML / 1.044686 owned YAML**.
These increases are costs of this measured candidate, despite its lower
allocated-byte totals; the result does not establish a retained-memory or
throughput win. YAML, Go and RSS use seeds **38601 / 38701 / 38801** through
the next nineteen seeds, with GOMAXPROCS=1, count=1, 750ms and benchmem.
The raw archives preserve the isolated setup failures, complete source pins,
all samples and exercised replay modes. The independent 32-byte version-state
prototype targets the frequent publication callers; it is not included here.

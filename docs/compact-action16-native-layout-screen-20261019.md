# Native action layout: safe, throughput improvement unproven

The [two-file native Action experiment](benchmarks/20261019-action16-native-layout/README.md)
reorders full-width fields from 20 to 16 bytes without an encoded decoder.
It passes all correctness, counter and memory gates but establishes no runtime
win. The prototype is not applied to production; its replay patch is archived.
The control is runtime `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`, before the
closed acceptance-group repair. It is not combined with the graph prototype.

All **414 complete ledger rows** and four canonical trees/work vectors remain
exact. Representative before → after counters:

| Counter | Before → after |
| --- | ---: |
| Go R4 full nodes / tokens | 1251→1251 / 589→589 |
| Go first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

All 206 ordinary 72-step sessions, explicit owned YAML, 618 C checks, the
unchanged strict census, all 306 Go C outcomes and 300 routes, large Go/YAML
witnesses, Core modes, 386, scoped races, memory/publication controls and
API/layout/R6/selector gates pass. Existing strict and Go C failures remain
visible; this experiment does not fix them or graduate a language.

All **480 shuffled timing rows** finish. All twelve timing differences are
inconclusive. Go full time moves **-2.02% (p=.414)**, one-MiB **-3.75% (p=.265)**,
grammargen **-4.07% (p=.495)** and query **+0.66% (p=.799)**. Owned YAML R4
moves **+1.11%**. Every object median stays exact and every time/object median
passes its ratchet. One-MiB Go remains **539,585,416 B/op / 325 objects/op**.
The per-record size reduction has no separately measured retained-table receipt.

All **126 RSS processes** pass, maximum **297.617 B/source byte**; median ratios
are **1.008743 Go / 0.998773 ordinary YAML / 1.000834 owned YAML**. Every no-edit
sample allocates nothing. No production source, route, counter pin, exception
or graduation setting changes. The larger next target is dense graph links
with shared immutable metadata, qualified separately on the published
acceptance-group correctness fix.

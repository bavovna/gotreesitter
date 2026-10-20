# Compact graph nodes: qualified memory reduction

Shrinking graph nodes **32→24 bytes** reduces one-MiB Go allocated bytes
**579888608→528111072 (−8.93%, p<.001)**. Median peak RSS falls **7.13% for Go,
2.94% for ordinary YAML and 6.11% for owned YAML**. Ordinary-YAML allocated
bytes fall **4.92% on R4 / 5.42% on 8 KiB**, p<.001. All twelve timing
differences are inconclusive. This change establishes memory improvements.

The [twenty-file source and reproducible evidence](benchmarks/20261019-node24-lineage-precedence/README.md)
use runtime `ca89615f82e02ca065c35e96a947934ba67f8e90` as the baseline. These
measurements are independent of prior capacity and snapshot-pair comparisons;
do not add their percentages. Ordinary YAML keeps its fallback, and no language
graduates. The pending 17-file Go correctness repair is absent.

## Representation and correctness

State IDs remain 32-bit, link counts 32-bit and path counts 64-bit. Common
precedence values fit a signed 16-bit field inside the existing **16-byte hot
lineage record**, after flattening the alternative set's six live bytes. Set
getters and updates preserve those exact bytes independently of precedence.
Lineage publication retains the destination node's immutable precedence.

One reserved value selects full int64 storage. That array uses direct NodeID
indexes, allocates only when needed, and never reserves more entries than the
node arena's capacity. Arithmetic and overflow checks keep full precision.
Transactions truncate its logical end; reset and decline cleanup handle its
retention. Footprints include all capacity. Diagnostic shadow copies detach,
compare and charge the wide storage. New regressions cover both integer limits,
overflow, rollback, reused IDs, reset and lineage mutations.

All **414 complete fixture-ledger rows** match the baseline, including work,
reuse, routes, stops, extents and errors. All four canonical Go deep-tree hashes
and complete Core/scheduler vectors match. No production work pin or exception
changes. Representative ledger counters remain:

| Counter | Before → after |
| --- | ---: |
| Go R4 candidate full nodes / tokens | 1251→1251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML ledger full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

The **206 ordinary 72-step edit sessions**, explicitly activated owned-YAML
72-step session and **618 C smoke checks** pass. No-edit reparses allocate
nothing. Strict real-corpus results remain **120 compact passes / 39 legacy
passes / 45 known legacy failures** across 204 files.

The fresh Go control and candidate have identical outcomes on all **306 cases**:
261/300 expanded passes, the same 39 failures and six targeted passes. All 300
expanded routes match: 90 compact / 210 fallback. This preserves current
behavior; it does not fix the failures awaiting the separate correctness
proposal. The **1048591-byte Go witness** matches the complete locked-C digest,
accepts without fallback or errors and retains its full work vector. Large
YAML document/scanner/edit C comparisons also pass.

Core normal, phase0A, one-pass, shadow, 386 and scoped race suites pass. Root
memory/pooling contracts, real publication stop controls and races pass. Native
integration preserves every measured Go hash. Root/API guards retain 756 files
and 12 tag sets; R6 and all 65 workflow selectors pass.

## Twenty shuffled pairs

The repository runner completes **480 rows**, with twenty alternating pairs per
language, GOMAXPROCS=1, count=1 per explicit seed, 750ms and benchmem. Runs are
serialized in pinned 6 GiB Docker on CPU 6. YAML seeds are 36801..36820;
Go seeds are 36901..36920. Custom work and route metrics remain exact throughout.
The public one-MiB benchmark separately asserts exact work, full coverage and
compact=1/fallback=0 on every operation.

| Case | Median time before → after | Direction | p |
| --- | ---: | ---: | ---: |
| Go one-MiB fresh parser | 1.195→1.217 s | +1.86% | .547 |
| Go full DFA | 12.296→12.608 ms | +2.54% | .841 |
| Go one-byte edit | 148.807→153.341 µs | +3.05% | .678 |
| Go no edit | 4.357→4.542 ns | +4.25% | .805 |
| Go query_compile | 14.387→14.641 ms | +1.77% | .947 |
| Go grammargen_lr | 153.660→152.949 ms | −0.46% | .925 |
| Ordinary YAML R4 | 301.480→292.074 µs | −3.12% | .738 |
| Ordinary YAML 8 KiB | 940.600→916.024 µs | −2.61% | .289 |
| Owned YAML R4 | 541.336→552.975 µs | +2.15% | .883 |
| Owned YAML 8 KiB | 2.098→2.117 ms | +0.87% | .904 |
| Legacy YAML R4 | 228.958→219.578 µs | −4.10% | .157 |
| Legacy YAML 8 KiB | 799.621→792.640 µs | −0.87% | .314 |

All time differences are inconclusive and below the 10% median ratchet. Large
Go allocation counts move **278→275**, p=.105, also inconclusive. Every other
allocation-count median remains exact. Full-Go bytes move **429374→429375**
and query bytes **8112→8113**, both inconclusive. Edit bytes stay 403. Every
no-edit sample has **0 B/op and 0 allocations**.

| YAML case | Bytes before → after | Allocation count |
| --- | ---: | ---: |
| Ordinary R4 | 15608→14840 (−4.92%, p<.001) | 37→37 |
| Ordinary 8 KiB | 51913→49097 (−5.42%, p<.001) | 34→34 |
| Owned R4 | 13032→13032 | 72→72 |
| Owned 8 KiB | 45528→45528 | 191→191 |

Legacy YAML bytes and allocations stay exact. All **126 RSS processes** pass,
including six initial probes. Maximum candidate RSS is **297.879 B/source byte**,
below 400. Matched median candidate/baseline ratios are **0.928745 Go /
0.970580 ordinary YAML / 0.938866 owned YAML**, below 1.10. Every original
sample is retained. RSS is safety and memory evidence; throughput remains unproven.

The receipt preserves the initial failed sizing probe, the reserve test's
byte-floor failure and the corrected expanded-route audit. The reserve test
now checks the actual reserve plan and a stricter relative incremental bound;
it does not force the implementation to waste bytes merely to exceed one MiB.

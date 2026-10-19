# Stable request window: measured rejection

The six-file proposal is **not promoted**. Its 480 shuffled rows show no
owned-YAML throughput or allocation benefit. The one-MiB Go allocation median
moves **278→325 (+16.91%)**, exceeding the 10% ratchet. That distribution is
wide and inconclusive (p=.930); the median gate still fails. YAML legacy R4
time rises **7.66% (p=.007)**. No slowdown is excused by its likely source or by
the prototype's intended scope.

Control runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
The [complete source pins, raw samples and replay inputs](benchmarks/20261019-yaml-stable-request-window/README.md)
identify 3518 baseline / 3520 candidate Go files. This comparison includes
neither the pending Go correctness repair nor either packed-action proposal.
No production runtime, ledger pin, exception, route or graduation changes.

## Mechanism and review

A checked four-byte request-window base lets election-prefix compaction move
sidecar entries while preserving surviving immutable header references. It
removes the loop that republishes every header only to renumber those
references. Lookup, append and clear reject stale prefixes, invalid lengths
and namespace overflow, including on 386. The next window is staged before
Core frontier advancement; failed elections retain their prior state.

Recovery's arbitrary-hole pruning keeps its existing renumbering barrier,
translated into the current window. It does not acquire the prefix window's
stale-reference guarantee for arbitrary holes. The recovery gate separately
checks order, shared immutable rollback wrappers, recovery fields and no-op
allocation behavior at zero, nonzero and greater-than-MaxInt32 offsets.
The first race selector omitted the pruning test's suffix. The original script
and logs remain, with the corrected run and exact PASS assertions; timing
started only after the corrected race gate completed.

## Correctness and deterministic work before timing

All **414 complete fixture-ledger rows** match, including routes, stops,
extents, errors, work and reuse. All four canonical Go trees and complete
Core/scheduler vectors match. Representative counters remain:

| Counter | Before → after |
| --- | ---: |
| Go R4 candidate full nodes / tokens | 1251→1251 / 589→589 |
| Go first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

All **206 ordinary 72-step sessions**, explicit owned YAML, and **618 C smoke
checks** pass. Every invariant no-edit reparse allocates nothing. The strict
census stays **120 compact passes / 39 legacy passes / 45 known failures**.
All **306 Go C outcomes / 300 routes** match a fresh control, retaining the
same 39 expanded failures. The one-MiB Go locked-C deep digest and full work
vector match; large YAML document/scanner/edit C checks pass.
Core normal, phase0A, one-pass, shadow, 386 and scoped races pass. Root memory,
pooling, real publication stop controls, races, layout/API/R6 and all 65
workflow selectors pass. These results preserve existing coverage; they do
not establish graduation.

## Twenty shuffled pairs

The repository runner uses twenty alternating pairs per language,
GOMAXPROCS=1, count=1 per seed, 750ms and benchmem, normal pooling, serialized
in pinned 6 GiB Docker on CPU 6. YAML seeds are **37701..37720**, Go
**37801..37820**. All 480 rows complete and all custom work/route metrics stay
exact. Times below are ns/op. Raw samples and benchstat retain every direction.

| Case | Time before → after | Direction | p | B/op before → after | Allocs/op before → after |
| --- | ---: | ---: | ---: | ---: | ---: |
| GoParseCompactFreshOneMiB | 1,081,856,620→1,123,925,275.5 | +3.89% | 0.301 | 528,375,312→539,780,556 | 278→325 |
| GoParseFullDFA | 11,085,381→11,604,481 | +4.68% | 0.640 | 429,377→429,374 | 37→37 |
| GoParseIncrementalNoEditDFA | 4→4 | -0.27% | 0.512 | 0→0 | 0→0 |
| GoParseIncrementalSingleByteEditDFA | 136,431.5→136,399 | -0.02% | 0.414 | 402→402 | 5→5 |
| StreamedPrefixGo/grammargen_lr | 134,720,611→140,443,334.5 | +4.25% | 0.512 | 1,155,600→1,155,600 | 1,706→1,706 |
| StreamedPrefixGo/query_compile | 12,991,757.5→12,937,020.5 | -0.42% | 0.779 | 8,112→8,112.5 | 121→121 |
| StreamedPrefixYAML/eof8k_legacy | 691,762→733,456.5 | +6.03% | 0.076 | 1,264→1,264 | 13→13 |
| StreamedPrefixYAML/eof8k_ordinary | 795,064→812,700.5 | +2.22% | 0.231 | 49,097→49,097 | 34→34 |
| StreamedPrefixYAML/eof8k_owned | 1,803,931→1,773,965.5 | -1.66% | 0.355 | 45,528→45,528 | 191→191 |
| StreamedPrefixYAML/r4_legacy | 182,547.5→196,536 | +7.66% | 0.007 | 1,440→1,440 | 16→16 |
| StreamedPrefixYAML/r4_ordinary | 252,894.5→264,520.5 | +4.60% | 0.056 | 14,840→14,840 | 37→37 |
| StreamedPrefixYAML/r4_owned | 455,880.5→470,706.5 | +3.25% | 0.495 | 13,032→13,032 | 72→72 |

All Go timings and all other YAML timings are inconclusive. Owned-YAML bytes
and allocations remain exactly **13032 / 72** at R4 and **45528 / 191** at
8 KiB. The Go large-file byte median moves **528375312→539780556 (+2.16%,
p=.109)**. Every no-edit sample has zero bytes and allocations.

All **126 RSS processes** pass, including the six initial samples. Maximum
candidate RSS is **318.949 B/source byte**, below 400. Candidate/baseline
median ratios are **0.998512 Go / 1.005969 ordinary YAML / 0.992225 owned YAML**,
within 1.10. RSS safety does not override the allocation ratchet or establish
a throughput improvement.

## What the profile changes

The existing b513 owned-YAML allocation profile attributes **63.35% of sampled
allocation objects** to `publishVersionState`. Filtering its caller stacks
places **54.30% of all sampled objects** under
`installEquivalentVersionLexerState`, through request publication and shifts.
No samples attribute that allocation to the removed election-compaction loop.
The completed timing samples likewise show no YAML allocation reduction.

This attribution includes setup/calibration and sampling; cumulative shares
overlap. It does not prove the loop never executes or predict a speedup.
Further work should target those actual immutable-publication callers while
preserving rollback, scanner validation and bounded retention.

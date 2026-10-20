# Ordinary YAML streaming ownership: correctness progress, timing rejection

Ordinary YAML now completes privately on compact, including the one-MiB witness,
with C-exact output and fewer native constructions. The combined source is
**rejected for promotion**: ordinary R4/8 KiB time rises **16.66%/42.63%** and
allocation counts rise **37→43/34→83**. Go full-parse time also exceeds the
10% median ratchet. Smaller output alone does not close the throughput gap.

Baseline: published runtime `54863cf280722c720bda81c2a8480f2398255730`.
The [source, raw pairs, counters and replay helper](benchmarks/20261019-yaml-streamed-prefix/README.md)
pin thirteen changed files, 3514 baseline and 3517 candidate Go sources. No
compiled runtime, work pin, route allowlist or graduation state changes.
The separate seventeen-file Go correctness proposal remains pending owner review.

## Construction and ownership

The experiment ports the binding-corrected single-prefix proof and the streaming
native publisher onto the latest qualified runtime. It transfers an already
executed shared request only from a clean, authenticated sole-version prefix.
It retains exact scanner binding, contract, checkpoint, elected-state and pending
token checks. An unowned split invalidates the proof; only a validated rejoin
can restore it. No pending token is scanned again.

Streaming emits public occurrences without constructing hidden native wrappers.
A workspace belongs to the pooled runner rather than a captured callback.
Scheduler accounting includes retained workspace capacity throughout the request;
cleanup clears all public pointers and drops oversized buffers. Rejected
publication charges its constructed nodes before releasing the arena. Comparison,
borrowed, eager and unsupported recovery materializations retain their guards.
The selector uses the complete external terminal lexicon and executed owned
requests, with no language-name comparison.

Four metadata comparisons cover ordinary/owned R4 and 8 KiB sources. State and
proof bits, fields, points, fragility, column flags and legacy read receipts match.
On the same accepted compact graphs, native constructions fall **484→232** and
**1936→925**. The reachable R4 tree contains 231 nodes plus one compatibility
construction. These counts do not imply a speed improvement.

## Counters before timing

Fifty comparisons pass without a work increase or reuse decrease. These public
candidate measurements include fallback; they are distinct from the default
ledger's incremental route. Both edits remain fresh fallbacks, with zero reuse.

| Candidate mode / witness | Full nodes before → after | First-edit nodes before → after | Returned tokens |
| --- | ---: | ---: | ---: |
| Ordinary R4 | 288→232 | 288→232 | 107→107 |
| Ordinary 8 KiB | 1156→925 | 1156→925 | 423→423 |
| Owned R4 | 484→232 | 484→232 | 102→102 |
| Owned 8 KiB | 1936→925 | 1936→925 | 403→403 |

The baseline ordinary route's failed compact attempt already reaches two live
versions. Whole-request peaks stay **2→2** on both witnesses. Comparing only the
returned legacy tree's peak of one would omit that attempted work. Including its
17/18 consumed tokens gives full-request totals **124→107 / 441→423**. The raw
public and retained-runner censuses preserve both observations. Default routing
stays unchanged, and no counter exception or pin reset is requested.

## Twenty alternating shuffled pairs

The repository runner completes **440 rows**, twenty pairs per language, in
serialized 6 GiB Docker on CPU 6 with Go 1.25.14, GOMAXPROCS=1, count=1,
750ms and benchmem. The shared benchmark uses normal runner pooling, checks work
on every parse and records every route. All source hashes remain exact afterward.

| YAML mode / witness | Time before → after | Change; p | B/op before → after | Allocations |
| --- | ---: | ---: | ---: | ---: |
| Ordinary R4 | 219.699→256.309 µs | +16.66%; .009 | 15608→6272 | 37→43 |
| Ordinary 8 KiB | 695.784→992.419 µs | +42.63%; <.001 | 51913→21808 | 34→83 |
| Owned R4 | 404.176→419.007 µs | +3.67%; .925 | 13032→13280 | 79→80 |
| Owned 8 KiB | 1.467→1.593 ms | +8.55%; .583 | 44952→45200 | 218→219 |
| Legacy R4 control | 160.425→172.386 µs | +7.46%; .799 | 1440→1440 | 16→16 |
| Legacy 8 KiB control | 627.553→592.887 µs | −5.52%; .799 | 1264→1264 | 13→13 |

Ordinary bytes fall **59.82%/57.99%**, but both time and allocation counts fail
their ratchets. Owned byte/allocation costs rise by 248 bytes and one object.
Owned and legacy timing differences are inconclusive; the legacy controls bypass
the changed path and supply no attributable speed claim.

| Go control | Time before → after | Change; p |
| --- | ---: | ---: |
| Full DFA | 8.040→8.909 ms | +10.81%; .134 |
| Single-byte edit | 107.355→112.613 µs | +4.90%; .314 |
| No edit | 3.2775→3.371 ns | +2.85%; .180 |
| Public query_compile | 9.632→9.939 ms | +3.19%; .253 |
| Public grammargen_lr | 106.670→110.759 ms | +3.83%; .341 |

All Go timings are inconclusive, but full DFA exceeds the median ratchet and
still blocks promotion. Allocations remain exact; tiny full/edit byte directions
are retained in the complete summary. Every no-edit sample has zero bytes and
zero allocations. Do not attribute these timing directions to a specific change.

## Completed checks and next target

The final source passes full Core tests, opaque historical-binding rejection,
four metadata comparisons, stale-owner/reset/rollback tests, pinned canonical Go
lifecycle work, both 72-step YAML invariant sessions and focused memory/pooling
contracts. The rejected-source regression verifies that 232/925 constructed
nodes remain charged after arena release.

Locked-C checks pass eleven sample/document/prefix/large witnesses, the owned R4
oracle and sixteen scanner-cursor inputs through legacy, ordinary and owned
routes, including each one-byte edit and fresh edited parse. Both 524-document,
**1,049,572-byte** inputs complete on compact with **121045** constructions.
The combined C process peaks at **143936 KiB**. This is an absolute observation,
not matched RSS qualification. No full fleet, race, API/layout or graduation
qualification is transferred to this rejected source.

Attribution points away from another wrapper-count optimization. The private
8 KiB YAML profile attributes **75.32% of allocated bytes** to scanner snapshot
records and **8.47%** to immutable version-state publication. These are allocation
shares, not time savings. Snapshot pages that remain immutable after reset are
the next allocation target; recycling published addresses would violate stale
ownership checks. The unchanged Go query profile attributes **37.43% cumulative**
CPU to active dispatch and **27.06%** to owned reduction; copying is **2.03% flat**.
Those overlapping CPU shares must not be added or presented as speedups.

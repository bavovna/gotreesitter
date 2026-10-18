# Actual shared lookahead ownership — 2026-10-18

A private prototype completes ordinary YAML compact parsing on the **1,998 B
R4**, **8,012 B**, and **32,048 B** witnesses, with the diagnostic ownership
probe and artifact exception disabled. It preserves locked-C trees on the
focused suite. **This is a correctness pathway, not a promoted runtime or a
throughput win.** Election and publication counters still block promotion.

The [direct-publication follow-up](compact-shared-request-publication-screen-20261018.md)
reduces the temporary publication cost and records its allocation measurements.
Its throughput remains inconclusive, and the ownership prototype stays unpromoted.

The [baseline reference](benchmarks/20261018-shared-lookahead-origin/baseline-reference.json)
pins qualified runtime `6d5b0b07e44a8f4fd1ab66d3246a485fde303909` and all
3,510 Go source hashes. No production Go file, route or allowlist changes.
This investigation follows [E-A7, #1319](https://github.com/odvcencio/gotreesitter/issues/1319)
and the [performance gates, #1065](https://github.com/odvcencio/gotreesitter/issues/1065).

## The ownership observation

On all three witnesses, the first blocked sibling is born from the actual
single header that requested the shared token. The actual lexer state is
**809**, header sequence **0**. During that same election, a reduction creates
sequence **2** from sequence 0. At the ordinary no-action decline, sequence 0
has shifted to state 696; sequence 2 is paused in state 1748.

The [trace](benchmarks/20261018-shared-lookahead-origin/origin-summary.json)
pins the source state, token spans, ancestry, headers and complete work at
the drop. Plain, minimal-observer and detailed-observer runs preserve trees,
routes and token/node counts; both observer modes preserve complete drop-time
work and headers. This is observation of these reduction births, not a proof
for other birth, resurrection or re-lex mechanisms. Matching lexer modes is
not used as an ownership proof.

## Passing private variants

The first variant publishes the genuine shared request immediately after its
actual `Next`. The second retains its source record and publishes ownership
before the first reduction. Both reuse existing before/after snapshots,
checkpoint authentication, metadata validation and request publication. The
source record binds the scheduler, Core generation, actual origin state and
creation sequence. It does not lex again in a later parser state and label
that token as the original request.

Canonical remapping and independent reduction candidates also need to respect
active ownership when the diagnostic probe is off. Enabling those existing
isolation rules resolves the later zero-width blocker in the tested fixtures.
The second variant reduces full ownership activations **105 → 55** on R4,
**421 → 220** on four documents, and **1,681 → 880** on sixteen documents.
These are separate correctness prototypes, not timing comparisons.

Each variant passes **19 fixtures**: the three stream witnesses plus sixteen
scanner-cursor cases. Each fixture has fresh, one-byte-edit incremental and
edited-fresh locked-C comparisons: **57 parsed-tree comparisons** per variant.
The comparisons cover symbols, fields, spans, points, flags and deep digests.
No-edit reparses allocate nothing. The stream witnesses require compact
acceptance for initial and edited-fresh parsing. Small cursor fixtures may
retain independent fallbacks; the suite does not require their graduation.

The reduction-entry variant also passes the **72-step YAML R4 invariant
session**, including zero-allocation no-edit parsing. Candidate incremental
parsing still uses fresh parsing where routing is unproven; this does not
establish compact incremental reuse.

## Counter trade, before any timing

Compare the existing diagnostic-owned route with the reduction-entry
prototype on identical R4 input:

| Counter | Diagnostic owned → prototype |
| --- | ---: |
| Shared elections / runtime tokens | **102 → 107** |
| New nodes | 484 → 484 |
| Scheduler reductions | 209 → 183 |
| Scheduler passes | 328 → 293 |
| Canonicalizations | 326 → 293 |
| Owned request receipts | **18 → 55** |
| Per-request re-lex restores | 18 → 0 |
| Snapshot publications | **60 → 224** |
| Core reduction pop paths | 231 → 187 |
| Core parent constructions | 231 → 187 |
| Core graph link additions | 355 → 304 |

Shared requests in the prototype are receipts for an already executed shared
`Next`; the request count is not an extra lexer-call count. Per-request restore
counters exclude shared-cursor rejoin restores. No total restore elimination
or elapsed-time saving is claimed.

The [complete comparison](benchmarks/20261018-shared-lookahead-origin/counter-comparison.json)
also retains the 8/32 KiB directions and complete Core/scheduler values.
Work is captured before pooled-runner reset; an earlier getter after `Parse`
returned unavailable and is not treated as zero work.

The prototype's full and first-edit token counts both rise **102 → 107
(+4.90%)** against the diagnostic ledger. The ordinary candidate previously
declined and has no accepted full ledger row. Default legacy remains at
**107 tokens / 288 full nodes / 480 first-edit nodes**; the prototype candidate
uses **484 nodes** for both. These are unresolved route/counter differences.
There is no ledger reset or owner-approved exception for this prototype.

## Rejected cheaper variants and remaining work

Publishing only after reduction outputs have forked still declines on all
three stream witnesses. A lightweight origin guard around canonical remaps
also remains insufficient, including its shifted-cursor variant: the guard
runs **11 times**, five after shifts, on each founding witness, but parsing
still declines. The sixteen cursor cases retain C agreement. These admission
failures are retained, not counted as compact passes.

The next architectural task is to carry the authenticated shared request
through ordinary dispatch while avoiding full snapshot publications until
version dispatch needs them. Canonical-remap gating alone is insufficient.
Production code must live under `internal/` and prove stale-source,
capability-callback, reset, pooling and reentrancy boundaries.

**No randomized timing, race, full-language fleet, RSS qualification,
actual-source engine qualification or E-A exit gate was run.** Counters block
promotion, so timing is deferred. The
[decision](benchmarks/20261018-shared-lookahead-origin/decision.json) and
[replay notes](benchmarks/20261018-shared-lookahead-origin/REPRODUCTION.md)
retain these limits. The qualified runtime remains active.

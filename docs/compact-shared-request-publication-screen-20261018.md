# Direct shared-request publication — 2026-10-18

Publishing the actual shared request directly removes an intermediate cursor
state from the private YAML ownership prototype. R4 publications fall
**224 → 169** and allocations fall **1,253 → 1,198**. Allocated bytes fall
**3.52%**. Twenty shuffled pairs establish **no supported throughput gain**.
This improves an **unpromoted prototype**; the qualified runtime is unchanged.

The [previous screen](compact-shared-lookahead-origin-screen-20261018.md)
provides the passing producer and its original ownership/counter limitations.
The new [source reference](benchmarks/20261018-shared-request-publication/source-reference.json)
pins runtime `6d5b0b07e44a8f4fd1ab66d3246a485fde303909` and the prototype inputs.

## Publication change and checks

The producer requires one unshifted, nonaccepted header outside recovery. It
previously seeded and published a before-cursor version state, constructed the
after snapshot, then immediately replaced that state with a request state.
The new branch constructs and validates the same before snapshot, constructs
the after snapshot, and publishes the request directly. It removes the
single-header seed-state map and temporary wrapper.

Snapshot/election/checkpoint preconditions remain explicit. Snapshot
construction, private copies, Core-generation checks, optional checkpoint
identity and destination validation remain in the same order. The
[validation-order audit](benchmarks/20261018-shared-request-publication/validation-order-audit.json)
is a static source audit; it is not a general callback or reentrancy proof.
No alternative-set or same-token-start drop condition is relaxed.

| Input | Publications before → direct | All other measured values |
| --- | ---: | --- |
| R4, 1,998 B | **224 → 169** | Exact |
| Four documents, 8,012 B | **896 → 676** | Exact |
| Sixteen documents, 32,048 B | **3,584 → 2,704** | Exact |

The [counter gate](benchmarks/20261018-shared-request-publication/atomic-counter-gate.json)
compares complete Core, scheduler and runtime values on all three inputs.
Exactly one publication disappears per activation. Both YAML ledger rows,
including collected edits, match between these prototypes. Each variant passes
**19 fixtures / 57 fresh-edit-fresh locked-C tree comparisons** and a **72-step
YAML R4 invariant session**. No-edit reparses allocate nothing. C comparisons
also exercise the observation-free helper used by the benchmarks.

## Randomized measurement

Go 1.25.14, CPU 6, one CPU, 6 GiB Docker, `GOMEMLIMIT=5GiB`,
`GOMAXPROCS=1`, count one, `750ms`, benchmem. The repository runner alternates
roles for seeds **33901–33920**. All **120 rows** are retained. No extra seeds
or repeated timing were used.

| Path | Before → direct | Time direction | p |
| --- | ---: | ---: | ---: |
| Prototype R4 | 724.715 → 624.854 µs | −13.78% | .495 |
| Prototype 8 KiB | 2.707128 → 2.631044 ms | −2.81% | .583 |
| Default YAML legacy control | 212.042 → 205.961 µs | −2.87% | .862 |

**Every timing difference is inconclusive.** Timing intervals reach 27%; the
legacy control remains unattributed. No speedup or geomean win is claimed.

| Path | B/op before → direct | Allocs/op before → direct |
| --- | ---: | ---: |
| Prototype R4 | **100,114 → 96,594 (−3.52%)** | **1,253 → 1,198 (−4.39%)** |
| Prototype 8 KiB | **402,730 → 388,649.5 (−3.50%)** | **4,985 → 4,765 (−4.41%)** |
| Legacy control | 1,440 → 1,440 | 16 → 16 |

Both prototype allocation improvements have p<.001. Allocation counts fall by
exactly the removed publication counts, 55 and 220. The
[measurement](benchmarks/20261018-shared-request-publication/publication-measurement.json)
retains all raw samples and metrics. The parser resets on every unit-table
header; all ns/B/allocation medians independently match the raw 20 samples.

These are construction-and-release measurements of a diagnostic adapter with
observational hooks and reflection. They compare two versions of that adapter,
not production implementations or the qualified diagnostic route.

## Discarded dispatch hypotheses

Disabling C4 does not restore stream admission for the lightweight origin
guard. All three founding stream cases still decline; the sixteen cursor
cases retain C agreement. C4 removal is not a sufficient fix.

The [no-action trace](benchmarks/20261018-shared-request-publication/no-action.json)
compares diagnostic-owned, early-publication and late-publication controls.
At the late variant's election 30, the paused sibling still owns zero-width
token 111 at **517..517**, while the shifted survivor owns token 93 at
**520..531**. The token starts differ. The existing same-start proof must
reject that drop; request-origin relabelling cannot repair it.

Re-lexing only when an inherited zero-width token reaches an empty action row
does not restore admission: paused headers bypass that classification branch.
Publishing before zero-width reductions while deferring positive-width
publication to a fork also remains insufficient and reaches the same
517-versus-520 frontier. Both variants retain three stream admission failures
and sixteen passing cursor cases. These results remain failures, not compact
correctness passes.

## Promotion limits

The prototype still uses **107 R4 tokens and 169 publications**, versus **102
and 60** on the qualified diagnostic-owned route. Its ordinary route previously
declined; default legacy uses 288 full nodes versus the prototype's 484.
No counter exception or baseline reset is requested or implied.

No production implementation, race/fleet/RSS qualification, actual-source
engine qualification, E-A exit or graduation is claimed. Production work must
start under `internal/` and prove arbitrary callback, reset, pooling and
reentrancy boundaries. The [decision](benchmarks/20261018-shared-request-publication/decision.json)
and [replay notes](benchmarks/20261018-shared-request-publication/REPRODUCTION.md)
retain these limits. Qualified runtime and routing remain unchanged.

# Combined reduction publication screen — 2026-10-18

Twenty shuffled pairs establish **no supported Go or YAML throughput gain**
from combining reduction execution with checked owner and lineage publication.
Timing intervals are wide. Allocation counts stay exact, and byte differences
provide no supported saving. This runtime is **not promoted**.

The baseline is qualified runtime `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`.
The [source reference](benchmarks/20261018-reduction-lineage-fusion/source-reference.json)
and [patch](benchmarks/20261018-reduction-lineage-fusion/runtime.patch) pin
three private source files. Active runtime, routing and graduation stay at
the qualified baseline.

## Change and correctness boundary

The candidate runs the existing reduction implementation, then publishes its
owner and scalar/alternative lineage inside that same owned Core operation.
The general path retains classification authentication; the corridor path
retains its existing validated-row obligation. The existing owner-conflict
check, scalar normalization, alternative-set union, journals, rollback and
fresh-session poisoning remain.

Publication requires a sole new output with no multiple-pop or imported
history and no drop references. The root also requires a single header whose
canonical probe is the identity, no conflict reduction, recovery cost/turn,
no-lookahead token, full receipts or eager callback, and a valid creation
sequence. This is the existing in-place output path: its zero new reduction
lineage leaves the header's scalar pair and alternative set unchanged. Other
outputs keep ordinary publication. No ownership or lexer-state proof is waived.

An untimed corridor-only precursor passed focused gates but could not reach
owned-lexer dispatch. The measured general variant covers **952/1,372 Go
reductions (69.39%)** and **1,114/1,674 owned-YAML reductions (66.55%)** in
count-mode setup probes. Those include 912 and 1,090 scalar publications.
This confirms activation, not corpus-wide coverage or timing improvement.

Differential tests cover both authenticated general and corridor reductions,
fresh and transactional sessions, scalar/set publication, rollback, zero
owners, condensed-head rejection, multiple-pop rejection and foreign-Core
classification authentication. Complete native state and work remain equal.
The [attempt record](benchmarks/20261018-reduction-lineage-fusion/precursor-and-attempts.json)
retains the unmeasured precursor and a missing-argument compile fix made
before measurement.

## Measurement

Go 1.25.14, CPU 6, one CPU, `GOMAXPROCS=1`, 6 GiB Docker,
`GOMEMLIMIT=5GiB`, `-count=1`, `750ms`, and `-benchmem`, serialized by both
benchmark locks. The repository randomized runner alternates role order and
uses Go seeds **33501–33520** and YAML seeds **33601–33620**. All **440 timed
rows** remain in the evidence. No seeds were added and no repeat was used to
seek significance.

| Compact path | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Go R4 | 950.863 → 986.068 µs | +3.70% | .862 |
| Go rewrite | 1.965247 → 1.985598 ms | +1.04% | .779 |
| Go query | 9.732898 → 9.200416 ms | −5.47% | .820 |
| Go language | 10.103488 → 10.251423 ms | +1.46% | .841 |
| Go large | 104.332446 → 108.297607 ms | +3.80% | .565 |
| Owned YAML R4 | 417.154500 → 423.511500 µs | +1.52% | 0.640 |
| Owned YAML 8 KiB | 1.645532 → 1.660129 ms | +0.89% | 0.640 |
| Ordinary YAML attempt plus fallback | 239.378000 → 239.354000 µs | -0.01% | 0.862 |

Every timing difference is inconclusive; intervals reach 13%. These directions
are neither established speedups nor established slowdowns. Results from
different buckets or environments are not combined.

| Default Go control | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Full | 4.569139 → 4.698485 ms | +2.83% | .620 |
| First edit | 113.434 → 112.221 µs | −1.07% | .738 |
| No edit | 3.486 → 3.580 ns | +2.68% | .292 |

Controls are also inconclusive and remain unattributed. All allocation
medians match. No edit remains **0 B/op / zero allocations**. Byte medians
match except default Go full **1,162 → 1,161 B/op**, p=.549, and owned YAML
8 KiB **44,313 → 44,312 B/op**, p=.675; neither supports a saving. The
[measurement bundle](benchmarks/20261018-reduction-lineage-fusion/measurement.json)
retains the supported metric tables and raw samples. The corrected unit-table
parser removes four custom fields that were incorrectly labelled as route
counts. Time, byte and allocation values and the decision are unchanged; the
[parser audit](benchmarks/20261018-reduction-lineage-fusion/analysis-parser-audit.json)
records those removals.

## Gate scope and decision

All **414 ledger rows** and five complete Go construction/consumption vectors
and deep digests equal baseline before timing. The
[counter reference](benchmarks/20261018-reduction-lineage-fusion/counter-reference.json)
links complete values and identical hashes. Focused root/corridor/lifecycle
and ownership tests, full Core normal/phase-zero-A suites, focused race/386,
Go/YAML/owned-YAML 72-step invariants and allocation-free no-edit checks pass.
Go and YAML locked-C fixture suites and owned-YAML document/cursor-transition
oracles pass. The coverage-only source bind is absent from normal timing.

All candidate and 3,510 baseline Go source hashes remain exact. The
[decision](benchmarks/20261018-reduction-lineage-fusion/decision.json) stops
the trial here: the full invariant/C fleets, strict census, RSS qualification
and actual-source promotion guards were **not run** for this candidate.
There is no runtime promotion, ledger exception, baseline reset or graduation.

The [replay notes](benchmarks/20261018-reduction-lineage-fusion/REPRODUCTION.md)
describe the pinned sources and commands. The profile-guided next investigation
is scanner destination validation: it accounts for 7.72% of sampled owned-YAML
CPU, while transient snapshot capture accounts for 1.13%. Those cumulative
samples attribute work; they do not prove a future optimization will win.

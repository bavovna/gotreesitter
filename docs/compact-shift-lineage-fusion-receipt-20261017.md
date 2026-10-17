# Combined shift and lineage publication — 2026-10-17

Compact Go R4 takes **1.27% less time, p=.003**, in twenty shuffled pairs.
Query and language fixtures improve **0.46% / 0.45%, p=.035 / .030**.
Other compact Go and all YAML timing differences remain inconclusive. All
414 counter rows remain exact. Ordinary YAML still declines to legacy; no
language graduates in this bucket.

Runtime: `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`. Baseline:
`5e52cf2a2644f3d38785513eebc39f8cf8a506b2`, the qualified paired-terminal
runtime. Results from separate buckets are not added. The
[source reference](benchmarks/20261017-shift-lineage-fusion/source-reference.json),
[patch](benchmarks/20261017-shift-lineage-fusion/runtime.patch), and full
[actual-source manifest](benchmarks/20261017-shift-lineage-fusion/actual-source-pins.json)
pin the comparison.

## Change and correctness boundary

An eligible direct shift now publishes its owner and scalar/alternative
lineage within the same owned Core operation. It still calls the existing
shift implementation, owner identity/conflict check, scalar merge and set
union. It retains transaction journaling, rollback, panic handling and
fresh-session poisoning. It adds no retained cache or Core fields.

The root adapter requires one header whose canonical probe is the identity,
an unexhausted creation sequence, empty/non-overflowed/non-blended drop
references, and no eager materialization callback. The existing direct-shift
eligibility also excludes external tokens and applicable fault hooks.
Publication succeeds only for a newly created head. Condensed existing heads
and ineligible headers retain the previous publication path. Omitted drop
reference publication is exactly the existing immediate no-op case.

Differential tests compare the complete state and work against separate
operations in fresh and transactional sessions. They cover owner conflicts,
rollback, zero owners, foreign active tokens, invalid/zero scalar lineage,
alternative sets and the previous-head dirtiness hint. A foreign token still
poisons and clears the receiver exactly as the old API does.

An untimed owner-only precursor covered 62 of 934 direct shifts in the public
Go setup probe; 872 required scalar lineage publication. The final count-mode
coverage probe exercises **934/934** combined owner publications, including
872 scalar publications. This is an activation check, not corpus-wide
coverage or timing evidence. Initial test-expectation, overlay-coverage and
launcher failures are retained in the
[harness record](benchmarks/20261017-shift-lineage-fusion/harness-attempts.json).

## Measurement

Go 1.25.14, CPU 6, `GOMAXPROCS=1`, 6 GiB Docker, `GOMEMLIMIT=5GiB`,
`-count=1`, `750ms`, and `-benchmem`; both benchmark locks serialize the run.
The repository randomized runner alternates role order and uses one process
per explicit seed: Go **33201–33220**, YAML **33301–33320**. All **440 timed
rows** are retained. No extra seeds were added for near-threshold results.

| Path | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Go R4 compact | 782.776 → 772.814 µs | **−1.27%** | **.003** |
| Go rewrite | 1.702040 → 1.691433 ms | −0.62% | .056 |
| Go query | 8.101121 → 8.063525 ms | **−0.46%** | **.035** |
| Go language | 8.452502 → 8.414355 ms | **−0.45%** | **.030** |
| Go large | 87.009213 → 86.029317 ms | −1.13% | .056 |
| Owned YAML R4 | 334.812 → 333.498 µs | −0.39% | .314 |
| Ordinary YAML attempt plus fallback | 189.578 → 189.071 µs | −0.27% | .096 |
| Owned YAML 8 KiB | 1.295174 → 1.299486 ms | +0.33% | .149 |

Only bold differences are statistically supported. Allocation medians stay
**22 / 21 / 120 / 239 / 1,705** for Go and **109 / 37 / 336** for YAML in
table order. Byte medians stay exact except Go language **150,419 → 150,418
B/op**, p=.752; no allocation or byte-saving claim is made.

| Default Go control | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Full | 3.920822 → 3.903308 ms | −0.45% | .211 |
| First edit | 98.913 → 99.483 µs | **+0.58%** | **.011** |
| No edit | 3.154 → 3.137 ns | −0.55% | .080 |

The supported default-edit slowdown is retained without attribution to the
compact change. No edit remains **0 B/op / zero allocations**. The
[measurement bundle](benchmarks/20261017-shift-lineage-fusion/measurement.json)
and raw samples retain every direction and metric.

## Qualification and limits

All **412 ordinary plus two owned-YAML ledger rows** match before, after
and actual-source execution. The
[counter reference](benchmarks/20261017-shift-lineage-fusion/counter-reference.json)
links complete values and identical hashes. Five full construction/consumption
vectors and deep digests match, as do four additional canonical Core/scheduler
vectors. No ledger exception or threshold change is used.

Full Core normal, phase-zero-A and selected-store-one-pass suites pass,
along with focused race and 386 checks, root corridor/lifecycle checks,
Go/YAML/owned-YAML invariant races and memory/retention contracts. All
**206 × 72-step invariant sessions** and the additional owned-YAML session
pass with zero no-edit allocations. CSV and Enforce use their grammar-smoke
fixtures; the other 204 sessions use real R4 samples. All **618 locked-C
fixture checks** pass, one grammar per process, with no skips.

The strict real-file census preserves every one of its **204 rows: 120
compact C-exact, 39 passing legacy routes, and 45 existing legacy mismatches**.
Those mismatches remain failures. One-MiB Go and ordinary/owned YAML match
locked C in both roles. The
[qualification audit](benchmarks/20261017-shift-lineage-fusion/qualification.json)
records the language-by-language scope and log hashes.

All six initial and 120 matched standalone parser RSS probes pass the
unchanged **400 B/source B** ceiling. The initial Go increase **342.07 →
355.67** is retained. Twenty alternating, case-shuffled matched pairs per
case, seeds **33401–33420**, pass the 10% median ratchet:

| One-MiB case | Median before → after, RSS B/source B | Median ratio |
| --- | ---: | ---: |
| Go | 348.102 → 348.815 | 1.00205 |
| Ordinary YAML | 68.915 → 69.110 | 1.00283 |
| Owned YAML | 113.794 → 113.771 | .99979 |

The highest candidate Go peak is **373.19 B/source B**. These are safety
probes, not evidence of lower memory use. The
[RSS record](benchmarks/20261017-shift-lineage-fusion/rss-safety.json)
retains every initial and matched value.

All **3,510 actual Go source files** equal the qualified sources except the
two shared diagnostic shims. Actual-source Core/lifecycle tests, **756/756**
root files, **12** public API tag sets, unchanged v1 registries, **65** CI
selectors across seven workflows and all 414 counter rows pass. The guard
uses a pinned tracked-source mirror to exclude ignored historical worktrees.
The [replay notes](benchmarks/20261017-shift-lineage-fusion/REPRODUCTION.md)
describe the archived probes and commands. Routing, allowlists and graduation
remain unchanged.

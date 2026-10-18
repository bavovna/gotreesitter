# Scanner byte-field packing screen — 2026-10-18

This candidate is **not promoted**. Twenty shuffled pairs show no supported
throughput difference and no allocation reduction on YAML. Active runtime
remains `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`.

The private change copies a snapshot's three scanner byte fields into one
allocation. Disjoint slices preserve nil/empty state, source isolation and
append boundaries. It leaves the separate zero-width trial-mask copy intact.
The [patch and source pins](benchmarks/20261018-scanner-byte-packing/source-reference.json)
retain the exact candidate. This is a rejected experiment, not an E-A1 closure.

## Measurement

Go 1.25.14, CPU 6, `GOMAXPROCS=1`, 6 GiB Docker, `GOMEMLIMIT=5GiB`,
`-count=1`, `750ms`, and `-benchmem`. Both benchmark locks serialize the run.
The repository randomized runner alternates role order over Go seeds
**34001–34020** and YAML seeds **34101–34120**. All **440 timed rows** remain
in the [measurement bundle](benchmarks/20261018-scanner-byte-packing/measurement.json).
No additional seeds were added. Confidence intervals reach 28%; every timing
direction below is inconclusive.

| Path | Time direction | p | Allocations before → after |
| --- | ---: | ---: | ---: |
| Go R4 compact | +2.20% | .341 | 22 → 22 |
| Go rewrite | −2.37% | .718 | 21 → 21 |
| Go query | +2.39% | .529 | 120 → 120 |
| Go language | −0.12% | .678 | 239 → 239 |
| Go large | +5.46% | .265 | 1,705 → 1,705 |
| Owned YAML R4 | +0.02% | .820 | 109 → 109 |
| Ordinary YAML attempt plus fallback | −0.76% | .495 | 37 → 37 |
| Owned YAML 8 KiB | +1.40% | .383 | 336 → 336 |
| Default Go full control | −3.41% | .841 | 6 → 6 |
| Default Go edit control | −1.78% | .989 | 5 → 5 |
| Default Go no-edit control | −0.51% | .805 | 0 → 0 |

YAML byte medians remain **12,872 / 15,608 / 44,313 B/op** in the table's
YAML order. No edit remains **0 B/op**. Go language bytes move
**150,421 → 150,419** and default-full bytes **1,162 → 1,161.5**; neither is
supported. Other byte medians remain exact. The analyzer resets its metric
on every CSV header and independently verifies all 20-sample time, byte and
allocation medians against the raw rows.

## Why it missed

A separate untimed census of the qualified runtime finds that these YAML
freezes contain **one populated byte field**, with 14–34 bytes, and **113
boolean zero-width trial flags**. Token-start and token-end byte fields are
empty. Combining the three byte fields therefore still allocates once for
the payload and once for the boolean mask.

The [field census](benchmarks/20261018-scanner-byte-packing/allocation-attribution/field-census.json)
and allocation profiles retain R4, 8 KiB and Go controls. These are attribution
probes with separate processes, not throughput comparisons. They motivate
testing record/storage coallocation rather than more byte-only variants.

## Correctness scope and limits

All **414 counter rows** and **five complete construction/consumption
vectors and deep digests** match. The four canonical Go consumption probes
and R4 control complete on compact without fallback.

Focused snapshot/ownership/lifecycle and recovery-frontier checks, separate
Go/YAML/owned-YAML 72-step invariant sessions, focused Go/YAML locked-C
checks, and the YAML stream/cursor/edit suite pass. Full Core normal and
phase-zero-A suites pass, as do focused Core race/386 and owned-YAML invariant
race checks. The YAML suite's opt-in large probes were not enabled.
The [gate logs](benchmarks/20261018-scanner-byte-packing/gate-logs.json)
retain the initial ledger-adapter build failure; its corrected
adapter subsequently passes.

Full-fleet invariants, C census, RSS and actual-source qualification were not
run after rejection. A prepared qualification harness was not launched.
There is no production change, counter exception, routing change or language
graduation. Ordinary YAML still falls back. See the
[replay notes](benchmarks/20261018-scanner-byte-packing/REPRODUCTION.md).

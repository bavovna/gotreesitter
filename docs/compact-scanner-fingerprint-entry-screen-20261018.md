# Scanner fingerprint entry split — 2026-10-18

Moving value-scanner serialization out of the common fingerprint entry reduces
its stack reservation **4,304 → 152 bytes**, but twenty shuffled pairs slow
compact Go R4 **0.98%, p=.001**. Owned YAML R4 improves **1.28%, p=.046**;
ordinary YAML attempt plus fallback improves **1.09%, p=.011**. This trade does
not close both target gaps. The runtime is **not promoted**.

Baseline: qualified runtime `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`.
The [baseline reference](benchmarks/20261018-scanner-fingerprint-entry/baseline-reference.json),
[source pins](benchmarks/20261018-scanner-fingerprint-entry/source-pins.json)
and [patch](benchmarks/20261018-scanner-fingerprint-entry/runtime.patch) pin
two private source files. Active runtime and routing remain unchanged.

## Change and correctness boundary

The existing nil and pointer identity branches retain their exact logic. The
complete value-only encoding block moves unchanged into an internal helper,
including array/slice contents, nil/empty distinctions, deterministic map
formatting and the SHA-256 fallback. Pointer identity still excludes mutable
scanner payload and includes its instance address; the caller still compares
type. No live binding, capability, checkpoint, generation or ownership check
is skipped, and no cache is introduced.

The [compiler audit](benchmarks/20261018-scanner-fingerprint-entry/compiler-audit.json)
checks byte-identical value-block source and records both entry disassemblies.
The public entry remains uninlined: compiler cost **429 → 227**, budget 80.
The smaller frame alone does not prove a throughput improvement. YAML's bound
scanner is a pointer; no empty-value-scanner shortcut was added.

## Measurement

Go 1.25.14, CPU 6, one CPU, `GOMAXPROCS=1`, 6 GiB Docker,
`GOMEMLIMIT=5GiB`, count one, `750ms`, and benchmark memory metrics. Both locks
serialize the repository randomized runner. Role order alternates per seed;
Go seeds are **33701–33720**, YAML **33801–33820**. All **440 timed rows** are
retained. No additional seeds, layout variants or repeat were used.

| Path | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Go R4 | 841.193 → 849.409 µs | **+0.98%** | 0.001 |
| Go rewrite | 1.852344 → 1.844171 ms | -0.44% | 0.602 |
| Go query | 8.765182 → 8.821238 ms | +0.64% | 0.114 |
| Go language | 9.127163 → 9.174473 ms | +0.52% | 0.495 |
| Go large | 93.351529 → 93.215782 ms | -0.15% | 0.862 |
| Owned YAML R4 | 366.374 → 361.671 µs | **-1.28%** | 0.046 |
| Owned YAML 8 KiB | 1.416154 → 1.410427 ms | -0.40% | 0.398 |
| Ordinary YAML attempt plus fallback | 206.442 → 204.195 µs | **-1.09%** | 0.011 |

Bold differences are statistically supported. Other compact timing directions
remain inconclusive. Allocation medians stay **22 / 21 / 120 / 239 / 1,705**
for Go and **109 / 336 / 37** for YAML in table order. Byte medians stay exact
except Go language **150,418.5 → 150,418 B/op**, p=.643; no saving is claimed.

| Default Go control | Before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Full | 4.265213 → 4.225460 ms | **-0.93%** | 0.011 |
| First edit | 108.856 → 108.463 µs | -0.36% | 0.211 |
| No edit | 3.396 → 3.419 ns | +0.68% | 0.113 |

The supported default-full speedup remains unattributed; it does not offset
the compact-R4 regression. Default-full byte medians both equal **1,160 B/op**,
with p=.026 for their sample distributions; this is not a median byte saving.
No edit stays **0 B/op / zero allocations**. The
[measurement bundle](benchmarks/20261018-scanner-fingerprint-entry/measurement.json)
retains all metrics and raw samples.

An analysis parser initially carried the previous unit into custom-metric
tables and overwrote four Go allocation fields. The corrected parser resets
on every unit header. Every reported ns/B/allocation median independently
matches the raw 20 samples; the timing verdict is unchanged. The
[audit](benchmarks/20261018-scanner-fingerprint-entry/analysis-parser-audit.json)
records affected fields. The previous reduction-fusion receipt's time, byte
and allocation values are unchanged. Its parser receives the same fix, and
four mislabelled custom fields are removed from its measurement JSON.

## Gate scope and decision

All **414 ledger rows** and five complete Go construction/consumption vectors
and deep digests equal baseline before timing. The
[counter reference](benchmarks/20261018-scanner-fingerprint-entry/counter-reference.json)
links full values and identical hashes. Scanner fingerprint tests cover
pointer payload mutation, value mapping mutation, nil/empty and value-kind
boundaries, deterministic unusual values and allocation behavior.

Full Core normal/phase-zero-A, focused race/386, root lifecycle, lexer snapshot,
activation, ownership and adversarial checks pass. Go/YAML/owned-YAML 72-step
invariants and no-edit allocation checks pass. Focused Go/YAML locked-C and
owned-YAML document/cursor-transition oracles pass. Both baseline and candidate
fingerprint suites pass. The [gate record](benchmarks/20261018-scanner-fingerprint-entry/gate-logs.json)
preserves scope and hashes.

The [decision](benchmarks/20261018-scanner-fingerprint-entry/decision.json)
rejects promotion after this screen. The full invariant/C fleets, strict
census, RSS qualification and actual-source guards were **not run**. There is
no ledger exception, baseline reset, route change or graduation. The
[replay notes](benchmarks/20261018-scanner-fingerprint-entry/REPRODUCTION.md)
describe the pinned sources and commands.

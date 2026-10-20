# Scanner record and storage coallocation — 2026-10-18

Owned YAML allocations fall **109 → 79 (−27.52%)** on R4 and **336 → 218
(−35.12%)** on the 8 KiB document stream. Allocated bytes rise **12,872 →
13,032 (+1.24%)** and **44,313 → 44,953 (+1.44%)**. Twenty shuffled pairs
establish no supported throughput difference. This is a qualified allocation
win with a byte-cost tradeoff, not a throughput or graduation claim.

Runtime: `b17ca367a85d419514554e88f4477a339fd3ecba`. Baseline:
`6d5b0b07e44a8f4fd1ab66d3246a485fde303909`. The
[source reference](benchmarks/20261018-scanner-record-coallocation/source-reference.json),
[patch](benchmarks/20261018-scanner-record-coallocation/runtime.patch) and
[actual-source manifest](benchmarks/20261018-scanner-record-coallocation/actual-source-pins.json)
pin the comparison. Results from separate buckets are not added.

## Change and correctness boundary

The new internal factory freezes a snapshot record, small byte payloads and
large boolean trial masks in one typed allocation. It applies only to masks
of 65–128 booleans and nonempty combined byte fields of at most 64 bytes.
Other shapes retain separate, exact-sized copies. The allocation contains
the actual typed record, a 32- or 64-byte array and 128 booleans; it uses no
unsafe conversion, pool, retained cache or language rule.

Every field has disjoint storage. Nonfinal byte fields have capacity equal
to length; the final present field owns the remaining capacity. The mask
retains its full reserved capacity. Existing cap-based footprint accounting
therefore charges every reserved byte. Nil and empty fields retain their
identity. Separate snapshots and their clones do not share mutable storage.

The factory runs at the existing deep-copy point after checkpoint-handle
authentication. Checkpoint copying, complete scanner identity, capability
callbacks, generation/reset binding and before/after checkpoint validation
remain intact. Clones still copy both checkpoint arrays. The standalone DFA
snapshot clone used by other paths is unchanged.

Tests cover source/field/clone isolation, appends, nil and empty state,
threshold fallback, typed-pointer GC survival, one-allocation construction,
reserved-capacity accounting and stale-generation rejection. The new root
storage/reset test passes normally, under race and on 386.

## Measurement

Go 1.25.14, CPU 6, `GOMAXPROCS=1`, 6 GiB Docker, `GOMEMLIMIT=5GiB`,
`-count=1`, `750ms` and `-benchmem`. Both locks serialize the run. The
repository randomized runner alternates role order over Go seeds
**34301–34320** and YAML seeds **34401–34420**. All **440 timed rows** are
retained; no extra seeds were added. Confidence intervals reach 32%.

| Path | Time direction | p | Allocations before → after |
| --- | ---: | ---: | ---: |
| Go R4 compact | +1.43% | 0.529 | 22 → 22 |
| Go rewrite | +2.31% | 0.495 | 21 → 21 |
| Go query | +2.06% | 0.883 | 120 → 120 |
| Go language | +1.39% | 0.904 | 239 → 239 |
| Go large | -1.56% | 0.841 | 1705 → 1705 |
| Default Go full control | +1.98% | 0.718 | 6 → 6 |
| Default Go edit control | +1.53% | 0.602 | 5 → 5 |
| Default Go no-edit control | -2.40% | 0.211 | 0 → 0 |
| Owned YAML R4 | +0.39% | 0.904 | 109 → 79 |
| Owned YAML 8 KiB | +0.15% | 0.925 | 336 → 218 |
| Ordinary YAML attempt plus fallback | -0.81% | 0.134 | 37 → 37 |

Every timing direction above is inconclusive. The two allocation reductions
and byte increases are supported, **p<.001**. Go and ordinary-YAML byte and
allocation medians remain exact. No edit remains **0 B/op / zero allocations**.
The [measurement bundle](benchmarks/20261018-scanner-record-coallocation/measurement.json)
retains every metric and raw sample. Its analyzer resets the metric on every
CSV header and independently checks all 20-sample time, byte and allocation
medians. Its `runtime_promoted=false` records the original private screen;
the source reference records subsequent qualification and promotion.

## Qualification and limits

All **414 ledger rows** match before, after and in actual-source execution.
For owned YAML candidate full and first edit, nodes stay **484 → 484** and
tokens stay **102 → 102**. All work and reuse values remain exact; no ledger
exception or changed threshold is used. The
[counter reference](benchmarks/20261018-scanner-record-coallocation/counter-reference.json)
contains complete values and identical hashes. Five complete construction/
consumption vectors and deep digests match, as do four canonical Core/
scheduler vectors. Canonical consumption stays compact without fallback.

Full Core normal, phase-zero-A and selected-store-one-pass suites pass,
along with focused root/scanner/lifecycle tests, Core and root race/386
checks, Go/YAML/owned-YAML invariant races and memory/retention contracts.
All **206 × 72-step invariant sessions**, plus the owned-YAML session, pass
with zero no-edit allocations. CSV and Enforce use grammar-smoke fixtures;
the other 204 sessions use real R4 samples. All **618 locked-C fixture
checks** pass, one grammar per process, with no skips.

The strict real-file census retains all **204 rows: 120 compact C-exact,
39 passing legacy routes, and 45 existing legacy mismatches**. Those failures
remain failures. One-MiB Go and ordinary/owned YAML match locked C in both
roles. The [qualification audit](benchmarks/20261018-scanner-record-coallocation/qualification-audit.json)
indexes the scope and per-language log hashes.

All six initial and 120 matched standalone RSS probes stay below the
unchanged **400 B/source B** ceiling. Twenty alternating, case-shuffled pairs
per case, seeds **34501–34520**, pass the 10% median ratchet:

| One-MiB case | Median RSS B/source B, before → after | Median ratio |
| --- | ---: | ---: |
| Go | 343.017 → 353.335 | 1.03008 |
| Ordinary YAML | 69.376 → 69.098 | .99601 |
| Owned YAML | 113.849 → 113.868 | 1.00017 |

The initial Go increase **337.07 → 370.15** and candidate maximum **389.01**
remain recorded without attribution. These are safety probes, not a lower-
memory claim. The [RSS record](benchmarks/20261018-scanner-record-coallocation/rss-safety.json)
retains every initial and matched value.

All **3,512 actual Go source files** equal the qualified sources except the
owned-ledger diagnostic shim. Actual-source Core/lifecycle checks,
**756/756** root files, **12** API tag sets, unchanged v1 registries, **65**
CI selectors across seven workflows and all 414 counters pass. The guard
uses a pinned tracked-source mirror. An initial host check expected two
historical diagnostic overrides; the benchmark wrapper is now identical,
leaving one. That launcher ran no test and exited 127; the corrected launch
passed. The protected worktree's 113 staged files remain unchanged.

The [replay notes](benchmarks/20261018-scanner-record-coallocation/REPRODUCTION.md)
cover the archived probes, commands and limits. Routes, allowlists, ordinary
YAML fallback and graduation remain unchanged.

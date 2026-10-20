# YAML graph retirement remains held on peak memory

Retiring the completed graph before native publication preserves the ordinary YAML tree and work reductions, but fails the resident-memory gate. Twenty matched pairs measure ordinary YAML median RSS **66.886→86.441 B/source byte (+29.24%)**, exceeding the 10% relative ratchet. No throughput timing follows, and no runtime or graduation change is promoted.

The private candidate combines the previously held ownership, packed-mask and paged-publication source with the now-merged wide-precedence suffix. After a completed fresh scheduler run, a bound lifetime proof permits large clean native publication to consume graph handles. Syntax, scanner checkpoints, authentication and work remain available; graph mutation requires Reset. Active transactions, changed owners/lifetimes and reused subtrees reject retirement. Small graphs keep their buffers. There is no forced GC or change to pooling, memory budgets or parser limits.

The one-MiB YAML storage probe confirms Core capacity **31,840,112→15,454,184 bytes** across publication, zero remaining graph nodes and the same **121,045 public nodes**. This is capacity evidence. It does not establish a resident-memory saving against the existing route, whose median is lower.

| RSS control | Baseline median B/source byte | Candidate median | Ratio |
| --- | ---: | ---: | ---: |
| Go | 289.252 | 288.633 | 0.997860 |
| Ordinary YAML | 66.886 | 86.441 | **1.292374 — fail** |
| Diagnostic-owned YAML | 107.425 | 93.388 | 0.869328 |

All six initial and 120 matched probes are retained. Every candidate is below the absolute 400 B/source-byte ceiling. Seeds are **43001–43020**, alternating role order and shuffled case order, GOMAXPROCS=1, normal pools, CPU 6 and serialized six-GiB Docker. The diagnostic-owned decrease does not override the ordinary-route failure. Earlier paging comparisons are separate experiments, not a causal estimate of retirement's RSS effect.

Before memory measurement, all **206 × 72-step invariant sessions**, explicit owned YAML, **618 exactly matched language-specific C fixture checks**, four canonical Go vectors, budget/pool tests, scoped races, native/386 and API guards pass. The strict corpus retains **159 PASS / 45 known legacy failures**; ordinary YAML changes to compact with exact C output. All **306 expanded Go statuses and 300 routes** remain equal, retaining 39 known failures. The one-MiB Go test explicitly runs and preserves the pinned C tree, 903,086 nodes and 425,742 tokens.

The 412-row ordinary ledger changes only YAML's completed candidate row; the two owned rows preserve their earlier scope, with candidate full/first-edit nodes **484→232** and all other counters equal. Fifty focused comparisons include the baseline's failed compact attempt: ordinary full node work falls **288→232 / 1,156→925**, and total token work falls **124→107 / 441→423** on R4 / 8 KiB. Work never rises and reuse never falls. No counter pin, exception, Go correctness-repair approval or allowlist changes.

Initial unit failures exposed a missing direct-Seed guard. Those failures and the pre-fix focused logs remain archived. The final source rejects mutation after retirement, invalidates completion on direct Seed, and passes the full qualification above. The final overlay and 3,535 source hashes identify the tested source; the initial generator is historical evidence only.

[Source, protocols, complete results and member hashes](benchmarks/20261020-yaml-graph-retirement/README.md) retain three verified archives with **1,000 members**. Peak memory accumulated before publication remains the blocker; releasing the finished graph at publication is insufficient.

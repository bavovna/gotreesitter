# Full-width precedence without an unused prefix

The first wide Go score can appear late in a file, but the old array reserved int64 slots for every earlier NodeID. Store a dense suffix beginning at the first wide node. On the pinned 1 MiB Go witness, capacity falls **8,388,608→1,398,336 bytes**, removing **6,990,272 bytes** without narrowing scores. Rollback, reset, retention release and shadow-copy checks preserve the origin.

[Source, raw measurements and gate results](benchmarks/20261020-wide-precedence-suffix/README.md) preserve all **414 exact ledger rows**, **four canonical Go vectors**, **206 × 72-step edit sessions**, **618 matched C fixtures**, unchanged strict/expanded C failures, the explicitly matched 1 MiB Go C check, scoped race/386/API/budget/pooling gates, and all **126 RSS probes**. Public runtime bytes match qualification.

All 480 randomized benchmark rows pass the ratchets. All twelve time differences remain inconclusive. Fresh Go allocated-byte medians fall **1.35%**, but p=.051 is borderline; no statistically established heap or throughput improvement is claimed. The deterministic capacity and memory-budget reduction is the result. Directional timing increases and all raw samples remain visible. No counter pins, budgets, allowlists, defaults or owner approvals change.

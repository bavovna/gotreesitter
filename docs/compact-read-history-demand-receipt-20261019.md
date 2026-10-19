# Compact read-history demand receipt — 2026-10-19

**Owned-invariant evidence correction (2026-10-19):** The extra invariant job
using `GTS_LAYOUT_OWNED_PROBE` did not activate ownership in the root test
process; that variable is read only by the private ledger tool. Treat that
job as ordinary-mode coverage. Explicit owned C and RSS checks retain their
scope. The [progress-capacity receipt](compact-progress-arena-projection-receipt-20261019.md)
adds an explicitly activated, route-asserted 72-step owned session for its
independent production candidate; it does not certify a private protocol source.

Explicitly known no-replay compact requests now skip lexer read-history
collection. Those requests cannot publish incremental reuse receipts. Keeping
their scan history and leaf provenance wastes CPU and storage. Requests with
replay enabled, and low-level callers whose publication context is unknown,
retain the existing collection path.

Twenty shuffled pairs support **6.49% less time on canonical Go `rewrite`**
and **6.20% less on `query_compile`**. Large canonical Go allocated bytes fall
**1,155,584 → 107,520 (−90.70%)**. These canonical benchmarks disable replay.
Public Go controls and all YAML timing changes are inconclusive. This does
not close the public Go throughput gap or graduate a language.

The baseline is qualified runtime
`b17ca367a85d419514554e88f4477a339fd3ecba`. This bucket changes one runtime
file and adds tests to two existing files. It contains none of the private
DFA-origin/version-ordering protocol. Routing, allowlists, incremental
eligibility and the global default remain unchanged. Ordinary YAML falls back.

## Correctness and direction gates

The baseline negative control fails the known-no-replay case: it attaches an
unused history despite that publication context. The new guard passes it,
while the replay-enabled and unknown-context controls continue to collect
and authenticate reads. A canonical test checks two complete parses against
the pinned source and deep digest, with reuse still disabled and no unused
history attached or retained. A prior eligible request's idle buffer is
dropped when the next request explicitly disables replay.

All **414 work/reuse ledger rows**, all **four complete canonical Core and
Scheduler vectors**, and all four deep digests remain exact. Native source
collection independently reproduces all 414 rows. No pin resets or owner
counter exceptions are needed.

All **206 × 72-step invariant sessions** and **618 smoke-C fixture checks**
pass, plus the owned-YAML invariant. The strict 204-file census matches
production row for row: **120 compact passes, 39 legacy passes and 45 known
legacy failures**. Those 45 failures remain visible. Large Go locked-C
equality and ordinary/owned YAML stream checks pass. Memory-budget,
large-then-small pooling and focused race checks pass.

Native tests pass in default, tagged and 386 builds. The source/API/layout
and CI selector checks pass with **756 root Go files, 3,512 total Go files
and 12 API tag sets**. Only the guard and two existing test files differ from
the baseline. The protected worktree's 113 staged paths and exact staged
diff are preserved.

## Randomized comparison

The repository runner completes **440 rows**: 20 Go pairs and 20 YAML pairs,
one process per explicit seed, count 1, 750ms, benchmem, `GOMAXPROCS=1`, CPU 6
and pinned Go 1.25.14. Go seeds are 34701–34720; YAML seeds are 34801–34820.
All 20-sample time/byte/allocation medians are independently checked.

| Benchmark | Time direction | p | B/op, before → after | Allocations, before → after |
| --- | ---: | ---: | ---: | ---: |
| Canonical Go `rewrite` | **−6.49%** | .005 | 1,776 → 1,776 | 21 → 21 |
| Canonical Go `query_compile` | **−6.20%** | .030 | 8,096 → 8,096 | 120 → 120 |
| Canonical Go `language` | −1.49%, inconclusive | .134 | 150,419 → 19,856 | 239 → 231 |
| Canonical Go `grammargen_lr` | −7.67%, inconclusive | .192 | 1,155,584 → 107,520 | 1,705 → 1,694 |
| Go R4 compact | −1.81%, inconclusive | .211 | 1,600 → 1,600 | 22 → 22 |
| Go default full | −1.76%, inconclusive | .841 | 1,159 → 1,159 | 6 → 6 |
| Go single-byte edit | −1.10%, inconclusive | .429 | 394 → 394 | 5 → 5 |
| Go no edit | +3.59%, inconclusive | .080 | 0 → 0 | 0 → 0 |
| YAML ordinary R4 | +0.37%, inconclusive | 1.000 | 15,608 → 15,608 | 37 → 37 |
| YAML owned R4 | +1.11%, inconclusive | .883 | 13,032 → 13,032 | 79 → 79 |
| YAML owned 8 KiB | −2.74%, inconclusive | .989 | 44,952 → 44,952 | 218 → 218 |

The public no-edit control moves **3.263 → 3.380 ns** without a supported
timing difference. Its zero-byte/zero-allocation behavior remains exact.
Every directional result and confidence interval is retained in the
[measurement](benchmarks/20261019-compact-read-history-demand/perf/measurement.json).
No YAML throughput gain or cumulative bucket percentage is claimed.

## Memory and replay evidence

All **126 RSS probes** pass the 400 B/source B ceiling and 1.10 median
ratchet. Candidate/baseline median ratios are Go **1.02408**, ordinary YAML
**1.00023**, and owned YAML **0.99864**. Maximum candidate RSS is
**373.06 B/source B**. The initial Go pair is **358.55 → 348.33**; all six
initial probes remain included. These are safety checks, not an RSS win.

The [archive and reproduction guide](benchmarks/20261019-compact-read-history-demand/REPRODUCTION.md)
retain the exact runtime/native patches, all source/probe hashes, complete
logs, all counter vectors, 440 timing rows, 126 RSS probes and tool versions.
Both patches reconstruct outside the checkout with exact hashes.

The shared breadth container completes this candidate, then exits 1 on a
separate private protocol's production-work pin. That later rejection is
not a failure of this guard. The first native v1guard invocation scans
historical untracked worktrees and fails; the tracked-source check passes.
Both preflights remain recorded. No OOM or wall timeout occurs in this
bucket. The repository's Docker runner and host configuration are unchanged.

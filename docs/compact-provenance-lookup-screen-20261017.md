# Provenance lookup screens, 2026-10-17

Two bounded position-hint variants are rejected. The first has one supported
owned-YAML stream improvement but slows Go. Restoring the empty-sidecar
helper's inlining does not remove the Go regressions and slows ordinary YAML.
Neither source is promoted. Runtime, routing, allowlists and graduation remain
unchanged.

Both independently start from
`a03d0842994a85aa26cf494c8c67404e1e64e999`. Each adds a 64-slot, 256-byte fixed
Core table of sparse-record positions. A hit checks the current payload key
and reads the live record. Neither cached absence nor a cached checkpoint or
ownership proof can satisfy a lookup. Rollback, Reset, ID reuse, collisions,
concurrent immutable readers and zero-allocation lookup checks pass.

| Compact path | Initial hints: time change, p | Inline wrapper: time change, p |
| --- | ---: | ---: |
| Go rewrite | +0.27%, .020 | +0.62%, .013 |
| Go query compiler | +0.36%, .046 | +0.64%, .076 |
| Go language | +0.41%, .096 | +0.80%, .004 |
| Go large grammar generator | +0.89%, .018 | +0.84%, .003 |
| Go R4 | +0.76%, .018 | +0.52%, .096 |
| YAML owned R4 | +0.24%, .925 | −0.09%, .989 |
| YAML ordinary attempt plus fallback | +0.24%, .063 | +1.26%, <.001 |
| YAML owned 8 KiB stream | −0.68%, .021 | −0.27%, .127 |

Positive means slower. Changes with p≥.05 are inconclusive. These sources
are independent comparisons; their samples are not pooled and percentages
are not added. These are not compact/legacy or Go/C ratios. All allocation
counts stay exact. Small B/op rounding stays in the samples; no memory saving
is claimed, and each variant adds 256 bytes to the Core header.

The Go 1.25.14 compiler reports the original helper inlined at cost 71,
the initial hint helper not inlined at cost 128 against a budget of 80,
and the split empty-sidecar wrapper inlined at cost 79 at nine call sites.
The controlled split keeps the hint algorithm unchanged. Its timing results
show that restoring inlining is insufficient to make this representation a
win; the initial slowdown cannot be assigned solely to the lost inlining.

Each source completes 20 alternating baseline/candidate pairs per language
with the repository randomized runner, 750 ms per benchmark, `-count=1` per
process, `-benchmem`, `GOMAXPROCS=1`, CPU 6, Go 1.25.14 and a 6 GiB Docker
container. Initial Go/YAML seeds are 29801–29820 / 29901–29920; the inline
control uses 30001–30020 / 30101–30120. The two sources retain 880 timed rows.

Default Go controls are unattributed. Initial full/edit/no-edit move +0.28%
(p=.003), −0.13% (p=.490), +2.68% (p<.001). The inline control moves +1.57%
(p<.001), +0.50% (p=.001), +0.11% (p=.136). No-edit remains at 0 B/op and
0 allocs/op.

Both pass core normal, phase-zero instrumentation, race and 386 checks;
focused root tests; Go, YAML and owned-YAML edit-session invariants; locked-C
Go/YAML fixtures and YAML EOF/contextual regressions. All 412 standard plus
two owned-YAML ledger rows are exactly equal for each source. Audits verify
all timed rows, source pins, alternating orders, work/reuse/route metrics and
median hard gates. The inline control reuses the unchanged baseline's pinned
focused-test evidence and recomputes both ledgers. No rejected source receives
full 206-language or RSS qualification.

[Raw evidence](benchmarks/20261017-provenance-lookup-screen/) includes samples,
benchstat reports, source patches, audits, scripts, compiler excerpts and log
hashes. `replay.json` references the shared baseline manifest and diagnostic
shims; restore their archived `.go.txt` suffixes to `.go` when reconstructing
the original evidence directories. Complete overlays and compiler logs remain
in those directories.

A separate private alternative uses the terminal-only provenance producer
invariant to skip a nonterminal's own sparse lookup while preserving recursive
descendant provenance and ordinary-terminal checkpoint pairs. It adds no
lookup table or record storage. This receipt makes no performance or
qualification claim for that alternative.

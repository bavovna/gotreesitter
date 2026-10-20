# Ordinary YAML with 16-byte graph nodes: memory screen

The combined candidate remains held. Smaller graph nodes, ordinary scanner
ownership, streaming publication, observed-density reserves, and paged
checkpoint records still exceed the ordinary YAML relative RSS limit.
This receipt promotes no runtime code or language allowlist.

The reference is the qualified 16-byte node implementation in
[PR #1500](https://github.com/odvcencio/gotreesitter/pull/1500), commit
`2264c231a57bb1f22c93e4929b0a5e73ed6441e5`. Its 3,527 Go files match that commit
exactly. The combined candidate contains 3,539 Go files and a 32-file overlay.
It includes neither graph retirement nor the pending Go correctness exception.

## Results

All six initial and 120 matched RSS processes are retained. Twenty explicit
seeds, `44701..44720`, shuffle the three cases and alternate reference/candidate
order. Each process parses one grammar with normal pools, `GOMAXPROCS=1`,
Go 1.25.14, one CPU, and a 6 GiB container. No GC, parser-budget, or stack-cap
override changes the comparison.

| Case | Candidate/reference median maximum RSS | Gate |
| --- | ---: | --- |
| Go, 1,048,591 bytes | 1.00155 | Pass |
| Ordinary YAML, 1,049,572 bytes | **1.16443** | **Fail: exceeds 1.10** |
| Diagnostic-owned YAML, same input | 0.91367 | Pass |

Every candidate process stays below 400 RSS bytes per source byte; the maximum
is 304.824. Absolute safety does not excuse the ordinary route's relative
failure. These are memory-safety observations, not throughput or retained-heap
measurements. No randomized timing comparison followed this failed screen.

Before RSS, the default and shadow Core suites, focused publication/scanner
lifecycle checks, API/layout guards, memory/pool checks, and the YAML C-oracle
document-stream and ownership checks pass, including the 1 MiB stream.
Ordinary and diagnostic-owned YAML each complete 72 invariant edit steps.
All 50 full/edit and whole-request counter comparisons pass the ratchets.

| Work | Reference | Candidate |
| --- | ---: | ---: |
| Ordinary R4 full/edit nodes, each | 288 | 232 |
| Ordinary 8 KiB full/edit nodes, each | 1,156 | 925 |
| R4 whole-request tokens, including declined attempts | 124 | 107 |
| 8 KiB whole-request tokens, including declined attempts | 441 | 423 |
| Diagnostic-owned R4 full/edit nodes, each | 484 | 232 |
| Diagnostic-owned 8 KiB full/edit nodes, each | 1,936 | 925 |
| Whole-request peak headers | 2 | 2 |

Other compared token and reuse counters remain equal. The small-fixture
reductions do not establish a memory or throughput win on ordinary large YAML.
The combined candidate did not run a new 206-language fleet, full 414-row
ledger, 618-fixture C sweep, race suite, or 386 suite. Earlier candidates'
broader evidence does not substitute for those gates on this source.

## Attribution and next experiment

The accepted-storage probe records 25,125,744 Core capacity bytes before public
publication and 25,234,192 after it, with 159,821 graph nodes and 121,045 public
nodes. Checkpoint record capacity accounts for 2,445,812 bytes. These capacity
gauges are distinct from process maximum RSS.

A separate allocation profile repeats the accepted-storage fixture 16 times.
It is attribution only, with profiler instrumentation and no before/after
performance claim. The halfway `ProjectRecordArenas` calls account for about
half of the five families' `growArena` allocation samples. A two-event probe
shows Core capacity growing from 21,841,196 to 21,924,132 bytes at that step:
only 82,936 extra capacity bytes, despite copying several complete arenas.
The next experiment tests avoiding a copy when existing capacity already
covers projected demand and only optional reserve slack would increase.

Separate CPU profiles of the qualified Go reference attribute approximately
37–39% of samples to dispatch and 16–19% to Core reduction construction.
The path-count accessor and its wrapper together account for under 1% on the
query fixture. These profiles select targets; they establish no speedup.

The [replay bundle](benchmarks/20261020-yaml-node16-memory/README.md) includes
source overlays, manifests, all RSS probes, counter rows, scoped qualification
logs, profiling inputs/results, and the initial build/mount diagnostics.

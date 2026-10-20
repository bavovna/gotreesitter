# Ordinary YAML with 16-byte graph nodes: memory screens

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

## Demand-covered reserve follow-up

A second candidate skips late arena copies when current capacity covers the
projected record demand. It keeps the existing 6.25% growth slack whenever an
arena actually needs growth, handles node and lineage capacities independently,
and preserves the complete-growth budget check. It changes no records or work.
The two-file overlay extends the combined candidate to 3,540 Go files.

Focused default/shadow Core, scanner/publication lifecycle, budget/pool,
API/layout, YAML C including the 1 MiB stream, and ordinary/owned 72-step
invariant checks pass again on that source. All 50 counter comparisons pass
with the same values above. The accepted-storage probe records 25,042,808 Core
capacity bytes before publication and 25,151,256 after it; graph/public node
counts remain 159,821 and 121,045.

This candidate also remains held. Its 20 matched pairs use seeds
`44901..44920` against the same qualified node16 reference, with all six initial
and 120 matched processes retained:

| Case | Candidate/reference median maximum RSS | Gate |
| --- | ---: | --- |
| Go | 0.96653 | Pass |
| Ordinary YAML | **1.14617** | **Fail: exceeds 1.10** |
| Diagnostic-owned YAML | 0.90787 | Pass |

Every candidate stays below the absolute ceiling; the maximum is 301.601 RSS
bytes per source byte. These pairs compare to the public reference, not the
first candidate, so the two screens do not establish a causal RSS improvement
between candidates. No randomized timing, new fleet/ledger/C sweep, or race/386
qualification follows the second memory rejection. Its complete evidence is
in `projection-demand.tar.gz`. The next composition adds authenticated
fresh-graph retirement before public projection, as recorded below.

## Completed-graph retirement follow-up

The third candidate adds the previously qualified fresh-session graph
retirement mechanism to the demand-covered reserve source. Its four-file
overlay preserves the session/owner/generation checks and mutation seal, and
also charges and releases the node16 sparse path-count arena's full capacity.
It contains 3,542 Go files. Default/shadow Core, focused lifecycle/budget/API,
ordinary/owned YAML invariant sessions, YAML C including the 1 MiB stream, and
all 50 work comparisons pass on this combined source.

Core capacity drops from 25,042,808 bytes before publication to 13,662,944 after
graph retirement. All GSS nodes are released; the public result still has
121,045 nodes. This capacity result does not establish a lower process peak.

The third candidate also fails the ordinary YAML relative RSS gate. Its 20
matched pairs use seeds `45001..45020` against the same node16 reference:

| Case | Candidate/reference median maximum RSS | Gate |
| --- | ---: | --- |
| Go | 1.01945 | Pass |
| Ordinary YAML | **1.16318** | **Fail: exceeds 1.10** |
| Diagnostic-owned YAML | 0.86277 | Pass |

All six initial and 120 matched processes remain in the bundle, and all
candidate processes stay below the absolute ceiling; the maximum is 305.578
RSS bytes per source byte. No timing comparison or runtime promotion follows.
This source likewise has no new full fleet/ledger/C sweep or race/386 gate.
`publication-retirement.tar.gz` contains its source delta, protocols and
complete scoped results. Releasing a completed graph has not cleared the
measured process-memory blocker; subsequent work must investigate storage
lifetimes during parsing. No forced collection or budget override is added.

## Go graph-lifetime attribution

A separate read-only census runs the four canonical Go fixtures and the
qualified 1 MiB Go source against the node16 reference. Each fixture runs with
and without an observer. All five pairs retain identical Core and scheduler
work vectors and deep trees; the four canonical digests also match their pins.
The observer samples every 64 elections and once after acceptance, tracing
current header heads and the current-generation boundary cache.

| Fixture | GSS nodes allocated | Largest sampled header closure | Largest sampled header + boundary closure |
| --- | ---: | ---: | ---: |
| rewrite | 2,996 | 37 | 43 |
| query_compile | 14,663 | 33 | 33 |
| language | 15,074 | 47 | 50 |
| grammargen_lr | 148,368 | 58 | 58 |
| 1 MiB Go | 1,032,095 | 17 | 19 |

The large fixture has 6,654 samples. This is a strong reason to investigate
recycling GSS storage during parsing, but **not a reclamation safety proof**.
The sampled closure excludes historical/certificate/callback owners, and
sampling can miss a larger frontier between observations. It establishes
neither that the remaining nodes can be freed nor that a new allocator would
improve throughput. The next implementation step must trace every owner and
preserve rollback and stale-handle rejection before recycling any storage.

`observations.tar.gz` includes the census's two-file observational overlay,
source/input hashes, replay command, all paired test results and summary.
The qualified runtime source is unchanged; this census runs no timing
comparison and makes no new C-oracle qualification claim.

# Go cohort frontier and dispatch restoration screen — 2026-10-19

A private compact protocol now passes **306/306 clean Go C checks** and
**144 generic edit steps**. Preserving an already-shifted sibling fixes the
last 12 qualified-type failures from the
[previous ordering screen](compact-go-version-turn-order-screen-20261018.md).
Removing a per-dispatch closure then improves three Go parse benchmarks by
**5.43–8.37%** in 20 shuffled pairs against that same private protocol.

These are private correctness and allocation results, **not a production
promotion**. Preserving previously lost histories raises production work
counters. No R3 exception is approved. Production remains
`b17ca367a85d419514554e88f4477a339fd3ecba`; all **3,512 Go files**, routing,
allowlists and graduation flags are unchanged.

The [archive](benchmarks/20261019-cohort-frontier-ordering/REPRODUCTION.md)
retains exact replay patches, source/probe hashes, complete logs, counter
vectors, raw samples and all rejected directions. Every runtime patch was
reconstructed outside the checkout and verified against its hashes.

## Correctness cause and evidence

For `F[p.T](x,y)`, one conflict arm has already shifted when the ordinary
shift cohort processes the remaining versions. That cohort supplied a nil
live frontier to condensation. The boundary remap then lost the shifted
sibling's history. Passing the current live candidates when the cohort is
only part of the header set preserves it. The complete-cohort fast path
still uses nil. No language-name or grammar-symbol shortcut is added.

A three-history synthetic regression establishes the cause: unchanged
production retains only **two**, while the isolated repair retains all
**three**, including the already-shifted payload. The negative-control
failure is archived as an expected failure, not a successful gate.

| Private variant | Expanded locked-C cases | Additional evidence |
| --- | ---: | --- |
| Unchanged runtime, previous screen | 261/300 | 39 failures: 27 fallback, 12 compact |
| Unconditional cohort frontier repair alone | 273/300 | Fixes the 12 qualified-type cases |
| Frontier repair + C pairwise ordering + authenticated union | **300/300** | Six original witnesses also pass |
| Cached stored precedence + token-start ordering | **300/300** | Six originals; 144 edit steps |
| Same protocol, value restoration | **300/300** | Six originals; 144 edit steps; focused race pass |

The conditional repair separately passes all 12 qualified-type checks and
36 edit steps. All 306 clean cases on the combined variants complete through compact with
zero fallbacks. The 24 edit sessions each run six steps. Every incremental
and fresh result matches locked C, and every incremental result matches
fresh Go. All **144 no-edit allocation checks** remain zero.

The ordering accessor reads the existing cached stack precedence in O(1).
The focused Core test distinguishes that running value from the maximum
over surviving paths; recomputing the latter would change C's semantics.
Ordering claims each token at its start, including single-version starts,
so a mid-token fork does not trigger another sort.

The cached-precedence variant passes all Core tests in normal and phase0A
builds, Go and YAML 72-step invariants, and three smoke-C tests per language.
Those gates precede the final token-start and restoration changes; they are
not presented as full qualification of the final protocol. The final
restoration variant passes 19 source/origin/context negatives, the cohort
regression, nested panic restoration, a zero-allocation helper check and
focused restoration/origin race tests. It preserves the same **four complete
Core/Scheduler vectors and deep digests** and **six selected Go/YAML/owned-YAML
ledger rows** as the private token-start baseline.

## Work direction still blocks promotion

The isolated frontier repair demonstrates why extra work appears: the
previous runtime had dropped a live parse history. Ordering and authenticated
publication union save graph links, but do not eliminate every increase.

| Canonical Go fixture | Parent constructions, production → private | Graph links, production → private | Action lookups, production → private |
| --- | ---: | ---: | ---: |
| `rewrite` | 1,504 → 1,505 | 2,995 → 2,971 | 3,540 → 3,539 |
| `query_compile` | 7,415 → 7,460 | 14,662 → 14,632 | 17,304 → 17,447 |
| `language` | 7,623 → 7,627 | 15,073 → 14,869 | 18,623 → 18,346 |
| `grammargen_lr` | 75,769 → 76,345 | 148,367 → 147,599 | 182,888 → 183,601 |

The [complete counter record](benchmarks/20261019-cohort-frontier-ordering/canonical-work.json)
includes every Core and Scheduler direction, including reduction pauses
**1,963 → 2,117 (+7.85%)** and no-action drops **8,172 → 8,443 (+3.32%)**
on `grammargen_lr`. Its reductions rise **74,911 → 75,220 (+0.41%)**.
The standard pinned production benchmark correctly rejects changed work;
that failure remains in the archive. Production pins are not reset.

The six selected ledger rows are exact against production, and all four
canonical deep digests are unchanged. That does not override the canonical
work directions. Neither the 2% ledger threshold nor the private-pair timing
result approves an R3 exception.

## Measured allocation win within the private protocol

An allocation profile attributes **66.46%** of sampled bytes to the closure
returned by `beginPrototypeDFADispatch`. Four dispatch sites defer that
closure to restore the previous token and active flag. Returning those two
values and deferring a direct restoration method preserves nested and panic
behavior without allocating the closure.

Baseline and candidate below are **private token-start with a closure versus
the identical private protocol with value restoration**. They are not
production versus private. Correctness and exact private-pair vectors passed
before timing. The repository randomized runner completed **20 Go pairs and
20 YAML pairs, 440 rows**, with one process per seed, count 1, 750 ms,
`-benchmem`, `GOMAXPROCS=1`, CPU 6 and the pinned Go 1.25.14 image.
Go seeds are 34501–34520; YAML seeds are 34601–34620.

| Benchmark | Parse time change | p-value | B/op, before → after | Allocations, before → after |
| --- | ---: | ---: | ---: | ---: |
| Go R4 compact | **−8.37%** | .004 | 63,714 → 1,600 | 669 → 22 |
| Go canonical `language` | **−5.43%** | .005 | 739,230 → 150,450 | 6,372 → 239 |
| Go canonical `grammargen_lr` | **−6.07%** | .002 | 7,105,859 → 1,164,192 | 63,731 → 1,839 |
| Go canonical `rewrite` | −2.73%, inconclusive | .121 | 122,739 → 1,776 | 1,281 → 21 |
| Go canonical `query_compile` | −3.41%, inconclusive | .056 | 604,430 → 8,928 | 6,336 → 133 |
| Go default full | +1.19%, inconclusive | .414 | 1,160 → 1,161 | 6 → 6 |
| Go single-byte edit | −0.40%, inconclusive | .461 | 394 → 394 | 5 → 5 |
| Go no edit | +1.96%, inconclusive | .634 | 0 → 0 | 0 → 0 |
| YAML ordinary R4 | −2.06%, inconclusive | .277 | 18,776 → 15,608 | 70 → 37 |
| YAML owned R4 | −4.74%, inconclusive | .076 | 33,000 → 13,032 | 287 → 79 |
| YAML owned 8 KiB | −2.68%, inconclusive | .127 | 124,539 → 44,952 | 1,047 → 218 |

The three bold Go timing changes are statistically supported. No YAML
throughput gain is established. Ordinary YAML keeps its existing fallback
route. All directions, confidence intervals, raw medians, samples and the
benchstat version/hash are retained in the
[measurement](benchmarks/20261019-cohort-frontier-ordering/value-restore/perf/measurement.json).
All 20 samples per metric and all 440 rows were independently counted, and
source/runtime/probe hashes still match after timing.

## Qualification limits and retained failures

No final-protocol all-206 invariant, 618-fixture C, full 414-row ledger,
strict corpus, 386 or RSS qualification ran. The new DFA source state and
origin receipt capacities are charged, but the complete protocol's retained
footprint and inline adapter still need memory qualification. The existing
[b17 scanner-coallocation receipt](compact-scanner-record-coallocation-receipt-20261018.md)
remains the latest qualified runtime. Ordinary YAML's ownership/EOF blocker
is unresolved, and no language graduates here.

The archive separately retains a stale debug-print compile failure, two
baseline-module setup failures and the pinned-work benchmark rejection.
An initial timing container stopped when Docker restarted, with exit 143,
no OOM and **zero benchmark rows**. Its incomplete headers were excluded.
The fresh retry completed all 40 shuffled pairs with exit 0. No host daemon,
network or global configuration was changed. A considered private daemon
was never started.

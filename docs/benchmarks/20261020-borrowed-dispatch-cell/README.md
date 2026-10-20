# Borrowed reduction dispatch cells: held screen, 2026-10-20

The private candidate passes a pointer to the caller-owned 64-byte dispatch-cell
snapshot through the synchronous reduction wrappers. All owner, epoch, row,
rollback and provenance checks remain. Both compiler reports show no cell heap escape;
the capture report changes from a 64-byte source value by reference to an
8-byte pointer by value. This is compiler attribution, not a closure allocation
or throughput measurement. The native cell itself stays 64 bytes.

Twenty matched alternating pairs per language provide **480 benchmark rows**.
All twelve timing differences are inconclusive and every Go median moves upward.
The runtime candidate stays **held**. No performance implementation is promoted.

| Workload | Before ns/op | After ns/op | Change | p |
| --- | ---: | ---: | ---: | ---: |
| go/fresh_one_mib | 8.35231e+08 | 8.45402e+08 | +1.22% | .718 |
| go/full_dfa | 8.17612e+06 | 8.4322e+06 | +3.13% | .142 |
| go/grammargen_lr | 1.061e+08 | 1.07409e+08 | +1.23% | .327 |
| go/no_edit_dfa | 3.222 | 3.2645 | +1.32% | .213 |
| go/query_compile | 9.5923e+06 | 9.68817e+06 | +1.00% | .565 |
| go/single_byte_edit_dfa | 102015 | 105096 | +3.02% | .056 |
| yaml/eof8k_legacy | 557728 | 551862 | -1.05% | .620 |
| yaml/eof8k_ordinary | 635383 | 648858 | +2.12% | .947 |
| yaml/eof8k_owned | 1.49018e+06 | 1.42817e+06 | -4.16% | .134 |
| yaml/r4_legacy | 156412 | 150904 | -3.52% | .369 |
| yaml/r4_ordinary | 211526 | 205732 | -2.74% | .738 |
| yaml/r4_owned | 393826 | 378470 | -3.90% | .127 |

Every time, byte and object median passes its 10% ratchet. All YAML byte/object
medians are exact. Go query and grammargen heap medians stay exact; full adds
one byte, edit 399→400 B/op and large Go adds 44 bytes and 246→246.5 objects.
No-edit always allocates zero bytes and objects. Preserve all directions and
samples; no result is combined with the prepared YAML binding experiment.

All **414 complete ledger rows**, four canonical deep trees and complete work
vectors, **206 × 72-step** ordinary sessions, owned YAML and **618 C fixture
checks** pass. Strict corpus outcomes remain **159 passes / 45 known failures**;
all 204 rows are exact. Expanded Go preserves all 306 outcomes, including the
same 39 known failures, and all 300 route observations. The one-MiB Go C tree
is exact at 903086 nodes / 425742 tokens. Core/shadow/one-pass, memory/pooling,
race, 386 and API/L0/R6 checks pass. The broad initial root selection included
an intentionally RED foreign-inline test; its unchanged baseline failure and
isolated producer-telemetry controls are retained. No exclusion or work pin changes.

All **126 RSS processes**, including six initial probes, pass the 400 B/source
ceiling and 1.10 median ratios. Candidate maximum is **297.293 B/source byte**.
Median candidate/baseline ratios are Go .996840, ordinary YAML 1.008388 and
owned YAML 1.030962. These are safety observations, not measured RSS wins.

The independent public fix corrects an existing test that assumed 64-bit sizes
on every architecture. The measured baseline is header/group/output/condense
**80/40/40/32 on amd64** and **76/36/36/32 on 386**. Pin both layouts using the
pointer width. All four widths remain exact; no record layout or budget changes.
The public fix passes the exact size test on amd64/386 plus API/L0/R6 guards.
The frozen prototype also includes that test repair and four call-site adaptations;
none of its runtime changes is included in the public branch.

Four archives and every member hash/size are pinned by archive-manifest.json.
Source-and-protocol contains the six candidate Go files and full reference/candidate
Go source pins. Qualification contains raw gates, complete before/after counters,
failed controls and compiler diagnostics. RSS retains all 126 probes. Matched
performance retains all 480 rows and their seed/order records. Observed completion
markers and executable binaries are excluded. Baseline support reuse is pinned
in reused-support-sha256.json within qualification evidence.

For replay, prepare public f28a3c1cfca394fa378bf5994fead01c3886e73b and verify
its source pins; copy it for candidate and replace only the six candidate files.
Extract protocol at a fresh evidence root and restore the archived baseline
ledger/canonical/strict observations from qualification. Mount reference and
candidate read-only at /reference and /candidate; mount evidence at /evidence.
Use image sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6GiB, CPU6, GOMEMLIMIT=5GiB and both repository locks. First run the default
Core tests into /evidence/core-normal.log, then focused-v2.sh and full-run.sh.
Require full-counter-gate.json before RSS. Mount the evidence root at /lab
and its rss directory at /evidence and run bash /evidence/run.sh. Restore /evidence, run
perf.sh, analyze-perf.py and benchstat. Seeds are YAML 41501–41520, Go
41601–41620 and RSS 41701–41720. Use scripts/run_randomized_benchmarks.sh;
require all actual paired workload orders to match. The old broad focused.sh
is a retained failed control, not the qualification selector.

Baseline main 2769aea23 has identical runtime and benchmark sources to f28;
only its CI-planner test differs. Ordinary YAML still falls back, expanded Go
C mismatches remain, and no allowlist or graduation setting changes.

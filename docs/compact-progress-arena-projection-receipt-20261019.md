# Progress-based compact record capacity: 2026-10-19

The retained capacity change reduces allocated bytes on the one-MiB Go witness
**827,364,832→592,422,760 B/op (−28.40%, p<.001)**. The complete locked-C tree,
work vectors and all 414 work/reuse ledger rows stay exact. This is a qualified
memory improvement. The timing comparison establishes no throughput improvement.

Baseline runtime: `5c463e567a3dec1d3f367f1a47ebaac03800a797`. The engine change
uses two existing root adapters and new code under `internal/parsercorephase0`.
The fifth measured file adds a reproducible large-file benchmark to an existing
test file. It is shared by the baseline and candidate timing roles.

## Capacity policy

The initial density reserve remains capped at 24 MiB and one eighth of each
armed memory limit. For larger sources, repeated Go slice growth had allocated
roughly 834 MB to finish with 153 MB of Core capacity and a 120 MB tree arena.
At halfway progress, the new estimate projects actual record counts to the
source end with 6.25% slack. It clamps counts to their existing record limits,
checks the entire capacity increase before allocating, and leaves at least
three quarters of every armed limit's remaining capacity for later work.
The scheduler uses its existing reserve check; small sources gain no extra
per-token branch. A spent limit refuses the estimate. An unarmed limit stays
unarmed. No parser limit, stop-control poll or GC setting is raised.

Growth preserves every live record, ID, length and work counter. Unit checks
cover record preservation, rejecting the whole estimate under a small ceiling,
warm zero-allocation calls, source bounds, each armed limit independently, and
odd-length midpoint rounding on amd64 and 386. The original private midpoint
was rounded down; review caught the one-byte scheduling gap before promotion.

## Correctness and deterministic work

All 206 72-step invariant sessions plus an explicitly activated diagnostic-owned YAML session pass. Each covers
incremental=fresh, root error consistency, coverage and zero-allocation no-edit
reparses. All 618 C smoke checks pass, one grammar per process. The strict real
corpus remains exactly **159 PASS / 45 known legacy-route FAIL** across 204
samples, including 120 actual compact/C-exact results. This is not an all-sample
C certificate.

The one-MiB Go public tree matches locked C, including fields, points and error
flags; its digest is `1464b53d73dd7d3ad9ff2b7e064235a4a68442ec7e1379d4c2c263fc6a9eef6c`.
Large diagnostic-owned YAML streams also match locked C. Full Core tests,
phase-zero-A and one-pass builds, default/386 root checks, memory contracts,
pooling, and scoped root/Core races pass. The native layout/API checks pass: 756 root Go files, 12 API tag sets,
454 language-name uses, 101 environment reads, and 65 valid test selectors.
All 3514 published Go hashes match the frozen candidate; native ledgers stay exact.

| Work counter | Before→after |
| --- | ---: |
| All ordinary ledger rows | 412→412, complete rows identical |
| Diagnostic-owned ledger rows | 2→2, complete rows identical |
| Go R4 candidate full nodes / tokens | 1,251→1,251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1,784→1,784 / 266→266 |
| Ordinary YAML default full/edit nodes | 288→288 / 480→480 |
| Owned YAML candidate full/edit nodes | 484→484 / 484→484 |
| Large Go public nodes / tokens | 903,086→903,086 / 425,742→425,742 |
| Four canonical trees and complete work vectors | Exact before→after |

Final review found that the extra YAML invariant run's environment flag was
only read by the ledger tool. The original bytes are preserved under an
env-only label. A separate wrapper explicitly enables ownership, proves the
initial compact=1/fallback=0 route, and runs all 72 steps successfully. This
replaces the extra run's owned-mode claim; the 206 ordinary sessions and the
explicit C/RSS modes retain their original scope. Timed observers are unchanged.

No work pin or ledger exception changes. Earlier owner approval remains
confined to its existing diagnostic-owned YAML rows.

## Shuffled comparison

The repository runner completed 20 alternating pairs per language, GOMAXPROCS=1,
count=1 per process, 750ms and benchmem, under both locks in 6-GiB Docker on CPU 6.
Go explicitly opts into compact, including the standard trio. Seeds are
35401..35420 for Go and 35501..35520 for YAML. All **480 benchmark rows** and
custom work/route metrics pass the audit. All source hashes are unchanged after
timing. The source-checked replay helper reconstructs the five files exactly.

| Benchmark | Median ns/op before→after | Direction | p |
| --- | ---: | ---: | ---: |
| Go one-MiB fresh | 1.181e+09→1.138e+09 | -3.65% | .277 |
| Go R4 | 1.149e+06→1.189e+06 | +3.47% | .242 |
| Go full DFA | 1.135e+07→1.172e+07 | +3.26% | .968 |
| Go edit | 1.368e+05→1.418e+05 | +3.69% | 1.000 |
| Go no edit | 4.085→4.232 | +3.59% | .899 |
| rewrite | 2.378e+06→2.527e+06 | +6.23% | .461 |
| query_compile | 1.154e+07→1.166e+07 | +1.04% | .758 |
| language | 1.154e+07→1.212e+07 | +5.04% | .565 |
| grammargen_lr | 1.23e+08→1.329e+08 | +8.02% | .429 |
| ordinary YAML R4 | 2.196e+05→2.33e+05 | +6.12% | .429 |
| owned YAML R4 | 3.966e+05→4.08e+05 | +2.89% | .565 |
| owned YAML 8 KiB | 1.548e+06→1.576e+06 | +1.82% | .620 |

All timing differences are inconclusive; they do not establish equivalence.
The large-file allocation-count median rises **305→326.5 (+7.05%, p=.439)**,
within the 10% ratchet. This direction is retained while allocated bytes fall
28.40%. Every other allocation-count median stays exact. No edit retains
**0 B/op and 0 allocations** in every sample. Tiny byte directions remain in
the raw data: Go full 429,373→429,374; Go edit 402→402.5; owned YAML 8 KiB
44,952.5→44,953 B/op. Other byte medians stay exact. The largest timing median
increase is grammargen_lr +8.02%, also within the comparative ratchet.

The attribution probe independently reports allocated bytes
834,360,144→599,225,008 (−28.18%), Core capacity
153,207,852→135,297,372 (−11.69%), and GC cycles 12→10. Its complete large-Go
Core/scheduler work and 119,756,072-byte tree arena remain identical. Attribution
is a separate diagnostic observation, not a timing sample.

## Memory safety and graduation limits

All **126** RSS processes pass, including all six initial probes and 20 matched
pairs per case. Go's candidate maximum is **331.515 B/source byte**, below 400;
its candidate/baseline median ratio is **0.925638**. Ordinary YAML is
**0.997552** and owned YAML **1.000859**, both below 1.10. Every original sample
is retained. All five final containers exit 0 without an OOM.

A separate earlier combined C-correct protocol plus projection screen passes
42 Go RSS processes with a 334.046 maximum and 0.937044 median ratio. It preserves
306 clean C cases, 144 edit steps and the preceding private work vectors. That
combined source still has 65 unapproved canonical work increases and lacks full
fleet, three-case RSS and timing qualification. It remains private. The original
flat and paged RSS failures remain recorded; this narrow result does not erase
them or transfer the independent production qualification.

Ordinary YAML still takes its ownership fallback. The small-Go throughput gap,
expanded Go C-correct protocol, E-A exit gate and compact graduation remain open.
The new memory result advances the large-Go blocker without certifying graduation.

Evidence: [source pins, raw pairs, audits and replay instructions](benchmarks/20261019-progress-arena-projection/README.md).

# Packed decoder follow-up: throughput remains unproven

The six-file follow-up passes correctness and memory gates, but establishes no
throughput improvement in **480 shuffled benchmark rows**. Every timing
difference is inconclusive. The runtime remains private. The next Go target is
to consume encoded fields directly, avoiding repeated full-Action construction.

The [complete source and replay inputs](benchmarks/20261019-packed-action-decoder/README.md)
use runtime `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37` as the control. This is an
independent comparison; do not add percentages to earlier receipts. It includes
neither the pending Go correctness repair nor the stable YAML request-window
prototype. No production route, counter pin, exception or graduation changes.

## Encoding and source

Canonical actions retain the previous proposal's eight-byte encoding;
exceptional entries remain lossless at sixteen bytes. State IDs stay 32-bit,
symbols and production IDs 16-bit, child counts eight-bit and dynamic precedence
signed 16-bit. Extra, extra-chain and repetition flags remain independent.
Unknown action types and nonzero otherwise-unused fields preserve every bit.
The row header stays 32 bytes on amd64 / 20 bytes on 386.

The common decoder constructs one Action value using a type-derived mask.
Exceptional reads move to an out-of-line helper, which checks the logical index
before multiplication, including integer extremes. Both encodings retain
immutable snapshots, zero-allocation reads, descriptors and reusable bits.
Owner, phase, transaction and ordinal checks remain.

Compiler attribution compares the previous rejected prototype to this decoder:
ActionRow.At's inlining cost falls **165→146**, still above 80. Its assembly
frame falls **96→80 bytes**. Candidate CPU attribution puts **1.90% flat /
2.00% cumulative** samples in At, versus **3.27% / 3.36%** in the earlier probe.
These profiles are attribution probes, not paired speed evidence. The compiler
control is the earlier private packed source; the timing control is runtime
b513. Source manifests identify both scopes.

## Correctness and counters before timing

All **414 complete fixture-ledger rows** match, including work, reuse, routes,
stops, extents and errors. All four canonical Go deep-tree hashes and complete
Core/scheduler vectors match. Representative counters remain:

| Counter | Before → after |
| --- | ---: |
| Go R4 candidate full nodes / tokens | 1251→1251 / 589→589 |
| Go R4 first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML ledger full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

All **206 ordinary 72-step sessions**, explicit owned YAML, and **618 C smoke
checks** pass. Every invariant no-edit reparse allocates nothing. Strict census
results remain **120 compact passes / 39 legacy passes / 45 known failures**.
All **306 Go C outcomes** and **300 routes** match the fresh control: 261/300
expanded passes, the same 39 failures, six targeted passes, 90 compact and 210
fallback routes. The one-MiB Go locked-C digest, full accepted coverage and
complete work vector match. Large YAML document/scanner/edit C checks pass.

Core normal, phase0A, one-pass, shadow, 386 and scoped races pass. Root memory,
pooling, real publication stop controls and races pass. Layout/API/R6 and all
65 workflow selectors pass. The primary runtime stays unchanged.

## Twenty shuffled pairs

The repository runner uses twenty alternating pairs per language, GOMAXPROCS=1,
count=1 per seed, 750ms and benchmem, normal pooling, serialized in pinned 6 GiB
Docker on CPU 6. YAML seeds are **37401..37420**, Go **37501..37520**. All 480
rows finish; custom work and route metrics stay exact throughout.

| Case | Median before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Go CompactFreshOneMiB | 801.191 ms→829.569 ms | +3.54% | 0.076 |
| Go FullDFA | 8.127 ms→8.271 ms | +1.77% | 0.327 |
| Go IncrementalNoEditDFA | 3.184 ns→3.225 ns | +1.29% | 0.597 |
| Go IncrementalSingleByteEditDFA | 101.314 µs→101.001 µs | -0.31% | 0.583 |
| Go grammargen_lr | 97.396 ms→100.897 ms | +3.59% | 0.127 |
| Go query_compile | 9.402 ms→9.671 ms | +2.86% | 0.127 |
| YAML eof8k_legacy | 527.100 µs→526.792 µs | -0.06% | 0.429 |
| YAML eof8k_ordinary | 601.523 µs→606.056 µs | +0.75% | 0.758 |
| YAML eof8k_owned | 1.372 ms→1.363 ms | -0.60% | 0.583 |
| YAML r4_legacy | 145.128 µs→145.834 µs | +0.49% | 0.841 |
| YAML r4_ordinary | 194.483 µs→195.605 µs | +0.58% | 0.478 |
| YAML r4_owned | 364.034 µs→353.876 µs | -2.79% | 0.086 |

All time/object medians stay within the 10% ratchet. Every timing difference is
inconclusive. Large-Go allocation medians move **280.5→278**, p=.767; all other
allocation medians stay exact. Every no-edit row has zero bytes and allocations.
Byte medians move Go full **429375→429374.5**, Go edit **399→400** (p=.331),
and ordinary YAML 8 KiB **49097→49096**; all byte comparisons are inconclusive.
All other byte medians stay exact. Raw evidence retains every direction.

All **126 RSS processes** pass, including the six initial probes. Maximum
candidate RSS is **295.695 B/source byte**, below 400. Candidate/baseline median
ratios are **0.994932 Go / 0.967289 ordinary YAML / 0.968543 owned YAML**, within
1.10. This establishes safety; it does not establish throughput improvement.

Full-Action decoding remains on the common path. Further work must qualify
encoded consumers against the published runtime before promotion or graduation.

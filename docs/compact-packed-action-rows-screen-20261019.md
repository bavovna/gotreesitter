# Packed compact actions: smaller tables, Go throughput rejected

The six-file experiment stays private because three Go throughput cases regress
significantly. No runtime code is promoted.

Baseline runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
The six-file source implements the packed-action part of E-A7 (#1319).
Each canonical action occupies eight bytes instead of the source Action's
20 bytes. A row containing any noncanonical action uses sixteen bytes per
entry and preserves every field. The row header stays 32 bytes on amd64
and 20 bytes on 386. This storage reduction is distinct from throughput.

Shift states remain uint32. Reduction symbols and production IDs retain all
16 bits, child counts all eight bits, and dynamic precedence all signed
16 bits. Extra, extra-chain and repetition flags remain independent. Unknown
action types and otherwise unused nonzero fields round-trip through the wide
encoding. Descriptors and reusable bits retain their original semantics.
Reads return immutable values and allocate nothing. Owner, transaction,
classification-phase and ordinal checks remain in place. Logical bounds are
checked before doubling wide-row indexes, including integer extremes.

The proposal changes no root Go file or public API. It includes neither the
pending Go correctness repair nor ordinary YAML ownership activation.
No production work pin, exception, route or graduation entry changes.

All 414 complete fixture-ledger rows and four canonical deep-tree hashes and
complete Core/scheduler work vectors match. All 206 ordinary 72-step edit
sessions and explicitly activated owned YAML pass, with allocation-free
no-edit reparses. All 618 C smoke checks pass. Strict real-corpus results stay
120 compact passes / 39 legacy passes / 45 known legacy failures.

Fresh controls and candidates retain identical outcomes on all 306 Go C cases,
including the same 39 expanded failures and all 300 routes (90 compact /
210 fallback). The 1048591-byte Go witness matches the locked-C structural
digest, accepts without fallback or errors and retains 903086 constructions /
425742 tokens. Large YAML scanner/document/edit C comparisons pass.

Core normal, phase0A, one-pass, shadow, 386 and scoped races pass. Root memory,
pooling, real publication stop controls and races pass. The initial 386 test
incorrectly assumed a 32-byte row header on both architectures; changing that
test assertion to 20 bytes on 386 preserves the original header width. The
original failure remains in the raw logs. The runtime did not change.

The fresh query_compile profile attributes 38.35% of CPU samples cumulatively
to dispatchPassActive, 25.68% to applyGenericReductionOwned, 17.35% to election
and 21.77% to acceptance materialization. These cumulative shares overlap and
are not additive speedup estimates. The profile predates the packed proposal.

## Twenty shuffled pairs: throughput rejected

The repository runner completes **480 rows**: six cases per language, twenty
alternating matched pairs, GOMAXPROCS=1, count=1, 750ms and benchmem, with normal
pooling. YAML seeds are 37101..37120; Go seeds are 37201..37220. All runs are
serialized in pinned 6 GiB Docker on CPU 6. Custom work and route metrics remain
exact. Raw before/after files and full benchstat output retain every result.

| Case | Median before → after | Time direction | p |
| --- | ---: | ---: | ---: |
| Go one-MiB fresh parser | 827.659 ms→847.709 ms | +2.42% | 0.242 |
| Go full DFA | 8.015 ms→8.439 ms | +5.29% | <.001 |
| Go no edit | 3.213 ns→3.157 ns | -1.76% | 0.129 |
| Go one-byte edit | 103.400 µs→100.944 µs | -2.38% | 0.355 |
| Go grammargen_lr | 101.163 ms→106.843 ms | +5.61% | 0.008 |
| Go query_compile | 9.572 ms→9.971 ms | +4.17% | 0.028 |
| YAML eof8k_legacy | 540.699 µs→528.007 µs | -2.35% | 0.277 |
| YAML eof8k_ordinary | 611.957 µs→612.139 µs | +0.03% | 0.718 |
| YAML eof8k_owned | 1.361 ms→1.370 ms | +0.71% | 0.862 |
| YAML r4_legacy | 146.772 µs→145.085 µs | -1.15% | 0.461 |
| YAML r4_ordinary | 200.656 µs→200.581 µs | -0.04% | 0.461 |
| YAML r4_owned | 354.981 µs→356.776 µs | +0.51% | 0.883 |

Three Go full-parse cases become significantly slower. Although all time/object
medians stay within the 10% ratchet, this proposal does not advance the Go
throughput goal. **The runtime remains private and is not promoted.** The other
nine timing differences are inconclusive. All twelve allocation-count medians
stay exact. All byte medians stay exact except Go edit 400→399 B/op (p=.160,
inconclusive); every no-edit sample has zero bytes and allocations.

A separate retained-table sanity probe reports Go cached table bytes
**95424→77056 (−19.25%)**, with unchanged 1139 action rows, 154 reduction plans,
1340 index entries and stride 10. This is one GC-based probe per role, not a
20-seed throughput measurement; it does not justify the measured slowdown.
Canonical entry payloads shrink 20→8 bytes; exceptional payloads use 16 bytes.

All **126 RSS processes** pass, including the six initial probes. Maximum
candidate RSS is **296.914 B/source byte**, below 400. Matched candidate/baseline
median ratios are **0.998173 Go / 0.983927 ordinary YAML / 0.978164 owned YAML**,
within 1.10. These safety measurements do not establish throughput improvement.

The candidate query profile attributes **3.27% flat / 3.36% cumulative** of its
samples to ActionRow.At. Its assembly shows full Action temporaries and repeated
stack copies. The baseline and candidate profile runs are attribution probes,
not paired timing evidence. The follow-up will target decoding and copying
before reconsidering packed storage; it must repeat the correctness, counter,
RSS and shuffled timing gates against the published runtime.

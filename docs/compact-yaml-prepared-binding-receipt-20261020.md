# Prepared YAML scanner binding: 2026-10-20

Prepare immutable scanner metadata once at language binding. The value scanner
shares a private symbol table, and a complete identity mapping uses its incoming
valid-symbol mask read-only. Other mappings keep the existing general path.
This removes per-call mapping copies and repeated identity remapping without
changing scanner state, public methods, callbacks or routing.

Twenty matched alternating pairs measure ordinary R4 YAML **2.60% faster**
(p=.028) and legacy R4 **2.07% faster** (p=.017). Other YAML timings are
inconclusive: ordinary 8KiB −.09%, owned R4 −.89%, owned 8KiB −2.34% and
legacy 8KiB −2.14%. Warm YAML bytes and object medians stay exact.

All six Go timings are inconclusive. Retain their directions: full DFA +5.59%
(p=.341), grammargen +4.99% (p=.157), no-edit +6.90% (p=.060), query +2.93%,
large Go +2.56% and edit −.19%. All **480 rows**, twenty distinct matched
orders per language, and time/object/byte ratchets pass. No-edit heap stays zero.
The earlier sharing-only trial is held separately; no percentages are combined.

All **414 complete before/after ledger rows** and four canonical tree/work
vectors are exact. YAML ordinary/owned **72-step sessions**, three C fixtures,
strict R4, large C witnesses, parsing race, scanner race/386, memory/pooling and
API/L0/R6 pass. Supplemental C behavior preserves **417/723 passes**, the same
306 failures and exact public vectors. Full 206-language sessions/C fixtures
were not rerun because all other engines and grammar implementations are unchanged.

All **126 RSS processes** pass, including initial probes. Candidate maximum is
**305.261 B/source byte**. The compiler inlines the validity helper at cost 73
and reports no mask heap escape; wrapper frame size falls 560→56 bytes. These
compiler findings are separate from measured runtime evidence.

The only runtime implementation change is grammars/runtime/yaml_scanner.go;
two existing tests cover rebinding, zero value, independent payloads, full-width
symbols and masks with unusual lengths, reordered slots, duplicates or unknowns.
All runtime and benchmark hashes on the public branch match the frozen
qualified candidate. The inherited CI-planner test and the Kotlin test isolation
fix differ and are pinned separately.

[Raw evidence, all timing directions, source pins and fresh-run replay](benchmarks/20261020-yaml-prepared-binding/README.md).
Baseline: public f28a3c1 from [PR1488](https://github.com/odvcencio/gotreesitter/pull/1488).
PR1488 merged as `2769aea23c6c8621db5368b6d9c3257bcb3c9b25` after 74 successful
checks and four skips. This scanner/Q-lane PR is based on main. It does not
close #1308, enable ordinary YAML compact ownership, change an allowlist or
graduate compact.

The initial draft CI found an existing Kotlin test-order failure. It reproduces
on the 64-byte reference, the 32-byte parent and this YAML candidate: each
passes alone and fails five times when the Kotlin tests run together. The two
forced-profile tests now use the existing language-clone helper, so each owns
its runner pool before changing certification flags. Every route and tree
assertion remains. All Kotlin tests pass five times on all three sources;
three certification repetitions under race and five shuffled repetitions
(seed 41801) also pass. No runtime or shipped Kotlin profile changes.
[Controls and raw logs](benchmarks/20261020-yaml-prepared-binding/kotlin-isolation-audit.json)
are archived separately from scanner measurements.

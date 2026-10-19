# Paired scanner snapshots: qualified YAML allocation reduction

Pairing small immutable scanner snapshots cuts owned-YAML allocations
**79→72 (−8.86%)** on R4 and **218→191 (−12.39%)** on the 8 KiB witness.
R4 bytes stay **13032→13032**; 8 KiB bytes rise **44952→45528 (+1.28%)**.
All timing comparisons are inconclusive. This is an allocation improvement;
ordinary YAML keeps its existing fallback and neither language graduates.

The [source, raw evidence and replay instructions](benchmarks/20261019-scanner-snapshot-pairs/README.md)
use runtime `54863cf280722c720bda81c2a8480f2398255730` as the baseline.
The five measured files contain neither the rejected streamed ownership proposal
nor the pending 17-file Go correctness repair. No work pin or exception changes.

## Layout and ownership

The earlier four-record layout was rejected for its R4 byte cost. An observation-only
census finds 14 small and one larger snapshot on R4, versus 55 small and four
larger snapshots on 8 KiB. Every trial mask has 113 entries. The revised helper
pairs only snapshots whose byte fields total at most 32 bytes; larger or otherwise
ineligible shapes retain the existing exact constructor. The odd small-snapshot
count on 8 KiB reserves one extra slot, accounting for its 576-byte cost.

Every published address remains immutable. Rollover allocates fresh storage;
reset drops the current page. Live snapshot pointers keep older pages reachable,
and independent clones clear the original storage identity. All scanner binding,
contract, checkpoint and generation checks remain in place.

The existing footprint traversal sorts snapshot pointers. Slots of a shared
allocation remain adjacent in that ordering because another allocation cannot
lie inside their storage. It therefore charges each live page once without
building another owner-reference list. The current page is charged even when
its records are unpublished or unused. Tests cover multiple pages in reverse
request order, a current page at the lowest address, unused slots, stale versions,
reset and independent clones. The helper constructs 64 immutable records in
32 allocations on native, 386 and race runs; this is a unit bound.

## Counters and correctness

All **414 complete fixture-ledger rows** match the baseline, including work,
reuse, stop reasons, extents and error status. Six additional public full/edit
rows match exactly, and all four canonical Go work pins pass.

| YAML work | Before → after |
| --- | ---: |
| Ordinary R4 full / ledger first-edit nodes | 288→288 / 480→480 |
| Owned R4 full / first-edit nodes | 484→484 / 484→484 |
| Ordinary 8 KiB public full / fresh-edit nodes | 1156→1156 / 1156→1156 |
| Owned 8 KiB full / fresh-edit nodes | 1936→1936 / 1936→1936 |
| Owned R4 / 8 KiB tokens | 102→102 / 403→403 |

The **206 ordinary 72-step invariant sessions**, explicitly activated owned-YAML
72-step session and **618 C smoke checks** pass. No-edit reparses allocate
nothing. The strict 204-file census is unchanged: **120 compact passes,
39 legacy passes and 45 known legacy failures**. This is not an all-file C
certificate. The existing YAML prefix, document, scanner-cursor and edited C
comparisons pass, including both 524-document, 1,049,572-byte witnesses.

Memory budgets, pooling, acceptance stop controls and scoped root/Core races
pass. The native integration keeps the measured implementation exact and moves
the three new root regressions into an existing test file. Root/API guards retain
756 files and 12 tag sets; R6 and all 65 workflow selectors pass. Native root
and 386 regression checks and native ledgers pass.

## Twenty shuffled pairs

The repository runner completes **440 rows**, with twenty alternating pairs per
language, GOMAXPROCS=1, count=1 per explicit seed, 750ms and benchmem. Runs are
serialized in pinned 6 GiB Docker on CPU 6. YAML seeds are 36501..36520;
Go seeds are 36601..36620. Public work and routing metrics stay exact.

| Case | Median time before → after | Direction | p |
| --- | ---: | ---: | ---: |
| Owned YAML R4 | 436.548→449.894 µs | +3.06% | .989 |
| Owned YAML 8 KiB | 1.671→1.748 ms | +4.55% | .718 |
| Ordinary YAML R4 | 245.348→242.706 µs | −1.08% | .799 |
| Ordinary YAML 8 KiB | 793.702→767.300 µs | −3.33% | .620 |
| Legacy YAML R4 | 184.777→175.431 µs | −5.06% | .659 |
| Legacy YAML 8 KiB | 647.254→623.554 µs | −3.66% | .461 |
| Go full DFA | 10.875→10.830 ms | −0.41% | .841 |
| Go one-byte edit | 133.218→136.201 µs | +2.24% | .341 |
| Go no edit | 3.967→4.005 ns | +0.96% | .815 |
| Go query_compile | 12.555→12.526 ms | −0.23% | .529 |
| Go grammargen_lr | 135.620→131.378 ms | −3.13% | .820 |

Every time difference is inconclusive. The two owned-YAML allocation reductions
have p<.001. Other allocation counts stay exact. Go edit bytes move **401→402**;
query bytes **8113→8112**. Other Go byte medians stay exact. Every no-edit sample
has zero bytes and allocations. No time/object median exceeds the 10% ratchet.

All **126 RSS processes** pass, including six initial samples. Candidate maximum
is **329.136 bytes/source byte**, below 400. Matched candidate/baseline median
ratios are **0.999140 Go / 0.997613 ordinary YAML / 1.039252 owned YAML**.
The owned-YAML RSS direction is **+3.93%**, within the 10% ratchet. All original
samples remain available. These are memory-safety measurements, not timing evidence.

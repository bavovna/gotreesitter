# Compact reduction-plan screen: 2026-10-20

The 16-byte reduction-plan candidate passes correctness and safety gates but
has **no demonstrated throughput or warm allocated-byte improvement**. It stays
private. This receipt does not change runtime source, pins, exceptions or routing.

The candidate replaces a 56-byte amd64 / 28-byte 386 value with a 16-byte /
8-byte value and a shared immutable metadata holder. Full-width IDs and copied
field/alias ownership remain intact. Empty metadata needs no holder; nonempty
plans add one cold holder allocation. The existing root adapter API is unchanged.

All **414 complete before/after ledger rows** and four canonical tree/work
vectors are exact. All **206 × 72-step** edit sessions, explicit owned YAML,
**618 C checks**, the unchanged **204-row** strict census, **306 expanded Go
outcomes**, large Go/YAML C witnesses, scoped races, 386, memory/pooling and
API/layout/R6 checks pass. The same 45 strict and 39 expanded-Go failures remain.
All **126 RSS probes** pass; candidate maximum including initial probes is
**293.730 B/source byte**. No work exception is used.

Twenty matched alternating pairs per language produce **480 rows** and twenty
distinct matched workload orders per language. Every 10% comparative ratchet
passes; no-edit allocation stays zero. All twelve timings are inconclusive.
Go edit time moves **+5.34% (p=.289)**, grammargen **+4.42% (p=.157)**,
and owned YAML 8 KiB **+4.85% (p=.738)**. Warm allocated-byte medians are
effectively unchanged. Large-Go object medians move **231→232.5 (+.65%)**.
These results do not justify landing the smaller representation.

The earlier borrowed-plan prototype fails the root API gate because its exported
adapter method adds a tracked declaration. Its focused tests pass; fleet/C and
performance gates never run. No API snapshot is changed. Both prototypes and
all failures remain [in the evidence bundle](benchmarks/20261020-reduction-plan16/README.md).

The pinned baseline is `f28a3c1cfca394fa378bf5994fead01c3886e73b`, the qualified
32-byte wrapper branch in [PR #1488](https://github.com/odvcencio/gotreesitter/pull/1488).
It is separate from main's merged PR #1487. Neither prototype is part of #1488.
Ordinary YAML ownership, the Go throughput gap and compact graduation stay open.

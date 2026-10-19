# Graph links: fewer allocated bytes, higher RSS

Control runtime: `b7046b6c5385ec52a09fb8b8250c9d689754b74e`.
The 29-file prototype stores graph identities and next links in 16 bytes,
with optional full-width signed scores, ordering and flags in immutable
shared metadata records. An implicit zero value and four-entry recent cache
avoid redundant records. Rollback invalidates the cache; reset, retention,
capacity accounting and independent shadow copies include the new plane.
All original identifier and metadata widths remain intact.

This is a qualified allocation reduction on the pinned control. It is not
applied to production in this receipt. Main has since advanced to 88dc1d9c;
the final combination requires fresh qualification. The private wrapper and
seeding-identity prototypes are absent, as is the held native-action layout.

All 414 complete ledger rows, four canonical deep trees/work vectors, 206
ordinary 72-step sessions, explicit owned YAML, 618 C fixture checks, the
unchanged strict 120 compact / 39 legacy / 45 known-failure census, all 306
Go C outcomes / 300 routes, large Go/YAML witnesses, Core modes, 386,
scoped races, memory/pooling/publication controls and API/layout/R6/65-selector
gates pass. All 3520 candidate Go hashes match the measured source. The
same 39 expanded Go failures remain; this is not a graduation certificate.

All 480 benchmark rows finish with twenty alternating shuffled pairs,
GOMAXPROCS=1, count=1, 750ms, benchmem and normal pooling. YAML seeds are
38601..38620, Go 38701..38720. One-MiB Go allocated bytes fall 6.89%
(539585416→502397808), and ordinary YAML R4 / 8 KiB fall 10.19% / 12.47%
(14840→13328 / 49097→42976); all have p<.001. Every timing difference is
inconclusive. Ordinary YAML 8 KiB time moves +7.53% (p=.060); query Go
+5.32% (p=.820). Every direction remains in perf-summary.json and benchstat.

The costs are retained, not waived. Ordinary YAML adds one object/op:
37→38 and 34→35, both p<.001. Large-Go allocation-count medians move
328→344 (+4.88%, p=.124), inconclusive. All other object medians stay
exact. All 126 RSS processes pass, including six initial probes, but median
RSS rises 6.02% Go / 1.50% ordinary YAML / 4.47% owned YAML. Ratios are
1.060237 / 1.015017 / 1.044686, within 1.10; maximum is 308.558 B/source
byte, below 400. RSS seeds are 38801..38820. Every no-edit sample allocates
zero bytes and objects. No work/reuse counter or memory ratchet fails.

The archived isolated b513 screen and three initial compiler failures remain
separate from the combined b704 qualification. Typed indices, logical test
snapshots and a phase0A-only observer accessor required adaptation. Normal
Core/386/race inputs remained unchanged after the observer correction;
that reuse is pinned in source-reference.json. No timing sample was discarded.

## Replay

```sh
python3 prepare-replay.py --baseline /path/to/b704-source \
  --candidate /path/to/new-candidate --evidence /path/to/new-evidence
python3 prepare-replay.py --baseline /path/to/b704-source \
  --candidate /path/to/new-candidate --evidence /path/to/new-evidence --check
```

The helper verifies five archive hashes, applies the exact 29-file patch and
checks complete 3518/3520-file Go manifests. It supplies no completion markers
or executable test binaries. Both modes were exercised. The raw archives
retain complete counters, known failures, all timing roles, RSS processes,
initial setup failures and runner metadata.

Mount baseline at /reference:ro, candidate at /candidate:ro and prepared
evidence at /evidence. Use Go 1.25.14, image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks.
Retain the C cache at /workspace/harness_out/parity_c_ref_cache/linux_amd64.

```sh
bash /evidence/focused.sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, mount prepared rss/ at /evidence and the full output at /lab:ro;
run `bash /evidence/selectors.sh`. Restore the full output at /evidence for
`bash /evidence/perf.sh`, `python3 /evidence/analyze-perf.py` and benchstat.
No route, counter pin, owner exception or graduation setting changes.

# Packed decoder follow-up: reproducible screen

Control runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
Six measured files preserve the eight-byte canonical / sixteen-byte exceptional
action encoding, replace conditional full-Action construction with one masked
value, and move exceptional reads out of line. All full-width fields, flags,
immutable rows, bounds, owner checks and header sizes remain intact.

**Not promoted:** all twelve timing comparisons are inconclusive across 480
rows. Go full +1.77%, query +2.86%, grammargen +3.59% and one-MiB +3.54% remain
visible; owned YAML R4 −2.79% and 8 KiB −0.60% are also inconclusive. No timing
or object median exceeds its 10% ratchet. Raw roles and benchstat retain every
direction. The next target is direct encoded consumption, avoiding full Action
values at common lookups. No production source or graduation change follows.

All 414 ledger rows, four canonical trees/work vectors, 206 ordinary 72-step
sessions, explicit owned YAML, 618 C checks, unchanged strict census, all 306
Go C outcomes / 300 routes, large Go/YAML witnesses, memory/pooling/publication
controls, scoped races, 386 and API/layout/R6/65-selector guards pass. All 126
RSS processes pass; maximum 295.695 bytes/source byte. No-edit always has zero
bytes and allocations. The pending Go correctness repair is absent.

The patch and six-file pins authenticate all changed source. Complete manifests
cover 3518 baseline / 3520 candidate Go files. A third manifest identifies the
earlier private packed source used only for the compiler diagnostic comparison.
Its At inlining cost is 165, versus 146 here; both exceed 80. CPU shares and
assembly are attribution, not paired timing evidence. Instruction text has
trailing whitespace removed; binaries and raw binary profiles stay private.

## Replay

Start with a clean complete baseline module and grammar/fixture assets:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

The helper checks five archive hashes, reconstructs six files and checks both
complete source manifests. Prepare and check modes were exercised. Mount
baseline at /reference:ro, candidate at /candidate:ro, prepared evidence at
/evidence and this receipt at /receipt:ro. Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, CPU 6, GOMEMLIMIT=5GiB and GOMAXPROCS=1, under both repository
locks. Retain the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, remount prepared rss/ at /evidence and the whole output at /lab:ro;
run bash /evidence/selectors.sh under the same locks and source mounts. Restore
the whole output at /evidence before the timing comparison:

```sh
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
```

Benchstat supplies significance tests. profile-candidate.sh optionally repeats
the attribution probe. Preparation supplies no completion marker or binary.

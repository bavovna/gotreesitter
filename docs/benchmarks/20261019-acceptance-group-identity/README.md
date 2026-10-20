# Closed acceptance-group identity: qualified correctness repair

Control runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
Three changed files preserve the acceptance identity a version retains after
its live recovery keys clear. Interning now matches the identity the existing
publisher would keep; lexer-owner equality compares the effective identity,
including the active-key fallback. No identifier is narrowed, no recovery
policy changes, and no counter pin, route or graduation setting changes.

Two regression tests fail on the control. Interning can otherwise overwrite
one closed group's identity with a sibling's, and ownership can collapse
different recovery elections. The repair passes both tests normally, under
race detection and on 386. Tests retain equal-identity reuse and active-key
fallback equivalence. These are internal identity regressions, not a claim
that this patch fixes the remaining public C mismatches.

All 414 complete fixture-ledger rows, four canonical trees/work vectors,
206 ordinary 72-step sessions, explicit owned YAML, 618 C fixture checks,
the strict 120 compact / 39 legacy / 45 known-failure census, all 306 Go C
outcomes and 300 routes, large Go/YAML witnesses, memory/pooling/publication
controls, scoped races, API/layout/R6 and 65 selectors pass. No-edit reparses
allocate zero bytes and objects. The pending 65-counter Go repair is absent.

All 480 shuffled benchmark rows finish: YAML seeds 38301..38320 and Go
38401..38420, 750ms, count=1, GOMAXPROCS=1, benchmem and normal pooling. All
twelve timing differences are inconclusive; no speedup is claimed. Every
allocation-count median is unchanged and every time/object median stays within
its ratchet. Raw samples retain all directional movements, including Go
grammargen +6.88%, owned YAML R4 +7.68% and ordinary YAML 8 KiB +7.52%.
All 126 RSS processes pass; `rss-audit.json` retains the six initial samples
and twenty alternating matched pairs per case (seeds 38501..38520).

The supplemental YAML corpus contains 241 small inputs across legacy,
ordinary and owned routes: 723 fresh C comparisons per revision. Both revisions
pass 417 and retain the same 306 failures, with no public-vector changes.
The first run accidentally used the clean-tree helper, which rejected error
nodes before structural comparison. Both complete runs remain archived. The
corrected oracle uses exact-with-errors comparison and explicit root HasError
equality. No parser source changed between those runs. Remaining mismatches
are documented limits; the repair does not establish graduation.

## Replay

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

The helper verifies six archive hashes, applies the three-file patch and
checks complete 3518-file Go manifests for both modules. Prepare and check
modes were exercised. Mount baseline at
/reference:ro, candidate at /candidate:ro and prepared evidence at /evidence.
Use Go 1.25.14, image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Retain
the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/witness.sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, remount prepared rss/ at /evidence and the whole output at /lab:ro;
run `bash /evidence/selectors.sh`. Restore the whole output at /evidence for
`bash /evidence/perf.sh`, then `python3 /evidence/analyze-perf.py` and benchstat.
For the supplemental oracle, extract yaml-error-corpus.tar.gz separately,
mount its yaml-errors/ at /evidence and run `bash /evidence/run.sh` with both
source modules and C cache mounted. The initial clean-helper directory is
historical evidence; the corrected yaml-errors/ run is authoritative.
Preparation supplies no completion marker or executable binary.

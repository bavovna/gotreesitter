# Stable YAML request window: reproducible rejection

Control runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
**Not promoted:** 480 shuffled rows establish no owned-YAML throughput or
allocation win. Large-Go allocation medians 278→325 (+16.91%) exceed the 10%
ratchet, despite an inconclusive high-variance distribution (p=.930). Legacy
YAML R4 time rises 7.66% (p=.007). Raw directions remain in both roles and
benchstat. All 414 ledger rows, four canonical vectors/trees, 206 ordinary
72-step sessions, explicit owned YAML, 618 C checks, strict census, all 306 Go
C statuses / 300 routes, large witnesses, memory, races and 386 stay unchanged.
All 126 RSS processes pass; maximum 318.949 bytes/source byte.

The patch adds a checked four-byte request window, preserving references
through election-prefix compaction so immutable headers need not be
republished. Recovery's existing hole-pruning renumbering barrier remains.
The six-file patch and runtime pins cover every changed file; complete source
manifests cover 3518 baseline and 3520 candidate Go files. The initial
five-file draft manifest is retained separately. No pending Go correctness
repair, packed decoder, production source or graduation change is included.

The original mistyped recovery race selector and logs are retained alongside
the corrected script, extra race replay and exact PASS assertions. Source
hashes remain exact across the passing qualification and timing runs.
`publication-callers.txt` filters the existing b513 attribution profile;
54.30% of sampled allocation objects sit under equivalent-state installation,
not the removed loop. These are sampled cumulative shares, not speed claims.

## Replay

Start with a complete clean baseline module and its grammar/fixture assets:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

The helper verifies five archive hashes, reconstructs the six measured files
and checks both complete source manifests. Prepare and check modes passed. Mount baseline at /reference:ro,
candidate at /candidate:ro, prepared evidence at /evidence and this receipt at
/receipt:ro. Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository
locks. Retain the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
bash /evidence/recovery-screen.sh
bash /evidence/recovery-race-resume.sh
```

For RSS, remount prepared rss/ at /evidence and the whole output at /lab:ro;
run `bash /evidence/selectors.sh` under the same locks and source mounts.
Restore the whole output at /evidence before timing:

```sh
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
```

Benchstat supplies significance tests. `analyze-perf.py` reports the failed
median ratchet; its successful execution is not promotion approval. No
completion marker or executable binary is supplied by preparation.

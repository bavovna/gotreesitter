# Packed action rows: source and reproducible screen

Baseline runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
The six-file proposal packs canonical actions into eight bytes and retains
lossless sixteen-byte exceptional entries, with unchanged row-header widths.
All full state/metadata widths, immutable values and ownership checks remain.

**Rejected for promotion:** Go full DFA time rises 5.29% (p<.001), query_compile
4.17% (p=.028), and grammargen_lr 5.61% (p=.008), across twenty matched pairs.
The smaller table storage does not justify these regressions. Other timings
are inconclusive; the complete 480 rows and every direction are retained.

All 414 ledger rows and four canonical trees/work vectors stay exact. The 206
ordinary 72-step sessions, explicit owned YAML, 618 C checks, unchanged strict
120/39/45 census, all 306 Go C statuses / 300 routes, large Go/YAML C witnesses,
memory/pooling/publication controls, scoped races, 386, layout/API/R6 and all
65 workflow selectors pass. No-edit stays zero bytes and allocations. All
126 RSS processes pass; the screen receipt gives complete medians and maxima.

The initial 386 failure was a test-only assumption that the row header was
32 bytes on both architectures. Its original log and reconstructed initial test
source are retained, clearly labeled. The corrected assertion preserves the
old 20-byte 386 header; runtime source is unchanged by that correction.

runtime.patch and runtime-pins.json authenticate the six measured files.
Complete source manifests authenticate all 3518 baseline / 3520 candidate Go
files. No production work pin, exception, route or graduation entry changes.
The pending Go correctness repair is absent. Profile text and ActionRow.At
assembly document the follow-up decoding target; no binary profile is committed.

## Replay

Start with a clean complete baseline module and its grammar/fixture assets.
The helper checks every archive hash, reconstructs the candidate outside the
baseline, and checks both complete source manifests:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

Mount baseline at /reference:ro, candidate at /candidate:ro, prepared evidence
at /evidence, and this receipt at /receipt:ro. Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, CPU 6, GOMEMLIMIT=5GiB and GOMAXPROCS=1. Hold both
repository locks. Retain the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, remount prepared rss/ at /evidence and the whole output at /lab:ro,
with the same source mounts and locks. Run bash /evidence/selectors.sh. Restore
the full output at /evidence before timing:

```sh
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
bash /evidence/native-check-scoped.sh
```

Benchstat supplies significance tests. Preparation creates no completion marker
or binary. Optional profile-baseline.sh and profile-candidate.sh reproduce the
attribution probes. Native source remains the baseline; the rejected source is
provided only as a replayable patch. Prepare and check modes were exercised.

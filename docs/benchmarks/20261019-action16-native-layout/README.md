# Native 16-byte actions: qualified, held without a measured runtime win

Control runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
The two-file prototype reorders the native Action fields from 20 to 16 bytes.
All field widths, direct reads, flags and immutable row semantics remain intact.
It includes neither the later closed acceptance-group repair nor other private
prototypes. No production source, counter pin, route or graduation setting changes.

All 414 complete ledger rows and four canonical deep trees/work vectors match.
All 206 ordinary 72-step sessions, explicit owned YAML, 618 C fixtures, the
unchanged strict 120 compact / 39 legacy / 45 known-failure census, all 306 Go C
outcomes / 300 routes, large Go/YAML witnesses, Core modes, 386, scoped races,
memory/pooling/publication controls, API/layout/R6 and 65 selectors pass.

All 480 timing rows finish using twenty alternating shuffled pairs, GOMAXPROCS=1,
count=1, 750ms, benchmem and normal pooling. YAML seeds are 38001..38020 and Go
38101..38120. All twelve timing differences are inconclusive. Go full moves
-2.02% (p=.414), one-MiB -3.75% (p=.265), grammargen -4.07% (p=.495), and query
+0.66% (p=.799). Owned YAML R4 moves +1.11%; every direction remains in the
raw samples and summary. Every allocation-count median stays exact and no
time/object median fails its ratchet. One-MiB Go stays 539,585,416 B/op and
325 objects/op. No retained-table byte improvement was measured separately.

All 126 RSS processes pass, including six initial probes and twenty matched
pairs per case with seeds 38201..38220. Maximum candidate RSS is 297.617
B/source byte. Candidate/control median ratios are 1.008743 Go, 0.998773
ordinary YAML and 1.000834 owned YAML. No-edit samples allocate zero bytes
and objects. These results establish safety, not a throughput improvement.
The prototype remains held while the graph-storage redesign is qualified.

The original performance prerequisite monitor expired before any timing
process started. Its missing-log warnings and timeout are described in
`perf-prerequisite-note.txt` inside correctness-raw.tar.gz. After qualification
and RSS passed, the unchanged benchmark source, seeds and protocol ran once;
no sample was discarded or repeated. Docker metadata and complete raw logs
remain archived.

## Replay

```sh
python3 prepare-replay.py --baseline /path/to/b513-source \
  --candidate /path/to/new-candidate --evidence /path/to/new-evidence
python3 prepare-replay.py --baseline /path/to/b513-source \
  --candidate /path/to/new-candidate --evidence /path/to/new-evidence --check
```

The helper checks all five archive hashes and complete 3518/3519-file Go
manifests, applies the exact two-file patch and prepares the runner inputs.
It supplies no completion markers or executable test binaries. Prepare and
check modes were exercised. The raw archives retain all outcomes, including
the known C failures; those failures are not approved divergences.

Mount the baseline at /reference:ro, candidate at /candidate:ro and prepared
evidence at /evidence. Use Go 1.25.14 and image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Retain
the C cache at /workspace/harness_out/parity_c_ref_cache/linux_amd64.

```sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, mount prepared rss/ at /evidence and the full output at /lab:ro;
run `bash /evidence/selectors.sh`. Restore the full output at /evidence for
`bash /evidence/perf.sh`, `python3 /evidence/analyze-perf.py` and benchstat.

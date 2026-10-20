# Paired scanner snapshots: source and qualification

Baseline runtime: `54863cf280722c720bda81c2a8480f2398255730`.
The five measured files reduce owned-YAML R4 allocations 79→72 and 8 KiB
allocations 218→191. R4 bytes stay exact; 8 KiB bytes rise 1.28%.
All eleven timing comparisons are inconclusive. Ordinary routing, work pins
and graduation stay unchanged. The pending Go correctness repair is absent.

`runtime.patch`, `runtime-pins.json`, `source-reference.json` and packed complete
manifests authenticate all 3514 baseline / 3516 measured candidate Go files.
`native-tests.patch` appends the same three root regressions to an existing test
file. The native source differs only in that test file; all measured implementation
files stay exact. Native source pins and API/layout/R6/selector results remain
unpacked. No new root Go file or API is added.

The 414 complete ledger rows, six public full/edit rows and canonical Go work
pins stay exact. All 206 ordinary 72-step sessions, explicitly activated owned
YAML, 618 C smoke checks, unchanged strict 204-row census, YAML large C/edit
witnesses, memory contracts and scoped races pass. Native root/386 tests and
native ledgers pass. These receipts preserve the 45 existing strict legacy
failures; they do not certify every real sample.

The runner completes 440 benchmark rows at GOMAXPROCS=1, count=1, 750ms,
benchmem and normal pooling: YAML seeds 36501..36520; Go 36601..36620.
No time/object median exceeds the ratchet. Go no-edit has zero bytes and
allocations in every sample. The complete medians, raw roles and benchstat
output remain unpacked. Public work/route metrics stay exact in all rows.

All 126 RSS processes pass, including six initial samples and 20 shuffled,
alternating pairs per case with seeds 36701..36720. Candidate maximum is
329.136 bytes/source byte. Median candidate/baseline ratios are 0.999140 Go,
0.997613 ordinary YAML and 1.039252 owned YAML. The owned RSS increase is
3.93%, within the 10% ratchet. Every original sample is preserved.

`archive-manifest.json` authenticates five bundles: complete source manifests,
replay inputs, correctness logs and ledgers, RSS logs, and Docker metadata.
No compiled binary or raw binary profile is included.

## Replay the measured source

Start from a complete clean baseline module with its pinned grammar/fixture
assets. Prepare a fresh external candidate and output directory:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

Preparation authenticates archives, preserves baseline hardlinks by detaching
modified files, applies the exact proposal and verifies every Go hash. Both
modes were exercised against fresh reconstructed directories.

Mount the modules at `/reference:ro` and `/candidate:ro`, the output directory
at `/evidence`, and this receipt at `/receipt:ro`. Use pinned Docker image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, one CPU pinned to 6, GOMEMLIMIT=5GiB and GOMAXPROCS=1.
Serialize through both repository locks. Keep the existing locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/guards.sh
bash /evidence/screen.sh
bash /evidence/extra.sh
python3 /receipt/analyze-counters.py /evidence
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
bash /evidence/qualify.sh
python3 /receipt/audit-qualification.py /evidence
```

For RSS, remount the prepared `rss/` directory at `/evidence`, the whole output
at `/lab:ro`, and retain the two source mounts. Run
`bash /evidence/selectors.sh` under both locks. It checks qualification completion
before starting the RSS probes; all initial probes are retained.

For native regression integration, repeat preparation/check with
`--native-tests` and fresh candidate/output directories. The helper safely
detaches the existing root test file, applies `native-tests.patch` and checks
the native manifest. Run `bash /evidence/native-check.sh` with that source at
`/candidate:ro`; the measured implementation remains identical. Do not add the
standalone snapshot-test overlay when the same tests are already permanent.

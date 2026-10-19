# Compact graph-node layout: source and evidence

Baseline runtime: `ca89615f82e02ca065c35e96a947934ba67f8e90`.
The twenty-file proposal keeps 32-bit state IDs, 64-bit path counts and full
64-bit precedence. Graph nodes shrink 32→24 bytes. Flattened alternative-set
fields let the existing 16-byte hot lineage record hold common precedence
values. Exceptional values use a capacity-bounded, NodeID-indexed int64 array.
Arithmetic, overflow checks, immutable publication and owner checks remain.

The proposal includes neither the rejected streamed-ownership change nor the
pending Go correctness repair. Ordinary YAML keeps its existing fallback.
No work pin, counter exception or graduation entry changes.

`runtime.patch`, `runtime-pins.json`, `source-reference.json` and the packed
complete source manifests authenticate all 3516 baseline / 3518 candidate Go
files. The replay helper reconstructs all twenty files outside the baseline;
prepare and check modes were exercised successfully.

## Correctness and memory

All 414 complete fixture-ledger rows, four canonical deep-tree hashes and
complete Core/scheduler work vectors match exactly. All 206 ordinary 72-step
edit sessions and explicitly activated owned YAML pass, including allocation-free
no-edit reparses. All 618 C smoke checks pass. The strict 204-file census remains
120 compact passes, 39 legacy passes and 45 known legacy failures.

A fresh control and candidate have identical results on all 306 expanded Go C
cases: 261/300 expanded passes, the same 39 failures, and six targeted passes.
All 300 expanded routes remain exact: 90 compact and 210 fallbacks. The separate
pending correctness proposal addresses those existing failures. The one-MiB Go
witness matches locked C in its complete structural digest, has full accepted
coverage, and retains 903086 constructions / 425742 tokens.

Core normal, phase0A, one-pass, shadow, 386 and scoped race suites pass. Memory,
pooling and real publication stop controls pass, with root races. Wide-value
regressions cover integer limits, overflow, rollback, reused IDs, reset, lineage
updates and independent shadow copies. Layout/API/R6 guards and all 65 workflow
selectors pass.

All 126 RSS processes pass, including six retained initial samples and twenty
alternating matched pairs per case, seeds 37001..37020. Candidate maximum is
297.879 bytes/source byte, below 400. Median candidate/baseline ratios are
0.928745 Go, 0.970580 ordinary YAML and 0.938866 owned YAML. These are memory
measurements; they do not establish a timing benefit.

## Measurement protocol

The timing screen uses the repository runner, GOMAXPROCS=1, count=1 per explicit
shuffle seed, 750ms and benchmem, normal pooling, serialized in pinned 6 GiB
Docker on CPU 6. YAML uses 36801..36820; Go 36901..36920. Six cases per language
include the standard Go trio, public query/grammargen files and fresh-parser
one-MiB Go. All 480 rows finish. All twelve timing differences are inconclusive and no
median exceeds the time/object ratchet. One-MiB Go bytes fall
579888608→528111072 (−8.93%, p<.001). Ordinary-YAML bytes fall
15608→14840 (−4.92%) and 51913→49097 (−5.42%), p<.001.
Large-Go allocation counts move 278→275, p=.105; other counts stay exact.
Full-Go bytes move 429374→429375; query bytes 8112→8113, both inconclusive.
No-edit stays zero bytes and allocations in every sample. Complete directions,
raw roles and benchstat output are unpacked alongside perf-summary.json.

archive-manifest.json authenticates five bundles containing complete source
manifests, replay inputs, raw correctness/RSS logs and Docker metadata. All
native Go hashes match the measured source. Layout, API, R6 and selectors pass.

## Replay

Start from a complete clean baseline module with its grammar/fixture assets.
Prepare fresh candidate and evidence directories:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

Mount those modules at `/reference:ro` and `/candidate:ro`, the output at
`/evidence`, and this receipt at `/receipt:ro`. Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, one CPU pinned to 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both
repository locks. Retain the locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/core-screen.sh
bash /evidence/guards.sh
bash /evidence/qualify.sh
bash /evidence/large-c.sh
python3 /evidence/audit-full.py
```

For RSS, remount prepared `rss/` at `/evidence` and the whole output at `/lab:ro`,
keeping source mounts. Run `bash /evidence/selectors.sh` under both locks. Restore
the full output at `/evidence` before timing:

```sh
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
```

Benchstat supplies the significance tests. Completion markers are produced by
the gates; preparation supplies none. No binary or raw binary profile is committed.

## Retained setup failures

The first sizing probe failed because Core StateID is 32-bit; its patch, pins and
failure remain under `layout-v1/` in the correctness archive. The revised layout
keeps that width and places precedence in flattened lineage fields.

A root reserve regression assumed fresh capacity must exceed one MiB. The
narrower records cross that floor. The test now checks against the actual reserve
plan and bounds incremental capacity by one quarter of that plan. It preserves
the reservation contract without requiring wasted bytes; the original failure
is retained under `qualification-initial/`.

The expanded C audit initially assumed all 300 cases used compact. The fresh
control demonstrates 90 compact / 210 fallback. The corrected audit requires
all 306 statuses and all 300 routes to equal the control, with the exact existing
39 failures. No runtime source changes separate these runs. The original audit
and traceback remain under `qualification-audit-initial/`.

The first native R6 attempt scanned historical hidden worktrees outside the
compiled source set. It is retained as native-unscoped-v1guard.log. The scoped
run checks the exact 3518-file source, whose hashes equal the integrated source,
and passes the unchanged 454 language-use / 101 environment-read baselines.
No hidden worktree is changed or removed.

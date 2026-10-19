# Fresh snapshot pages: rejected capacity trade

This five-file private proposal uses published runtime
`54863cf280722c720bda81c2a8480f2398255730` as its baseline. It contains neither
single-prefix ownership, native streaming nor the pending Go correctness repair.
The runtime remains unchanged.

`runtime.patch`, `runtime-pins.json` and the packed complete manifests authenticate
3514 baseline and 3516 candidate Go files. Two new internal files implement and
test immutable four-record pages; three root files bind their allocation and
memory accounting. `archive-manifest.json` authenticates four evidence archives.
No compiled binary or raw profile is committed.

The source passes the focused Core/386/race allocator tests, full Core tests,
authenticated stale-version/reset and page-accounting regressions, pinned canonical
Go work, Go/ordinary-YAML/explicit-owned-YAML 72-step sessions, memory contracts and
the existing YAML document/scanner-edit C suite. Six public full/edit census rows
remain exactly equal to the baseline. The allocation unit constructs 64 immutable
records in 16 allocations. It does not predict whole-parser speed or allocation.

Twenty alternating shuffled pairs finish per language: 440 rows, normal runner
pooling, GOMAXPROCS=1, count=1, 750ms and benchmem. YAML uses 36201..36220 and
Go 36301..36320. All public work/route metrics stay exact; no-edit remains zero
bytes/allocations. All timing differences are inconclusive.

Owned YAML R4 allocations fall 79→76 but bytes rise 13032→18392 (+41.13%).
The owned 8 KiB case falls 218→181 allocations with bytes 44952→47816 (+6.37%).
No time/object median exceeds the 10% ratchet; the byte cost still rejects this
layout. There is no full-fleet, general race, API/layout, paired RSS or graduation
qualification.

## Replay

Use a complete clean baseline module with the pinned grammar/fixture assets.
Prepare a fresh external candidate and output directory:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

Mount those directories at `/reference:ro`, `/candidate:ro` and `/evidence` in
the pinned Docker image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`.
Use Go 1.25.14, 6 GiB, one CPU pinned to 6, GOMEMLIMIT=5GiB and both repository
locks. Retain the pinned C build cache under
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/core-screen.sh
bash /evidence/screen.sh
python3 /receipt/analyze-counters.py /evidence
bash /evidence/perf.sh
python3 /evidence/analyze-perf.py
```

Mount this receipt directory at `/receipt:ro` for the counter analyzer; benchstat
supplies significance tests. The original source/probe hashes and failed setup
logs remain packed. Two early ownership-test attempts inspected references after
normal cleanup; the final test constructs an authenticated real scanner-state
snapshot directly. A subsequent test-only StateID cast fixes compilation. No
runtime change separates those attempts.

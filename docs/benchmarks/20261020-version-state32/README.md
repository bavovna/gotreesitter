# 32-byte version state

The final runtime starts at b876c5b5a4ce9569a47dbfdf6adc7cff139ebefb and changes
twelve files. The common wrapper becomes 32 bytes on amd64 and 20 on 386;
optional immutable recovery ownership moves into a shared full-width holder.
The visible-node baseline remains inline. The final public assembly adds the
five test-harness files described in the benchmark-order receipt. It has 3524
Go files and retains 756 root files.

The four archive hashes and all member hashes are in archive-manifest.json.
No test binary, completion state for a new run, or staged user work is supplied
by the replay helper. Source-and-protocol contains both native manifests, all
twelve exact runtime files, measured/public harness files and full manifests.
Qualification preserves complete raw outcomes, known failures and setup errors;
RSS preserves all six initial plus 120 matched processes. Matched-performance
contains every new 480-row result and the order audit. The older failed 480-row
screen and host-monitor exit 143 remain in the benchmark-order archive.

Use prepare-replay.py with a clean b876 source and a fresh output directory:

```sh
python3 prepare-replay.py --baseline /path/to/b876 --output /path/to/replay
python3 prepare-replay.py --baseline /path/to/b876 --output /path/to/replay --check
```

Mount prepared reference-source and candidate-source at /reference and /candidate,
and prepared evidence at /evidence. Run bash /evidence/smoke.sh and
python3 /evidence/audit-smoke.py, then bash /evidence/perf.sh after reviewing
the qualified counters. Use the recorded Go 1.25.14 image
sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Inputs are
pinned by their existing fixture digests. The prepared public-combined-source
reconstructs the final published code, and candidate-native reconstructs the
original fully qualified runtime without the new benchmark harness.

The earlier qualification container labels retain the historical word control;
source manifests and mounted paths identify the current-main composition.
The measured helper parses the seed inside its test-support package. The final
helper takes an explicit seed parsed by the existing root test file, avoiding
an R6 environment addition. The ordering implementation and timed workloads
are unchanged. Public helper and final composition checks retain separate logs.

This is a memory improvement. All twelve timing differences are inconclusive;
ordinary YAML still falls back and graduation remains open. The private graph,
action16, seed-group and Go correctness proposals are absent.

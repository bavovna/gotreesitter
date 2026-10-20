# Stable benchmark workload order

The archive preserves the original 480-row wrapper screen, including its failed
large-Go allocation ratchet, six exact-setup attribution processes, 48 initial
smoke rows, all fifteen runner regression checks and the final public helper's
normal/race/386, invalid-seed, smoke and native guard logs. No executable test
binary is included. The manifest authenticates every member and archive.

All twenty original Go pairs used different workload orders. Adding two root
tests changed Go's shared test/benchmark shuffle stream. The original YAML
parent emitted one fixed subbenchmark order across all twenty seeds. These
observations do not waive the original failure or establish a speed change.

The exact attribution mounts the original b876 baseline and original 32-byte
wrapper candidate at /reference and /candidate, with exact-attribution/ at
/evidence. Its run.sh retains the original three seeds and stock workload set.
Use the recorded native source manifests; adding the new suite benchmarks would
change that original experiment's registration list.

The new parent suites shuffle their named workloads from GTS_BENCHMARK_SEED,
independently of registered tests. The public support helper accepts an explicit
int64 seed; the existing root test file parses the setting before every child
timer. This preserves the ordering algorithm while adding no non-test
environment read. Workload labels use the Label field; the strict guard treated
the earlier Name field as language metadata. The initial failure is retained
and no guard or allowlist changes. Public smoke verifies the same order and large-Go bytes and
objects as the measured helper.

Run one language per process through scripts/run_randomized_benchmarks.sh:

```sh
GTS_ADMISSION_CANDIDATE=1 bash scripts/run_randomized_benchmarks.sh   --output /tmp/go-after.txt --baseline-root /path/to/baseline   --baseline-output /tmp/go-before.txt   --bench-regex '^BenchmarkCompactThroughputGo$' --runs 20
```

Use BenchmarkCompactThroughputYAML in a separate invocation for YAML. Supply
--require-benchmarks with the six exact names when producing qualification
receipts. The Go suite delegates the historical full/edit/no-edit trio and
large-file witness to their original functions, and adds the pinned query and
grammargen fixtures. YAML keeps legacy, ordinary and diagnostic-owned routes
separately named. The runner alternates roles, exports each seed, records the
actual workload order and stops with both outputs incomplete if orders differ.

Runtime sources and pinned inputs are unchanged by this measurement fix.
No work exception, route or graduation setting changes.

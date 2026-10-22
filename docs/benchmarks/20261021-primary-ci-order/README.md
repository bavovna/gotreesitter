# Primary Go CI ordering receipt, 2026-10-21

PR #1509's performance job stopped at seed 1 before comparing timing: Go shuffled the three benchmarks in different orders after one unit test was added. The existing paired runner correctly rejected the mismatch. The exact [CI failure](https://github.com/odvcencio/gotreesitter/actions/runs/39685988654/job/119520171870) and its decisive excerpt are retained.

The new `--primary-go-suite` mode calls the unchanged full-DFA, single-byte-edit-DFA and no-edit-DFA functions under one suite. That suite shuffles only its three cases using `GTS_BENCHMARK_SEED`; it does not depend on registered-test count. The runner restores the three canonical benchmark names after removing the exact wrapper prefix. All required metrics and workload-order validation remain mandatory.

Each revision receives a frozen test-only overlay of its existing `benchmark_test.go`: its original function bytes are preserved; only required imports and the shared suite are added. Checkouts remain untouched. Raw headers pin the shared suite and each revision's original/prepared source hashes. Existing import aliases are reused. The mode refuses another Go overlay, conflicting selectors/packages/required sets, an existing suite declaration, and a symlink anchor. Go 1.22 vet cannot open a wholly virtual added file, so the final design overlays an existing file and leaves vet enabled.

Validation passes:

- All existing lock, output, metric, failure and order contracts in `run_randomized_benchmarks_test.sh`.
- Five real-Go contract groups on Go 1.22.0 and again on Go 1.25.14, including different registered-test counts, quoted paths, original-file hashes, temporary cleanup, source/overlay preservation, missing workloads and genuine benchmark failures.
- Distinct `identity/op` values verify that every canonical name calls its original function. Missing metric sets and an actual `b.Fatal` remain fatal; neither partial campaign can report completion.
- Twenty real matched alternating pairs, seeds 1..20, 750 ms, count 1, benchmem, GOMAXPROCS=1, and no build tags, matching CI. All 60 rows per revision are complete and workload order matches in every pair. No crash or OOM occurred.

The real comparison reproduces the previously qualified D64-to-PR1509 runtime change: Go edit 159.9 to 144.6 us (-9.57%, p=.049); full and no-edit timing are inconclusive (both p=.862). It is validation of the harness and an existing candidate, not a new runtime optimization. Raw output is retained byte-for-byte in `base.txt.gz` and `head.txt.gz`, with benchstat alongside it. No threshold, benchgate rule, runtime source, grammar, allowlist, ledger baseline or memory setting changes in this tooling PR. The existing RSS/graduation issues remain open.

The production comparison and the final identity contracts pin their own inputs. One subsequent runner edit removed trailing whitespace only; its before/after hashes are in `format-only-followup.json`. The final contract run exercises that formatted runner and the stronger identity canary. Full runtime/C suites were already qualified for PR1509 and were not rerun for this tooling-only change.

Reproduce the protocol contracts in Docker with `bash scripts/run_randomized_benchmarks_test.sh` and `bash scripts/run_primary_go_suite_test.sh`, then select `--primary-go-suite` in `scripts/run_randomized_benchmarks.sh`. Use the pinned environment and mounts in `run-qualification.sh.txt`; the source inputs for the recorded comparison are the D64 baseline and PR1509's unchanged runtime snapshot. `manifest.json` pins all receipt files except itself.

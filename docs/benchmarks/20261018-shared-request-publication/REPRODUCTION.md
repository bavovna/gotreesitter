# Replay direct publication and rejected dispatch hypotheses

Use a fresh isolated checkout of qualified runtime
`6d5b0b07e44a8f4fd1ab66d3246a485fde303909` for each variant. The previous
ownership archive's `prepare.py` documents baseline verification against all
3,510 Go hashes. Do not apply experiment patches to the primary checkout.

The files below are diagnostic inputs, not production engine source.

| Variant | Driver patch | Probe | C test | Expected |
| --- | --- | --- | --- | --- |
| Paired publication | `publication-driver.patch` | `publication_probe.go.txt` | `paired_c_test.go.txt` | Both roles pass 19 cases. |
| C4 isolation | `corridor-driver.patch` | `corridor_probe.go.txt` | `corridor_c_test.go.txt` | Disabled-C4 stream admission fails. |
| No-action trace | `publication-driver.patch` | `phase_probe.go.txt` | `no_action_c_test.go.txt` | Diagnostic controls pass; late fallback is expected. |
| Empty-action retry | `zero-retry-driver.patch` | `phase_probe.go.txt` | `zero_retry_c_test.go.txt` | Three stream admission failures. |
| Selective activation | `publication-driver.patch` | `selective_probe.go.txt` | `selective_c_test.go.txt` | Three stream admission failures. |

Apply the chosen patch with `git apply`, copy the selected probe to an isolated
root `.go` file, and copy its C test under `cgo_harness/` as `_test.go`. Install
`no_action_observer.go.txt` as a root `.go` file for every variant except C4
isolation. No-action/selective trace uses `no_action_selective_c_test.go.txt`
with `selective_probe.go.txt`.

Run the corresponding named test with Docker and the image recorded in
`source-reference.json`, `gts_parsercorephase0,treesitter_c_parity`, count one,
`-v`, and a 12-minute test timeout. Use one language, 6 GiB, one CPU, CPU 6,
`GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`, `GOWORK=off`, `GOFLAGS=-p=1 -buildvcs=false`
and both repository locks. Expected admission failures are retained; do not
turn them into accepted baselines.

For counter reproduction, install `phase_counter_test.go.txt` as a root test
and the prior archive's `work_capture.go.txt` and `invariant_init_test.go.txt`.
Add `diagnosticSharedWorkRecord(s)` at entry to `publishTotals` before returning
the pooled runner. Run `TestActualSharedRequestPhaseCounters`; then run the
YAML `TestV1InvariantGateR4EditSession` separately with
`GTS_ACTUAL_SHARED_INVARIANT=1`, `GTS_ADMISSION_CANDIDATE=1`, and
`GTS_SHARED_ATOMIC_PUBLICATION=0` or `1`. The prior ledger adapter supplies the
two YAML rows when initialized with the selected shared producer.

For timing, use two isolated roots with the paired-publication driver and
probe. Install `publication_bench_test.go.txt` in both. Mount the before root
at `/baseline` and the direct-publication root at `/workspace`; the benchmark
uses those exact working directories to select `GTS_SHARED_ATOMIC_PUBLICATION`.
The helper records no observation slices during timing. Set
`GTS_ADMISSION_REAL_CORPUS_LANGS=yaml` and use the repository randomized runner
with the exact three benchmark names, twenty pairs, seed start 33901, 750ms,
count one, and benchmem. `publication-perf.sh` retains the original overlay
command; overlay input paths refer to the original private evidence directory.

All 120 rows, including the legacy control, remain in the archive. The
measurement JSON contains independently checked raw samples. The C test makes
three unique Go parses per fixture; a duplicate edited-fresh assertion is not
counted as an additional parse comparison. Arbitrary callback behavior,
races, fleets, memory/RSS, graduation and production performance remain
unqualified for this private producer.

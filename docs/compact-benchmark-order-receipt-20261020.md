# Benchmark order correction: 2026-10-20

The benchmark runner now rejects paired samples with different workload orders.
The compact Go and YAML suites shuffle named workloads from an explicit seed,
independently of Go's registered test list. YAML's six mode/fixture pairs now
change order between seeds as well.

The failure was concrete. The 32-byte wrapper's original large-Go medians moved
231→325 allocations (+40.69%), failing the ratchet. All twenty Go pairs ran
workloads in different orders after two candidate regression tests changed
Go's shared shuffle stream. In the exact stock setup, a cached medium core
produced 499,977,144 B / 207 objects; the tiny warmup produced 539,585,416 B /
408 objects. Six instrumented processes reproduce their original modes.
The original failed result is retained and is not waived.

Two corrected smoke seeds produce identical orders across revisions despite
those different test counts, with different orders between seeds. All 48 rows
complete. The large-Go observations match exactly within each seed:
539,585,416 B / 408 objects and 540,119,152 B / 331 objects. These are smoke
observations, not a timing comparison. Qualification uses separate twenty-pair
runs under the corrected protocol.

All fifteen runner regression checks pass, including rejection of complete
metrics in different orders, correct per-process seed propagation, incomplete
output retention and lock release. The public helper passes normal, race and
386 checks; invalid seeds fail explicitly. Public smoke retains the measured
ordering and large-Go allocations. Native layout/API and R6 guards pass.
No new non-test environment read or parser runtime behavior is introduced.

[Raw observations, source pins, manifest and reproduction details](benchmarks/20261020-benchmark-order/README.md).

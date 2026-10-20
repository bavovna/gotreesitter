# YAML CPU attribution

Runtime b876c5b5, with the explicit-seed harness at b54372b4. This is the shipped
64-byte-wrapper control, before the separate 32-byte wrapper. Three processes
profile the same pinned 8,012-byte YAML witness through diagnostic-owned,
ordinary and legacy modes, with route totals asserted. Normal pools and memory
profiling rate remain enabled. Each process uses a 3-second CPU profile,
GOMAXPROCS=1, count=1, benchmem and seed 39101. These are attribution samples,
not a before/after throughput comparison or a graduation certificate.

In owned mode, cumulative shares include generic reduction 25.84%, election
22.22%, scanner Scan 11.37%, and destination validation 5.68%. Shares overlap
and must not be added. Materialization accounts for 15.25%; duffcopy is 5.94%
flat. The next investigation should inspect shared reduction/election work and
repeated destination-contract validation before selecting an optimization.
Ordinary mode still spends most time in the legacy parser after its decline.

The archive contains all three profiles, complete top-30 flat/cumulative views,
raw results, source pins, scripts and route audit. The test binary is excluded.
The initial v2 job failed its prerequisite before profiling; its runner log and
initial source reference remain separate from the successful v3 run.

Rebuild from b54372b4 with the pinned Go 1.25.14 Docker image, CPU 6, 6 GiB,
GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Mount the source at
/public and fresh evidence at /evidence; profile-v3.sh records the original
public-check prerequisite at /previous. It runs one YAML mode per process.
This receipt changes no engine source, counter pin, owner exception or route.

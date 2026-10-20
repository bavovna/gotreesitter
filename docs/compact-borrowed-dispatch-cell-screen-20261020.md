# Borrowed dispatch cells: no measured throughput win

The private reduction-wrapper pointer prototype passes all 414 complete ledger
rows, four canonical tree/work vectors, 206 edit sessions, 618 C fixture checks,
unchanged strict/expanded C outcomes, memory/race/386 and API guards. Its source
preserves caller-owned snapshots and every owner/provenance check.

All **480 matched shuffled rows** complete. Every timing difference is
inconclusive; all six Go time medians rise by **1.00–3.13%**. All ratchets and
**126 RSS probes** pass, maximum **297.293 B/source byte**. Compiler diagnostics
show no cell heap escape, but the runtime change remains **held**.

Only the independent scheduler-size test repair is promoted: the old assertion
expected amd64 sizes on 386. Keep exact sizes 80/40/40/32 for 64-bit pointers
and 76/36/36/32 for 32-bit pointers. The exact test passes on amd64 and 386;
API/L0/R6 pass. No runtime record, memory budget, counter pin or route changes.

[All raw samples, failed controls, source pins and replay](benchmarks/20261020-borrowed-dispatch-cell/README.md).

# Direct election fill remains held

The compiler removes an election temporary and reduces its stack reservation **1,120→856 bytes**, but twenty matched randomized pairs per language show **no significant timing improvement across all twelve Go/YAML cases**. Heap results are unchanged. The experiment remains private; no runtime code, default, allowlist, budget or counter pin is promoted.

[Source, raw timing, correctness and RSS evidence](benchmarks/20261020-go-election-fill/README.md) retain 480 benchmark rows, twenty distinct matched orders per language, all 126 RSS probes, all 414 exact ledger rows, four exact canonical Go work vectors, 206 × 72 edit steps and 618 C fixtures. Known strict and expanded Go C failures remain unchanged. Every timing/allocation/RSS ratchet passes; a smaller stack frame alone does not establish a useful win.

A separately scoped storage census on the held YAML publication source identifies the next Go target: the full-width precedence array reserves **8 MiB**, although its first wide value occurs at **NodeID 873,785**. A dense suffix could remove the unused prefix while preserving full int64 arithmetic. The accompanying capacity census is not an RSS estimate or a performance claim for that proposed change.

Verification correction: the initial large-Go filter matched no helper, so its warning/PASS output was not a C check. The [supplement](benchmarks/20261020-go-election-fill/large-go-verification.tar.gz) records the repaired overlay and actual passing 1 MiB Go comparison, run after timing on unchanged source. All 618 language-specific C fixture subtests were separately verified by name. The updated audit rejects empty runs. No runtime promotion relies on this correction.

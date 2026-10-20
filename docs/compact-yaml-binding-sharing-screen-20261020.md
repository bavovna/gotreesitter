# YAML binding sharing: 2026-10-20

The shared-binding candidate passes correctness and safety gates but has no
supported YAML throughput improvement. It stays outside the runtime. Compiler
copy removal is not promoted as a speedup.

The public value scanner shrinks to one pointer: its immutable symbol mapping
is shared, its zero value keeps the default mapping, and per-parse state remains
in independent payloads. The generated Scan wrapper frame drops 560→56 bytes
and loses two copy calls. Existing concrete pointer bindings and public methods
remain intact. A cold binding allocation is added; warm YAML heap medians stay
exact. No root/core engine code changes.

| YAML workload | Time direction | p |
| --- | ---: | ---: |
| Legacy R4 | −1.51% | .445 |
| Legacy 8 KiB | −4.13% | .183 |
| Ordinary R4 | +0.004% | .989 |
| Ordinary 8 KiB | −5.70% | .192 |
| Owned R4 | +2.01% | .989 |
| Owned 8 KiB | −7.53% | .369 |

All six differences are inconclusive. The Go no-edit control rises **2.76%**
(p=.003), retaining zero heap allocation; no causal attribution is established.
Other Go timings are inconclusive. All **480 samples** complete with twenty
distinct matched workload orders per language; comparative ratchets pass.

All **414 complete ledger rows** and four canonical work/tree vectors remain
exact. YAML ordinary/owned **72-step** sessions, three C fixtures, strict R4,
large C witnesses, memory/pooling, parsing race, scanner race/386 and API/L0/R6
checks pass. Supplemental C behavior remains **417/723 passes**, the same 306
failures and exact public vectors. All **126 RSS processes** pass, including
initial probes; maximum candidate RSS is **301.800 B/source byte**.

[Source, raw outcomes, every direction and fresh-run replay](benchmarks/20261020-yaml-binding-sharing/README.md).
The baseline is the pinned f28 commit in [PR1488](https://github.com/odvcencio/gotreesitter/pull/1488).
The prepared identity-validity follow-up is a separate experiment. No runtime,
pin, owner exception, route, allowlist or graduation change accompanies this receipt.

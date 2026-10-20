# PR 1487: final comparison against main

Baseline: 88dc1d9c3ff15cc2b8b5c53864455fc3a24a9d34. Candidate:
bdc453188793e830ee45ca0bc6cb7e536c420e7c (runtime b876c5b5).

This checks the original PR as a whole under matched workload order. It excludes
the new 32-byte wrapper and all other private prototypes. Both roles share the
test-only suite/large-witness/counter helpers. Runtime Go source hashes are
pinned separately. All 414 complete work/reuse rows are byte-identical; no
counter exception or reset is needed for this comparison.

All 480 rows complete: YAML seeds 40201..40220, Go 40301..40320, twenty
alternating pairs per language, GOMAXPROCS=1, count=1, 750ms, benchmem, normal
pools and limits. Each pair emits the same six workload names in the same
order; orders vary between seeds. Every custom work/route metric is retained.
Every no-edit sample allocates zero bytes and objects. All 10% median ratchets
pass. Timing significance and all directional changes are in benchstat.

Large Go improves **914.596→860.425 ms (−5.92%, p=.001)** and
**829,614,984→539,585,416 B/op (−34.96%, p<.001)**. No-edit time moves
3.4875→3.2555 ns (−6.65%, p=.005), retaining zero allocations. Other timing
differences are inconclusive. Owned YAML's object reductions trade **+1.24% /
+2.74% allocated bytes** for **−33.94% / −43.15% objects**; both costs stay
visible and all memory/performance ratchets pass. Ordinary YAML allocated bytes
fall **11.46% / 13.33%** with unchanged object counts.

| Workload | Time direction | Allocated-byte direction | Object direction |
| --- | ---: | ---: | ---: |
| fresh_one_mib (go) | -5.92% | -34.96% | -4.76% |
| full_dfa (go) | -1.75% | -0.00% | +0.00% |
| grammargen_lr (go) | +1.78% | +0.00% | +0.00% |
| no_edit_dfa (go) | -6.65% | +0.00% | +0.00% |
| query_compile (go) | -1.32% | +0.00% | +0.00% |
| single_byte_edit_dfa (go) | -2.21% | +0.00% | +0.00% |
| eof8k_legacy (yaml) | -2.64% | +0.00% | +0.00% |
| eof8k_ordinary (yaml) | -1.14% | -13.33% | +0.00% |
| eof8k_owned (yaml) | -1.92% | +2.74% | -43.15% |
| r4_legacy (yaml) | -0.20% | +0.00% | +0.00% |
| r4_ordinary (yaml) | -4.86% | -11.46% | +0.00% |
| r4_owned (yaml) | +0.39% | +1.24% | -33.94% |

The manifest authenticates all source pins, raw counter outputs, raw process
results, helpers, order metadata and analysis. Test binaries are excluded.
This final timing audit supplements the existing whole-fleet correctness,
locked-C, memory and RSS receipts; it does not claim new C coverage or compact
graduation. The source manifests distinguish benchmark support code from the
unchanged parser revisions.

For a fresh replay, copy replay.sh and the input helper/overlay/audit files into
an empty evidence directory. Keep the archived raw out/ and perf/ directories
separate so the runner can create new outputs without overwriting evidence.
Install support/internal/benchorder and the support runner in fresh copies of
the two pinned native sources. Verify them against source-pins.json. Then run
replay.sh with the pinned native sources plus the recorded
test helper overlay and internal/benchorder support files, mounted at
/reference and /candidate. Use Go 1.25.14 and image
sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks.
The previous-screen prerequisite in run.sh records the original sequencing;
it is not a new-run completion marker supplied by this archive.

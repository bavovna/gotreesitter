# Trusted small-source qualification

The private V4 candidate removes the redundant fresh verification parse for clean edits whose actual default DFA producer, complete reads, source identity and dispatch schedule are authenticated. On the exact Cogno Go fixture, 20 matched pairs on an M1 Max under Docker linux/arm64 show plain insert API time falling **107.981→5.705 ms** and replace **95.971→5.697 ms** (both p<.001). This receipt changes no runtime, allowlist, ledger baseline or approval.

The candidate remains held. The selected ledger has **178 adverse guarded changes**, including **142 above 2%**; the complete-operation view has **158 event increases**. [Every changed selected field and adverse operation event](counter-changes.md) is listed. [R3](../../v1-design.md#r3-counter-ledger-changes) says: “Agents do not approve ledger exceptions.” No exception is approved here.

The [owner exception proposal](owner-exception-proposal.md) lists all 238 selected-field changes and all 1,457 complete-operation changes with exact old/new values and reasons. It remains proposed; this link records no approval.

## Measured scope

The source is 140,368 bytes, 1,760 functions, SHA-256 `5434575bb249338937331c3756e10dcec34237d107f523ea315996fb6de0ef8f`. Edits target byte 57, row 5, column 1, using the [October 21 downstream report](https://github.com/odvcencio/gotreesitter/issues/454#issuecomment-6311551850). The comparison is current D64 runtime against private V4, **not** v0.55.1 against v0.56.0. There is no independent native Windows timing in this receipt.

Every edited benchmark creates a native old tree outside its timed region, applies Tree.Edit under a separate timer, then times the public incremental API and both owned-handle releases. Copy is not substituted for the native producer. No-edit benchmarks retain one native old tree for the entire benchmark and release each returned handle. Both plain and profiled APIs run. All processes use one explicit seed, count=1, GOMAXPROCS=1, 750ms and benchmem; 20 matched pairs alternate revision order and preserve identical child order. No pool or parser budget override is applied.

| Public API workload | D64 median | V4 median | Result |
|---|---:|---:|---|
| Plain insert | 107.981 ms | 5.705 ms | −94.72%, p<.001 |
| Plain replace | 95.971 ms | 5.697 ms | −94.06%, p<.001 |
| Profiled insert | 99.209 ms | 6.512 ms | −93.44%, p<.001 |
| Profiled replace | 105.915 ms | 7.434 ms | −92.98%, p<.001 |
| Plain delete | 296.3 ms | 285.6 ms | inconclusive, p=.678 |
| Profiled delete | 296.2 ms | 289.2 ms | inconclusive, p=.925 |
| Fresh full parse | 83.14 ms | 88.66 ms | inconclusive, p=.738 |
| Plain no edit | 69.74 ns | 65.81 ns | inconclusive, p=.835 |
| Profiled no edit | 138.9 ns | 138.0 ns | inconclusive, p=.433 |

Plain insert allocated bytes fall 555.5 KiB→1,160 B and allocations 37→7. Plain replace falls 107.5 KiB→1,160 B and 34→7. Delete allocated bytes fall 5.94% and allocations fall 100→97 plain, 102→99 profiled. No edit remains zero bytes and zero allocations. See the raw output and full benchstat tables for every metric and directional change. Timing variability is large on this host; these results do not establish native Windows ratios or a delete-time win.

## Tree.Edit cost remains visible

Tree.Edit regresses: plain replace **416.1 µs→1.712 ms** (+311.50%), insert **2.306→3.478 ms** (+50.79%) and delete **2.204→3.232 ms** (+46.67%). All are significant in this sample. Profiled counterparts also rise; all six rows appear in `cogno-benchstat.txt`.

For context, adding each process's separately measured Tree.Edit and API averages gives descriptive medians **110.263→9.133 ms** for plain insert and **96.404→7.396 ms** for replace. These sums exclude old-tree setup and do not carry a new significance claim. They do not hide the Tree.Edit regression or replace its separate attribution.

The standard production Go trio has no significant time change. All six YAML workload/mode time differences are inconclusive. Ordinary YAML still falls back; only the explicit diagnostic-owned cases complete on compact. This is not YAML ownership activation or compact graduation.

## Correctness and counters

- 1,236 standard locked-C checks pass: 206 languages, two routes, three checks, with no skips or OOM.
- Eight exact Cogno insert/replace C cases pass across both routes and both APIs. The known reduced Go delete lexical-context mismatch with C remains preexisting and unfixed.
- 412 canonical invariant sessions pass 72 edits each (29,664 steps), including zero no-edit allocations. Twenty memory contracts pass. This is not a new large-file RSS qualification.
- The exact Djot/TOML corpus first edits pass the existing caller-route fresh/C regression. A private forced-legacy Djot reference retains its known false error; that raw diagnostic stays failed.
- Complete-operation attribution covers all 412 fixture/route rows. Full Parse+Release and separate Edit+Profiled API+owned releases include hidden verifiers/retries. Their phase and attempt partitions are exact. On the Cogno production insert/replace, attempts fall **2→1**, shifts **72,200→1,792**, reductions **75,729→1,803**. Delete remains **5→5**; four extra shifts and a 0.345% table-lookup increase remain recorded.
- The selected ledger retains 92 unavailable candidate full profiles as unchanged declines. No zeros are fabricated. All full selected profiles and all candidate selected profiles are unchanged. The proposed default first-edit changes are held for review.

## Historical state diagnostics

Six locked-C probes show identical incremental/fresh public trees with differing historical state IDs on non-extra nodes: Kconfig 6, Objective-C 18, FIDL 0, CSS 1, Java 1 and Regex 15. C's Regex root starts at byte 3 after the BOM. Exact historical numeric state equality and universal start-zero coverage are therefore stronger diagnostics than the observed C contract. The raw failures remain retained; public structure, fields, flags, error/stop/end-coverage and subsequent-edit invariants remain required.

The new complete-work capture retains 161 strict diagnostic failures. Its only cross-route public-shape difference is the already documented forced-legacy Djot error; the exact caller-route/C check passes. This receipt does not rename strict failures as passes or claim a repaired state-ID bug. The per-case C evidence and the unchanged invariant gate establish the distinction.

## Rejected YAML screens

Two independent screens retain their exact patches, source pins, correctness results, counters and 20-pair output:

- Shared scanner finish: 62 focused tests, 32 C cases, four Go/YAML invariant sessions and all 412 selected rows match. All six timing differences are inconclusive. No performance promotion follows. The private unread-scan controls fail on the old helper, but existing caller normalization already supplies the bound; that is not an established end-user correctness defect.
- Cached external rune: 63 focused tests, three actual 386 cache tests, 32 C cases, six YAML digests/work rows and all 412 selected rows match. The lexer remains 104 bytes native and 72 on 386. Legacy R4 YAML gets **5.50% slower** (p=.038); the other five timings are inconclusive. The prepared main-based successor stays unexecuted and unpromoted.

A separate main-based DFA probe-state experiment returns only the six coordinates already compared by primitive equivalence: 32 bytes native instead of the 240-byte Lexer value, 24 instead of 136 on 386. Its focused tests/counters pass, but its timing is still pending at this receipt's capture. No win or runtime promotion is claimed for it here.

## Reproduction

Use two clean checkouts of observed main `33584bd16d0569dc672e8508d800f637a6583f12`. Its runtime is D64. Apply `runtime-source.patch.gz` only to the candidate, then the matching baseline/candidate benchmark-harness patches. They modify three existing test files and retain the corrected no-edit/native-producer semantics. Apply `primary-wrapper.patch.gz` to both checkouts for identical seeded primary-trio ordering. The benchmark source manifests pin every curated build input; the pure runtime manifest pins all 3,542 candidate Go files, with 756 at root.

The repository randomized runner is preserved unchanged. The seed shim only forwards each explicit `-shuffle=N` into GTS_BENCHMARK_SEED, then executes the pinned Go tool. `run-paired-mac.sh.txt` gives all 60 paired seeds and required row sets. Adjust mount paths to the two checkouts and evidence directory; its overlay is a test-only copy of the same primary wrapper. Keep ordinary and diagnostic-owned YAML cases separate. Source files are mounted read-only; source and user-checkout hashes match before/after. The final archive SHA and each member are verified in `provenance.json`.

The raw benchmark outputs, unapplied patches, counter ledgers, complete-operation diffs, gate receipts and C state-contract reports are review evidence. None authorizes a ledger reset, removal of fresh verification for unproved producers, an allowlist change, or graduation.

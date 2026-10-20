# Ordinary YAML ownership, current layout, packed trial masks

Held experiment. Ordinary YAML completes on the compact candidate route and preserves the locked-C tree, but fails the relative RSS ratchet. No runtime changes, allowlist changes, or counter resets were promoted.

The source combines authenticated shared-prefix ownership transfer and streaming native publication with immutable 113-bit scanner trial masks. It uses the already-qualified prepared YAML scanner and 32-byte version state. It excludes the separately held Go correctness repair.

Qualification: 206 languages with 72 edit-session steps each and zero-allocation no-edit reparses; 618 C fixture checks; 204 strict C rows with only YAML changing from legacy fallback to compact while remaining C-exact; 50 public/whole-request YAML counter comparisons; four exact canonical Go work vectors and tree digests; unchanged 39 known expanded Go C failures; memory-budget, pooling, and scoped race gates. Candidate source pins cover 3,530 Go files.

Work improves: ordinary R4 public nodes 288→232 and whole-request tokens 124→107; ordinary 8 KiB nodes 1,156→925 and tokens 441→423. Diagnostic-owned R4 nodes 484→232. All other ordinary ledger rows are exact.

RSS: six initial probes plus 120 matched probes, all retained, seeds 42001–42020, normal pooling and GOMAXPROCS=1. Median candidate/baseline ratios: Go 1.013884; ordinary YAML 1.337192; diagnostic-owned YAML 0.908040. Every candidate stays below 400 bytes/source byte; ordinary YAML exceeds the 1.10 relative limit. See rss/rss-matched/audit.json. No before/after timing comparison was run for this rejected variant.

A separate allocation profile on the pinned 1 MiB ordinary YAML witness attributes 20.94 MiB to checkpoint interning, including 12.07 MiB of record-slice growth and 6.33 MiB of byte-slice growth. Native publication lookup-buffer growth allocates another 10.41 MiB. These are cumulative allocations, not retained bytes or causal RSS estimates. The subsequent paged-publication experiment is in a separate source tree and does not alter this evidence.

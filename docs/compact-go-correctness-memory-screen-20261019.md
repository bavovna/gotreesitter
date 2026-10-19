# Compact Go correctness and memory screen — 2026-10-19

This private candidate repairs all **39 failures** from the 300-case Go
locked-C screen and passes the six original witnesses: **306/306 clean cases
through compact, zero fallbacks**. It remains unpromoted. The qualified
runtime stays `5c463e567a3dec1d3f367f1a47ebaac03800a797`.

The final candidate fails the hard RSS ceiling at **404.16 B/source B** on
one Go probe. It is **not promoted**, and no counter exception is requested.
There are also 65 canonical counter increases and 12 decreases, all listed
below; no production pins are reset. All numerical fixture-ledger counters
remain exact, with one changed C diagnostic decline location.

## Candidate and correctness evidence

An ordinary shift cohort had omitted an already-shifted sibling from its live
frontier. The production control loses one of three histories; the repair
preserves all three. The candidate also follows C's pairwise version-slot
ordering once per elected token, reads the existing cached stack precedence,
and authenticates shared terminal origins against the actual DFA source,
owner and reset generation. Matching token values alone grant no authority.
The eight-link cap is unchanged. The qualified no-replay history guard is
included without changing its behavior.

All **206 × 72-step invariants** and **618 smoke-C checks** pass. All 24
generic edit sessions pass six steps each against fresh Go and locked C;
all **144 no-edit allocation checks** stay zero. The 204-file strict census
is unchanged: 120 compact passes, 39 legacy passes and 45 known legacy
failures. All four canonical deep digests are unchanged.

All numeric work/reuse fields in the 414-row ledger remain exact. One C
candidate row changes only its diagnostic decline location, retaining the
route and all counters. The complete canonical vectors retain every one
of the 77 changed fields, including category changes in link-union work.

Normal, phase0A, selected-store one-pass and 386 Core checks pass. Source and
context negatives, nested panic restoration, default/tagged root checks,
focused races, pooling, large Go C equality and YAML stream checks pass.
Original production-pinned lifecycle/benchmark checks still reject changed
work. One original memory test stops in that work-pinned fixture setup;
separate diagnostic tests preserve its budget assertions, source/deep-tree
pins and explicit private work vectors. No production pin is reset here.

## Memory repair and limits

The first combined candidate fails two Go RSS probes: **400.43 and 401.72
B/source B**, above 400. Every failed sample remains archived. A one-MiB Go
attribution probe finds identical complete graph/tree work, but the new
origin-receipt slice allocates **16.8 MB** while retaining 3.45 MB as it grows.

Paged receipt storage removes **13,651,080 allocated bytes** on that same
witness. Allocation falls **851,126,320 → 837,475,240 bytes**; retained Core
footprint falls **156,656,756 → 156,322,036**. These are diagnostic allocation
observations, not throughput measurements. Source/owner reset, missing-ID
rejection, page-boundary lookups and zero-allocation reuse remain checked.
All page and pointer-table capacity remains charged after reset.

The narrowed Go RSS screen passes all 42 probes, with maximum candidate
**384.25 B/source B** and median ratio **0.97693**. The complete repeated
qualification and three-case RSS gate use the final 15-file source.

The complete 126-probe run has candidate/baseline median ratios Go **1.07590**, ordinary YAML **1.00221**, and owned YAML **0.99459**. The Go median is **342.29 → 368.27 B/source B**, but one candidate reaches **404.16**, exceeding 400. All samples remain included; the median ratchet does not override the ceiling.

No production/candidate timing comparison ran after the failing work
directions. Earlier private closure/value timing does not transfer to this
candidate. No routing, allowlist, graduation or global-default change is
proposed. Ordinary YAML's ownership/cost blocker remains.

## Remaining gate

The allocation repair does not establish RSS safety. The complete run keeps
all 126 samples, including its failed Go sample. The preceding flat store's
two failed Go samples are also retained. No production/candidate timing
comparison or runtime promotion follows this rejected screen. The next
investigation needs to reduce the large-Go memory peak before an owner
counter-exception review is appropriate.

The [complete archive and replay guide](benchmarks/20261019-paged-dfa-origin-receipts/REPRODUCTION.md)
retain exact patches/hashes, complete vectors, failed samples, attribution
and final qualification. Production remains the qualified history guard.

| Fixture | Counter | Before | After | Direction |
| --- | --- | ---: | ---: | --- |
| `rewrite` | `CoreWork.EmittedPopPaths` | 1,635 | 1,636 | increase |
| `rewrite` | `CoreWork.EmittedPopPayloads` | 2,982 | 2,985 | increase |
| `rewrite` | `CoreWork.PredecessorLinkUnionAttempts` | 174 | 175 | increase |
| `rewrite` | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 4 | 29 | increase |
| `rewrite` | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 25 | 0 | decrease |
| `rewrite` | `CoreWork.PredecessorLinkUnionAlternateAppended` | 145 | 146 | increase |
| `rewrite` | `CoreWork.GraphLinkAdditionsProxy` | 2,995 | 2,971 | decrease |
| `rewrite` | `CoreWork.ParentConstructionsProxy` | 1,504 | 1,505 | increase |
| `rewrite` | `SchedulerWork.ActionLookups` | 3,540 | 3,539 | decrease |
| `rewrite` | `SchedulerWork.ConvergedReductionSplitDrops` | 164 | 165 | increase |
| `rewrite` | `SchedulerWork.NoActionDrops` | 166 | 167 | increase |
| `query_compile` | `CoreWork.Reductions` | 7,382 | 7,408 | increase |
| `query_compile` | `CoreWork.ReductionPopRequests` | 7,382 | 7,408 | increase |
| `query_compile` | `CoreWork.EmittedPopPaths` | 7,981 | 8,026 | increase |
| `query_compile` | `CoreWork.EmittedPopPayloads` | 14,603 | 14,686 | increase |
| `query_compile` | `CoreWork.PredecessorLinkUnionAttempts` | 722 | 750 | increase |
| `query_compile` | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 36 | 111 | increase |
| `query_compile` | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 75 | 0 | decrease |
| `query_compile` | `CoreWork.PredecessorLinkUnionAlternateAppended` | 611 | 639 | increase |
| `query_compile` | `CoreWork.GraphLinkAdditionsProxy` | 14,662 | 14,632 | decrease |
| `query_compile` | `CoreWork.ParentConstructionsProxy` | 7,415 | 7,460 | increase |
| `query_compile` | `SchedulerWork.Passes` | 12,874 | 12,913 | increase |
| `query_compile` | `SchedulerWork.ActionLookups` | 17,304 | 17,447 | increase |
| `query_compile` | `SchedulerWork.Dispatches` | 13,383 | 13,409 | increase |
| `query_compile` | `SchedulerWork.ConvergedReductionSplitDrops` | 664 | 683 | increase |
| `query_compile` | `SchedulerWork.Reductions` | 6,454 | 6,480 | increase |
| `query_compile` | `SchedulerWork.ReductionPauses` | 119 | 132 | increase |
| `query_compile` | `SchedulerWork.NoActionDrops` | 666 | 685 | increase |
| `query_compile` | `SchedulerWork.Canonicalizations` | 12,244 | 12,270 | increase |
| `language` | `CoreWork.Reductions` | 7,513 | 7,515 | increase |
| `language` | `CoreWork.ReductionPopRequests` | 7,513 | 7,515 | increase |
| `language` | `CoreWork.EmittedPopPaths` | 8,326 | 8,330 | increase |
| `language` | `CoreWork.EmittedPopPayloads` | 15,765 | 15,773 | increase |
| `language` | `CoreWork.PredecessorLinkUnionAttempts` | 1,036 | 1,039 | increase |
| `language` | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 18 | 226 | increase |
| `language` | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 207 | 0 | decrease |
| `language` | `CoreWork.PredecessorLinkUnionRecursiveChanged` | 1 | 0 | decrease |
| `language` | `CoreWork.PredecessorLinkUnionAlternateAppended` | 810 | 813 | increase |
| `language` | `CoreWork.GraphLinkAdditionsProxy` | 15,073 | 14,869 | decrease |
| `language` | `CoreWork.ParentConstructionsProxy` | 7,623 | 7,627 | increase |
| `language` | `SchedulerWork.Passes` | 12,803 | 12,806 | increase |
| `language` | `SchedulerWork.ActionLookups` | 18,623 | 18,346 | decrease |
| `language` | `SchedulerWork.Dispatches` | 13,408 | 13,410 | increase |
| `language` | `SchedulerWork.ConvergedReductionSplitDrops` | 633 | 635 | increase |
| `language` | `SchedulerWork.Reductions` | 6,629 | 6,631 | increase |
| `language` | `SchedulerWork.ReductionPauses` | 242 | 243 | increase |
| `language` | `SchedulerWork.NoActionDrops` | 636 | 638 | increase |
| `language` | `SchedulerWork.Canonicalizations` | 12,271 | 12,273 | increase |
| `grammargen_lr` | `CoreWork.Shifts` | 66,115 | 66,119 | increase |
| `grammargen_lr` | `CoreWork.Reductions` | 74,911 | 75,220 | increase |
| `grammargen_lr` | `CoreWork.ReductionPopRequests` | 74,911 | 75,220 | increase |
| `grammargen_lr` | `CoreWork.EmittedPopPaths` | 82,259 | 82,847 | increase |
| `grammargen_lr` | `CoreWork.EmittedPopPayloads` | 150,516 | 151,663 | increase |
| `grammargen_lr` | `CoreWork.PredecessorLinkUnionAttempts` | 9,137 | 9,454 | increase |
| `grammargen_lr` | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 325 | 1,685 | increase |
| `grammargen_lr` | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 1,376 | 18 | decrease |
| `grammargen_lr` | `CoreWork.PredecessorLinkUnionRecursiveChanged` | 1 | 0 | decrease |
| `grammargen_lr` | `CoreWork.PredecessorLinkUnionAlternateAppended` | 7,435 | 7,751 | increase |
| `grammargen_lr` | `CoreWork.GraphLinkAdditionsProxy` | 148,367 | 147,599 | decrease |
| `grammargen_lr` | `CoreWork.LeafConstructionsProxy` | 53,896 | 53,897 | increase |
| `grammargen_lr` | `CoreWork.ParentConstructionsProxy` | 75,769 | 76,345 | increase |
| `grammargen_lr` | `SchedulerWork.Passes` | 127,874 | 128,336 | increase |
| `grammargen_lr` | `SchedulerWork.ActionLookups` | 182,888 | 183,601 | increase |
| `grammargen_lr` | `SchedulerWork.Dispatches` | 132,872 | 133,184 | increase |
| `grammargen_lr` | `SchedulerWork.Conflicts` | 7,888 | 7,889 | increase |
| `grammargen_lr` | `SchedulerWork.ConflictActions` | 16,043 | 16,045 | increase |
| `grammargen_lr` | `SchedulerWork.Forks` | 8,155 | 8,156 | increase |
| `grammargen_lr` | `SchedulerWork.ConflictActionArmsAdmitted` | 16,043 | 16,045 | increase |
| `grammargen_lr` | `SchedulerWork.CausalConflictForks` | 8,155 | 8,156 | increase |
| `grammargen_lr` | `SchedulerWork.ConflictHeads` | 17,407 | 17,409 | increase |
| `grammargen_lr` | `SchedulerWork.ConvergedReductionSplitDrops` | 8,172 | 8,443 | increase |
| `grammargen_lr` | `SchedulerWork.Reductions` | 62,965 | 63,273 | increase |
| `grammargen_lr` | `SchedulerWork.OrdinaryShifts` | 61,496 | 61,499 | increase |
| `grammargen_lr` | `SchedulerWork.OrdinaryCohorts` | 10,862 | 10,863 | increase |
| `grammargen_lr` | `SchedulerWork.ReductionPauses` | 1,963 | 2,117 | increase |
| `grammargen_lr` | `SchedulerWork.NoActionDrops` | 8,172 | 8,443 | increase |
| `grammargen_lr` | `SchedulerWork.Canonicalizations` | 120,653 | 120,962 | increase |

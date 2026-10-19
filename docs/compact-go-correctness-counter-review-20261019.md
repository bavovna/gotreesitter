# Go correctness protocol: owner counter-exception review

**Status: owner approval required; runtime remains private.** The proposal fixes
all 39 expanded Go C failures on the current published runtime and now passes
the complete memory gate that rejected earlier versions. It introduces no root
API changes and no language-name rule. Official production/candidate timing and
promotion await R3 approval; no work pin has been reset.

Baseline runtime: `54863cf280722c720bda81c2a8480f2398255730`.
The exact 17-file proposal, source hashes, raw logs and controls are in the
[review archive](benchmarks/20261019-go-correctness-counter-review/README.md).
Final patch SHA-256: `76d179a5fb81dfdeb48b032c74a23b428da75855597d4b39720cc98559fe8e8d`.

## Correctness reason for the exception

C keeps a running per-stack dynamic-precedence value, applies physical version
ordering at token boundaries, and retains already-shifted sibling histories
when an ordinary cohort condenses. The old route can lose a history, recompute
the wrong precedence, and choose the wrong Go generic-call alternative. The
repair preserves those histories and C's order/precedence rules. Authenticated
DFA origin receipts stay bound to the actual source, fresh owner and reset
generation. Dispatch restoration preserves nested and panic behavior.

A fresh baseline control reproduces **261 PASS / 39 FAIL** in the 300-case
expanded corpus. The proposal passes **300/300**, plus six targeted cases,
through compact with no fallback; all **144 generic edit steps** match fresh
Go and C. Its complete one-MiB Go public tree also matches locked C.

The richer histories change 77 canonical Core/scheduler fields: **65 increase
and 12 decrease**. The largest percentage increases are duplicate-noop union
work (language **18→226**, rewrite **4→29**, grammargen_lr **325→1685**, query
**36→111**). Query reduction pauses rise **119→132 (+10.92%)**. These are actual
work directions, not relabeled telemetry; all are listed below. Canonical deep
tree digests remain identical. Owner approval is required even for increases
below the ledger's 2% failure tolerance.

The review asks approval for all 65 increases for this exact correctness repair,
with the 12 decreases and all other counters retained. Approval permits official
performance qualification; it does not waive memory, timing, correctness or
release/graduation gates. No statistical throughput claim is made.

## Qualification of the final source

- All **206 ordinary 72-step invariant sessions**, plus an explicitly activated
  owned-YAML session, pass. The owned wrapper proves compact=1/fallback=0 before
  the session; no-edit reparses allocate nothing.
- All **618 C smoke checks** pass. The 204-sample strict census is exactly
  **120 compact PASS / 39 legacy PASS / 45 existing legacy FAIL**. It is not an
  all-sample C certificate.
- All **414 numerical fixture work/reuse rows** are identical. One existing C
  decline diagnostic changes coordinates `(450,365)→(445,389)`; both report the
  same live-link cap **9>8**. No route changes in that ledger.
- Normal/phase0A/one-pass Core checks, amd64/386 regressions, root/Core races,
  pooling and publication memory/cancellation/timeout assertions pass. Original
  production-pinned lifecycle/budget tests still reject the changed work before
  those assertions; separately pinned diagnostic copies preserve the assertions.
- All **12 API tag sets**, 756-root-file layout, R6 language/environment guards
  and all 65 CI selectors pass. The first composition added two root methods;
  the final version moves the adapter interface into `internal/parsercorephase0`.
  Its full inline size remains charged. All **3521 candidate Go hashes** are sealed.

All **126 RSS processes** pass, including the six initial probes. Final candidate
Go maximum is **324.343 B/source byte**, below 400. Matched candidate/baseline
median ratios are Go **1.009375**, ordinary YAML
**1.001307**, owned YAML
**0.977019**; all remain below 1.10. Every initial and matched
sample is retained. The attribution probe reports **602,340,424 allocated bytes**
and **138,411,556 Core bytes**, versus the qualified baseline's 599,225,008 and
135,297,372, with complete large-Go work and tree-arena volume unchanged.
These are memory observations; timing has not been qualified across the failed
work direction.

The first fresh C-control attempt lacked its module-local cache and tried an
offline clone. That is a retained setup failure, not a parser result. The final
control explicitly uses the existing pinned C cache. Wrapper import/error-string
and host/container audit-path failures are retained in the local evidence; they
do not count as passing assertions or parser failures.

## Every changed canonical field

| Fixture | Counter | Before | After | Change |
| --- | --- | ---: | ---: | ---: |
| rewrite | `CoreWork.EmittedPopPaths` | 1635 | 1636 | +0.06% |
| rewrite | `CoreWork.EmittedPopPayloads` | 2982 | 2985 | +0.10% |
| rewrite | `CoreWork.PredecessorLinkUnionAttempts` | 174 | 175 | +0.57% |
| rewrite | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 4 | 29 | +625.00% |
| rewrite | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 25 | 0 | -100.00% |
| rewrite | `CoreWork.PredecessorLinkUnionAlternateAppended` | 145 | 146 | +0.69% |
| rewrite | `CoreWork.GraphLinkAdditionsProxy` | 2995 | 2971 | -0.80% |
| rewrite | `CoreWork.ParentConstructionsProxy` | 1504 | 1505 | +0.07% |
| rewrite | `SchedulerWork.ActionLookups` | 3540 | 3539 | -0.03% |
| rewrite | `SchedulerWork.ConvergedReductionSplitDrops` | 164 | 165 | +0.61% |
| rewrite | `SchedulerWork.NoActionDrops` | 166 | 167 | +0.60% |
| query_compile | `CoreWork.Reductions` | 7382 | 7408 | +0.35% |
| query_compile | `CoreWork.ReductionPopRequests` | 7382 | 7408 | +0.35% |
| query_compile | `CoreWork.EmittedPopPaths` | 7981 | 8026 | +0.56% |
| query_compile | `CoreWork.EmittedPopPayloads` | 14603 | 14686 | +0.57% |
| query_compile | `CoreWork.PredecessorLinkUnionAttempts` | 722 | 750 | +3.88% |
| query_compile | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 36 | 111 | +208.33% |
| query_compile | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 75 | 0 | -100.00% |
| query_compile | `CoreWork.PredecessorLinkUnionAlternateAppended` | 611 | 639 | +4.58% |
| query_compile | `CoreWork.GraphLinkAdditionsProxy` | 14662 | 14632 | -0.20% |
| query_compile | `CoreWork.ParentConstructionsProxy` | 7415 | 7460 | +0.61% |
| query_compile | `SchedulerWork.Passes` | 12874 | 12913 | +0.30% |
| query_compile | `SchedulerWork.ActionLookups` | 17304 | 17447 | +0.83% |
| query_compile | `SchedulerWork.Dispatches` | 13383 | 13409 | +0.19% |
| query_compile | `SchedulerWork.ConvergedReductionSplitDrops` | 664 | 683 | +2.86% |
| query_compile | `SchedulerWork.Reductions` | 6454 | 6480 | +0.40% |
| query_compile | `SchedulerWork.ReductionPauses` | 119 | 132 | +10.92% |
| query_compile | `SchedulerWork.NoActionDrops` | 666 | 685 | +2.85% |
| query_compile | `SchedulerWork.Canonicalizations` | 12244 | 12270 | +0.21% |
| language | `CoreWork.Reductions` | 7513 | 7515 | +0.03% |
| language | `CoreWork.ReductionPopRequests` | 7513 | 7515 | +0.03% |
| language | `CoreWork.EmittedPopPaths` | 8326 | 8330 | +0.05% |
| language | `CoreWork.EmittedPopPayloads` | 15765 | 15773 | +0.05% |
| language | `CoreWork.PredecessorLinkUnionAttempts` | 1036 | 1039 | +0.29% |
| language | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 18 | 226 | +1155.56% |
| language | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 207 | 0 | -100.00% |
| language | `CoreWork.PredecessorLinkUnionRecursiveChanged` | 1 | 0 | -100.00% |
| language | `CoreWork.PredecessorLinkUnionAlternateAppended` | 810 | 813 | +0.37% |
| language | `CoreWork.GraphLinkAdditionsProxy` | 15073 | 14869 | -1.35% |
| language | `CoreWork.ParentConstructionsProxy` | 7623 | 7627 | +0.05% |
| language | `SchedulerWork.Passes` | 12803 | 12806 | +0.02% |
| language | `SchedulerWork.ActionLookups` | 18623 | 18346 | -1.49% |
| language | `SchedulerWork.Dispatches` | 13408 | 13410 | +0.01% |
| language | `SchedulerWork.ConvergedReductionSplitDrops` | 633 | 635 | +0.32% |
| language | `SchedulerWork.Reductions` | 6629 | 6631 | +0.03% |
| language | `SchedulerWork.ReductionPauses` | 242 | 243 | +0.41% |
| language | `SchedulerWork.NoActionDrops` | 636 | 638 | +0.31% |
| language | `SchedulerWork.Canonicalizations` | 12271 | 12273 | +0.02% |
| grammargen_lr | `CoreWork.Shifts` | 66115 | 66119 | +0.01% |
| grammargen_lr | `CoreWork.Reductions` | 74911 | 75220 | +0.41% |
| grammargen_lr | `CoreWork.ReductionPopRequests` | 74911 | 75220 | +0.41% |
| grammargen_lr | `CoreWork.EmittedPopPaths` | 82259 | 82847 | +0.71% |
| grammargen_lr | `CoreWork.EmittedPopPayloads` | 150516 | 151663 | +0.76% |
| grammargen_lr | `CoreWork.PredecessorLinkUnionAttempts` | 9137 | 9454 | +3.47% |
| grammargen_lr | `CoreWork.PredecessorLinkUnionDuplicateNoop` | 325 | 1685 | +418.46% |
| grammargen_lr | `CoreWork.PredecessorLinkUnionPrecedenceReplaced` | 1376 | 18 | -98.69% |
| grammargen_lr | `CoreWork.PredecessorLinkUnionRecursiveChanged` | 1 | 0 | -100.00% |
| grammargen_lr | `CoreWork.PredecessorLinkUnionAlternateAppended` | 7435 | 7751 | +4.25% |
| grammargen_lr | `CoreWork.GraphLinkAdditionsProxy` | 148367 | 147599 | -0.52% |
| grammargen_lr | `CoreWork.LeafConstructionsProxy` | 53896 | 53897 | +0.00% |
| grammargen_lr | `CoreWork.ParentConstructionsProxy` | 75769 | 76345 | +0.76% |
| grammargen_lr | `SchedulerWork.Passes` | 127874 | 128336 | +0.36% |
| grammargen_lr | `SchedulerWork.ActionLookups` | 182888 | 183601 | +0.39% |
| grammargen_lr | `SchedulerWork.Dispatches` | 132872 | 133184 | +0.23% |
| grammargen_lr | `SchedulerWork.Conflicts` | 7888 | 7889 | +0.01% |
| grammargen_lr | `SchedulerWork.ConflictActions` | 16043 | 16045 | +0.01% |
| grammargen_lr | `SchedulerWork.Forks` | 8155 | 8156 | +0.01% |
| grammargen_lr | `SchedulerWork.ConflictActionArmsAdmitted` | 16043 | 16045 | +0.01% |
| grammargen_lr | `SchedulerWork.CausalConflictForks` | 8155 | 8156 | +0.01% |
| grammargen_lr | `SchedulerWork.ConflictHeads` | 17407 | 17409 | +0.01% |
| grammargen_lr | `SchedulerWork.ConvergedReductionSplitDrops` | 8172 | 8443 | +3.32% |
| grammargen_lr | `SchedulerWork.Reductions` | 62965 | 63273 | +0.49% |
| grammargen_lr | `SchedulerWork.OrdinaryShifts` | 61496 | 61499 | +0.00% |
| grammargen_lr | `SchedulerWork.OrdinaryCohorts` | 10862 | 10863 | +0.01% |
| grammargen_lr | `SchedulerWork.ReductionPauses` | 1963 | 2117 | +7.85% |
| grammargen_lr | `SchedulerWork.NoActionDrops` | 8172 | 8443 | +3.32% |
| grammargen_lr | `SchedulerWork.Canonicalizations` | 120653 | 120962 | +0.26% |


Ordinary YAML ownership/throughput and compact graduation remain open. This
proposal preserves the current routing and global default. The private source
is not merged or enabled while its counter direction remains unapproved.

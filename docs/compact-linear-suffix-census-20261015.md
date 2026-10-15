# Go linear-suffix feasibility and transition evidence

The current Go census identifies a larger architectural target than another
boundary-lookup cache: about one third of graph-state publications are not
required by the observed corridor exits or later checked node reads. This is
an **upper bound on a possible representation change**, not measured speed or
memory savings. No parser route or default changes, and all merges remain held.

Evidence date: 2026-10-15 UTC. Baseline:
`7b016214d6322540ffd52009ae5eb214ce8434ea`, whose production source remains
`c498e889ec2d86382a3a0baad58020d7df7145b3`.

## What the census retains

The observer tags new single-link graph states produced inside C4 regions,
excluding retained multi-pop reduction construction and historical-boundary
cases. At every region exit it retains every live head and current frontier
index entry, plus their complete predecessor closure. Reads through `Core.node`
outside the region also force retention and predecessor closure.

Four separately executed observed/unobserved parses preserve both scheduler
work vectors and all four pinned deep tree digests. Invalid references remain
zero. Source pins and terminal exit zero pass the audit in local evidence
`gotreesitter-evidence/20261015-linear-suffix-retention-census`.

| Go fixture | Actual graph states | Tagged new states | Tagged states retained at exits | Remaining candidates | Fraction of all graph states |
| --- | ---: | ---: | ---: | ---: | ---: |
| `rewrite` | 2,996 | 1,395 | 399 | 996 | 33.24% |
| `query_compile` | 14,663 | 7,127 | 1,745 | 5,382 | 36.70% |
| `language` | 15,074 | 6,852 | 1,424 | 5,428 | 36.01% |
| `grammargen_lr` | 148,368 | 66,853 | 17,607 | 49,246 | 33.19% |

Large Go executes 11,890 observed regions. Its 97,524 later reads of tagged
states require no additional states beyond the conservative exit closures.
The largest region produces 1,192 tagged states. None of these counts estimates
how much graph import, prefix metadata or stack storage a replacement needs.

Direct array reads are not exhaustively intercepted. A real implementation
must account for those reads, immutable-row authentication, frontier history,
multiple pop paths, recovery, checkpoint state, hooks, metadata and rollback.
The census supplies no ownership certificate and does not authorize deleting
the counted states from the existing arena.

## Private transition-layer prototype

The next prototype represents an ordinary vector suffix above a frozen GSS
prefix under a fresh scheduler owner. Its operations construct no graph nodes
or links. Borrowed pop plans carry a revision and classification phase; graph
growth, prefix node/lineage/checkpoint mutation, owner completion and reset
invalidate the relevant authority. Buffer and object footprints are explicit.

Sixty-one seeded fixture shapes compare vector pops and one reduction commit
with a separate GSS reference. They cover arities zero through 255, interstitial
and trailing extras, child order, byte spans, score/order folds, predecessor
facts and reattached extras. Abstract stack-link work remains equal. Additional
tests reject stale/foreign/checkpoint leases, prefix mutations, overflow,
invalid payloads and logical node-cap violations without partial frame/work
changes. Focused transition, full core and phase-zero-A suites pass in Docker.
An ambiguous-prefix case preserves both GSS paths, matches a local suffix pop,
and requests GSS handling when a pop crosses into the diamond.

The initial overflow fixture used a childless payload, whose aggregate
precedence the existing C-aligned core correctly ignores. Its failed assertion
is archived; the corrected fixture uses a nonempty parent. Earlier source
without prefix freezing has a separate receipt. Final source and tests are
pinned in `20261015-linear-suffix-stack-prototype`.

Buckley's first broad review ends incomplete and supplies no approval. Its
completed bounded comparison flags a conditional zero-end difference: GSS
uses the first forward structural child's end when the reverse peel leaves
the structural end at zero. A direct regression reproduces vector end 0 versus
GSS end 5 before the correction and passes after it. The source follow-up
establishes no remaining mismatch in that narrow change. Both completed reviews
are supplied-source comparisons, not independent execution or parser approval.
A missing container utility interrupts the first post-fix runner; that attempt
is excluded, and the portable runner completes all final gates.

At this checkpoint parent construction, frontier-history preservation, GSS
import/flush and parser dispatch integration are absent. The next receipt below
adds private parent construction; it supplies no whole-parser qualification.

## Parent construction against the actual scheduler

The continuation resolves the actual vector state's sole ordinary reduction
cell, production plan and predecessor goto. It rechecks owner, prefix, revision,
classification phase and ordinary context after table callbacks. Parent fields
and aliases use the existing remapper and raw-store seam; no graph predecessor
is invented. All frame precedence and logical capacity checks precede parent
publication, and arena caps fail before any store mutation. Session pressure
history survives temporary scratch reset.

The actual scheduler exposes a gap in the earlier hand-built reference:
migrated extras clear branch order. A focused witness fails before correction
and passes afterward. Both private vector reduction operations now follow that
rule; this is a prototype correction, not a production bug fix. The initial
test's link-order type error is archived separately and supplies no evidence.

Eighty seeded shapes and an empty-stack epsilon case compare actual parent
metadata, migrated extras, subsequent pops, head facts and parent/pop/abstract
link counters against `ReduceOutputs`. Fifteen callback, context, plan, goto,
arena-cap and overflow cases reject without publishing a parent, frames or work;
a reentrant goto callback invalidates the borrowed pop. Existing transition
tests and full core/phase-zero-A suites pass in Docker. Frozen sources and
terminal exits are in `20261015-linear-suffix-parent-prototype`.

The parent review's epsilon concern is contradicted by the original GSS
zero-child branch and an explicit actual-scheduler witness above two extras,
with distinct gotos per predecessor state. The witness passes without changing
epsilon behavior. Its mutable-pop concern produces failing keep/span/trailing
witnesses. Commit now treats the returned description as a lease, consumes
saved scalar facts and reads migrated extras from original frames. All six
description-mutation cases pass afterward, along with the state-specific goto
comparisons and full core/phase-zero-A suites. Borrowed child descriptions keep
the existing read-only scratch contract; this does not make arbitrary writes
within the trusted package safe.

Buckley's completed follow-up considers the lease finding addressed and
establishes no remaining epsilon mismatch in the supplied source. It does not
independently execute the witnesses or certify parser integration/performance.

The parent checkpoint remains outside the checkout and parser routing. The
next receipt adds private frontier preservation and graph flush. It supplies
no whole-parser qualification.

## Frontier preservation and atomic graph handoff

The continuation assigns publications typed virtual ordinals, separate from
graph `NodeID`s. Each journal record retains its predecessor. The current
frontier keeps complete state/byte/checkpoint/shifted keys, including popped
states that are no longer active frames. A duplicate virtual or existing graph
key requests GSS handling before a shift or parent publication. A changed
frontier expires the old key list; active frames and their predecessor closure
still retain any necessary older records.

Flush marks active references and every current virtual frontier entry, follows
their predecessor closure, and serializes retained records in DAG order through
the existing graph publication checks. It preserves every preexisting graph and
index entry. The existing core transaction restores graph/index/work after a
failed flush; successful flush closes the vector capability. Serialization adds
no abstract parse work: virtual stack-link work was already counted when the
operation occurred. Logical node/link caps still include every publication.

Scheduler owners are explicit per virtual head, rather than inferred from its
predecessor. Zero/conflicting owners and stale pop plans are rejected. Scanner
quiescence is frozen at entry; both recorded-checkpoint and quiescent modes are
covered. Unsupported recovery/conflict/certificate contexts and active reduction
scratch decline. Journal, reference, history, retention and remap buffers are
included in the private object's footprint; this is not a parser budget gate.

Forty seeded traces execute 65 operations each against actual GSS reductions.
Twenty use each scanner capability mode; 26 persist explicit scheduler owners.
Heads and **every current frontier entry** match reference derivations, scanner
facts and lineage records after flush. Parent payloads, parent constructions,
reductions, emitted pop paths/payloads and abstract stack-link counters match.
Six flush-failure cases
preserve logical graph/index/work state, including a late index-cap failure
after partial writes; repaired cases retry. A direct history witness retains
four graph states in the original frontier and three after expiry, with equal
abstract work. Ambiguous-prefix handoff preserves both branches.

Buckley identifies a missing active-batch guard. Its witness fails before the
correction and passes afterward; the completed bounded follow-up considers the
guard addressed and establishes no defect in that correction. Neither review
executes the tests or certifies the surrounding parser. Final focused tests,
full core and phase-zero-A suites pass in Docker with frozen source pins in
`20261015-linear-suffix-handoff-prototype`.

This checkpoint implements a private handoff layer outside the checkout.
The next receipt adds selected real-Go replay and deferred scalar/set header
persistence; certificate handling, recovery and parser dispatch remain open.
There is no whole-parser qualification or graduation claim.
It advances the implementation boundary of [E-A7](https://github.com/odvcencio/gotreesitter/issues/1319),
whose corpus-throughput exit requirement remains unproven. All merges stay held.

## Real Go replay and deferred header lineage

Four separate Go processes compare unobserved, profile-only and replay parses.
Each preserves the full native core and scheduler work vectors and its pinned
deep tree digest. The profile chooses the 24 largest graph-publication regions
plus fixed region ordinals. These are selected traces, not all-region coverage.
Detached graph/metadata snapshots prevent model appends from sharing live arena
backing. The replay imports the actual authenticated terminals and independently
builds reduction parents and stack state; it does not replace token production.

The owner-only model stops mainly on inherited lineage. Deferred header
persistence preserves the actual successful scheduler-call inputs, including
the dirty bit and original alternative sets, then applies the existing GSS
scalar/set helpers inside the graph-flush transaction. A populated overflowed
input can produce a zero-member node set with overflow/blended flags; recording
only that final node would lose the input needed to reproduce it. Focused
inline, spill, overflow and repeated-update cases compare against GSS. Logical
command caps, unresolved membership and malformed chains reject without a
partial publication. Certificate references remain unsupported.

| Go fixture | Selected regions | Owner-only replayed operations | Lineage replayed operations | Regions reaching their end | Prefix handoffs |
| --- | ---: | ---: | ---: | ---: | ---: |
| `rewrite` | 25 | 125 | 193 | 2 | 23 |
| `query_compile` | 28 | 80 | 176 | 2 | 26 |
| `language` | 27 | 415 | 457 | 4 | 23 |
| `grammargen_lr` | 70 | 107 | 795 | 36 | 34 |

All 150 selected regions start successfully. The lineage model replays 900
shifts and 721 reductions, up from 727 total operations with owners alone.
Heads and every current frontier entry match graph/link/scanner facts and
lineage membership; spill positions are compared by members in their separate
arenas. Full model core work matches native work at every checked handoff.
The model serializes 166 new graph states versus 1,695 native states **within
those matched prefixes**. This is not a whole-parse memory or speed saving:
the diagnostic also allocates snapshots and membership imports.

At this checkpoint 106 handoffs reach below the deferred suffix into its opaque
GSS prefix. The next receipt adds deterministic-prefix import; the observed
header-lineage stops are already eliminated here.

The broad Buckley report ends truncated and supplies no approval. Its partial
evidence motivates a pending-command witness that fails before correction.
Capture now queues only successful persistence calls; finish rejects native
errors and unconsumed commands. The adapter checks snapshot ownership against
the live node, and repeated-owner tests reject completed/reset sessions. A
completed bounded review confirms those corrections and finds an uncapped
waiting queue. Its before witness fails; the corrected queue stops diagnostic
qualification at the logical cap while returning the native result unchanged.
A completed guard-only follow-up confirms that correction; the source audit
finds one production capture append path, with queues initialized empty.
Review scopes and incomplete output are preserved with the raw evidence.

Final focused diagnostic/vector tests, full core and phase-zero-A suites use
the explicit detached-clone tag `gts_eof_recovery_shadow`; each Go fixture runs
separately. Evidence is `20261015-linear-suffix-real-go-trace` and
`20261015-linear-suffix-lineage-trace`, with frozen sources, archived attempts
and terminal exits. No prior fleet/race/budget/RSS/timing certificate transfers.
This code remains outside the checkout and parser routes. No allowlist,
default, throughput or graduation change follows; all merges remain held.

## Lazy deterministic-prefix import

The continuation imports only the existing single-link frames needed to
complete a pop. It validates the complete required chain before changing the
representation. Original graph IDs, checkpoints, owner/lineage, score/order,
path counts and recorded precedence maxima remain intact. A stored single-link
maximum can include an earlier fold, so import does not recompute it from the
link. Imported frames consume neither new-publication work nor new node/link
budget; flush reuses their existing graph identities.

Deferred publications retain fixed graph predecessors. Moving the opaque base
therefore cannot reinterpret older frontier history, and no existing journal
entry acquires a forward virtual predecessor. Imported snapshots are checked
before operations and flush. Validation reads bounded raw links without an
adjacency allocation; a 12-origin check measures zero allocations. It still
scans the origins, so this is no throughput estimate.

| Go fixture | Selected regions | Previous replay operations | Imported-prefix operations | Regions reaching their end | Handoffs | Imported original frames |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `rewrite` | 25 | 193 | 866 | 23 | 2 | 308 |
| `query_compile` | 28 | 176 | 1,650 | 25 | 3 | 404 |
| `language` | 27 | 457 | 2,469 | 21 | 6 | 316 |
| `grammargen_lr` | 70 | 795 | 4,393 | 60 | 10 | 403 |

All 150 selected regions start. Completion rises 44→129; replay rises
1,621→9,378 operations (4,663 shifts and 4,715 reductions). All native work
vectors/pinned trees and model work/frontier semantics remain exact. The 21
handoffs now distinguish **16 canonical-boundary collisions and five ambiguous
prefixes**. Import totals 1,431 original frames, with a region peak of 37.
The model adds 958 graph states versus 9,664 native states within the matched
prefixes. Existing graph storage, diagnostic snapshots and membership imports
remain present; these counts are not whole-parse memory or timing savings.

Thirty-two seeded prefix shapes cover all available arities, extras, both
checkpoint modes and origin-only flush preserving IDs/work. Focused tests
cover base movement with older history, folded maxima, exhausted budgets,
partial/capped imports, revision limits and node/link/lineage/checkpoint
mutation. Original-node metadata changes roll back and retry.

Buckley finds that the loop rejects ERROR-state nodes, but initially accepts
a zero-cost ERROR-state final predecessor. A real recovery-discontinuity
witness fails before correction and passes after the guard; its bounded
follow-up confirms that guard. The metadata rollback test then exposes an
over-strict private snapshot check: core rollback restores logical membership
but can leave bytes in unused inline capacity. Detailed evidence confirms
owner, flags, counts, graph and work were restored. Before witnesses reject a
legitimate retry and unused-tail change. The corrected comparison preserves
all header fields and recorded inline members; active-member mutation still
rejects, and rollback/retry passes. Spilled membership relies on the core's
append-only arena contract. A completed bounded comparison covers this fix;
no shared-core rollback change or bug is claimed.

Final focused/import/diagnostic tests, full core and phase-zero-A suites plus
four separately executed Go trace checks pass with frozen pins in
`20261015-linear-suffix-prefix-import`. Reviews inspect supplied source only.
Runtime dispatch, terminal production, certificate/recovery handling and
memory integration remain open. There is no whole-parser C, incremental,
fleet, race, RSS or shuffled-timing qualification, no route/default change,
and no graduation claim. All merges remain held.

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

This remains a transition layer outside the checkout. Parent construction,
frontier-history preservation, GSS import/flush and parser dispatch integration
are not implemented. There is no whole-parser C, invariant, race, memory-budget,
RSS or throughput qualification, and no graduation claim.

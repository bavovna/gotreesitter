# Compact layout and dispatch screens

Evidence date: 2026-10-15 UTC. Each independent comparison starts at
`c498e889ec2d86382a3a0baad58020d7df7145b3`. All five prototypes remain outside
the checkout. None improves compact throughput enough to promote. All merges
to main remain held.

| Independent experiment | Go query time | Large Go time | Owned YAML R4 time | Owned YAML 8 KiB stream time | Decision |
| --- | ---: | ---: | ---: | ---: | --- |
| Pack two lineage booleans into flags; retain dense records | −0.20%, p=.242 | −0.84%, p=.121 | −0.12%, p=.398 | +0.67%, p=.040 | Reject: no demonstrated compact speed gain |
| Reuse an exactly equal immutable lexer-state wrapper | Not claimed | Not claimed | +0.84%, p=.030 | +0.81%, p=.011 | Reject: actual allocation counts do not fall |
| Select the first pure reduction through compiled cohort rows | +1.67%, p<.001 | +1.67%, p<.001 | +0.92%, p=.063 | +0.37%, p=.547 | Reject: both canonical Go files slow down |
| Inspect built-in rows directly; authenticate the selected reduction normally | −0.16%, p=.583 | −0.05%, p=.620 | −0.32%, p=.425 | −0.29%, p=.301 | Reject: no established throughput gain |
| Check existing policy rejection guards before token projection | −0.22%, p=.461 | −0.99%, p=.076 | +0.24%, p=.547 | −0.05%, p=.640 | Reject: no established compact throughput gain |

Negative time means less parse time. Inconclusive directions are retained in
the table, not presented as wins. These percentages have independent paired
baselines and must not be added to earlier improvements.

## What the screens establish

Packing flags reduces each dense lineage record from 32 to 28 bytes without
an interner or loss of metadata. The retained record width falls 12.5%, but
the measured compact benchmarks do not establish a throughput improvement.
All compact allocation-count and byte medians stay equal. Default full and
no-edit controls move −3.57% and −1.06% (both p<.001); the edit control moves
−0.25% (p=.433). Those controls bypass this compact representation, so their
directions are not attributed to the packing change.

Exact wrapper reuse preserves every comparable field and copies on any change.
A focused regression fails on the baseline and proves zero allocations for an
equal publication in the prototype; changed values preserve old aliases and
retained acceptance state. The public YAML allocation medians nevertheless
remain 109 and 336 objects, with the same byte medians. The existing equivalent
state installation already handles the common public path. After completing
all 20 affected YAML pairs, the remaining Go timing was deliberately stopped;
partial Go samples establish nothing.

The compiled cohort reads only ordinary unary shift/reduce rows, selects the
same first reduction as generic dispatch, and rejects recovery, contextual
relex, owned scanning, conflicts and other mixed policies. It authenticates the
selected boundary and uses the existing corridor reducer. The extra preflight
does not pay for itself: query time rises 9.66190→9.82312 ms and large Go rises
102.511→104.226 ms. Go R4 moves +0.45% (p=.142). Object counts stay equal;
query bytes round 138,738→138,739, while large Go stays at 3,251,728 bytes.
The default trio moves +0.11%, +0.04%, −0.48%, all inconclusive; no-edit remains
zero bytes and objects.

The direct-row follow-up avoids compiled sparse dispatch and does not use the
corridor-trusted reducer or caller-supplied classified rows. A current scheduler
owner can borrow the table provider, and only the concrete built-in adapter is
eligible for speculative inspection; arbitrary callbacks stay on the original
path. Ordinary `ClassifyBoundary` authenticates the selected row. This removes
the earlier significant regression but establishes no gain on either canonical
Go fixture. Go R4 moves −0.48% (p=.301); default full/edit/no-edit move
+0.08% / +0.28% / −0.71% (p=.799/.512/.060). Object counts remain equal. The
full-DFA byte median rounds 1,159→1,160; compact byte medians remain equal.

The policy follow-up moves the callee's existing nil-language, empty-policy and
unary-row rejection guards before token construction in shared and owned
dispatch. It adds no cache, capability or state layout. All 414 rows remain exact,
but the completed screen establishes no compact speed gain. Go R4 moves −0.16%
(p=.698). Default full/edit/no-edit controls move +0.12% / +0.96% / −1.79%
(p=.529/.001/<.001). The controls bypass this policy path; their directions are
recorded without attributing them to the guard. Object medians stay equal;
full-DFA bytes round 1,159→1,159.5, and all compact byte medians stay equal.
The source-only Buckley review finds no concrete defect in the supplied diff
and cannot independently verify the calibration receipts or qualification.
Its lack of findings does not override the performance result.

## Verification and limits

Every experiment passes full core and phase-zero-A tests, focused Go/YAML root
checks, Go/YAML/CMake/HTML/Python edit invariants, the diagnostic-owned YAML
invariant, and focused locked-C comparisons before timing. All **414 ledger
rows** are exactly equal: 412 ordinary and two diagnostic-owned YAML rows.
Default and opt-in C4 checks pass. The layout screen rechecks the 206 static
table shapes; the cohort screen reuses the unchanged compiler's pinned static
receipt rather than claiming a fresh fleet shape run.

Comparisons use the repository randomized runner, 20 alternating shuffled pairs,
one process per seed, `GOMAXPROCS=1`, `-count=1`, 750 ms and `-benchmem`, serialized
under both locks in 6 GiB Docker on CPU 6. Source pins and timed route/node
metrics pass the completed layout and cohort audits. Wrapper reuse has 20
completed YAML pairs and a separate pinned rejection receipt, not a completed
Go audit. Local evidence directories are `20261015-packed-lineage-flags`,
`20261015-version-state-reuse`, and `20261015-pure-reduction-cohort` under
`gotreesitter-evidence`; the direct follow-up is `20261015-direct-reduction-cohort`.
The policy follow-up is `20261015-conflict-policy-preflight`; both roles share
the identical test-only diagnostic receipt refresh. The runtime guard is not
promoted, and the test repair receives no performance claim.

The cohort run was interrupted for disk pressure after completing YAML. Its
partial Go samples were discarded and all 20 Go pairs restarted from seed 1
after serialized cleanup of old rebuildable Docker cache. Completed source,
fixtures, raw evidence and CPU profiles were preserved. This interruption is
not a parser failure or an out-of-memory result.

No full 206-session invariant fleet, 618-fixture C fleet, strict census, race,
memory-budget or large-file RSS qualification transfers to these rejected
prototypes. Runtime, admission allowlists and global defaults remain unchanged.

## Censuses that rule out broad caches

A separate read-only census compares complete parent records and ordered child,
field and alias arrays with the existing reduction-identity predicate. It finds
only 749 exact duplicate parents among 129,665 large-Go compact subtrees
(0.58%; 0.99% of parents), and none among the 187 / 751 parents in the ordinary
YAML R4 / four-document prototype. Go query has 21 duplicates among 12,961
subtrees. This gives no ownership, replay or reuse certificate and does not
justify a global subtree interner. All four Go deep digests and both YAML
public differentials pass, with unchanged observed work and frozen source.

A boundary-index census excludes internal rehash lookups. Large Go makes
287,787 logical probes; only 31,715 (11.02%) hit the first published key of a
frontier. YAML makes 337 / 1,341 probes, with 38 / 149 first-key hits (11.28% /
11.11%). The 50,609 empty Go probes equal its first publications, so making
only empty lookups lazy would still need the insertion hash. These counts do
not establish a worthwhile first-entry cache. The initial observer incorrectly
asserted table completeness during partial rehash and is archived as invalid;
the corrected run passes all named digest/work checks and source pins.

These diagnostics live in `20261015-exact-subtree-duplicate-census` and
`20261015-boundary-first-entry-census`. Neither changes the runtime or supplies
a timing, C-fleet or graduation certificate.

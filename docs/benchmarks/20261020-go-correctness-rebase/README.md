# Go correctness repair on the current compact layout, 2026-10-20

This receipt requalifies the held repair on the 32-byte version-state runtime
f28a3c1cfca394fa378bf5994fead01c3886e73b, equivalent to main 2769aea23 for all
runtime and benchmark sources. Its 13 changed Go files preserve the current
24-byte node layout, precedence sidecars and closed acceptance-group identity.
The borrowed-cell and prepared YAML experiments are excluded.

The protocol authenticates actual elected internal-DFA terminals in one fresh
owner, preserves C's stored per-version precedence and keeps already-shifted
siblings during ordinary canonicalization. Actual source, input, scope and
owner checks remain. The rebased precedence getter uses the current full-width
accessor after the original node validation. An internal generic adapter with
a stable caller-owned context and method expression removes two accidental
root API additions without callback closures or per-dispatch allocation.
Source and adapter clear at owner exit, and inline adapter storage is charged.
The failed first API control and its repaired source are retained separately.

Identical C probe source hashes and all 306 case names are checked against f28.
The candidate passes **306/306**, repairing the **39 baseline failures**. All
300 expanded cases route compact, versus baseline 90 compact / 210 fallback.
All **24 six-step edit sessions** pass incremental=fresh=C and their no-edit
allocation assertions. Root provenance/context negatives, nested panic cleanup,
zero-allocation dispatch helper and three-history sibling regression pass.

The new source passes **206 × 72-step sessions**, explicit owned YAML and
**618 C fixture checks**. All 204 strict rows remain exact: 159 pass and the
same 45 legacy failures. The one-MiB Go C tree and ordinary/owned YAML streams
pass. Core normal/one-pass, focused 386, API (12 tag sets), R6, root race,
private diagnostic budget/lifecycle and pooling checks pass. This is the recorded
component scope; the full v1 graduation/performance matrix is not complete.

All **414 numeric ledger rows** and four canonical deep trees remain exact.
One C candidate decline diagnostic changes, without numeric or route changes.
The **77 complete canonical work changes** exactly match the prior review:
**65 increases and 12 decreases**. The original production-pinned lifecycle
still fails at its work guard. Private diagnostic budget/lifecycle tests retain
the original source/tree pins and budget assertions with distinct explicit work
vectors; they do not replace or waive the production guard. No pins or exclusions
change. Work-direction gate: **FAIL**. R3 owner exception: **pending**.

All **126 RSS probes** pass, including all six initial samples. Candidate maximum
is **307.125 B/source byte**, below 400. Candidate/baseline medians are Go
**1.022674** (+2.27%), ordinary YAML **.996559** (−.34%) and owned YAML
**1.001214** (+.12%), each below 1.10. These are memory safety observations,
not throughput evidence. **No timing comparison ran** after the rejected work
counters. No runtime code, route, allowlist or graduation change is promoted.

[Every old/new work field](all-counter-changes.md), source-rebase.json and
qualification-status.json distinguish the held source from production. Three
archives and every member hash/size are pinned in archive-manifest.json. Binaries
and observed completion markers are excluded. Qualification retains all language
logs, raw C comparisons, unchanged production-pin rejection and failed API control.
RSS retains all 126 initial/matched probes (41901–41920).

For replay, check out clean f28, verify reference-source-pins.json from protocol,
and copy it for candidate. Replace only the 13 candidate-files and verify all
3527 candidate Go hashes. Extract protocol to a fresh evidence root. Mount source
read-only at /candidate and evidence writable at /evidence. Use image
sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6GiB, CPU6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Use
screen.sh, counters.sh, then qualify.sh. Compare complete canonical vectors and
all ledger fields with the archived baseline; expect the documented D10 rejection.
For RSS mount f28 at /reference, candidate at /candidate, the evidence root at
/lab and rss at /evidence; run bash /evidence/run.sh. No performance runner is
included or authorized by this receipt. Approval has not been inferred from
correctness results or the memory gate.

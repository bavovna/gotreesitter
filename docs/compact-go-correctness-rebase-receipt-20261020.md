# Current-layout Go correctness review

The private 13-file repair now passes **306/306 identical C witnesses**, fixing
all **39 failures** on f28. All 300 expanded cases use compact, versus baseline
90 compact and 210 fallback. All 24 six-step edit sessions pass incremental=fresh=C.

On current 24-byte nodes and 32-byte version state, it also passes **206 × 72-step**
sessions, **618 C fixtures**, unchanged 204 strict rows (159 pass / 45 known legacy
failures), large C witnesses, root race, focused 386, API/R6, pooling and diagnostic
budget/lifecycle checks. The adapter now lives behind the internal API boundary.

All **126 RSS probes** pass, maximum **307.125 B/source byte**. Median Go RSS
rises **2.27%**, ordinary YAML falls **.34%** and owned YAML rises **.12%**.
All **414 numeric ledger rows** and four canonical trees stay exact. The work
review is unchanged: **65 increases / 12 decreases**, all 77 values exactly
matching the prior proposal. The original production guard still rejects them.

**R3 approval remains pending.** No production pins, runtime code, routes,
allowlists or graduation settings change, and no timing comparison ran.

[Every counter, raw gate, source pin and replay](benchmarks/20261020-go-correctness-rebase/README.md).

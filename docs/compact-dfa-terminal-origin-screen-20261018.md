# DFA terminal origin screen — 2026-10-18

A private source proof removes the **9 > 8 live-link failure** from three Go
witnesses while keeping the cap at eight. Those witnesses still decline at
tied acceptance, and their public results remain C-exact through fallback.
Extending the proof to copies of one actual elected read makes the runner
finish all six witnesses, but **five public results disagree with locked C**.
That selection variant is rejected. No runtime is promoted.

Production stays `b17ca367a85d419514554e88f4477a339fd3ecba`; evidence starts
from `b08c7904b75c5f866297d130e694119840b4c671`. The
[source reference](benchmarks/20261018-dfa-terminal-identity/source-reference.json),
[variant summary](benchmarks/20261018-dfa-terminal-identity/summary.json) and
[replay notes](benchmarks/20261018-dfa-terminal-identity/REPRODUCTION.md)
retain exact patches, source hashes and complete logs. All 3,512 production
Go files remain unchanged.

## Proof boundary

The prototype binds one adapter source before any payload exists, under one
fresh owner and reset generation. The adapter checks the actual lexer,
language, input identity, complete elected/dispatch token, internal-DFA flag,
read frontier and skipped-prefix provenance. It excludes owned request
substitutions, synthetic/missing tokens and error-mode lexing.

Go uses a stateless ASI scanner, so requiring a nil scanner never activates
the proof. The corrected binding uses the repository's existing proven
quiescence capability. This adds no language-name comparison. External
terminals retain their complete scanner-checkpoint validation.

The first active variants certify only identical terminal IDs. The final
variant records a sparse **payload ID / actual election ID** receipt. Distinct
payloads can share an origin only within that one authenticated read; matching
token values or lexer modes do not grant equality. Different origins still
retain alternatives. Scalar leaf, skipped-prefix, parent geometry, production,
precedence, predecessor and same-reduction-batch checks remain in place.

Receipt capacities are included in the prototype's footprint calculation,
and the source/receipts clear on session exit, reset, failure and panic. This
is implementation coverage, **not memory qualification**. The new storage and
hot-path cost have not passed performance or RSS gates.

## Observed results

| Variant | Runner outcome on five generic witnesses | Public locked C |
| --- | --- | --- |
| Nil-scanner-only eligibility | Two tied-acceptance declines; three cap failures | 6/6 pass through existing routes |
| Proven quiescence, identical IDs, pressure only | All five reach tied-acceptance decline; no cap failures | 6/6 pass through existing routes |
| Same proof with earlier clean selection | Same acceptance blocker | 6/6 pass through existing routes |
| Authenticated actual-election origins across IDs | All five finish without errors and cover the input | **5/6 fail; ordinary-call control passes** |

The six cases are a single identifier generic call, a qualified generic call,
both in one function, reversed order, separate functions and ordinary calls.
Observed/unobserved runner errors, successful trees and committed work match
within each variant. This is not a before/after work-ratchet comparison.

The failing variant selects `call_expression(index_expression)` for
`F[int](x)` and `p.G[T](x)`. Locked C and the unchanged legacy route select
`type_conversion_expression(generic_type)`. The combined and separate-function
cases reproduce the same wrong choice. Error-free completion and input
coverage therefore do not establish correctness.

The focused Core tests retain the existing rejection of unproven DFA/mixed
histories. New tests cover source/owner scope, foreign and transactional owners,
late/repeated binding, generic publication, reset, failure and panic. The root
source probe rejects **19 changed-origin or unsupported-context cases**. A
separate focused unit checks equal actual origins across distinct payloads,
different origins and scalar mismatches. Its exact run is retained because
the original focused selector did not match that new test name.

## What the oracle narrows

The one-witness trace records both compared Core links at **effective
precedence 1**. Its first decisive raw-tree comparison favors a call with
**two children** over a call with **three children**; a later comparison
prefers the call over conversion by raw symbol.

| Symbol | Runtime ID | Locked-C ID |
| --- | ---: | ---: |
| `call_expression` | 173 | 171 |
| `index_expression` | 178 | 176 |
| `type_conversion_expression` | 181 | 179 |
| `generic_type` | 122 | 120 |

These symbols keep the same relative order, so simple symbol renumbering
cannot fix the observed call/conversion preference. The loaded Go artifact
also reports **structural-election certification false**. Lexical ownership
does not supply that independent selection authority.

The C logger records the competing index, type-instantiation, conversion and
call reductions. The legacy reference agrees with C. The
[oracle log](benchmarks/20261018-dfa-terminal-identity/oracle-attribution/gate-logs.json)
retains the raw comparisons and source data. It does **not** yet prove the
complete precedence/version-ranking cause. The next investigation must compare
that full decision with production, including its temporary-parent and
shape-aware selection; this screen does not authorize a raw-tree shortcut.

A subsequent, separate run instruments the **unchanged legacy result selector**
with the experimental origin protocol disabled. It resolves a result comparison
at aggregate dynamic precedence **−3 versus 1** and returns the C-exact conversion.
The [legacy trace](benchmarks/20261018-dfa-terminal-identity/legacy-selection/oracle.log.txt)
retains that decision, exact source pins and its passing oracle check.

The legacy result comparison and Core's earlier local fold are different
scopes. Their values do not yet prove a miscount. The next decisive check is
to compute the aggregate precedence of each compact payload at the same fold
and compare the surviving derivations with production. No such fix, cache or
new qualification is claimed here.

## Qualification limits

The three earlier variants pass focused Core/root checks and all six public
C witnesses. The actual-election variant fails five C witnesses; the oracle
attribution run preserves the same single-witness failure. No failure is
relabeled as a pass. The separately scoped origin unit passes.

The counter harness was prepared but **not launched** after rejection.
There are no randomized benchmarks, 414-row ratchet results, full Core/race/
386 sweeps, broad invariants, strict corpus census or RSS qualification for
this prototype. Routing, allowlists, ordinary YAML fallback and graduation
remain unchanged. Existing production qualification is the separate
[scanner-coallocation receipt](compact-scanner-record-coallocation-receipt-20261018.md).

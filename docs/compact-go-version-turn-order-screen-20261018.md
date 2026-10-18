# Go version-turn ordering screen — 2026-10-18

A private C-style version-ordering prototype repairs **27 of 39 newly exposed
locked-C failures** in a 300-case Go screen, with no new failures in that
screen. It still fails 12 cases and is **not promoted**. Production remains
`b17ca367a85d419514554e88f4477a339fd3ecba`; all 3,512 Go files are unchanged.
There is no throughput claim or graduation change.

The [summary](benchmarks/20261018-go-version-turn-screen/summary.json),
[source reference](benchmarks/20261018-go-version-turn-screen/source-reference.json)
and [replay instructions](benchmarks/20261018-go-version-turn-screen/REPRODUCTION.md)
retain exact patches, hashes, full logs and expected failing exits. Every
archived patch was reconstructed in external storage and checked against its
source hashes. The replay helper also passed a source/hash preparation check.

## Correctness results

The expanded screen combines two callee forms, ten type-argument forms, five
argument lists and three statement contexts. All 300 inputs are accepted by
locked C. Checks compare symbols, fields, spans, points, flags and deep digests.

| Runtime or private variant | C-exact cases | Compact / fallback |
| --- | ---: | ---: |
| Unchanged runtime control | 261/300 | 90 / 210 |
| One priority promotion per token turn, incumbent retention | 252/300 | 300 / 0 |
| Same ordering, union at publication | 252/300 | 300 / 0 |
| C pairwise version-slot permutation, publication union | **288/300** | 300 / 0 |

Of the unchanged runtime's 39 failures, **27 use fallback and 12 use compact**.
The best prototype fixes those 27 fallback failures. Its 12 failures are the
same 12 already present on compact; the set comparison finds no new failure.
These are bounded correctness and admission observations, not qualified work
counters or throughput evidence.

On the six original generic-call witnesses, the once-per-token and subsequent
variants pass C parity through compact with zero fallbacks. This includes
combined calls, reversed order and separate functions, which previously hit
the eight-link cap. The cap remains eight. That smaller screen alone would
have missed the failures above.

All seven selected existing Go suites pass on the expanded prototypes:
certification, incremental execution, repeated same-width edits, three nested
reuse suites and recovery version turns. This coverage does not replace the
full invariant and C corpus gates.

## The architectural distinction

The first per-payload observer verifies the compact link scores **1 versus 1**
by summing local dynamic precedence over every subtree occurrence. Its reads
leave the complete Core work vector unchanged. The legacy accepted alternatives
are different: a type-instantiation call at **−3** and a conversion at **1**.
There is no demonstrated precedence miscount in that earlier local fold, so a
precedence cache or propagation repair would target the wrong cause.

The clean legacy merge trace shows four versions after the closing parenthesis.
After the closing brace, at Go state 469 / byte 36, two same-score versions
merge into the conversion receiver. Only conversion and the lower-scoring
instantiation call reach final selection. Compact instead retains alternatives
and can choose the wrong family during a later reduction.

Keeping the first compact payload alone still fails five of the six original
witnesses. Re-ranking after every reduction also fails those five: it interrupts
a version's reduction chain when its score changes. Choosing priority once
per elected token fixes the six, but fails 48 of the expanded cases.

The C source's condensation loop compares each version with **every earlier
physical slot**, swapping on a preference for the later version. Merely moving
one best version to slot zero does not reproduce that permutation. Applying
that pairwise ordering once per token turn, together with the authenticated
publication union, reduces the expanded failures from **48 to 12**. This
supports a version-turn implementation as the next architectural direction;
it does not certify the prototype's complete scheduling or merge policy.

The prototype retains the prior fresh-owner DFA-origin proof. Matching token
values alone cannot authorize a union. It checks actual elected origins,
terminal histories, scanner transitions, shallow geometry and the common
predecessor. The new ranking code enumerates paths and allocates diagnostic
storage. It is deliberately unsuitable as a production hot path.

## Remaining qualified-type failures

All 12 remaining cases use a qualified type argument such as `F[p.T](x,y)` or
`F[p.T]()`, across both callee forms and all three statement contexts.

The narrowed oracle forces legacy and confirms a C-exact explicit-type-argument
call. Legacy compares aggregate precedence **1, −2 and 2**, keeping the call at
2. Compact publishes the index-call form. An unchanged-policy compact observer
reproduces the failure and records the complete header/path and classified-cell
sequence; the observed conflict executions use no policy-selected override.

The next investigation must preserve the explicit-type-argument call path
through these shared boundaries before treating the parse as uniquely accepted.
The evidence does not yet establish the exact loss point or authorize a local
symbol, arity or language-name shortcut. The failing witnesses remain visible.

## Qualification limits

No runtime code, routing, allowlist or graduation flag changes. The
[qualified scanner-coallocation runtime](compact-scanner-record-coallocation-receipt-20261018.md)
remains the production reference. No before/after deterministic ratchet,
randomized timing, generic-call edit-session invariants, full Core, race, 386,
fleet census or RSS qualification ran for these new prototypes. Existing Go
incremental checks passed, but they do not prove the new generic cases.

Two compile preflights failed before parser tests and are archived separately.
An earlier Docker bridge allocation failed before tests; the private isolated
runner uses `--network none` with cached dependencies. The repository runner
is unchanged. Recorded test containers report no OOM or wall timeout. Failed
C checks and build exits are retained as failures.

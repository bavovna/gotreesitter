# Go generic-call frontier attribution — 2026-10-18

A read-only trace narrows a Go compact-route blocker to reconverged DFA
histories. Three two-generic-call witnesses reach **nine links against the
unchanged cap of eight**. Every link has the same graph predecessor and
matching terminal values, but the leaves form four distinct identity groups.
Matching values alone do not prove shared lexical ownership.

Baseline: `6d5b0b07e44a8f4fd1ab66d3246a485fde303909`. This was an untimed
attribution run before scanner-record coallocation. It changes no production
runtime, selection rule, ownership check, work counter or limit. The
[source pins](benchmarks/20261018-go-generic-call-frontier/source-reference.json),
[trace](benchmarks/20261018-go-generic-call-frontier/trace.json) and
[replay notes](benchmarks/20261018-go-generic-call-frontier/REPRODUCTION.md)
retain the complete evidence.

| Witness | Public candidate route | Frontier evidence |
| --- | --- | --- |
| `F[int](x)` | Legacy fallback, tied-acceptance equality unproven | Four same-batch pairs; identical leaf IDs, selector disabled |
| `p.G[T](x)` | Same fallback | Four same-batch pairs; identical leaf IDs, selector disabled |
| Both calls in one function | Legacy fallback | 9 > 8 at state 229, byte 49; one same-batch pair, selector enabled |
| Calls in reverse order | Legacy fallback | Same cap, state and byte; one same-batch pair, selector enabled |
| Calls in separate functions | Legacy fallback | 9 > 8 at state 8, byte 65; six same-batch pairs, selector enabled for three |
| Ordinary `F(x); p.G(x)` | Compact, no fallback | No cap or same-batch comparison |

All **six public-route witnesses match locked C structurally**. For combined
and reversed calls, the cap's exact leaf-ID groups contain **4 / 2 / 2 / 1**
links; separate functions have the same grouping sizes. Every group shares
the same terminal values. This does not authorize folding across groups.

The existing reduction selector requires complete authenticated external-
scanner history and rejects DFA or mixed histories, including equal leaf
IDs. Pressure activation alone cannot solve these witnesses: the selector
is already enabled at relevant comparisons. The next proof must establish
shared stateless-DFA origin with the required owner/source/reset binding;
raising the link cap or accepting value equality would skip that proof.
No such new proof or compact activation is claimed here.

Each witness runs with and without the election observer. Cap records,
same-batch records and normalized errors/trees are exact across modes.
Cap records include full Core work, and the observer asserts its reads leave
that vector unchanged. The root probe compares complete committed work on
successful executions; failed executions are compared by error and the
recorded frontier. The public locked-C probe independently records routing
and fallback reasons. No throughput comparison, corpus-wide gain or
language graduation is established.

# Preserve closed acceptance-group identity

The qualified three-file repair keeps immutable version interning and lexer
ownership from losing the identity used by the final recovery election.
A version can retain its acceptance group after its live recovery and missing
keys clear. The old interning predicate omitted that group and could adopt a
sibling's wrapper; ownership equality could also treat distinct groups as equal.

Interning now matches the group the existing publisher would keep. Owner
equality preserves the effective group while retaining active-key fallback
equivalence. Equal groups remain shareable. No identity width, recovery policy,
route, counter pin, owner exception or graduation setting changes.
The [complete source and replay evidence](benchmarks/20261019-acceptance-group-identity/README.md)
compare against runtime `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
All 3518 published Go source hashes match the qualified candidate exactly.
The pending Go 65-counter repair and native action layout are not included.

## Correctness and counters

Both new regressions fail on the baseline. They pass with the repair normally,
under race detection and on 386, covering recovery-only, missing-only, combined
and empty groups, immutable siblings and equivalent active-key fallback.
These prove internal identity preservation; the corpus does not establish a
reduction in public C mismatches from this change.

All **414 complete ledger rows** and four complete canonical trees/work vectors
match. Representative counters before→after:

| Counter | Before → after |
| --- | ---: |
| Go R4 full nodes / tokens | 1251→1251 / 589→589 |
| Go first-edit reused bytes / splices | 1784→1784 / 266→266 |
| Ordinary YAML full / first-edit nodes | 288→288 / 480→480 |
| Owned YAML full / first-edit nodes | 484→484 / 484→484 |
| One-MiB Go constructions / tokens | 903086→903086 / 425742→425742 |

All **206 ordinary 72-step sessions**, explicit owned YAML and **618 C checks**
pass; every invariant no-edit reparse allocates nothing. The strict census
remains **120 compact passes / 39 legacy passes / 45 known failures**.
All **306 expanded/targeted Go C outcomes and 300 routes** match the fresh
control, including its same 39 expanded failures. Large Go locked-C deep
identity/work and large YAML document/scanner/edit checks pass. Core modes,
scoped races, memory/pooling/publication controls, layout/API/R6 and 65 workflow
selectors pass.

The additional malformed-YAML corpus checks 241 inputs over three fresh routes:
**417/723 checks pass on both revisions**, with the same 306 failures and exact
public vectors. The first run used a clean-tree helper that rejects error nodes
before comparison; all its artifacts remain. The corrected run uses exact
error-tree comparison and explicit root HasError equality. No engine source
changed between runs. The remaining mismatches stay open correctness work.

## Twenty shuffled pairs

YAML seeds **38301..38320**, Go **38401..38420**; GOMAXPROCS=1, count=1 per seed,
750ms, benchmem and normal pooling, serialized in 6 GiB Docker on CPU 6.
All 480 rows complete with exact work/route metrics. All twelve timing
differences are inconclusive; **no speedup is claimed**. Every object median
is unchanged and every time/object median passes its ratchet. Times are ns/op.

| Case | Time before → after | Direction | p | B/op before → after | Objects before → after |
| --- | ---: | ---: | ---: | ---: | ---: |
| GoParseCompactFreshOneMiB | 1,065,908,223→1,062,001,835.5 | -0.37% | 0.925 | 539,585,416→539,585,416 | 325→325 |
| GoParseFullDFA | 10,948,031→11,226,937.5 | +2.55% | 0.947 | 429,372.5→429,373.5 | 37→37 |
| GoParseIncrementalNoEditDFA | 4.1→4.1 | -0.90% | 0.841 | 0→0 | 0→0 |
| GoParseIncrementalSingleByteEditDFA | 134,338.5→135,626.5 | +0.96% | 0.779 | 402.5→402 | 5→5 |
| StreamedPrefixGo/grammargen_lr | 129,237,773→138,130,785.5 | +6.88% | 0.529 | 1,155,600→1,155,600 | 1,706→1,706 |
| StreamedPrefixGo/query_compile | 12,782,516→13,163,004.5 | +2.98% | 0.989 | 8,112→8,112.5 | 121→121 |
| StreamedPrefixYAML/eof8k_legacy | 865,177→886,789.5 | +2.50% | 0.947 | 1,264→1,264 | 13→13 |
| StreamedPrefixYAML/eof8k_ordinary | 968,768.5→1,041,627 | +7.52% | 0.620 | 49,097→49,097 | 34→34 |
| StreamedPrefixYAML/eof8k_owned | 2,291,227.5→2,242,059 | -2.15% | 0.841 | 45,528→45,528 | 191→191 |
| StreamedPrefixYAML/r4_legacy | 238,525.5→240,311 | +0.75% | 0.718 | 1,440→1,440 | 16→16 |
| StreamedPrefixYAML/r4_ordinary | 344,990.5→338,736 | -1.81% | 0.820 | 14,840→14,840 | 37→37 |
| StreamedPrefixYAML/r4_owned | 585,893→630,918.5 | +7.68% | 0.779 | 13,032→13,032 | 72→72 |

Every no-edit sample has zero bytes and allocations. Raw samples and benchstat
retain all directions, including Go grammargen +6.88%, owned YAML R4 +7.68%
and ordinary YAML 8 KiB +7.52%; none is a demonstrated slowdown.
All 126 RSS processes pass, including six initial probes. Maximum candidate
RSS is **297.914 bytes/source byte**; median ratios are **1.000020 Go /
0.997723 ordinary YAML / 0.998291 owned YAML**, within 1.10. RSS uses seeds
38501..38520. These gates qualify the identity repair; they do not graduate a
language or close the Go/YAML throughput gaps.

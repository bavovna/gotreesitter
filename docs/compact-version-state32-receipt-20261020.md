# Compact version-state storage: 2026-10-20

The common immutable version wrapper shrinks **64→32 bytes** on amd64
(**20 bytes** on 386). Rare region/recovery/missing/acceptance ownership moves
to an optional shared immutable holder. Full identity widths, rollback and
closed-group equality remain intact; the visible-node baseline stays inline
because clean Go uses it too. Footprint accounting charges each shared holder
once. The hot header remains 80 bytes on amd64 and 76 on 386.

Against b876c5b5, all **414 complete ledger rows** and four canonical deep trees
and work vectors stay exact. All **206 × 72-step** ordinary invariant sessions,
explicitly activated owned YAML, **618 C fixture checks**, scoped races, Core
modes, amd64/386, memory/pooling/publication controls and layout/API/R6 checks
pass. Strict real-corpus results remain **120 compact / 39 legacy passes /
45 known failures**. Expanded Go retains the same **39 known failures** across
306 checked cases; the private correctness proposal is absent. The complete
one-MiB Go tree remains C-exact with 903,086 constructions and 425,742 tokens.
The final public assembly passes separate focused amd64/386 and native guards.
An existing size test assumed amd64 on 386; the untouched baseline reproduces
that 76-versus-80 assertion failure. The final test pins each actual layout.
No parser runtime change or budget relaxation accompanies this test correction.
No work pin or owner exception changes.

The original screen failed the large-Go allocation ratchet. Its twenty Go
pairs ran in different workload orders after two regression tests changed the
Go shuffle stream. Its 480 rows and failure remain recorded. The
[benchmark-order correction](compact-benchmark-order-receipt-20261020.md)
establishes an explicit workload seed and rejects mismatched paired orders;
it does not waive the failure. The following fresh comparison uses that
corrected protocol with twenty distinct, matched orders per language.

| Workload | Median allocated bytes before→after | Direction |
| --- | ---: | ---: |
| Go query_compile | 8,112→4,496 | −44.58% |
| Go grammargen_lr | 1,155,600→1,105,392 | −4.34% |
| Owned YAML R4 | 13,032→11,848 | −9.09% |
| Owned YAML EOF 8 KiB | 45,529→41,048 | −9.84% |
| Large Go | 539,300,408→539,300,408 | unchanged |

All four material byte reductions have p<.001. Every allocation-count median
is exact, including **260→260** for large Go. Every no-edit sample allocates
zero bytes and objects. All **480 rows** complete, with YAML seeds
40001..40020 and Go 40101..40120, alternating roles, GOMAXPROCS=1, count=1,
750ms and benchmem. Normal pools and limits remain enabled. All twelve timing
differences are inconclusive. Directions range from ordinary YAML R4 −6.90%
(p=.174) to legacy YAML R4 +6.36% (p=.211); no throughput improvement is claimed.
All comparative 10% ratchets pass, and every direction is retained in benchstat.

All **126 RSS processes** pass, including initial probes. Matched median ratios
are Go **1.000572**, ordinary YAML **0.972219**, owned YAML **0.968588**. The
candidate Go maximum, including initial probes, is **319.230 B/source byte**,
below 400 (matched-sample maximum **301.707**). Supplemental YAML
error checking retains **417/723 passes and the same 306 failures** on each
revision, with no changed public vector; it is not an all-input C certificate.
Ordinary YAML ownership, Go throughput and compact graduation remain open.

[Raw gates, all samples, source pins and replay instructions](benchmarks/20261020-version-state32/README.md).

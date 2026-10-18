# Reproduce DFA terminal origin screens

Production runtime stays `b17ca367a85d419514554e88f4477a339fd3ecba`.
Use that commit, or evidence head
`b08c7904b75c5f866297d130e694119840b4c671`, at `/workspace`. Copy this
receipt directory into a fresh writable external directory mounted at
`/evidence`. Do not apply these experimental patches to a user checkout.

Use the image and resource limits in `source-reference.json`: Go 1.25.14,
CPU 6, one CPU, 6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`. Acquire both the
common and Nightwatch locks. Each Docker launch and its actual exit status
is retained in `harness.json`. No comparison timing was run.

Run `python3 /evidence/prepare-replay.py <variant>` once in a fresh evidence
copy. It checks all 3,512 baseline Go files, copies only changed files into
external storage, applies the zero-context patch with `--unidiff-zero`, and
checks every variant hash before creating the overlay.

For the first four variants, run `bash /evidence/check.sh`. The first three
pass their focused gates and all six public C witnesses. `actual-election`
finishes all six runner probes but **fails five public C witnesses** and
exits 1. Preserve that failure. Its Core test selector did not match the
new `TestFreshDFATerminalOriginSameElectionDifferentPayloads`; the separate
`origin-unit.log` records that test passing on the final instrumented source.
To repeat that focused unit, use the same overlay and run inside Docker:

```
GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json' \
  go test ./internal/parsercorephase0 \
  -run '^TestFreshDFATerminalOriginSameElectionDifferentPayloads$' -count=1 -v
```

For `oracle-attribution`, run `bash /evidence/oracle.sh`. Its independent C
symbol/logger and legacy-reference probe passes; its one candidate C witness
still fails, so the container exits 1. The complete log retains effective
precedence and raw-child comparisons. C symbol names come from the locked
loaded grammar, not an inferred mapping.

Every variant's complete correctness logs and original source hashes are in
its subdirectory. Shared root/C probes are in `probes/`. Source hashes use
their original pre-archival names; the replay helper resolves those names.
The final variant's source retains the prototype's earlier ID-only comments;
its implemented election-origin method is the tested behavior. No production
claim should be inferred from a stale experimental comment.

`counter-gates.sh` was prepared but **not launched** after the C rejection.
Its extra diagnostic helpers/overlay are not supplied here as a qualification
workflow. No counter ratchet, broad invariant gate, full Core suite, race/386,
RSS gate, randomized timing, routing change or graduation is claimed for this
prototype. Existing production checks and receipts remain separate.


The later `legacy-selection/` probe uses **baseline runtime only** plus two
instrumented legacy files. In another fresh external evidence copy, run
`python3 /evidence/legacy-selection/prepare-replay.py`, then
`bash /evidence/legacy-selection/run.sh` inside the same pinned Docker setup.
Do not run the experimental variant preparation in that copy. The independent
legacy/C check passes; its trace logs dynamic precedence −3 versus 1. Two host
preparation errors, both before a Docker launch, are retained. This result
comparison occurs later than Core's local fold; it does not by itself prove
a shared-scope precedence discrepancy.

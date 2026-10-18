# Replaying the scanner-entry split

Use baseline `6d5b0b07e44a8f4fd1ab66d3246a485fde303909` for both roles.
Apply `runtime.patch` only to the candidate. It moves the value-only encoding
block into a new internal helper and leaves nil/pointer identity logic intact.
`source-pins.json` records both candidate files. The 3,510-file baseline
manifest is referenced by `baseline-reference.json`.

Use the same external evidence layout as the
[reduction-fusion replay](../20261018-reduction-lineage-fusion/REPRODUCTION.md):
separate clean `/baseline` and `/workspace` sources, a writable evidence copy
at `/evidence`, qualified ledger values at `/reference`, and diagnostic
overrides shared between roles. Reconstruct `/evidence/baseline` and
`/evidence/runtime` from these pinned sources if using the scripts verbatim.
The four diagnostic overrides and source-hash requirements are identical.

Use the pinned Docker image, Go 1.25.14, CPU 6, one CPU, 6 GiB memory,
`GOMAXPROCS=1`, `GOMEMLIMIT=5GiB`, and both benchmark locks. Run `compiler.sh`
to capture baseline/candidate fingerprint tests, inline diagnostics and
entry disassembly. The moved value block must remain byte-identical. A frame
change does not establish a timing win.

Run `screen.sh` before comparison timing. It runs full Core and focused
root/lexer-ownership/C/invariant/race/386 checks, then compares all 414 ledger
rows and five complete consumption vectors. After inspecting those results,
run `run-perf.sh`. It verifies source pins and invokes the repository runner
for twenty alternating pairs, Go seeds 33701–33720 and YAML 33801–33820,
750ms, count one and benchmark memory metrics. No fixed-order comparison is
used. The opt-in large YAML oracle cases are outside this focused screen.

Archive samples use `before/after` filenames; new script outputs use
`go-{base,head}.txt` and `yaml-{base,head}.txt`. Run benchstat on each pair
and generate its CSV tables before `analyze.py`. The corrected parser resets
its unit on every table header, including custom metrics. Validate the
ns/B/allocation medians independently against all twenty raw samples.

The original trial was rejected after the compact-Go R4 regression. Its
focused results do not replace full-fleet, strict-census, RSS or actual-source
qualification for any future runtime candidate.

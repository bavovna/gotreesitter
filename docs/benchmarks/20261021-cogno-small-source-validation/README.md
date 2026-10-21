# Latest Cogno report: proof qualification and rejected candidate

This receipt uses Cogno's [October 21 v0.56.0 report](https://github.com/odvcencio/gotreesitter/issues/454#issuecomment-6311551850), the newest of 41 comments when rechecked. It records qualification evidence and a rejected optimization. It changes no runtime, grammar, default, allowlist, counter ledger, or owner exception.

The exact Go fixture is 140368 bytes, source SHA256 `5434575bb249338937331c3756e10dcec34237d107f523ea315996fb6de0ef8f`, with edits at byte 57. The report identifies fresh verification below 512KiB as the dominant cost. We independently reproduced that call path on Linux ARM64 Docker on an M1 Max. We did not reproduce Windows timing ratios or pool timings across hosts/toolchains; the report uses Go 1.27.0, while these containers use Go 1.25.14.

## Qualification does not establish the missing proof

The uninstrumented private `clean-transfer-runtime-v2` candidate changes seven paths relative to runtime base `d30639dd95af74197305ca76de645ea8d9c29c07`. Its full Go-source manifest SHA256 is `296bc3e1e73020f55024372ec2018ab18140c160d0e93d9d72f4593e44a50ada`; the compressed patch is retained here solely as rejected evidence. It keeps 756 root Go files.

- Linux amd64 Docker: 50 top-level executions, 191 cases, including race and actual 386 runs. The Go strided probe covers 165 sites, 122 fresh-clean sites, with zero scoped divergences.
- Mac M1 Max / Linux ARM64 Docker: 206 grammars in each of ordinary and candidate modes, 412 independent processes, 72 edits each, 29664 total steps. All sessions pass fresh equality and root/stop invariants. All no-edit reparses allocate zero. No OOM occurred. The full 1236-check C gate was not run on this candidate.
- A stronger historical-producer test then fails on the candidate. The same test passes on baseline. Therefore the candidate is rejected despite those earlier passes. No timing qualification or runtime promotion follows.

The adverse producer uses a deterministic factory that lexes a same-length copy with 1760 `+` bytes replaced by `-`, while retaining the original public source. A later ordinary replacement at byte 57 must equal an ordinary fresh parse. Baseline invokes its verifier and passes. The candidate incorrectly certifies the result: its complete primitive read history describes the transformed lexer buffer, but does not authenticate that buffer as the public source. At byte139 the selected symbol is 60 while fresh parsing requires 59; parser-state metadata also differs. Both roots are clean and accepted. This is a new candidate defect, not a failure in the ordinary downstream witness.

`cross-producer-test.patch.gz` adds the same untagged helper and grammar registration to two existing test files on either baseline or candidate. Run in the required Docker isolation, separately per revision:

```sh
GOMAXPROCS=1 GTS_COGNO_SHARED_OUT=/evidence go test . -run '^TestCognocienteGo137KiBCrossProducer$/transformed_factory/plain/replace$' -count=1 -v
```

Decompress the patches before applying them. Baseline uses `cross-producer-test.patch.gz` and must pass. For the rejected candidate, first apply `rejected-candidate.patch.gz`, then `cross-producer-test-candidate.patch.gz`; the latter preserves all candidate tests and adds the identical shared harness. That variant reproduces the failure. Use the recorded report JSON to distinguish selected public-profile metrics from complete operation work. The plain API's zero-valued profile is not evidence of zero work. A replacement needs positive old-producer/source/context evidence and closure across chained reuse, or it must retain fresh verification.

## Separate locked-C deletion defect

The exact 140368-byte fixture's insert and replacement pass locked-C checks on both routes and both plain/profiled APIs, on baseline and the receipt-normalization foundation. Deletion fails identically on both: Go publishes one unknown `:=` child, while C publishes separate `:` and `=` children. The defect also occurs on a 103-byte source reduced from the same fixture. Go incremental equals fresh Go; C incremental equals fresh C. Error nodes remain in the strict comparison.

The C oracle is Go commit `2346a3ab1bb3857b48b29d779a1ef9799a248cd7`, cached Linux amd64 artifact SHA256 `f17d674be6e3e7a0edb521defa31d3174c877b01414fd758a4988673423573f7`. The fetched pinned parser source has blob `e3567a9519739c92ae776060dc8d3b4968bc465f` and SHA256 `3dbf6ed1238b5dfcf2be4d2f2d4cb27a14d34f34d7784eccccbfd532fd4a6d85`. All 1442 lexer-mode metadata entries match the artifact. This is not a blanket claim about machine-code/source identity.

C logger-only runs preserve the untraced Go and C result digests and record 127 incremental and 390 fresh events without truncation. Both show ordinary C lexer mode 58 producing `:`, followed by recovery mode 0 producing `=`. The Go DFA diagnostic instead shows the contextual mode and synthetic error mode both using lexical state 0, which cannot recognize either punctuation byte.

The generator diagnostic binds complete parse-table/action storage to the shipped Go blob before interpreting generator state 39 as runtime state 40. The raw missing-token recovery set includes `:`, `=`, and `:=`; the existing allowlist removes all three. A bounded path explains the colon: insert missing identifier 82, enter state 227, shift colon into state 467. This establishes the omission; it does not justify admitting every raw recovery token. C's ordinary mode accepts `:` without extending it to `:=`, whereas C's broad error mode can accept `:=`. A repair must preserve that context.

The C strict failures and candidate D8 failure are retained. This receipt grants no counter exception, does not apply the held Go repair, and establishes no new speedup. Ordinary YAML ownership and compact graduation remain open.

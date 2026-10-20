# Replay the Go version-turn screens

Use a clean checkout whose 3,512 Go files match `baseline-source-pins.json`.
The runtime is `b17ca367a85d419514554e88f4477a339fd3ecba`; documentation head
`8f7c131d15eb04db6132a8e096bc3dbf135f0ed2` has identical Go sources.
Copy this archive into a fresh writable external directory mounted at `/evidence`.
Keep the checkout mounted at `/workspace`. These are rejected diagnostic
prototypes, not patches to apply to a working checkout.

Use the pinned image and limits in `source-reference.json`: one CPU on CPU 6,
6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`, Go 1.25.14, `GOWORK=off`, `-p=1`.
Use the repository's Docker runner and acquire both common and Nightwatch
locks. A bridge allocation failed before one earlier launch could start any
test. The private runner adds `--network none` to both the test and ownership
fixup containers; its exact patch and hashes are retained. The production
runner was unchanged. Cached dependencies and C grammars suffice for these
runs. `harness.json` records actual container exits and OOM/timeout status.

For the best prototype:

```sh
python3 /evidence/prepare-replay.py c-version-permutation
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/replay/overlay.json'
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoGenericCallFrontierLockedCProbe$' -count=1 -v -timeout=8m
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoTokenTurnExpandedLockedCProbe$' -count=1 -v -timeout=8m
```

The first command passes all six witnesses. The second **must fail 12 of
300** with the archived source. A successful process exit is not the expected
result of that second command. Complete logs are beside the patch.

For the unchanged-runtime control, start with another external output folder:

```sh
python3 /evidence/prepare-replay.py qualified-type-order --baseline --output /evidence/baseline-replay
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/baseline-replay/overlay.json'
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^TestGoTokenTurnExpandedLockedCProbe$' -count=1 -v -timeout=8m
```

This must fail **39 of 300**. It includes 90 compact parses and 210 fallbacks.
The best prototype fixes 27 of those failures and adds none in this screen;
12 previously compact-routed failures remain. This does not qualify a routing
change or establish throughput.

Every variant has a zero-context `runtime.patch`, exact runtime/probe hashes,
full logs and `original-run.sh`. Prepare each in a fresh output directory.
The helper verifies all baseline files, reconstructs only changed files in
external storage with `git apply --unidiff-zero`, checks every resulting hash,
and emits an overlay. It does not modify the checkout.

For `payload-aggregate`, use selector
`^(TestGoDFASelectionOracleEvidence|TestGoGenericCallFrontierLockedCProbe)$/^single_identifier$`.
For `legacy-merge-trace`, use `^TestGoDFASelectionOracleEvidence$`.
For `qualified-type-order`, use
`^(TestGoDFASelectionOracleEvidence|TestGoGenericCallFrontierLockedCProbe)$`.
The oracle passes; the two compact witnesses fail. For
`qualified-baseline-trace`, use
`^TestGoGenericCallFrontierLockedCProbe$/^qualified_type_multi$`; the observed
policy remains unchanged and the witness fails. The two `*-build-preflight`
variants preserve compile failures, not parser test results.

The existing Go certification, incremental, nested-reuse and recovery selectors
are retained in each expanded variant's `original-run.sh`; all seven selected
suites pass. No full Core, race, 386, fleet invariant, deterministic ratchet,
randomized timing or RSS qualification was run for these prototypes.

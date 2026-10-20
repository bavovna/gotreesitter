# Replay the combined compact Go correctness candidate

This is a **private, unpromoted** 15-file engine candidate based on
`5c463e567a3dec1d3f367f1a47ebaac03800a797`, the qualified no-replay guard.
It adds five files under `internal/`, keeping the root file count at 756.
No owner approval exists for its canonical work increases.
The complete final RSS run also fails one Go probe at **404.16 B/source B**.
The candidate is rejected for promotion; no owner exception is requested.
The narrower 42-probe Go pass does not override this complete run.

Use a complete clean baseline checkout whose 3,512 Go files match
`baseline-source-pins.json`, mounted at `/workspace`. Copy this archive to a
fresh writable external directory at `/evidence`. The helper reconstructs
the 15 files outside the checkout, including the three new internal files,
checks exact hashes and emits an overlay. Never apply the private patch to
the working checkout before the owner counter exception and remaining gates.

Use pinned Go 1.25.14 image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
one CPU on CPU 6, 6 GiB, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`, `GOWORK=off`,
count 1 and `-p=1`. Acquire common and Nightwatch locks. The private Docker
runner uses the archived network-none patch; the repository runner and host
configuration are unchanged.

```sh
python3 /evidence/prepare-replay.py
export GOWORK=off GOMAXPROCS=1
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/replay/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^Test(CompactLegacyReadHistoryPublicationDemand|CompactCanonicalNoReplayReadHistory|PrototypeDFATerminalSourceRejectsChangedOrigin|PrototypeDFADispatchRestoresNestedPanicWithoutAllocating|OrdinaryShiftCohortPreservesAlreadyShiftedSibling)$' -count=1 -v -timeout=8m
cd /workspace/cgo_harness
go test . -tags gts_parsercorephase0,treesitter_c_parity -run '^(TestGoGenericCallFrontierLockedCProbe|TestGoTokenTurnExpandedLockedCProbe|TestGoVersionTurnEditSessionsLockedC)$' -count=1 -v -timeout=8m
```

Require 306 clean C cases through compact, 24 six-step edit sessions with
incremental=fresh=C, and 144 zero-allocation no-edit checks. The root cases
retain all 19 source/origin/context negatives, panic restoration, the
zero-allocation helper and the causal three-history regression. The baseline
regression loses one of three histories; this candidate preserves all three.
`--baseline` prepares the unchanged control in another output folder.

Compile root and C test binaries once, then run one language/process for each
entry in `languages.txt`: `TestV1InvariantGateR4EditSession` with
`GTS_ADMISSION_CANDIDATE=1` and `GOTREESITTER_V1_INVARIANT_LANGUAGE`; and the
three `TestParityFreshParse`, `TestParityIncrementalParse`,
`TestParityHasNoErrors` subtests with `GTS_PARITY_MODE=exhaustive`. All 206
sessions and 618 checks pass. The strict 204-file census is unchanged at
120 compact passes, 39 legacy passes and 45 known legacy failures.
`qualify.sh` and `strict.py` retain exact selectors and the original paths;
replace the overlay/output paths for an external replay.

## Counter rejection remains mandatory

`TestCanonicalMaskCensus` records all four complete vectors and unchanged
canonical deep digests. The numerical 414-row fixture ledger matches the
qualified guard. One C candidate row reports a different decline location;
its counters and route do not change. The canonical work comparison has
**77 changed fields: 65 increases and 12 decreases**. Every old/new value is
in `canonical-work.json` and `all-counter-changes.md`.

The standard production-pinned lifecycle and benchmark reject those work
changes. Their pins remain unchanged. An original memory test also stops in
that work-pinned fixture preparation before reaching its budget assertion;
the full failure is retained in `prior-identical-core/`.

Separate diagnostic tests preserve the original changed-source budget and
two-pass lifecycle assertions, source/deep-tree pins, and distinct explicit
private work vectors. They pass without modifying the original tests or
production pins. `diagnostic-test-source-reference.json` records the exact
original source hashes and distinction. These diagnostic passes are not a
passing D10 gate or approval to promote.

Normal/phase0A and 386 Core results are reused only for identical internal
source hashes and retained under `prior-identical-core/`. The fused candidate
separately passes the selected-store one-pass Core suite, default/tagged
root checks, focused races, memory contracts, pooling, large Go C equality
and ordinary/owned YAML stream checks. Both adapter storage and the
once-per-token cursor are charged, including inline padding; source/reset
and owner-exit cleanup remain active.

## Paged receipts and RSS

The preceding flat receipt store failed two Go RSS probes at 400.43 and
401.72 B/source B. Its complete 126-probe run is retained under
`failed-flat-receipts/`; no samples are discarded. Go-only attribution
finds 16.8 MB of growth allocation for 3.45 MB retained receipts. Paged
storage removes 13,651,080 allocated bytes on the same one-MiB witness,
with all complete large-Go and canonical work vectors unchanged. The
42-probe narrowed Go screen passes before the complete qualification is
repeated. All prior results keep their original source hashes.

## RSS and limits

`rss/` retains the six initial probes and 20 alternating matched pairs per
case for generated one-MiB Go, ordinary YAML and owned YAML: **126 probes**,
one grammar/process, seeds 35001–35020. The unchanged strong probe requires
the exact sources, expected routes and Go token/node work. Use
`/usr/bin/time -v`; require every candidate at most 400 B/source B and each
candidate/baseline median ratio at most 1.10. `rss/repeat_rss.py` retains the
loop and checks; repoint its initial-result and binary paths when replaying.

No production/candidate timing comparison ran after the failing work
directions. Earlier closure/value timing belongs to its separately pinned
private pair and does not transfer to this combined candidate. No routing,
allowlist, graduation or global-default change is proposed here. Ordinary
YAML's ownership/cost blocker remains. Owner R3 approval is required before
updating any production work pins or promoting the candidate.

The pinned one-MiB Go witness is retained as `source.go.txt.gz`; decompress
it only in external replay storage, or use the archived witness generator.

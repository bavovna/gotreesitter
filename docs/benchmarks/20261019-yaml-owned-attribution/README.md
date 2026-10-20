# Current owned-YAML attribution

Runtime: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`; one 8012-byte owned-YAML
fixture, `BenchmarkStreamedPrefixYAML/eof8k_owned`. Routing and work stay exact:
compact=1, fallback=0, 1936 public constructions and 403 tokens per parse.
The source reference pins the input and real sample hashes, the 3518-file Go
manifest and the shared overlay. This refresh uses the published runtime after
the snapshot-pair and node-layout improvements, independently of private Go
packing and stable-request-window proposals.

This is attribution only. CPU profiling uses an eight-second benchmark; a
separate four-second allocation run samples at 65536 bytes. GOMAXPROCS=1,
count=1, pinned 6 GiB Docker on CPU 6 and both repository locks match the
optimization environment. No fixed-order timing comparison or speedup follows.
Allocation profiles include setup and calibration, so sampled shares cannot
be treated as exact per-operation fractions or additive speedup estimates.

| Site | Attribution |
| --- | ---: |
| Header publishVersionState | 63.35% flat sampled allocation objects; 18.27% bytes |
| ScannerSnapshotPages.New | 66.11% flat sampled bytes; 71.10% cumulative bytes |
| Snapshot validateDestination | 8.61% cumulative CPU |
| Owned dispatchVersionLexerPassActive | 26.57% cumulative CPU |
| Owned applyGenericReductionOwned | 26.67% cumulative CPU |
| Acceptance materialization | 13.52% cumulative CPU |

Cumulative CPU and byte shares overlap. Scanner serialization itself has 1.11%
cumulative CPU in this probe; byte allocation shares are not CPU shares.
The results point to request/header publication, snapshot validation and shared
reduction work as further targets. The first private proposal replaces ordinary
request renumbering with a stable reference window, preserving immutable
wrappers, rollback, stale-request validation and recovery compaction. It still
requires its own complete correctness, counters, RSS and randomized timing gates.
Nothing graduates or changes route based on this profile.

## Replay

Verify archive hashes in archive-manifest.json. Start with a clean complete
baseline module, including grammar and fixture assets, and verify all hashes in
the packed Go manifest. Mount it at /reference:ro and a writable copy of these
inputs at /evidence. Use image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
Go 1.25.14, 6 GiB, CPU 6, GOMEMLIMIT=5GiB and GOMAXPROCS=1. Hold both repository
locks and run bash /evidence/profile.sh. Raw text and Docker metadata are retained;
no binary or binary profile is committed. Binary outputs from replay remain
private. Benchstat and matched pairs are required for later performance claims.

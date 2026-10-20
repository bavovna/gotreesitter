# Integrate main after the YAML scanner parent lands

PR #1486 merged at `88dc1d9c3ff15cc2b8b5c53864455fc3a24a9d34` after all
78 checks passed, including editor latency; no unresolved review thread
remained. Existing owner authorization permits the admin review override.
Buckley merge `b876c5b5a4ce9569a47dbfdf6adc7cff139ebefb` integrates that main
into the compact branch and preserves its current evidence date and earlier
qualified lineage receipt. The only conflicts were those documentation sections.

The merged 3520-file Go source manifest matches the frozen test input. All
414 complete ledger rows and four complete canonical Go trees/work vectors
remain exact. The packed-stack equivalence regression, runtime-profile unit
suite, TypeScript/TSX grammar regressions and their exact C fresh/incremental
checks pass in Docker. Each grammar and each C comparison runs separately.
The profile unit suite retains its opt-in diagnostic skips; neither C process
skips a case. No timing comparison is claimed for this integration.

The archive retains all focused logs, runner inputs, source hashes, original
counter rows and runner metadata, excluding generated executables. The graph
and 32-byte version-state prototypes are absent from the compiled source.
Full engine qualification of subsequent proposals remains separate.

Verify archive-manifest.json, extract evidence.tar.gz and check out b876c5b5.
Mount that source at /candidate:ro and evidence at /evidence, then run
`bash /evidence/focused.sh` under both repository locks. Use Go 1.25.14,
image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and the existing locked-C cache.

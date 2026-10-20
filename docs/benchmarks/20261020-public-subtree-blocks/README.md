# Held 16K-record subtree arena

The [receipt](../../compact-public-subtree-block-screen-20261020.md) records an 18.42% Go byte-allocation saving and the 21.59% heap-object increase that rejects promotion. All 480 timing rows and all 126 RSS processes are retained.

Reference code commit `647ea982cdf2f6accedce5cda0705949f957acb8` and PR #1502 head `98747629037d6934b9dcf6dfbb41db6d082a3078` have identical 3,535-file Go source. The held candidate has 3,541 Go files and a 47-file internal overlay. Its source is not promoted by this receipt.

`archives.json` pins three archive hashes, sizes and member counts. `archive-members.json` pins every member. All 1,057 members were reopened and verified by size and SHA-256; binaries and caches are excluded.

- `source-protocol.tar.gz` includes the final candidate overlay, complete source manifests, reference counters/canonical vectors, exact inputs, executed scripts and source overlays from failed compilation attempts.
- `qualification.tar.gz` includes all Core build modes, 206 edit sessions, 618 named C fixtures, strict/expanded outcomes, actual large-Go C verification, race/386/budget/API gates and failed build logs.
- `measurements.tar.gz` includes paired capacity results, six initial plus 120 matched RSS processes, all shuffled timing processes, workload-order/ratchet audits and benchstat output.

To replay, check out the reference commit, verify every reference source hash, copy the checkout and apply `candidate-overlay/`, then verify every candidate hash. Extract `protocol/` into a fresh result directory. Use the pinned Go 1.25.14 Docker image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`, locked C cache, both Docker locks, six-GiB memory, CPU 6 and GOMAXPROCS=1. Mount sources read-only at `/reference` and `/candidate`, results/protocol at `/evidence`.

Run `core-first.sh`, then `qualify-and-audit.sh`. It reuses completed default/shadow logs and runs the remaining build modes, separate one-language C/invariant processes, strict/expanded controls, the actual one-MiB C witness, race/386 and API/layout guards. Empty runs and changed source hashes are rejected.

For RSS, mount the protocol root at `/lab` and `rss/` at `/evidence`, then run `/lab/rss-after-qualification.sh`. After RSS passes, mount the protocol root at both `/lab` and `/evidence` and run `capacity-perf-after-rss.sh`. Go seeds are 46301–46320, YAML 46201–46220, RSS 46101–46120. Normal pools and memory/stack settings stay in force. Run `analyze-perf.py`, then benchstat on each complete pair and verify source hashes again. **The analyzer is expected to exit 1 because the heap-object ratchet fails.**

The original lab is `/home/draco/.local/state/gotreesitter-evidence/20261020-public-subtree-blocks`. Archived scripts retain original paths; adjust mount/output locations for replay. Failed migration helpers remain evidence of their attempts; final-source replay applies the qualified overlay directly.

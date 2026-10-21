# Blocked graph-node storage evidence

The [receipt](../../compact-gss-node-block-receipt-20261020.md) records results and the measured grammargen time regression. Reference Go commit `2264c231a57bb1f22c93e4929b0a5e73ed6441e5` and main `c9770115d6bc23873c7a452ea5753d12ff2c5d1b` have identical 3,527-file Go source. The final candidate has 3,535 Go files. No ordinary YAML ownership or Go correctness-exception repair is included.

`archives.json` pins seven archive hashes, sizes and member counts. `archive-members.json` pins every member; all 2,584 members were reopened and verified by size and SHA-256. Binaries and caches are excluded.

- `cached-candidate-source-protocol.tar.gz`, `cached-candidate-qualification.tar.gz` and `cached-candidate-measurements.tar.gz` contain the final overlay, executed protocols, complete qualification and matched measurements.
- The three `uncached-screen-*` archives retain the earlier measured screen. Its original standard gates passed, but the later boundary audit exposed 386 defects shared with the rejected cached prototype. It is held and is not the promoted source.
- `cached-rejected-boundary-attempt.tar.gz` retains the exact rejected source, its completed unit/invariant/ledger checks, interrupted qualification and both expected 386 failures. It has no completed C/RSS/timing claim.

For a fresh final-source replay, check out main `c9770115d6bc23873c7a452ea5753d12ff2c5d1b`, verify all reference source hashes, copy that checkout, apply `candidate-overlay/`, then verify all candidate hashes. Extract `protocol/` into a fresh results directory. Mount sources read-only at `/reference` and `/candidate`, results/protocol at `/evidence`, and use Go 1.25.14 image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`, the locked C cache, both Docker locks, six-GiB memory, CPU 6 and GOMAXPROCS=1.

Run `core-all.sh`, then `qualify-and-audit.sh`. This reuses the already completed default/shadow Core logs and runs the remaining build modes, 206 separate edit sessions, 618 named C fixtures, strict/expanded C controls, actual large-Go C witness, race/386 and layout/API guards. Empty test runs are rejected. The unchanged known C failures remain explicit.

For RSS, mount the protocol root at `/lab` and its `rss/` directory at `/evidence`, then run `/lab/rss-after-qualification.sh`. It retains all 126 processes and stops on a ceiling or median-ratchet failure. For paired capacity and timing, mount the protocol root at both `/lab` and `/evidence` again and run `capacity-perf-after-rss.sh`. Go seeds are 46001–46020, YAML 45901–45920, RSS 45801–45820. Normal pools, memory and stack settings stay in force. Run `analyze-perf.py`, compare both complete language files with benchstat, and verify all source hashes again.

The original final lab is `/home/draco/.local/state/gotreesitter-evidence/20261020-go-gss-block-cached-safe`. Archived scripts retain their original paths; adjust only mount/output locations for a fresh replay. `bucket-blocks.py` verifies and packs the evidence; its working-checkout path can be changed for replay.

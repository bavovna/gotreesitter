On Linux ARM64, L reduces ordinary YAML allocations from **71 to 39 per 8 KiB parse** and **40 to 32 per R4 parse**. Allocated bytes also fall. All 12 timing differences are nonsignificant. Diagnostic-owned bytes rise 0.49%/0.59%; Go changes are nonsignificant. Native YAML remains held against fallback. See the [full receipt](../../compact-version-publication-coallocation-20261021.md) for every direction, control and limitation.

- `source-protocol.tar.gz`: source overlays, source pins, qualification commands and retained setup failures.
- `qualification.tar.gz`: C, deterministic counters, invariant sessions, build modes, scoped race, 386, layout and memory-budget checks.
- `memory-safety.tar.gz`: all 189 raw RSS probes and the safety audit.
- `arm64-measurements.tar.gz`: all 480 raw timing rows, runner logs, counters, controls, statistical reports, environment and container state.
- `arm64-replay.tar.gz`: exact runner, I/L input manifests, public verifier and sanitized replay commands.

The three Linux archives retain their original bytes. Archive/member hashes are recorded in `archives.json` and `archive-members.json`. Mac execution used pinned Linux ARM64 Go 1.25.14; it was not native Darwin execution. AMD64 and ARM64 measurements remain separate. This bundle covers L against I; packed64 experiment M has its own evidence.

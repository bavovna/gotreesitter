# Public subtree storage: 65,536-record blocks

See [the qualification receipt](../../compact-public-subtree-blocks-64k-20261020.md). This is local evidence against unmerged PR #1502; promotion still requires the core lane and all latest-head CI checks.

- `source-protocol.tar.gz`: exact source overlay, source pins, commands, test overlays, and retained failed build attempts.
- `qualification.tar.gz`: deterministic ledgers, all-language invariants, locked-C checks, race/386/API/layout and core mode results.
- `measurements.tar.gz`: raw paired Go/YAML timings, capacity probes, and all retained RSS observations.
- `archives.json` and `archive-members.json`: archive and member SHA-256 hashes.
- JSON summaries and benchstat tables: directly readable results; all directional changes are retained.

Reproduction uses the pinned reference and candidate Go source maps from the protocol archive. Follow the stored correctness scripts before RSS and timing scripts. Do not compare these medians to separate campaigns or infer a throughput win from allocated bytes.

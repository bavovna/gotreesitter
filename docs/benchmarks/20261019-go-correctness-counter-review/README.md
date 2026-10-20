# C-correct protocol on progress-based capacity

Baseline: `54863cf280722c720bda81c2a8480f2398255730`; 3514 Go files.
Candidate: 17 overrides, 3521 Go files, 756 root files. Source remains private.
`runtime.patch` and all source/probe hashes make the complete proposal reviewable.
No production work pin changes; 65 canonical fields increase and 12 decrease.
The complete old/new table is `canonical-counter-table.md`.

Correctness: 306 clean Go C cases, 144 generic edit steps, all 206 ordinary
72-step sessions, explicitly activated owned YAML, 618 C smoke checks, strict
204-row equality (120 compact pass / 39 legacy pass / 45 known legacy failures),
root/Core races, real publication cancel/timeout/memory assertions, memory/pool
contracts, 386, all 12 API tag sets, layout and R6 guards pass. The fresh baseline
reproduces exactly 39 expanded C failures; its cache setup failure is retained.

All 126 RSS processes pass, including six initial probes. No timing comparison
is run across the unapproved work increases. The owner must approve R3 before
performance qualification and promotion can proceed.

Raw correctness, control and RSS bytes are preserved in `raw-logs.tar.gz` with
relative paths and a SHA-256 manifest. No compiled binaries or heap profiles are
committed. Diagnostics use explicit private work vectors; production-pinned
negative controls remain failures. Root interface methods live in the internal
adapter and its complete inline size is charged to the existing memory gauge.

Replay preparation accepts two complete baseline snapshots and an external
output directory. It validates both 3514-file source sets, applies the exact
patch outside either checkout, and verifies all 17 results. Probe mappings are
separate from runtime code. Run through the repository Docker runner in the
pinned Go 1.25.14 image, 6 GiB, CPU 6, GOMAXPROCS=1, GOMEMLIMIT=5GiB, both locks,
one grammar/process, and the prebuilt C cache. Remap overlay paths for container
mounts; `/workspace`, `/reference`, `/evidence` and `/candidate` are the recorded
roles. The host audit scripts use sibling historical receipt paths; the archived
JSON and raw logs retain those exact comparisons. These scripts are captured
provenance rather than a self-contained remote download of prior artifacts.

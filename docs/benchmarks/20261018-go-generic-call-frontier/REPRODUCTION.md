# Reproduce Go generic-call frontier attribution

Use baseline runtime `6d5b0b07e44a8f4fd1ab66d3246a485fde303909` in the
pinned Go 1.25.14 Docker image from the coallocation receipt. Mount a writable
external copy of this evidence directory at `/evidence`.

Create an overlay from `/workspace/<name>` to the corresponding archived
`runtime/<name>.txt` for the three instrumented Core sources. Add
`root_probe_test.go.txt` as `/workspace/zz_go_generic_frontier_test.go`, and
`cgo_probe_test.go.txt` as
`/workspace/cgo_harness/zz_go_generic_frontier_test.go`. Write the map to
`/evidence/overlay.json`, then run `bash /evidence/run.sh` with both benchmark
locks and one language/process. Source hashes in `source-pins.json` refer
to the original names before the archival `.txt` suffix.

The root probe compares observed and unobserved errors, full committed work,
cap/reconvergence records and successful trees. The observer asserts that
its complete Core work vector is unchanged by reading the frontier. Public
C comparison uses the normal route and records every fallback reason.
This is attribution only: no timing comparison, ownership proof, branch-cap
change, route activation or runtime change is claimed.

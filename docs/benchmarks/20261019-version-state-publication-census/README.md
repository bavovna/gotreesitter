# Version-state publications: preserve the common node baseline

The read-only diagnostic overlay counts non-nil wrappers created by
`publishVersionState` on runtime `b7046b6c5385ec52a09fb8b8250c9d689754b74e`.
The native wrapper occupies 64 bytes. Every measured publication can omit
the region, recovery group, missing group and retained acceptance group.
Clean Go still publishes the visible-node baseline; moving that baseline
into separately allocated recovery storage would penalize the Go cases.

| Case | New wrappers | With node baseline | With region or group metadata |
| --- | ---: | ---: | ---: |
| Go query_compile, 20,168 bytes | 113 | 113 | 0 |
| Go grammargen_lr, 235,626 bytes | 1,569 | 1,569 | 0 |
| Go, 1,048,591 bytes | 0 | 0 | 0 |
| Owned YAML R4, 1,998 bytes | 37 | 1 | 0 |
| Owned YAML EOF witness, 8,012 bytes | 140 | 4 | 0 |
| Owned YAML stream, 1,049,572 bytes | 19,380 | 524 | 0 |

All six parses complete on compact, cover their input and have no errors.
The large Go witness retains 903,086 constructions and 425,742 tokens.
Raw logs pin each input, route and runtime work. The observer increments a
fixed array, retains no parser objects and changes no publication decision.
It does not count wrappers created at other sites, such as clearAcceptanceGroup,
and is not an allocation, retention, RSS or timing measurement.

The resulting prototype keeps the full-width cursor, request, node baseline
and baseline-valid flag in a 32-byte wrapper. Rare region/group metadata goes
into an optional shared immutable holder. This preserves the node baseline
without allocating a holder for any publication in this census. The prototype
is separate from the graph-link redesign and has not completed qualification;
**no runtime memory or throughput improvement is claimed here**. No production
source, counter pin, route, exception or graduation setting changes.

## Replay

```sh
python3 prepare-replay.py --baseline /path/to/b704-source \
  --evidence /path/to/new-evidence
python3 prepare-replay.py --baseline /path/to/b704-source \
  --evidence /path/to/new-evidence --check
```

Both modes were exercised. The helper checks the archive, all 3518 Go source
hashes and all four diagnostic overlays. It prepares inputs without completion
markers or binaries. The archive retains the complete raw logs and original
runner metadata. The exported observer exists only in a test overlay.

Mount the source at /reference:ro and prepared evidence at /evidence; run
`bash /evidence/census.sh` under both repository locks. Use Go 1.25.14, image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB and GOMAXPROCS=1. The fixture helper's historical
RSS test name supplies the accepted large inputs; this census does not invoke
an RSS measurement or establish C graduation.

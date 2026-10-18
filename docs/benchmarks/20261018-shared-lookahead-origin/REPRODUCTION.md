# Replay the private ownership investigation

Use an isolated checkout of runtime
`6d5b0b07e44a8f4fd1ab66d3246a485fde303909`. The primary checkout is not an
experiment target. `baseline-reference.json` names the complete source manifest.
Keep the evidence directory available outside that checkout.

`prepare.py --root CHECKOUT --variant VARIANT --output-dir OUTPUT` validates
all baseline Go hashes, checks and applies the selected patch, and installs
only the diagnostic probe files needed for that variant. It refuses a source
mismatch or existing target file. Use a fresh isolated checkout per variant.
This creates temporary diagnostic source in that isolated root, not production
source for a PR.

| Variant | Purpose / expected result |
| --- | --- |
| `origin` | Read-only ancestry census; three observer controls pass. |
| `eager` | Actual shared request after `Next`; 19 C fixture cases pass. |
| `reduction-entry` | Defer publication to first reduction; 19 C cases pass. |
| `late-fork` | Publish after reduction outputs split; stream admission fails. |
| `pending-origin` | Canonical guard with shifted-cursor coverage; stream admission fails. |
| `phase-counter` | Capture live work and run the 72-step YAML invariant gate. |
| `ledger` | YAML ordinary, diagnostic-owned and prototype ledger rows. |

Run the generated `OUTPUT/run.sh` inside Docker, mounted as `/evidence`, with
the isolated checkout at `/workspace`. Use the repository wrapper, one grammar
at a time, the image pinned in `baseline-reference.json`, 6 GiB, one CPU,
CPU 6, `GOMEMLIMIT=5GiB`, `GOMAXPROCS=1`, and both repository locks. For example:

```sh
bash cgo_harness/docker/run_parity_in_docker.sh \
  --repo-root CHECKOUT --image IMAGE_SHA --no-build \
  --memory 6g --cpus 1 --cpuset-cpus 6 --gomemlimit 5GiB \
  --wall-timeout 1800 --mount OUTPUT:/evidence \
  --mount /home/draco/.local/state/nightwatch/gts-docker.lock:/locks/nightwatch \
  --mount /tmp/gts-docker.lock:/locks/common \
  -- 'flock /locks/nightwatch flock /locks/common bash /evidence/run.sh'
```

The generated commands set `GOWORK=off` and `GOFLAGS=-p=1 -buildvcs=false`.
All C runs use `gts_parsercorephase0,treesitter_c_parity`; root runs use
`gts_parsercorephase0`. The C harness verifies its locked grammar source.
No benchmark is supplied because counter regressions block promotion.

The original runs used overlays over frozen copies rather than editing the
isolated source. Patches and `.go.txt` files retain the exact source inputs;
`input-pins.json` authenticates the archive. The public C summaries count three
unique parse modes per fixture; a repeated edited-fresh assertion is not an
additional parse comparison. Original private run records remain under
`/home/draco/.local/state/gotreesitter-evidence/20261018-shared-lookahead-origin`.

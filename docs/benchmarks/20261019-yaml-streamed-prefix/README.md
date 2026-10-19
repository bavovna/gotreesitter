# Streamed ordinary YAML ownership: rejected source

Baseline runtime: `54863cf280722c720bda81c2a8480f2398255730`.
The thirteen-file `runtime.patch` combines authenticated single-prefix ownership
with streaming native publication. It is private evidence, not promoted runtime.
It does not contain the Go C-correctness proposal or change its pending approval.

`runtime-pins.json` authenticates the modified files. The packed complete source
manifests contain 3514 baseline and 3517 candidate Go files. The patch reconstructs
all thirteen files; three are new internal files. The root adapter extends the
existing materializer, and introduces no root Go file or language-name rule.
`archive-manifest.json` hashes the raw evidence bundles.

The focused source passes full Core tests, four metadata comparisons, the opaque
binding regression, pinned canonical Go lifecycle work, ordinary/explicit-owned
72-step YAML sessions, memory/pooling checks, expanded scanner C/edit comparisons
and both 1,049,572-byte YAML C witnesses. It has no full fleet, race, paired RSS,
layout/API or graduation qualification. Do not transfer earlier gates to it.

The fifty counter comparisons include the failed compact attempt before the
baseline's legacy fallback: peak versions stay 2→2, rather than comparing the
returned legacy tree's peak of one with the completed compact peak of two.
Raw public and attempt censuses remain separate. No production pin is reset.

The repository runner completes twenty alternating shuffled pairs per language,
one process per seed, count=1, GOMAXPROCS=1, 750ms and benchmem. Go uses
35901..35920; YAML uses 36001..36020. There are 440 benchmark rows. The shared
benchmark uses normal runner pooling and verifies stable work on every parse.
The candidate routes every ordinary/owned YAML operation through compact;
the baseline ordinary route falls back. No-edit allocations stay zero.

The combined source fails five comparative median ratchets. Ordinary R4/8 KiB
time rises 16.66%/42.63%, allocation counts rise 37→43/34→83, and Go full time
rises 10.81% (p=.134, inconclusive). Owned timing differences are inconclusive.
The node/byte savings do not justify promotion. Preserve every sample.

## Replay

Provide one complete baseline tree with the pinned Go sources and grammar/fixture
assets. Prepare a fresh external candidate directory and evidence directory:

```sh
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence
python3 prepare-replay.py --baseline /path/to/baseline \
  --candidate /path/to/new-candidate --evidence /path/to/evidence --check
```

Mount these paths at `/reference:ro`, `/candidate:ro` and `/evidence` in the pinned
image `sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`.
Use the repository Docker runner, 6 GiB, one CPU pinned to 6, GOMEMLIMIT=5GiB,
both repository locks and Go 1.25.14. The focused overlay deliberately targets
`/reference`; the census/timing overlays distinguish both complete modules.
Retain the existing locked C cache at
`/workspace/harness_out/parity_c_ref_cache/linux_amd64`.

```sh
bash /evidence/pooled/run.sh
bash /evidence/pooled/census.sh
python3 /evidence/pooled/analyze-counters.py
bash /evidence/pooled/perf.sh
python3 /evidence/pooled/analyze-perf.py
bash /evidence/pooled/profile.sh
```

The analyzer records failed ratchets without deleting output. Benchstat supplies
the significance tests. CPU/allocation profiles are attribution, not comparative
timing. Their text reports are retained; compiled binaries and raw profiles stay
in the local evidence store. Initial missing-tag and child-route environment
plumbing failures retain their original labels in the raw archive.

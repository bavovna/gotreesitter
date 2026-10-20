# Graph-link metadata census

Runtime control: `b5133ae07d1b1cd274c119cdef0a2625ff3d1a37`.
This read-only diagnostic overlay examines the retained graph when a fresh
scheduler session returns. All six sessions succeed through compact; the
public witnesses check complete, error-free trees and expected routes. The
large Go witness also retains 903086 constructions and 425742 tokens.
The archive pins all 3518 baseline Go files, instrumentation, fixture helpers,
raw output and Docker metadata. No production source is changed.

A link currently occupies 32 bytes: full-width predecessor, payload and next
identities, signed 64-bit score, unsigned 64-bit branch order and 32-bit flags.
The census separates all-zero metadata and simulates a four-entry recent-key
cache over retained-record order. Every key includes score, order and flags.

| Fixture | Links | Zero metadata | Four-entry cold misses | Estimated live link bytes |
| --- | ---: | ---: | ---: | ---: |
| go_query | 14,662 | 68.82% | 1,209 | 469,184→263,608 (-43.82%) |
| go_grammargen | 148,367 | 62.83% | 15,967 | 4,747,744→2,757,080 (-41.93%) |
| go_large | 1,032,094 | 72.50% | 64,505 | 33,027,008→18,061,624 (-45.31%) |
| yaml_r4_owned | 355 | 86.48% | 4 | 11,360→5,776 (-49.15%) |
| yaml_8k_owned | 1,402 | 87.52% | 16 | 44,864→22,816 (-49.14%) |
| yaml_large_owned | 186,522 | 86.52% | 2,096 | 5,968,704→3,034,656 (-49.16%) |

The final column assumes a 16-byte dense record and 24-byte immutable metadata
record for each simulated miss. It omits backing-array capacity, rollback
history, cache state, temporary buffers and allocator size classes. These are
geometry estimates, **not measured allocation, RSS or throughput improvements**.
The actual append stream can include rolled-back records missing from this
retained graph. A separate unqualified prototype is integrating lossless
storage, cache invalidation, rollback, honest accounting and shadow copies.
It must pass all correctness, counter, memory and timing gates before promotion.
No route, work pin, owner exception or graduation setting changes here.

## Reproduce

```sh
python3 prepare-replay.py --baseline /path/to/clean/baseline \
  --evidence /path/to/new/evidence
python3 prepare-replay.py --baseline /path/to/clean/baseline \
  --evidence /path/to/new/evidence --check
```

Mount the baseline module plus grammar/fixture assets at /reference:ro and the
prepared evidence at /evidence. Use Go 1.25.14, image
`sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df`,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks.
Run `bash /evidence/census.sh`. Each test process handles one grammar and case;
no timing comparison is performed. Preparation verifies the archive and all
source/overlay hashes and supplies no executable binary. Prepare and check
modes were exercised.

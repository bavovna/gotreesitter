# Fused scanner checkpoint receipt screen, 2026-10-21

**E stays held: all twelve timing changes are nonsignificant.** The Mac completed twenty matched pairs per language, 80 processes and 480 rows. Deterministic route/node/token counters remain exact, no-edit allocations stay zero, and all 36 median ratchets pass. This preliminary result establishes no throughput improvement and does not justify full-fleet qualification, a runtime PR, route activation or compact graduation.

E returns the interned checkpoint ID, byte length and digest from the record already found, avoiding another record copy. Scanner Serialize/Scan/Deserialize and observer calls remain unchanged. Five focused regressions cover ownership across growth/reset, transaction rejection, capacity failure, collisions/corrupt chains and allocation-free repeated lookup. Private runtime commit d342ff7afef564b0a6d1c368b50f4d86001bfece compares with M 73556f21928e68712de2f08452d05620334fee9e: four changed Go files, 3,568 candidate Go files and root cap 756. Both full transports freshly match frozen bytes and Git blobs.

All directions follow; positive changes are increases. Exact medians, samples and statistical reports are archived.

| Workload | Time | B/op | Allocations/op |
| --- | ---: | ---: | ---: |
| Go fresh_one_mib | -0.22% (p=0.968) | +0.0000% | +0.00% |
| Go full_dfa | -1.73% (p=0.102) | +0.0000% | +0.00% |
| Go grammargen_lr | +1.32% (p=0.157) | +0.0000% | +0.00% |
| Go no_edit_dfa | +0.41% (p=0.155) | +0.0000% | +0.00% |
| Go query_compile | +0.53% (p=0.547) | +0.0000% | +0.00% |
| Go single_byte_edit_dfa | -0.22% (p=0.429) | +0.0000% | +0.00% |
| YAML eof8k_legacy | +0.65% (p=0.192) | +0.0000% | +0.00% |
| YAML eof8k_ordinary | -2.15% (p=0.547) | +0.0000% | +0.00% |
| YAML eof8k_owned | -4.01% (p=0.072) | +0.0000% | +0.00% |
| YAML r4_legacy | +0.14% (p=0.799) | +0.0000% | +0.00% |
| YAML r4_ordinary | -1.00% (p=0.183) | +0.0000% | +0.00% |
| YAML r4_owned | -0.97% (p=0.086) | +0.0000% | +0.00% |

Before timing, focused Linux Docker checks preserve **414 ledger rows and four canonical Go vectors**, pass **six actual C fixture checks** plus owned-YAML/document-stream C oracles, and pass three 72-edit sessions (Go, ordinary YAML and owned YAML) with no-edit allocation zero. Sixteen memory-contract tests pass. Focused native/race tests pass 16 internal/7 root; actual 386 runs pass 16 internal/6 root, explicitly excluding the AMD64-only layout test. The full 206-session, 618-C, full-Core and RSS gates were not run for E.

The first C/counter attempt omitted the parity tag and owned helper. Its vacuous C output is not counted; the fixture-mode mismatch is not attributed as a runtime regression. The corrected attempt uses actual C tags and the qualified helper; both attempts remain archived. An earlier missing-import compile attempt remains private and is superseded by the pinned committed source. The first Mac launcher failed at image inspection before samples. The same-image retry completed exit 0/no OOM; all samples and the initial failure remain retained, with no exclusions or replacements.

The Apple M1 Max Mac, reached over tailnet, executes **Linux ARM64 Docker**, not native Darwin. Both roles use Go 1.25.14 and the pinned image in the protocol, with CPU quota 2, cpuset 2,3, 4 GiB memory/swap, a 3 GiB Go limit, GOMAXPROCS=1, one process/count per explicit seed, 750ms and benchmem, normal pools/default budgets and a shared compute lock. Go seeds 49701–49720 and YAML seeds 49601–49620 alternate roles with matched shuffled workload order. ARM64 samples stay separate from AMD64. The existing Mac user checkout stays untouched.

M/native YAML already fails its separate net comparison against the qualified fallback. This relative E-vs-M screen does not change that hold. No work exception, allowlist, source pin or runtime behavior changes.

[Archive hashes](benchmarks/20261021-fused-checkpoint-screen/archives.json), [member hashes](benchmarks/20261021-fused-checkpoint-screen/archive-members.json) and [public derivations](benchmarks/20261021-fused-checkpoint-screen/redaction-derivations.json) retain source replay, focused evidence, all measurements, initial failures and statistics. Public files substitute private worker/path labels; numerical samples and assertions remain unchanged. Original protocol hashes identify historical private bytes; derivations identify changed labels.

# Paged native publication, current YAML ownership

Held after full correctness qualification. This source adds indexed pages for native publication records to the separately held current-layout ownership and packed-mask source. It preserves stable record addresses, exact memory charges for unused slots and page pointers, and clears every public pointer on success, rejection, and pool reset.

The correctness and work gates pass: 206 languages × 72 edit steps with zero-allocation no-edit reparses; 618 C fixtures; 204 strict rows (only YAML changes route, still C-exact); 50 whole-request/public YAML counter comparisons; four exact canonical Go work vectors and digests; no change to the 39 known expanded Go C failures; scoped races and native/386 publication, snapshot, and accounting checks. Pins cover 3,532 Go files. See full-counter-gate.json and audit-completed.py.

The RSS qualification retains all six initial and 120 matched probes, seeds 42301–42320. All candidates remain below 400 bytes/source byte. Candidate/baseline median ratios are Go 0.999318, ordinary YAML 1.301437, and diagnostic-owned YAML 0.898752. Ordinary YAML still fails the 1.10 relative ratchet. No before/after timing comparison was run and no runtime, allowlist, budget, or counter baseline was promoted.

The preceding packed-mask version failed at ordinary YAML ratio 1.337192. Those two independently shuffled runs do not establish the causal size of the paging change. The current result rules out publication-buffer growth as a sufficient fix for the ordinary YAML RSS gap. Further work must address the compact parse's live graph, checkpoint, and publication overlap while preserving exact ownership and authentication.

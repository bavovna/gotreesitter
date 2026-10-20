# Ordinary YAML ownership remains held on memory

The private current-layout ownership candidate preserves the locked-C tree on ordinary YAML, including the 8 KiB EOF witness and 1 MiB document streams. Immutable packed scanner trial masks and paged native publication also pass the full work and correctness gates. Neither source can be promoted: ordinary YAML median RSS rises 33.72% / 30.14% against the existing fallback path, exceeding the 10% relative ratchet. Every probe is retained and stays below the absolute ceiling.

[Raw evidence and source/protocol archives](benchmarks/20261020-yaml-ordinary-memory/README.md) contain both experiments: 206 × 72-step edit sessions; 618 C checks; 204 strict rows with 45 unchanged legacy failures; four exact canonical Go vectors; the same 39 expanded Go C failures; 50 whole-request/public YAML counter comparisons; budget, pooling and race checks. The paging variant also passes scoped native/386 publication and snapshot checks.

Ordinary YAML public node construction falls 288→232 on R4 and 1,156→925 at 8 KiB. Whole-request token work falls 124→107 / 441→423, including the old failed compact attempt. All other ordinary ledger rows are exact. Diagnostic-owned R4 node construction falls 484→232. Neither variant includes the separately held Go correctness repair.

No before/after timing comparison was run after the memory failures. No runtime, allowlist, budget, production counter pin, or approval state changes. The results identify a remaining memory problem in the overlap of compact graph, checkpoint and public-tree storage; eliminating publication-buffer growth alone is insufficient.

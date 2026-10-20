# Prepared YAML scanner bindings

The combined binding change reduces ordinary R4 YAML time 2.60% (p=.028) and
legacy R4 time 2.07% (p=.017) against f28a3c1cfca394fa378bf5994fead01c3886e73b.
The other four YAML and all six Go timings are inconclusive. The sharing-only
trial is separate; its percentages are not added to this measured result.

The YAML value scanner holds one pointer to its immutable token mapping.
Binding also proves whether external indices equal semantic indices. A complete
113-element identity mask can then be used read-only. Empty, short, long,
reordered, sparse, duplicate and unknown mappings retain general remapping.
Zero-value symbols, concrete pointer binding, public methods, owned input data,
rebinding and independent payloads are covered. Scanner callbacks, checkpoint
capture, serialization and language routing remain authoritative. The private
binding holder adds cold construction storage; warm YAML heap medians are exact.

Source: 3524 Go files, with three changed files in grammars/runtime (one
implementation, two tests). All root/core Go source and benchmark inputs match
f28. The public branch inherits one changed CI-planner test from PR1488 and isolates
two forced-profile Kotlin tests. public-source-composition.json pins both test-only
differences from the qualified Go code. All runtime and benchmark hashes match.
There is no API snapshot, work pin, owner exception or allowlist change.

All 414 complete ledger rows and four canonical tree/work vectors are exact.
The affected-language gate is YAML: ordinary and owned 72-step sessions, three
C fixtures, strict R4, large document-stream C witnesses, parse race, scanner
race/386, memory/pooling and API/L0/R6 pass. Supplemental C keeps 417/723 passes,
306 known failures and every public work/route vector. Other languages' edit/C
sessions were not rerun: their engine and grammar implementation is unchanged.
This is not an all-input C certificate. The Go correctness repair is absent.

All 126 initial+matched RSS probes pass. Candidate maximum including initial
samples is 305.261 B/source byte. Median RSS ratios are Go .986282,
ordinary YAML 1.019106 and owned YAML .962962. All 480 timing rows complete,
with twenty distinct matched orders per language, alternating process order,
GOMAXPROCS=1, count=1 per process, 750ms, benchmem and normal limits/pools.
Seeds: RSS 41201..41220, YAML 41301..41320, Go 41401..41420. Time, object and
byte ratchets pass; no-edit heap is zero. Retain all Go directions, including
full DFA +5.59% (p=.341), grammargen +4.99% (p=.157), and no-edit +6.90%
(p=.060). No Go speedup or causal attribution is claimed.

The compiler inlines semanticValidity at cost 73 and reports no mask heap
escape. Its diagnostic log is in the RSS archive. The Scan wrapper frame is
56 bytes versus 560 previously; assembly-provenance.json states the different
binary contexts. These compiler results are attribution, separate from timings.

Five archives and every member hash/size are pinned in archive-manifest.json.
The separate kotlin-test-isolation.tar.gz contains the original failure controls,
the test-only overlay and fixed repetitions; it does not change scanner evidence.
Source-and-protocol contains full Go manifests, the three changed files,
qualification helpers, overlays, assembly and fresh-run scripts. Other archives
store observations under observed/, including known failures. No executable or
new-run completion marker is supplied as protocol. Reference ledger/canonical
observations reuse the same f28 source/helpers; baseline-reuse.json pins them.
Replay regenerates reference observations before candidate qualification.

For replay, prepare a clean f28 reference and a separate copy for candidate.
Extract source-and-protocol into an empty evidence directory, verify reference
pins, copy candidate-files over candidate and verify candidate pins. Keep saved
observations separate. Mount sources at /reference and /candidate read-only;
fresh evidence at /evidence. Use the recorded Go1.25.14 image
sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6GiB, CPU6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Run
bash /evidence/replay-qualification.sh. For RSS mount the evidence root at
/lab and its rss directory at /evidence and run bash /evidence/run.sh. Restore
the original /evidence mount, then run bash /evidence/perf.sh and
python3 /evidence/analyze-perf.py plus benchstat. A writable locked-C cache
remains at /workspace/harness_out/parity_c_ref_cache/linux_amd64.

This is a grammar-owned scanner/Q-lane component, related to #1308 without
completing its checkpoint work. Core PR1488 merged as
2769aea23c6c8621db5368b6d9c3257bcb3c9b25 after 74 successful checks and four
skips. This PR is based on main and requires its own current CI before merging. Ordinary YAML compact ownership,
Go throughput and compact graduation remain open.

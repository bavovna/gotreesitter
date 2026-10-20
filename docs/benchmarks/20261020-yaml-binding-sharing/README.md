# YAML shared binding: held screen

The immutable binding removes table copies in the compiler output but has no
supported YAML throughput win in this comparison. All six YAML timings are
inconclusive. The Go no-edit control rises 2.76% (p=.003); it still allocates
zero. No parser source, work pin, API snapshot or route changes in this receipt.
The later prepared-validity prototype is separate and has no results here.

Baseline: f28a3c1cfca394fa378bf5994fead01c3886e73b, the qualified 32-byte-wrapper
branch in PR1488. It has 3524 Go files. The candidate changes three files in
grammars/runtime, one implementation and two tests. It shares a private immutable
symbol mapping while keeping the public value scanner, zero value, concrete
pointer binding and independent payloads. Bound symbol-table zero fallback runs
once. Constructor storage adds one cold binding holder; warm allocated bytes
and object medians are unchanged for every YAML workload.

The compiler wrapper frame shrinks 560 to 56 bytes and two mapping-copy calls
are absent. assembly-provenance.json limits that comparison: the older profile
binary has identical YAML scanner source to f28, while the new binary is the
focused package binary. This attribution is not a controlled runtime result.

All 414 complete ledger rows and four canonical vectors match the same frozen
reference and unchanged helpers. Reference ledger/canonical observations are
reused and pinned by baseline-reuse.json; candidate observations are fresh.
The affected-language scope is YAML: ordinary and owned 72-step edit sessions,
three C fixture checks, strict R4, both large document-stream witnesses, parsing
race, memory/pooling and scanner unit/race/386 pass. All 723 supplemental C
outcomes and public vectors are equal: 417 pass and 306 known failures remain.
This is not an all-input C certificate. All 12 root API tag sets and L0/R6 pass.

All 126 initial+matched RSS observations pass. Candidate maximum including
initial samples is 301.800 B/source byte. Median ratios are Go 1.011126,
ordinary YAML .970780 and owned YAML .988096. All 480 timing rows complete:
20 distinct matched shuffled orders per language, alternating process order,
GOMAXPROCS=1, count=1 per process, 750ms, benchmem and normal limits/pools.
YAML seeds 41001..41020; Go 41101..41120; RSS 40901..40920. All comparative
ratchets pass; every timing direction remains in the two benchstat files.

Four archives and all member hashes/sizes are in archive-manifest.json. Source
and protocol contain full source pins and the three changed files, test helpers,
overlays, scripts and assembly evidence. Other archives preserve observations
under observed/, including known failures and the initial setup failure. No
executable or new-run completion marker is supplied as protocol.

For replay, use clean f28 reference source and a separate copy as candidate.
Extract source-and-protocol in an empty evidence directory; verify reference
pins, copy candidate-files over candidate and verify candidate pins. Keep saved
observations separate from the new evidence directory. Mount source trees at
/reference and /candidate read-only and fresh evidence at /evidence. Use the
recorded Go1.25.14 image
sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6GiB, CPU6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Run
bash /evidence/replay-qualification.sh; it rebuilds reference evidence and fresh
candidate checks. RSS uses the evidence root at /lab and its fresh rss directory
at /evidence; run bash /evidence/run.sh. Restore the evidence-root /evidence
mount and run bash /evidence/perf.sh, then python3 /evidence/analyze-perf.py and
benchstat. The scripts require successful qualification and RSS before timing.
A writable locked-C cache remains at
/workspace/harness_out/parity_c_ref_cache/linux_amd64.

Ordinary YAML still falls back, the earlier Go correctness repair is absent,
and compact graduation remains open. This receipt is documentation only.

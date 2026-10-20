# Immutable reduction-plan values: held screen

All 480 timing rows complete and all comparative ratchets pass. Every timing
difference is inconclusive; warm allocated bytes are effectively unchanged.
The smaller value is **not promoted**. Go edit time moves +5.34% (p=.289),
grammargen +4.42% (p=.157), and owned YAML 8 KiB +4.85% (p=.738).
All directions remain in the two benchstat files. All 126 RSS probes pass,
including initial probes; candidate maximum is 293.730 B/source byte.
Median RSS ratios are Go 1.001191, ordinary YAML .994880, owned YAML .985340.

The source, protocol, raw outcomes and archive members are pinned by
archive-manifest.json. No parser source changes accompany this receipt.


Baseline: f28a3c1cfca394fa378bf5994fead01c3886e73b (3524 Go files).
The candidate changes five internal files, including two new files, and has
3526 Go files. ReductionPlan goes from 56 to 16 bytes on amd64, and 28 to 8
on 386. Full production IDs, structural child counts, fields and aliases stay
intact. The constructor still validates before allocation and snapshots input
slices. Empty metadata needs no holder; nonempty metadata adds a shared immutable
holder allocation at plan construction. Do not infer fewer total allocations
from the smaller value. Existing provider callbacks and root adapter APIs remain.

All 414 complete ledger rows and four canonical tree/work vectors are exact.
206 ordinary 72-step sessions plus explicit owned YAML, 618 C fixture checks,
the exact 204-row strict census, 306 unchanged expanded Go outcomes, large Go
and YAML C witnesses, scoped races, memory/pooling, 386 and API/layout/R6 pass.
Known failures remain 45 strict legacy cases and 39 expanded Go cases. No work
exception, allowlist, selector or routing change is included.

The baseline raw ledger/canonical/strict observations were reused from the
immediately preceding borrowed-plan screen: exact same f28 source and overlay
helpers. baseline-reuse.json records every relevant hash; original raw outcomes
are included. Candidate observations are fresh. A replay regenerates both roles.

Use source-and-protocol.tar.gz in an empty evidence directory, a clean f28
reference source, and a separate copy for candidate. Verify reference-source-pins.json,
then copy candidate-files over candidate and verify candidate-source-pins.json.
Do not extract observed results into the fresh evidence directory. Every saved
observation lives under observed/ in the other archives, and no executable or
new-run completion marker is supplied as protocol.

Mount the sources read-only at /reference and /candidate, fresh evidence at
/evidence, and a writable C-reference cache at
/workspace/harness_out/parity_c_ref_cache/linux_amd64. Use the recorded Go 1.25.14
image sha256:187907888b4bdc6f326c87b045718339e5f665baceb27db6b74633ca41e996df,
6 GiB, CPU 6, GOMEMLIMIT=5GiB, GOMAXPROCS=1 and both repository locks. Run
bash /evidence/replay-qualification.sh first. It runs focused checks, regenerates
baseline, runs all candidate gates and audits complete work direction.

For RSS mount the evidence directory at /lab and its fresh rss directory at
/evidence, keeping source mounts; run bash /evidence/run.sh. This builds fresh
binaries and retains six initial plus 120 matched observations, seeds
40601..40620, one grammar/process. It requires the completed qualification gate.
Restore the original /evidence mount, then run bash /evidence/perf.sh. It requires
both qualification and RSS completion and runs 20 matched alternating pairs per
language: YAML 40401..40420, Go 40501..40520, six shuffled workloads, 750ms,
count=1 per process and benchmem with normal limits/pools. Analyze with
python3 /evidence/analyze-perf.py and benchstat. No fixed-order comparison is used.

The borrowed pointer-provider prototype is separate: its root adapter method
failed the API gate, so it has no timing/RSS samples and never ran fleet/C gates.
Its four source files, source pins, focused outcomes and exact API failure remain
in rejected-borrowed-prototype.tar.gz. API snapshots were not changed.

The later PR1488 CI wiring changes one planner test and its workflow registration;
all runtime and benchmark Go files are identical to this baseline. This experiment
does not include the pending private Go correctness repair or ordinary YAML
ownership activation. It does not establish compact graduation.

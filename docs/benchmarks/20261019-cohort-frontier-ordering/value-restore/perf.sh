#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/restore-counter-gate.json
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/perf-overlay.json' GIT_OPTIONAL_LOCKS=0
git config --global --add safe.directory /workspace
git config --global --add safe.directory /baseline
cd /workspace
go test . -tags gts_parsercorephase0 -race -run '^TestPrototype(DFATerminalSourceRejectsChangedOrigin|DFADispatchRestoresNestedPanicWithoutAllocating)$' -count=1 -v -timeout=8m > /evidence/restore-race.log 2>&1
export GTS_ADMISSION_REAL_CORPUS_LANGS=go
bash scripts/run_randomized_benchmarks.sh --output /evidence/go-after.txt --baseline-root /baseline --baseline-output /evidence/go-before.txt --bench-regex '^Benchmark(DFADispatchRestoreCanonical|GoParseFullDFA|GoParseIncrementalSingleByteEditDFA|GoParseIncrementalNoEditDFA|AdmissionR4Compact)$' --require-benchmarks BenchmarkDFADispatchRestoreCanonical/rewrite,BenchmarkDFADispatchRestoreCanonical/query_compile,BenchmarkDFADispatchRestoreCanonical/language,BenchmarkDFADispatchRestoreCanonical/grammargen_lr,BenchmarkGoParseFullDFA,BenchmarkGoParseIncrementalSingleByteEditDFA,BenchmarkGoParseIncrementalNoEditDFA,BenchmarkAdmissionR4Compact --runs 20 --seed-start 34501 --benchtime 750ms > /evidence/perf-go.log 2>&1
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml
bash scripts/run_randomized_benchmarks.sh --output /evidence/yaml-after.txt --baseline-root /baseline --baseline-output /evidence/yaml-before.txt --bench-regex '^Benchmark(AdmissionR4Compact|AdmissionR4OwnedExternalLexer|AdmissionYAMLDocumentStreamOwned)$' --require-benchmarks BenchmarkAdmissionR4Compact,BenchmarkAdmissionR4OwnedExternalLexer,BenchmarkAdmissionYAMLDocumentStreamOwned --runs 20 --seed-start 34601 --benchtime 750ms > /evidence/perf-yaml.log 2>&1
printf 'complete\n' > /evidence/perf-complete.txt

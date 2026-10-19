#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/counter-gate.json
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json' GIT_OPTIONAL_LOCKS=0
git config --global --add safe.directory /workspace
git config --global --add safe.directory /baseline
mkdir /evidence/perf
cd /workspace
go version > /evidence/perf/environment.log
export GTS_ADMISSION_REAL_CORPUS_LANGS=go
bash scripts/run_randomized_benchmarks.sh --output /evidence/perf/go-after.txt --baseline-root /baseline --baseline-output /evidence/perf/go-before.txt --bench-regex '^Benchmark(ParserCoreFreshFullCanonical|GoParseFullDFA|GoParseIncrementalSingleByteEditDFA|GoParseIncrementalNoEditDFA|AdmissionR4Compact)$' --require-benchmarks BenchmarkParserCoreFreshFullCanonical/rewrite,BenchmarkParserCoreFreshFullCanonical/query_compile,BenchmarkParserCoreFreshFullCanonical/language,BenchmarkParserCoreFreshFullCanonical/grammargen_lr,BenchmarkGoParseFullDFA,BenchmarkGoParseIncrementalSingleByteEditDFA,BenchmarkGoParseIncrementalNoEditDFA,BenchmarkAdmissionR4Compact --runs 20 --seed-start 34701 --benchtime 750ms > /evidence/perf/perf-go.log 2>&1
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml
bash scripts/run_randomized_benchmarks.sh --output /evidence/perf/yaml-after.txt --baseline-root /baseline --baseline-output /evidence/perf/yaml-before.txt --bench-regex '^Benchmark(AdmissionR4Compact|AdmissionR4OwnedExternalLexer|AdmissionYAMLDocumentStreamOwned)$' --require-benchmarks BenchmarkAdmissionR4Compact,BenchmarkAdmissionR4OwnedExternalLexer,BenchmarkAdmissionYAMLDocumentStreamOwned --runs 20 --seed-start 34801 --benchtime 750ms > /evidence/perf/perf-yaml.log 2>&1
printf 'complete\n' > /evidence/perf/complete.txt

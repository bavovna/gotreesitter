#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/full-counter-gate.json
test -f /evidence/rss-v2/complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay-v2.json' GIT_OPTIONAL_LOCKS=0 GTS_ADMISSION_CANDIDATE=1
mkdir /evidence/perf-v2
cd /workspace
go version > /evidence/perf-v2/environment.log
export GTS_ADMISSION_REAL_CORPUS_LANGS=go
bash scripts/run_randomized_benchmarks.sh --output /evidence/perf-v2/go-after.txt --baseline-root /reference --baseline-output /evidence/perf-v2/go-before.txt --bench-regex '^Benchmark(ParserCoreFreshFullCanonical|GoParseCompactFreshOneMiB|GoParseFullDFA|GoParseIncrementalSingleByteEditDFA|GoParseIncrementalNoEditDFA|AdmissionR4Compact)$' --require-benchmarks BenchmarkParserCoreFreshFullCanonical/rewrite,BenchmarkParserCoreFreshFullCanonical/query_compile,BenchmarkParserCoreFreshFullCanonical/language,BenchmarkParserCoreFreshFullCanonical/grammargen_lr,BenchmarkGoParseCompactFreshOneMiB,BenchmarkGoParseFullDFA,BenchmarkGoParseIncrementalSingleByteEditDFA,BenchmarkGoParseIncrementalNoEditDFA,BenchmarkAdmissionR4Compact --runs 20 --seed-start 35401 --benchtime 750ms > /evidence/perf-v2/perf-go.log 2>&1
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml
bash scripts/run_randomized_benchmarks.sh --output /evidence/perf-v2/yaml-after.txt --baseline-root /reference --baseline-output /evidence/perf-v2/yaml-before.txt --bench-regex '^Benchmark(AdmissionR4Compact|AdmissionR4OwnedExternalLexer|AdmissionYAMLDocumentStreamOwned)$' --require-benchmarks BenchmarkAdmissionR4Compact,BenchmarkAdmissionR4OwnedExternalLexer,BenchmarkAdmissionYAMLDocumentStreamOwned --runs 20 --seed-start 35501 --benchtime 750ms > /evidence/perf-v2/perf-yaml.log 2>&1
printf 'complete\n' > /evidence/perf-v2/complete.txt

#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/check-complete.txt
test -f /evidence/consumed-check-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/perf-overlay.json'
export GIT_OPTIONAL_LOCKS=0
git config --global --add safe.directory /workspace
git config --global --add safe.directory /baseline
python3 - <<'GATE'
from pathlib import Path
import json,hashlib
p=Path('/evidence');assert json.loads((p/'counter-gate.json').read_text())['exact_rows']==414;assert json.loads((p/'consumed-gate.json').read_text())['exact_vectors']==5
for n,h in json.loads((p/'source-pins.json').read_text()).items():assert hashlib.sha256((p/'runtime'/n).read_bytes()).hexdigest()==h,n
GATE
cd /workspace
export GTS_ADMISSION_REAL_CORPUS_LANGS=go
bash scripts/run_randomized_benchmarks.sh --output /evidence/go-head.txt --baseline-root /baseline --baseline-output /evidence/go-base.txt --bench-regex '^Benchmark(ParserCoreFreshFullCanonical|GoParseFullDFA|GoParseIncrementalSingleByteEditDFA|GoParseIncrementalNoEditDFA|AdmissionR4Compact)$' --require-benchmarks BenchmarkParserCoreFreshFullCanonical/rewrite,BenchmarkParserCoreFreshFullCanonical/query_compile,BenchmarkParserCoreFreshFullCanonical/language,BenchmarkParserCoreFreshFullCanonical/grammargen_lr,BenchmarkGoParseFullDFA,BenchmarkGoParseIncrementalSingleByteEditDFA,BenchmarkGoParseIncrementalNoEditDFA,BenchmarkAdmissionR4Compact --runs 20 --seed-start 34001 --benchtime 750ms > /evidence/perf-go.log 2>&1
export GTS_ADMISSION_REAL_CORPUS_LANGS=yaml
bash scripts/run_randomized_benchmarks.sh --output /evidence/yaml-head.txt --baseline-root /baseline --baseline-output /evidence/yaml-base.txt --bench-regex '^Benchmark(AdmissionR4Compact|AdmissionR4OwnedExternalLexer|AdmissionYAMLDocumentStreamOwned)$' --require-benchmarks BenchmarkAdmissionR4Compact,BenchmarkAdmissionR4OwnedExternalLexer,BenchmarkAdmissionYAMLDocumentStreamOwned --runs 20 --seed-start 34101 --benchtime 750ms > /evidence/perf-yaml.log 2>&1
printf 'complete\n' > /evidence/perf-complete.txt

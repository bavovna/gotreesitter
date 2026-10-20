#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test -c -tags gts_parsercorephase0 -o /evidence/runtime.test . > /evidence/build.log 2>&1
for name in yaml_r4 yaml_8k go;do
 case "$name" in
 yaml_r4) lang=yaml;bench='^BenchmarkAdmissionR4OwnedExternalLexer$';iterations=2000x;;
 yaml_8k) lang=yaml;bench='^BenchmarkAdmissionYAMLDocumentStreamOwned$';iterations=500x;;
 go) lang=go;bench='^BenchmarkAdmissionR4Compact$';iterations=1000x;;
 esac
 GTS_ADMISSION_REAL_CORPUS_LANGS="$lang" /evidence/runtime.test -test.run '^$' -test.bench "$bench" -test.benchtime "$iterations" -test.count=1 -test.benchmem -test.memprofilerate=1 -test.memprofile /evidence/$name.mem > /evidence/$name.log 2>&1
 go tool pprof -top -alloc_objects -nodecount=25 -focus 'benchmarkAdmissionR4|BenchmarkAdmissionYAMLDocumentStreamOwned' /evidence/runtime.test /evidence/$name.mem > /evidence/$name.objects.txt
 go tool pprof -top -alloc_space -nodecount=25 -focus 'benchmarkAdmissionR4|BenchmarkAdmissionYAMLDocumentStreamOwned' /evidence/runtime.test /evidence/$name.mem > /evidence/$name.bytes.txt
 echo "$name allocation attribution collected (profile timings are not comparison evidence)"
done
export GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/census-overlay.json'
for name in yaml_r4 yaml_8k go;do
 case "$name" in
 yaml_r4) lang=yaml;bench='^BenchmarkAdmissionR4OwnedExternalLexer$';;
 yaml_8k) lang=yaml;bench='^BenchmarkAdmissionYAMLDocumentStreamOwned$';;
 go) lang=go;bench='^BenchmarkAdmissionR4Compact$';;
 esac
 GTS_ADMISSION_REAL_CORPUS_LANGS="$lang" go test . -tags gts_parsercorephase0 -run '^$' -bench "$bench" -benchtime=1x -count=1 -timeout=5m > /evidence/$name-fields.log 2>&1
 echo "$name field population census completed (untimed)"
done
printf 'complete\n' > /evidence/complete.txt

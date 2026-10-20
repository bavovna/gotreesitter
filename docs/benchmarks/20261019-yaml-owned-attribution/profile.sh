#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/local/go/bin:$PATH GOWORK=off GOMAXPROCS=1 GTS_ADMISSION_CANDIDATE=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/profile-overlay.json'
cd /reference
go test . -tags gts_parsercorephase0 -run '^$' -bench '^BenchmarkStreamedPrefixYAML/eof8k_owned$' -benchtime=8s -count=1 -cpuprofile=/evidence/yaml-owned-cpu.pprof -o /evidence/yaml-owned-cpu.test > /evidence/cpu-run.log 2>&1
go tool pprof -top -nodecount=35 /evidence/yaml-owned-cpu.test /evidence/yaml-owned-cpu.pprof > /evidence/cpu-flat.txt
go tool pprof -top -cum -nodecount=65 /evidence/yaml-owned-cpu.test /evidence/yaml-owned-cpu.pprof > /evidence/cpu-cum.txt
go test . -tags gts_parsercorephase0 -run '^$' -bench '^BenchmarkStreamedPrefixYAML/eof8k_owned$' -benchtime=4s -count=1 -memprofilerate=65536 -memprofile=/evidence/yaml-owned-alloc.pprof -o /evidence/yaml-owned-alloc.test > /evidence/alloc-run.log 2>&1
go tool pprof -top -alloc_space -nodecount=25 /evidence/yaml-owned-alloc.test /evidence/yaml-owned-alloc.pprof > /evidence/alloc-space.txt
go tool pprof -top -alloc_objects -nodecount=25 /evidence/yaml-owned-alloc.test /evidence/yaml-owned-alloc.pprof > /evidence/alloc-objects.txt
printf 'complete\n' > /evidence/complete.txt

#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/profile-overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^$' -bench '^BenchmarkDiagnosticCohortFrontierProfile$' -benchtime=5s -count=1 -benchmem -cpuprofile=/evidence/diagnostic.cpu -memprofile=/evidence/diagnostic.mem -o /evidence/profile-diagnostic-root.test -timeout=8m > /evidence/profile-diagnostic.log 2>&1
go tool pprof -top -nodecount=24 /evidence/profile-diagnostic-root.test /evidence/diagnostic.cpu > /evidence/cpu-top.txt
go tool pprof -top -alloc_space -nodecount=16 /evidence/profile-diagnostic-root.test /evidence/diagnostic.mem > /evidence/allocation-top.txt
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 for lang in go yaml;do
  go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs "$lang" > "/evidence/$role-$lang-ledger.json" 2> "/evidence/$role-$lang-ledger.log"
 done
 GTS_LAYOUT_OWNED_PROBE=1 go run -tags gts_parsercorephase0 ./cmd/perfcounterledger --langs yaml > "/evidence/$role-owned-yaml-ledger.json" 2> "/evidence/$role-owned-yaml-ledger.log"
done
printf 'complete\n' > /evidence/profile-complete.txt

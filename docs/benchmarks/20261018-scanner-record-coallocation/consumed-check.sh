#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/check-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/perf-overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestS5RunOwned(DeclinesTokenCountAboveUint16Range|TokenCountAtUint16LimitIsNotDeclinedByTheGuard)$' -count=1 -v -timeout=8m > /evidence/recovery-frontier.log 2>&1
for role in base head;do
 if [[ $role == base ]];then cd /baseline;else cd /workspace;fi
 go test . -tags gts_parsercorephase0,gts_workcount -run '^TestDeferredPublicationWorkCensus$' -count=1 -v -timeout=8m > /evidence/$role-work.log 2>&1
 go test . -tags gts_parsercorephase0 -run '^$' -bench '^BenchmarkCompactGoFullConsume$' -benchtime=1x -count=1 -benchmem -timeout=8m > /evidence/$role-consume-preflight.log 2>&1
 echo "$role full-consumption preflight passed (no timing comparison)"
done
python3 - <<'GATE'
from pathlib import Path
import json
p=Path('/evidence')
def read(role):return [json.loads(l.split('PUBLICATION_WORK_CENSUS ',1)[1]) for l in (p/f'{role}-work.log').read_text().splitlines() if 'PUBLICATION_WORK_CENSUS ' in l]
a,b=read('base'),read('head');assert len(a)==5 and a==b
(p/'consumed-gate.json').write_text(json.dumps({'exact_vectors':5,'complete_work_and_deep_digests_equal':True},indent=2)+'\n')
GATE
printf 'complete\n' > /evidence/consumed-check-complete.txt

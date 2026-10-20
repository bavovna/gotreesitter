#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/screen-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test -c -tags gts_parsercorephase0 -coverpkg=github.com/odvcencio/gotreesitter/internal/parsercorephase0 -covermode=count -o /evidence/coverage.test . > /evidence/coverage-build.log 2>&1
for name in go yaml_owned;do
 if [[ $name == go ]];then lang=go;bench='^BenchmarkAdmissionR4Compact$';else lang=yaml;bench='^BenchmarkAdmissionYAMLDocumentStreamOwned$';fi
 GTS_ADMISSION_REAL_CORPUS_LANGS=$lang /evidence/coverage.test -test.run '^$' -test.bench "$bench" -test.benchtime=1x -test.count=1 -test.coverprofile=/evidence/$name.cover > /evidence/$name-coverage.log 2>&1
done
python3 - <<'COUNTS'
from pathlib import Path
import json
p=Path('/evidence')
def line(file,needle):return next(i for i,s in enumerate((p/'coverage-core'/file).read_text().splitlines(),1) if needle in s)
def hits(rows,file,n):
 for row in rows:
  if '/'+file+':' not in row:continue
  location,statements,count=row.split();lo,hi=[int(x.split('.')[0]) for x in location.rsplit(':',1)[1].split(',')]
  if lo<=n<=hi:return int(count)
 return 0
result={}
for name in ['go','yaml_owned']:
 rows=(p/f'{name}.cover').read_text().splitlines()
 n=hits(rows,'reduction_owner.go',line('reduction_owner.go','published = err == nil'))
 all=hits(rows,'scheduler_owned.go',line('scheduler_owned.go','func (c *Core) reduceOutputsClassifiedIntoActive('))
 entered=hits(rows,'reduction_owner.go',line('reduction_owner.go','if err = c.beginSchedulerOwned(owner)'))
 scalar=hits(rows,'reduction_owner.go',line('reduction_owner.go','err = c.publishShiftLineage'))
 assert n>0 and entered>=n and all>=entered,(name,n,entered,all)
 result[name]=dict(combined_publications=n,eligible_entry_calls=entered,all_core_reduction_calls=all,scalar_publications=scalar,combined_fraction=n/all)
result['scope']='Count-mode setup/activation only; not timing or corpus-wide coverage'
(p/'activation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
COUNTS
printf 'complete\n' > /evidence/coverage-complete.txt

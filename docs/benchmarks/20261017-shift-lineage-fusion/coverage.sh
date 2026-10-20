#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
GTS_ADMISSION_REAL_CORPUS_LANGS=go go test . -tags gts_parsercorephase0 -coverpkg=github.com/odvcencio/gotreesitter/internal/parsercorephase0 -covermode=count -coverprofile=/evidence/owner.cover -run '^$' -bench '^BenchmarkAdmissionR4Compact$' -benchtime=1x -count=1 -timeout=5m > /evidence/owner-coverage.log 2>&1
python3 - <<'COVER'
from pathlib import Path
p=Path('/evidence');src=(p/'runtime/internal/parsercorephase0/shift_owner.go').read_text().splitlines();assign=next(i for i,l in enumerate(src,1) if 'ownerPublished = err == nil' in l)
rows=[]
for l in (p/'owner.cover').read_text().splitlines():
 if '/shift_owner.go:' in l:
  location,statements,count=l.split();span=location.rsplit(':',1)[1];lo,hi=[int(x.split('.')[0]) for x in span.split(',')];rows.append((lo,hi,int(count)))
assert any(lo<=assign<=hi and count>0 for lo,hi,count in rows),'new owner write not exercised by public Go setup probe'
(p/'owner-coverage-proof.txt').write_text(f'Public Go setup probe executed owner publication at line {assign}; block coverage {rows}. No comparison timing claim.\n')
src2=(p/'coverage-core/scheduler_owned.go').read_text().splitlines()
func=next(i for i,l in enumerate(src2,1) if 'func (c *Core) shiftDirectUncheckpointed(' in l)
entry=next(i for i,l in enumerate(src2,1) if i>func and 'node, err := c.node(head.Node)' in l)
def hits(file,line):
 for text in (p/'owner.cover').read_text().splitlines():
  if '/'+file+':' not in text:continue
  location,statements,count=text.split();lo,hi=[int(x.split('.')[0]) for x in location.rsplit(':',1)[1].split(',')]
  if lo<=line<=hi:return int(count)
 return 0
count=hits('shift_owner.go',assign);total=hits('scheduler_owned.go',entry)
(p/'owner-counts.json').write_text(__import__('json').dumps({'fused_owner_writes':count,'direct_shifts':total,'fraction':count/total if total else None,'mode':'count','purpose':'execution mix only; not comparison timing evidence'},indent=2)+'\n')
print('public Go benchmark setup exercises the fused owner write; coverage timings are not comparison evidence',flush=True)
COVER
printf 'complete\n' > /evidence/coverage-complete.txt

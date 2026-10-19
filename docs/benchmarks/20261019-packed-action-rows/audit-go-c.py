from pathlib import Path
from collections import Counter
import json,re,sys
p=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parent/'out'
results={};routes={}
for role in ['baseline','candidate']:
 text=(p/f'{role}-expanded-go-c.log').read_text()
 rows={name:status for status,name in re.findall(r'--- (PASS|FAIL): ((?:TestGoTokenTurnExpandedLockedCProbe|TestGoGenericCallFrontierLockedCProbe)/[^\s]+)',text)}
 assert len(rows)==306,(role,len(rows))
 by_case={};current=None
 for line in text.splitlines():
  if line.startswith('=== RUN   '):current=line.split('=== RUN   ',1)[1].strip()
  match=re.search(r'EXPANDED_ROUTE compact=(\d+) fallback=(\d+)',line)
  if match:
   assert current and current.startswith('TestGoTokenTurnExpandedLockedCProbe/'),current
   assert current not in by_case,current
   by_case[current]=[int(match[1]),int(match[2])]
 assert len(by_case)==300,(role,len(by_case))
 assert Counter(tuple(v) for v in by_case.values())==Counter({(1,0):90,(0,1):210}),role
 results[role]=rows;routes[role]=by_case
assert results['baseline']==results['candidate'],'expanded C behavior changed'
assert routes['baseline']==routes['candidate'],'expanded routes changed'
expanded=[v for k,v in results['candidate'].items() if k.startswith('TestGoTokenTurnExpandedLockedCProbe/')]
assert expanded.count('PASS')==261 and expanded.count('FAIL')==39
report=dict(total_cases=306,expanded_pass=261,expanded_known_fail=39,all_306_statuses_equal=True,new_failures=0,targeted_cases=6,expanded_routes_exact=300,expanded_compact_routes=90,expanded_fallback_routes=210,baseline=results['baseline'],candidate=results['candidate'],baseline_routes=routes['baseline'],candidate_routes=routes['candidate'])
(p/'expanded-go-c-audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k not in ['baseline','candidate','baseline_routes','candidate_routes']}))

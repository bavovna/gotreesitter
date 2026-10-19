#!/usr/bin/env python3
import hashlib
import json
import re
from collections import defaultdict
from pathlib import Path
from statistics import median

lab=Path(__file__).resolve().parent
assert (lab/'perf/complete.txt').read_text().strip()=='complete'
assert json.loads((lab/'full-counter-gate.json').read_text())['work_direction_passed']
expected={
 'go':{'BenchmarkGoParseFullDFA','BenchmarkGoParseIncrementalSingleByteEditDFA','BenchmarkGoParseIncrementalNoEditDFA','BenchmarkStreamedPrefixGo/query_compile','BenchmarkStreamedPrefixGo/grammargen_lr','BenchmarkGoParseCompactFreshOneMiB'},
 'yaml':{'BenchmarkStreamedPrefixYAML/'+name for name in ['r4_legacy','eof8k_legacy','r4_ordinary','eof8k_ordinary','r4_owned','eof8k_owned']}}
results={};ratchets=[];rows=0
for language,names in expected.items():
 roles={}
 for role,suffix in [('baseline','before'),('candidate','after')]:
  content=(lab/f'perf/{language}-{suffix}.txt').read_text()
  assert '# status: complete' in content and 'FAIL' not in content
  start=38401 if language=='go' else 38301
  assert f'# seeds: {start}..{start+19}' in content
  data=defaultdict(list)
  for line in content.splitlines():
   if not line.startswith('Benchmark'):continue
   fields=line.split();name=re.sub(r'-[0-9]+$','',fields[0]);assert name in names,name
   metrics={fields[i+1]:float(fields[i]) for i in range(2,len(fields),2)}
   assert {'ns/op','B/op','allocs/op'} <= metrics.keys(),line
   data[name].append(metrics);rows+=1
  assert set(data)==names and all(len(v)==20 for v in data.values())
  roles[role]=data
 results[language]={}
 for name in sorted(names):
  a,b=roles['baseline'][name],roles['candidate'][name]
  units=set(a[0]);assert all(set(v)==units for v in a+b)
  custom={}
  for unit in units-{'ns/op','B/op','allocs/op','MB/s'}:
   left={r[unit] for r in a};right={r[unit] for r in b}
   assert len(left)==len(right)==1,(name,unit)
   before,after=next(iter(left)),next(iter(right));custom[unit]=[before,after]
   assert before==after,(name,unit)
  medians={unit:{'before':median(v[unit] for v in a),'after':median(v[unit] for v in b)} for unit in ['ns/op','B/op','allocs/op']}
  for unit,value in medians.items():
   before,after=value['before'],value['after'];value['change_percent']=100*(after/before-1) if before else (0 if after==0 else None)
   if unit in ['ns/op','allocs/op'] and after>1.1*before:
    ratchets.append(dict(language=language,benchmark=name,metric=unit,**value))
  if name=='BenchmarkGoParseIncrementalNoEditDFA':assert all(v['B/op']==v['allocs/op']==0 for v in a+b)
  results[language][name]=dict(metrics=medians,custom=custom)
assert rows==480,rows
report=dict(benchmark_rows=rows,baseline_runtime='b5133ae07d1b1cd274c119cdef0a2625ff3d1a37',no_edit_zero_allocations=True,median_10_percent_failures=ratchets,results=results)
(lab/'perf-summary.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'rows':rows,'ratchet_failures':ratchets},indent=2))
for language,benches in results.items():
 for name,row in benches.items():print(language,name,json.dumps(row['metrics']))

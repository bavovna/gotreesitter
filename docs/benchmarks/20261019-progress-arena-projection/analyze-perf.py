from pathlib import Path
from collections import defaultdict
from statistics import median
import argparse,hashlib,json,re
parser=argparse.ArgumentParser();parser.add_argument('--evidence',default=str(Path(__file__).resolve().parent));args=parser.parse_args();p=Path(args.evidence).resolve()
assert (p/'perf-v2/complete.txt').read_text().strip()=='complete'
ref=json.loads((p/'source-reference-v2.json').read_text())
for name,sha in ref['runtime'].items():assert hashlib.sha256((p/'runtime-v2'/name).read_bytes()).hexdigest()==sha,name
rss=json.loads((p/'rss-v2/rss-matched/audit.json').read_text());assert rss['candidate_safety_pass']
expected={
 'go': {'BenchmarkParserCoreFreshFullCanonical/'+n for n in ['rewrite','query_compile','language','grammargen_lr']} | {'BenchmarkGoParseCompactFreshOneMiB','BenchmarkGoParseFullDFA','BenchmarkGoParseIncrementalSingleByteEditDFA','BenchmarkGoParseIncrementalNoEditDFA','BenchmarkAdmissionR4Compact'},
 'yaml':{'BenchmarkAdmissionR4Compact','BenchmarkAdmissionR4OwnedExternalLexer','BenchmarkAdmissionYAMLDocumentStreamOwned'}}
result={};rows=0
for language,names in expected.items():
 roles={}
 for role,file in [('baseline','before'),('candidate','after')]:
  text=(p/f'perf-v2/{language}-{file}.txt').read_text()
  assert '# status: complete' in text and 'FAIL' not in text
  assert ('# seeds: 35401..35420' if language=='go' else '# seeds: 35501..35520') in text
  data=defaultdict(list)
  for line in text.splitlines():
   if not line.startswith('Benchmark'):continue
   fields=line.split();name=re.sub(r'-[0-9]+$','',fields[0]);assert name in names,name
   metrics={fields[i+1]:float(fields[i]) for i in range(2,len(fields),2)}
   assert {'ns/op','B/op','allocs/op'}<=metrics.keys(),line
   data[name].append(metrics);rows+=1
  assert set(data)==names
  assert all(len(values)==20 for values in data.values())
  roles[role]=data
 result[language]={}
 for name in sorted(names):
  a,b=roles['baseline'][name],roles['candidate'][name]
  units=set(a[0]);assert all(set(r)==units for r in a+b)
  for unit in units-{'ns/op','MB/s','B/op','allocs/op'}:
   assert len({r[unit] for r in a+b})==1,(name,unit)
  medians={unit:{'before':median(r[unit] for r in a),'after':median(r[unit] for r in b)} for unit in ['ns/op','B/op','allocs/op']}
  for unit,m in medians.items():m['change_percent']=100*(m['after']/m['before']-1) if m['before'] else (0 if m['after']==0 else None)
  if name=='BenchmarkGoParseIncrementalNoEditDFA':assert all(r['B/op']==r['allocs/op']==0 for r in a+b)
  result[language][name]=medians
assert rows==480,rows
ratchets=[]
for language,benches in result.items():
 for name,metrics in benches.items():
  for unit in ['ns/op','allocs/op']:
   m=metrics[unit]
   if m['before'] and m['after']>1.1*m['before']:ratchets.append(dict(language=language,benchmark=name,unit=unit,**m))
report=dict(protocol='20 alternating shuffled pairs per language; count=1 per process; GOMAXPROCS=1; 750ms; compact opt-in for Go trio',baseline_runtime=ref['baseline_runtime'],timing_source_unchanged=True,benchmark_rows=rows,all_custom_work_and_route_metrics_exact=True,no_edit_zero_allocations=True,median_10_percent_failures=ratchets,results=result,rss_candidate_baseline_median_ratios=rss['candidate_baseline_median_ratios'])
(p/'perf-summary.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
if ratchets:raise SystemExit('A comparative median exceeds 10 percent; preserve evidence, do not promote')

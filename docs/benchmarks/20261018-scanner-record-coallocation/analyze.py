from pathlib import Path
from statistics import median
import csv,hashlib,json,math,re,subprocess
p=Path(__file__).resolve().parent
assert (p/'perf-complete.txt').read_text().strip()=='complete'
for n,h in json.loads((p/'source-pins.json').read_text()).items():
 assert hashlib.sha256((p/'runtime'/n).read_bytes()).hexdigest()==h,n
allowed={'sec/op','B/op','allocs/op','B/s','compact-routes/op','compact-fallbacks/op'}
metrics={};samples={};total=0
for lang,count in [('go',8),('yaml',3)]:
 for extension,args in [('txt',[]),('csv',['-format=csv'])]:
  with (p/f'benchstat-{lang}.{extension}.notes.txt').open('w') as notes:
   out=subprocess.check_output(['/home/draco/go/bin/benchstat',*args,f'{lang}-base.txt',f'{lang}-head.txt'],cwd=p,text=True,stderr=notes)
  (p/f'benchstat-{lang}.{extension}').write_text(out)
 raw={}
 for role in ['base','head']:
  rows={}
  for line in (p/f'{lang}-{role}.txt').read_text().splitlines():
   if not line.startswith('Benchmark'):continue
   fields=line.split();assert int(fields[1])>0
   name=fields[0].removeprefix('Benchmark')
   for value,unit in zip(fields[2::2],fields[3::2]):
    if unit in {'ns/op','B/op','allocs/op'}:rows.setdefault(name,{}).setdefault(unit,[]).append(float(value))
   total+=1
  assert len(rows)==count,(lang,role,len(rows))
  assert all(len(values)==20 for row in rows.values() for values in row.values()),(lang,role)
  raw[role]=rows
 assert raw['base'].keys()==raw['head'].keys()
 result={};metric=None
 for row in csv.reader((p/f'benchstat-{lang}.csv').open()):
  if len(row)>4 and row[0]=='' and row[2]=='CI':
   metric=row[1] if row[1] in allowed else None
   continue
  if metric is None or len(row)<7 or not row[0] or row[0]=='geomean':continue
  try:before,after=float(row[1]),float(row[3])
  except ValueError:continue
  key='ns/op' if metric=='sec/op' else metric
  scale=1e9 if key=='ns/op' else 1
  result.setdefault(row[0],{})[key]=dict(before=before*scale,after=after*scale,relative_percent=100*(after/before-1) if before else (0 if after==0 else None),supported=row[5]!='~',p=row[6],before_ci=row[2],after_ci=row[4])
 assert result.keys()==raw['base'].keys(),(lang,result.keys(),raw['base'].keys())
 for name in result:
  for unit in ['ns/op','B/op','allocs/op']:
   for role,field in [('base','before'),('head','after')]:
    got=result[name][unit][field];want=median(raw[role][name][unit])
    assert math.isclose(got,want,rel_tol=1e-12,abs_tol=1e-8),(lang,name,unit,role,got,want)
 metrics[lang]=result;samples[lang]=raw
assert total==440,total
report=dict(comparison='Qualified runtime 6d5b0b07 versus private scanner record/storage coallocation only',timed_rows=total,go_seeds='34301..34320',yaml_seeds='34401..34420',metrics=metrics,raw_samples=samples,parser_audit='Metric reset on every CI header; whitelist; all 20-sample time/byte/allocation medians independently verified',runtime_promoted=False)
(p/'measurement.json').write_text(json.dumps(report,indent=2)+'\n')
for lang,rows in metrics.items():
 for name,m in rows.items():
  t=m['ns/op'];b=m['B/op'];a=m['allocs/op']
  print(lang,name,'time',f"{t['relative_percent']:+.3f}%",t['p'],'supported',t['supported'],'B',b['before'],b['after'],'allocs',a['before'],a['after'])
print('All 440 samples retained and 20-sample medians verified.')

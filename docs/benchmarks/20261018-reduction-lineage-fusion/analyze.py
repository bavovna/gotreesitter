from pathlib import Path
import csv,json,hashlib
p=Path(__file__).resolve().parent
out={}
for lang in ['go','yaml']:
 rows={};metric=None
 for row in csv.reader((p/f'benchstat-{lang}.csv').open()):
  if len(row)>4 and row[0]=='' and row[1] in ['sec/op','B/op','allocs/op','B/s','compact-routes/op','compact-fallbacks/op']:
   metric=row[1];continue
  if not row or not row[0] or row[0]=='geomean' or len(row)<7 or metric is None:continue
  try:before,after=float(row[1]),float(row[3])
  except ValueError:continue
  m=metric;scale=1
  if m=='sec/op':m='ns/op';scale=1e9
  rows.setdefault(row[0],{})[m]=dict(before=before*scale,after=after*scale,relative_percent=(after/before-1)*100 if before else 0,supported=row[5]!='~',p=row[6],before_ci=row[2],after_ci=row[4])
 out[lang]=rows
(p/'measurement.json').write_text(json.dumps(out,indent=2)+'\n')
for lang,rows in out.items():
 print(lang)
 for name,metrics in rows.items():
  t=metrics['ns/op'];print(name,round(t['relative_percent'],3),t['supported'],t['p'],'bytes',metrics.get('B/op'),'allocs',metrics.get('allocs/op'))
for name,h in json.loads((p/'source-pins.json').read_text()).items():assert hashlib.sha256((p/'runtime'/name).read_bytes()).hexdigest()==h,name
for name,h in json.loads((p/'baseline-source-pins.json').read_text()).items():assert hashlib.sha256((p/'baseline'/name).read_bytes()).hexdigest()==h,name
assert sum(sum(l.startswith('Benchmark') for l in (p/f'{lang}-{role}.txt').read_text().splitlines()) for lang in ['go','yaml'] for role in ['base','head'])==440
(p/'decision.json').write_text(json.dumps(dict(status='not_promoted_inconclusive',runtime_promoted=False,timed_rows=440,counter_rows_exact=414,consumed_vectors_exact=5,source_hashes_exact=True,supported_compact_timing_gains=[],timing_limit='Wide intervals and no supported timing differences; no added seeds or repetition used.',remaining_qualification='Full language fleets, strict census and RSS were not run after this screen.',baseline_runtime='6d5b0b07e44a8f4fd1ab66d3246a485fde303909'),indent=2)+'\n')

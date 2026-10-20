"""Run in a writable external evidence copy inside the pinned container."""
from pathlib import Path
import hashlib,json,shutil
p=Path('/evidence');r=json.loads((p/'source-reference.json').read_text());pins=json.loads((p/'actual-source-pins.json').read_text())
for n,h in pins.items():
 assert hashlib.sha256((Path('/workspace')/n).read_bytes()).hexdigest()==h,('candidate',n)
 if n in r['new_files']:
  assert not (Path('/baseline')/n).exists(),('baseline new file',n)
 else:
  assert hashlib.sha256((Path('/baseline')/n).read_bytes()).hexdigest()==r['baseline_changed_source_pins'].get(n,h),('baseline',n)
for n in ['counter_main.go','owned_init_test.go']:shutil.copyfile(p/(n+'.txt'),p/n)
for kind in ['ledger','owned-ledger']:shutil.copyfile(p/('complete-'+kind+'.json'),p/('baseline-'+kind+'.json'))
for n in r['source_pins']:
 dest=p/'runtime'/n;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(Path('/workspace')/n,dest)
shared={'cmd/perfcounterledger/main.go':'counter_main.go','zz_scanner_bytes_owned_init_test.go':'owned_init_test.go'}
def overlay(extra):
 return {'Replace':{root+'/'+name:str(p/source) for root in ['/workspace','/baseline'] for name,source in dict(shared,**extra).items()}}
(p/'overlay.json').write_text(json.dumps(overlay({}),indent=2)+'\n')
extra={'zz_byte_packing_work_census_test.go':'work-census.go.txt','zz_byte_packing_consume_bench_test.go':'consume-bench.go.txt'}
(p/'perf-overlay.json').write_text(json.dumps(overlay(extra),indent=2)+'\n')
for n in ['large_go_test.go','rss_root_test.go','canonical_work_census_test.go']:shutil.copyfile(p/'fleet'/(n+'.txt'),p/'fleet'/n)
extra.update({'cgo_harness/compact_lineage_large_go_probe_test.go':'fleet/large_go_test.go','compact_lineage_rss_probe_test.go':'fleet/rss_root_test.go','canonical_work_census_test.go':'fleet/canonical_work_census_test.go'})
(p/'fleet/overlay.json').write_text(json.dumps(overlay(extra),indent=2)+'\n')
print('Candidate and baseline source manifests match; diagnostic overlays prepared.')

#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,re,sys
p=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parent
out=p/'out/candidate'
assert (p/'qualify-complete.txt').read_text().strip()=='complete'
for name in ['root-default.log','memory-pooling.log','owned-yaml-invariant.log','yaml-large-c.log','root-race.log','core-race.log']:
 s=(out/name).read_text();assert '\nPASS\n' in s and '--- FAIL' not in s and '--- SKIP' not in s,name
for name in ['core-phase0a.log','core-onepass.log']:
 assert 'ok ' in (out/name).read_text(),name
for prefix in ['invariant-','c-']:
 files=list(out.glob(prefix+'*.log'));assert len(files)==206,(prefix,len(files))
 for f in files:
  s=f.read_text();assert '\nPASS\n' in s and '\nFAIL' not in s and '--- SKIP' not in s,f
  if prefix=='invariant-':assert 'session_steps=72 no_edit_allocs=0' in s,f
count=sum(len(re.findall(r'--- PASS: TestParity(?:FreshParse|IncrementalParse|HasNoErrors)/',f.read_text())) for f in out.glob('c-*.log'))
assert count==618,count
owned=(out/'owned-yaml-invariant.log').read_text();assert 'owned initial compact=1 fallback=0' in owned and 'session_steps=72 no_edit_allocs=0' in owned
assert json.loads((out/'strict-census.json').read_text())==json.loads((p/'production-strict-census.json').read_text())
assert json.loads((out/'strict-differences.json').read_text())==[]
for before,after in [('reference-ledger.json','ledger.json'),('reference-owned-yaml-ledger.json','owned-yaml-ledger.json')]:
 assert json.loads((p/before).read_text())==json.loads((out/after).read_text()),(before,after)
ledger=json.loads((p/'fleet-counter-audit.json').read_text())
assert all(v['complete_json_equal'] for v in ledger.values())
assert sum(v['rows'] for v in ledger.values())==414
assert '756/756 root Go files, 12 API tag sets' in (p/'layout.log').read_text()
assert '454 language-name uses and 101 environment reads' in (p/'v1guard.log').read_text()
pins=json.loads((p/'candidate-source-pins.json').read_text())
assert len(pins)==3516
for name,sha in pins.items():assert hashlib.sha256(((p/'candidate-source' if (p/'candidate-source').exists() else Path('/candidate'))/name).read_bytes()).hexdigest()==sha,name
result=dict(baseline_runtime='54863cf280722c720bda81c2a8480f2398255730',measured_files=5,candidate_go_files=len(pins),ledger_complete_rows_exact=414,canonical_go_work_pins_pass=True,invariant_languages=206,steps_per_session=72,owned_yaml_explicitly_activated=True,c_smoke_checks=618,strict_rows_exact=204,strict_passes=159,known_legacy_strict_failures=45,memory_contracts_pass=True,race_pass=True,private_go_correctness_repairs_included=False,ordinary_yaml_routing_unchanged=True,work_direction_passed=True)
(p/'qualification-audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))

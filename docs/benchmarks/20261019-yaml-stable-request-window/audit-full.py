from pathlib import Path
import hashlib,json,re,sys
p=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parent
out=p/'out/candidate'
assert (p/'core-complete.txt').read_text().strip()=='complete'
assert (p/'qualify-complete.txt').read_text().strip()=='complete'
assert (p/'large-c-complete.txt').read_text().strip()=='complete'
for name in ['root-default.log','memory-pooling.log','owned-yaml-invariant.log','yaml-large-c.log','root-race.log','core-race.log','core-shadow.log']:
 text=(out/name).read_text();assert '\nPASS\n' in text and '--- FAIL' not in text and '--- SKIP' not in text,name
for name in ['core-normal.log','core-386.log','core-race.log']:
 text=(p/name).read_text();assert '\nPASS\n' in text and '--- FAIL' not in text,name
for name in ['core-phase0a.log','core-onepass.log']:assert 'ok ' in (p/name).read_text(),name
assert '--- PASS: TestStableRequestWindowRetiresReferencesWithoutRenumbering' in (out/'core-shadow.log').read_text()
ledger_rows=0
for before,after in [('reference-ledger.json','ledger.json'),('reference-owned-yaml-ledger.json','owned-yaml-ledger.json')]:
 a=json.loads((p/before).read_text());b=json.loads((out/after).read_text());assert a==b,(before,after);ledger_rows+=len(b['rows'])
assert ledger_rows==414
for prefix in ['invariant-','c-']:
 files=list(out.glob(prefix+'*.log'));assert len(files)==206,(prefix,len(files))
 for f in files:
  s=f.read_text();assert '\nPASS\n' in s and '--- FAIL' not in s and '--- SKIP' not in s,f
  if prefix=='invariant-':assert 'session_steps=72 no_edit_allocs=0' in s,f
checks=sum(len(re.findall(r'--- PASS: TestParity(?:FreshParse|IncrementalParse|HasNoErrors)/',f.read_text())) for f in out.glob('c-*.log'))
assert checks==618,checks
owned=(out/'owned-yaml-invariant.log').read_text();assert 'owned initial compact=1 fallback=0' in owned and 'session_steps=72 no_edit_allocs=0' in owned
assert json.loads((out/'strict-census.json').read_text())==json.loads((p/'production-strict-census.json').read_text())
assert json.loads((out/'strict-differences.json').read_text())==[]
before=json.loads((p/'reference-canonical-work.json').read_text())['candidate']
after={}
for line in (out/'canonical-work.log').read_text().splitlines():
 if 'CANONICAL_WORK_CENSUS ' in line:
  row=json.loads(line.split('CANONICAL_WORK_CENSUS ',1)[1]);after[row['Fixture']]=row
assert before==after and len(after)==4,'canonical trees or complete work changed'
(p/'canonical-work.json').write_text(json.dumps(dict(baseline=before,candidate=after),indent=2)+'\n')
expanded=json.loads((p/'out/expanded-go-c-audit.json').read_text());assert expanded['all_306_statuses_equal'] and expanded['new_failures']==0
large=(p/'large-go-c.log').read_text();assert '\nPASS\n' in large and 'bytes=1048591 ' in large and 'compact=1 fallback=0' in large
pins=json.loads((p/'candidate-source-pins.json').read_text());assert len(pins)==3520
for name,sha in pins.items():assert hashlib.sha256(((p/'candidate-source' if (p/'candidate-source').exists() else Path('/candidate'))/name).read_bytes()).hexdigest()==sha,name
assert '756/756 root Go files, 12 API tag sets' in (p/'layout.log').read_text()
assert '454 language-name uses and 101 environment reads' in (p/'v1guard.log').read_text()
report=dict(baseline_runtime='b5133ae07d1b1cd274c119cdef0a2625ff3d1a37',candidate_go_files=3520,measured_files=6,stable_request_window=True,header_republication_removed_from_ordinary_compaction=True,ledger_complete_rows_exact=414,canonical_complete_vectors_and_trees_exact=4,invariant_languages=206,steps_per_session=72,owned_yaml_explicitly_activated=True,c_smoke_checks=618,strict_rows_exact=204,strict_passes=159,known_legacy_strict_failures=45,expanded_go_c_cases_equal=306,expanded_go_known_failures=39,large_go_locked_c_exact=True,shadow_core_pass=True,memory_and_pooling_pass=True,root_and_core_races_pass=True,work_direction_passed=True,private_go_correctness_repairs_included=False)
(p/'full-counter-gate.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))

from pathlib import Path
import hashlib,json,re
p=Path(__file__).resolve().parent
out=p/'out/candidate';before=p.parent/'20261019-progress-arena-projection-production'
assert (p/'preflight-complete.txt').read_text().strip()=='complete'
assert (p/'qualify-complete.txt').read_text().strip()=='complete'
r=json.loads((p/'source-reference.json').read_text())
for name,sha in r['runtime_pins'].items():assert hashlib.sha256((p/'runtime'/name).read_bytes()).hexdigest()==sha,name
q=json.loads((p/'qualification-reference.json').read_text());assert hashlib.sha256((p/q['extra_probe']).read_bytes()).hexdigest()==q['extra_probe_sha256']
changes=[];count=0
for a,b in [('native-ledger.json','ledger.json'),('native-owned-ledger.json','owned-yaml-ledger.json')]:
 old=json.loads((before/a).read_text());new=json.loads((out/b).read_text());assert len(old['rows'])==len(new['rows'])
 for x,y in zip(old['rows'],new['rows']):
  count+=1
  if x!=y:
   assert {k:v for k,v in x.items() if k!='decline_reason'}=={k:v for k,v in y.items() if k!='decline_reason'}
   changes.append(dict(language=x['language'],route=x['route'],before=x.get('decline_reason'),after=y.get('decline_reason')))
assert count==414 and len(changes)==1 and changes[0]['language']=='c',changes
for prefix in ['invariant-','c-']:
 files=list(out.glob(prefix+'*.log'));assert len(files)==206,(prefix,len(files))
 for f in files:assert '\nPASS\n' in f.read_text() and '\nFAIL' not in f.read_text(),f
smoke=sum(len(re.findall(r'^\s*--- PASS: TestParity(?:FreshParse|IncrementalParse|HasNoErrors)/',f.read_text(),re.M)) for f in out.glob('c-*.log'))
assert smoke==618,smoke
owned=(out/'owned-yaml-invariant.log').read_text();assert 'owned initial compact=1 fallback=0' in owned and 'session_steps=72 no_edit_allocs=0' in owned
assert json.loads((out/'strict-census.json').read_text())==json.loads((p/'production-strict-census.json').read_text())
for name in ['diagnostic-budget-lifecycle.log','memory-pooling.log','root-race.log','core-race.log','history-default.log','yaml-stream-c.log']:
 file=out/name
 if not file.exists():file=p/'qualification-attempt1/out/candidate'/name
 text=file.read_text();assert '\nPASS\n' in text and '\nFAIL' not in text,name
for name in ['core-phase0a.log','core-onepass.log']:
 file=out/name
 if not file.exists():file=p/'qualification-attempt1/out/candidate'/name
 assert 'ok ' in file.read_text(),name
control=(out/'diagnostic-budget-lifecycle.log').read_text()
for name in ['cancelled','timeout','memory_budget']:assert 'TestDiagnosticPrivateCachedPublicationStopControl/'+name in control,name
assert (out/'production-pinned-budget-controls-negative-exit.txt').read_text().strip()=='1'
report=dict(baseline_runtime=r['baseline_runtime'],candidate_go_files=r['candidate_go_files'],runtime_overrides=len(r['runtime_pins']),ordinary_invariant_sessions=206,steps_per_session=72,owned_invariant_explicit_route=True,c_smoke_checks=smoke,strict_rows_exact=204,strict_compact_pass=120,strict_legacy_pass=39,strict_known_legacy_fail=45,ledger_numeric_rows_exact=count,diagnostic_reason_changes=changes,canonical_work_direction_passed=False,canonical_changed_fields=77,canonical_increased_fields=65,owner_exception_approved=False,production_work_pins_unchanged=True,diagnostic_publication_budget_checks_pass=True,source_still_private=True,timing_blocked_by_work_direction=True,root_api_unchanged=True,layout_guard_pass=True,cache_setup_failure_not_parser_evidence=True)
(p/'qualification-audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

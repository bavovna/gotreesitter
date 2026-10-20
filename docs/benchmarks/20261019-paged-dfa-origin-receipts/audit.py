from pathlib import Path
import hashlib,json,re

p=Path(__file__).resolve().parent
labs=p.parent
out=p/'out/candidate'
assert (p/'complete.txt').read_text().strip()=='complete'
reference=json.loads((p/'source-reference.json').read_text())
for name,h in reference['runtime_pins'].items():assert hashlib.sha256((p/'runtime'/name).read_bytes()).hexdigest()==h,name
for name,h in reference['probe_pins'].items():assert hashlib.sha256((p/name).read_bytes()).hexdigest()==h,name

def census(path):
    result={}
    for line in path.read_text().splitlines():
        if 'CANONICAL_WORK_CENSUS ' in line:
            row=json.loads(line.split('CANONICAL_WORK_CENSUS ',1)[1]);result[row['Fixture']]=row
    assert len(result)==4
    return result

before=json.loads((labs/'20261019-compact-read-history-demand/archive/canonical-work.json').read_text())['candidate']
after=census(out/'canonical-work.log')
prior=census(labs/'20261019-cohort-frontier-qualification/out/protocol-resume/canonical-work.log')
assert after==prior,'Fusing the qualified history guard changed complete protocol work or deep trees'
changes=[]
for fixture in before:
    assert before[fixture]['DeepTree']==after[fixture]['DeepTree']
    for group in ['CoreWork','SchedulerWork']:
        for name,old in before[fixture][group].items():
            new=after[fixture][group][name]
            if old!=new:changes.append(dict(fixture=fixture,counter=group+'.'+name,before=old,after=new,delta_percent=100*(new-old)/old if old else None))
increases=[r for r in changes if r['after']>r['before']]
(p/'canonical-work.json').write_text(json.dumps(dict(baseline=before,candidate=after,unchanged_deep_digests=4,identical_to_prior_protocol_complete_vectors=True,all_changed_rows=changes,increased_rows=increases,work_direction_passed=False,owner_exception_approved=False),indent=2)+'\n')

ledger_changes=[]
for baseline_name,candidate_name in [('native-ledger.json','ledger.json'),('native-owned-ledger.json','owned-yaml-ledger.json')]:
    a=json.loads((labs/'20261019-compact-read-history-demand'/baseline_name).read_text())
    b=json.loads((out/candidate_name).read_text())
    assert len(a['rows'])==len(b['rows'])
    for old,new in zip(a['rows'],b['rows']):
        if old!=new:
            stripped_old={k:v for k,v in old.items() if k!='decline_reason'}
            stripped_new={k:v for k,v in new.items() if k!='decline_reason'}
            assert stripped_old==stripped_new,'A ledger change is more than the known diagnostic decline reason'
            ledger_changes.append(dict(language=old['language'],route=old['route'],before=old.get('decline_reason'),after=new.get('decline_reason')))
assert len(ledger_changes)==1 and ledger_changes[0]['language']=='c'
(p/'ledger-audit.json').write_text(json.dumps(dict(rows=414,all_numeric_work_and_reuse_fields_equal=True,diagnostic_reason_changes=ledger_changes,canonical_direction_still_failed=True),indent=2)+'\n')

for prefix in ['invariant-','c-']:
    files=list(out.glob(prefix+'*.log'));assert len(files)==206
    for f in files:assert '\nPASS\n' in f.read_text(),f
assert json.loads((out/'strict-census.json').read_text())==json.loads((p/'production-strict-census.json').read_text())
c=(out/'generic-c-edits.log').read_text()
assert len(re.findall(r'^\s*--- PASS: TestGoTokenTurnExpandedLockedCProbe/',c,re.M))==300
assert len(re.findall(r'^\s*--- PASS: TestGoGenericCallFrontierLockedCProbe/',c,re.M))==6
assert len(re.findall(r'^\s*--- PASS: TestGoVersionTurnEditSessionsLockedC/',c,re.M))==24
for name in ['diagnostic-budget-lifecycle.log','pooled-lifecycle.log','root-focused.log','root-race.log','history-default.log','large-go-c.log','yaml-stream-c.log']:
    text=(out/name).read_text();assert '\nPASS\n' in text and '\nFAIL' not in text,name
summary=dict(baseline_runtime=reference['baseline_runtime'],runtime_files=len(reference['runtime_pins']),candidate_go_files=reference['candidate_go_files'],root_go_files=756,all_206_invariant_sessions_pass=True,steps_per_session=72,smoke_c_checks=618,clean_generic_c_cases=306,generic_edit_sessions=24,generic_edit_steps=144,strict_passes=159,strict_known_legacy_failures=45,strict_rows_exact=204,canonical_deep_digests_exact=4,canonical_changed_rows=len(changes),canonical_increased_rows=len(increases),ledger_numeric_rows_exact=414,diagnostic_reason_changes=1,work_direction_passed=False,owner_exception_approved=False,original_production_pinned_lifecycle_expected_failure=True,diagnostic_private_budget_and_lifecycle_pass=True,rss_qualification_pending=True,runtime_promoted=False)
(p/'audit.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))

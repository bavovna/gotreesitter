from pathlib import Path
import hashlib,json,re
p=Path(__file__).resolve().parent
prior=p.parent/'20261019-paged-dfa-origin-receipts'
production=p.parent/'20261019-progress-arena-projection-production'
r=json.loads((p/'source-reference.json').read_text())
for name,sha in r['runtime_pins'].items():assert hashlib.sha256((p/'runtime'/name).read_bytes()).hexdigest()==sha,name
for name,sha in r['probe_pins'].items():assert hashlib.sha256((p/name).read_bytes()).hexdigest()==sha,name
assert (p/'screen-complete.txt').read_text().strip()=='complete'
def records(path,marker):return [json.loads(s.split(marker,1)[1]) for s in path.read_text().splitlines() if marker in s]
a=records(prior/'canonical-work.log','CANONICAL_WORK_CENSUS ')
b=records(p/'canonical-work.log','CANONICAL_WORK_CENSUS ')
assert a==b and len(b)==4,'Private canonical work or trees changed'
prod=json.loads((production/'canonical-work.json').read_text())['candidate']
changes=[]
for row in b:
 old=prod[row['Fixture']];assert old['DeepTree']==row['DeepTree']
 for group in ['CoreWork','SchedulerWork']:
  for name,value in old[group].items():
   new=row[group][name]
   if new!=value:changes.append(dict(fixture=row['Fixture'],counter=group+'.'+name,before=value,after=new,delta_percent=100*(new-value)/value if value else None))
assert len(changes)==77 and sum(c['after']>c['before'] for c in changes)==65
old=records(production/'screen-v2/go-memory-attribution.log','GO_MEMORY_ATTRIBUTION ')[0]
new=records(p/'go-memory-attribution.log','GO_MEMORY_ATTRIBUTION ')[0]
for name in ['source_bytes','core_work','scheduler_work','arena_volume']:assert old[name]==new[name],name
owned=(p/'owned-yaml-invariant.log').read_text();assert 'owned initial compact=1 fallback=0' in owned and 'session_steps=72 no_edit_allocs=0' in owned
text=(p/'generic-c-edits-large.log').read_text()
assert len(re.findall(r'^\s*--- PASS: TestGoTokenTurnExpandedLockedCProbe/',text,re.M))==300
assert len(re.findall(r'^\s*--- PASS: TestGoGenericCallFrontierLockedCProbe/',text,re.M))==6
assert len(re.findall(r'^\s*--- PASS: TestGoVersionTurnEditSessionsLockedC/',text,re.M))==24
assert '--- PASS: TestCompactLineageLargeGoLockedC' in text
assert (p/'production-work-pin-negative-exit.txt').read_text().strip()=='1'
report=dict(canonical_complete_private_vectors_and_trees_exact=4,canonical_changed_fields=len(changes),canonical_increased_fields=65,owner_exception_approved=False,work_direction_passed=False,clean_go_c_cases=306,generic_edit_steps=144,owned_invariant_explicit_activation=True,owned_invariant_steps=72,large_go_complete_work_equal=True,allocated_bytes_before=old['allocated_bytes'],allocated_bytes_after=new['allocated_bytes'],core_footprint_before=old['core_footprint'],core_footprint_after=new['core_footprint'])
(p/'canonical-counter-changes.json').write_text(json.dumps(changes,indent=2)+'\n')
(p/'screen-audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

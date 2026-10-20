from pathlib import Path
import json,hashlib
lab=Path(__file__).resolve().parent
paged=lab.parent/'20261019-paged-dfa-origin-receipts'
ref=json.loads((lab/'source-reference.json').read_text())
for family in ['source_hashes','observer_hashes']:
 for name,sha in ref[family].items():
  assert hashlib.sha256((lab/name).read_bytes()).hexdigest()==sha,name
assert (lab/'screen-complete.txt').read_text().strip()=='complete'
def records(p,marker):
 return [json.loads(line.split(marker,1)[1]) for line in p.read_text().splitlines() if marker in line]
old=records(paged/'canonical-work.log','CANONICAL_WORK_CENSUS ')
new=records(lab/'canonical-work.log','CANONICAL_WORK_CENSUS ')
assert len(old)==len(new)==4 and old==new,'canonical trees or work changed'
before=records(paged/'go-memory-attribution.log','GO_MEMORY_ATTRIBUTION ')[0]
after=records(lab/'go-memory-attribution.log','GO_MEMORY_ATTRIBUTION ')[0]
for field in ['source_bytes','core_work','scheduler_work','arena_volume']:
 assert before[field]==after[field],field
fields=['allocated_bytes','core_footprint','scheduler_footprint','heap_after','heap_inuse_after','gc_cycles']
result={'canonical_trees_work_equal':4,'large_go_work_equal':True,'metrics':{key:{'before':before[key],'after':after[key],'change_percent':100*(after[key]/before[key]-1)} for key in fields},'private_only':True}
(lab/'audit-screen.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))

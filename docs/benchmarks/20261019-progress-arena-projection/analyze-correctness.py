from pathlib import Path
import argparse,hashlib,json
parser=argparse.ArgumentParser();parser.add_argument('--evidence',required=True);parser.add_argument('--output');args=parser.parse_args()
p=Path(args.evidence).resolve();archive=Path(__file__).resolve().parent;out=p/'out/candidate'
ref=json.loads((archive/'source-reference-v2.json').read_text())
for name,sha in ref['runtime'].items():assert hashlib.sha256((p/'runtime-v2'/name).read_bytes()).hexdigest()==sha,name
for name,sha in ref['observers'].items():assert hashlib.sha256((p/name).read_bytes()).hexdigest()==sha,name
owned_ref=json.loads((archive/'owned-invariant-reference.json').read_text())
assert hashlib.sha256((p/'owned_yaml_invariant_test.go.txt').read_bytes()).hexdigest()==owned_ref['probe_sha256']
owned=(out/'owned-yaml-invariant.log').read_text()
assert 'owned initial compact=1 fallback=0' in owned and 'session_steps=72 no_edit_allocs=0' in owned
assert (p/'qualify-complete.txt').read_text().strip()=='complete'
def records(path,marker):return [json.loads(s.split(marker,1)[1]) for s in path.read_text().splitlines() if marker in s]
before=json.loads((archive/'canonical-work.json').read_text())['baseline']
after={r['Fixture']:r for r in records(p/'screen-v2/canonical-work.log','CANONICAL_WORK_CENSUS ')}
assert before==after and len(after)==4
count=0
for old,new in [('baseline-ledger.json','ledger.json'),('baseline-owned-yaml-ledger.json','owned-yaml-ledger.json')]:
 a=json.loads((archive/old).read_text());b=json.loads((out/new).read_text());assert a==b;count+=len(a['rows'])
assert count==414
for prefix in ['invariant-','c-']:
 files=list(out.glob(prefix+'*.log'));assert len(files)==206
 for f in files:assert '\nPASS\n' in f.read_text() and '\nFAIL' not in f.read_text(),f
assert json.loads((out/'strict-census.json').read_text())==json.loads((archive/'production-strict-census.json').read_text())
for name in ['root-default.log','root-386.log','memory-pooling.log','owned-yaml-invariant.log','yaml-stream-c.log','root-race.log','core-race.log']:
 s=(out/name).read_text();assert '\nPASS\n' in s and '\nFAIL' not in s,name
for name in ['core-phase0a.log','core-onepass.log']:assert 'ok ' in (out/name).read_text(),name
old=json.loads((archive/'baseline-large-attribution.json').read_text());new=records(p/'screen-v2/go-memory-attribution.log','GO_MEMORY_ATTRIBUTION ')[0]
for key in ['source_bytes','core_work','scheduler_work','arena_volume']:assert old[key]==new[key],key
result=dict(work_direction_passed=True,ledger_complete_rows_exact=414,canonical_complete_vectors_and_trees_exact=4,large_go_complete_work_equal=True,invariant_languages=206,steps_per_session=72,c_smoke_checks=618,strict_rows_exact=204,strict_passes=159,known_legacy_strict_failures=45,memory_contracts_pass=True,race_pass=True)
(Path(args.output) if args.output else p/'full-counter-gate.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

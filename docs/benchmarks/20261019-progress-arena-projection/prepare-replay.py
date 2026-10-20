"""Reconstruct the measured candidate from two complete, unmodified 5c checkouts."""
from pathlib import Path
import argparse,gzip,hashlib,json,shutil,subprocess
archive=Path(__file__).resolve().parent
parser=argparse.ArgumentParser()
parser.add_argument('--workspace',default='/workspace')
parser.add_argument('--baseline-root',default='/reference')
parser.add_argument('--output',default='/evidence')
parser.add_argument('--check',action='store_true')
args=parser.parse_args()
workspace,before,output=[Path(v).resolve() for v in [args.workspace,args.baseline_root,args.output]]
assert workspace!=before,'paired roles need distinct paths'
for root in [workspace,before]:
 assert root!=output and root not in output.parents,'evidence must be outside checkouts'
 assert (root/'go.mod').is_file(),'use a complete module, not a Go-only snapshot'
pins=json.loads((archive/'baseline-source-pins.json').read_text())
assert len(pins)==3512
for root in [workspace,before]:
 for name,sha in pins.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==sha,(root,name)
changed=json.loads((archive/'runtime-pins.json').read_text())
runtime=output/'runtime-v2'
if not args.check:
 output.mkdir(parents=True,exist_ok=True)
 runtime.mkdir(exist_ok=False)
 for name in changed:
  target=runtime/name;target.parent.mkdir(parents=True,exist_ok=True)
  if (workspace/name).exists():shutil.copyfile(workspace/name,target)
 subprocess.run(['git','apply','--unidiff-zero',str(archive/'runtime.patch')],cwd=runtime,check=True)
replace={}
for name,sha in changed.items():
 target=runtime/name
 assert hashlib.sha256(target.read_bytes()).hexdigest()==sha,('candidate',name)
 replace[str(workspace/name)]=str(target)
# Keep the exact new large-file benchmark common to both runtimes.
replace[str(before/'benchmark_admission_fresh_test.go')]=str(runtime/'benchmark_admission_fresh_test.go')
probes={'canonical_work_census_test.go.txt':'zz_canonical_work_census_test.go','counter_main.go.txt':'cmd/perfcounterledger/main.go','large_go_test.go.txt':'cgo_harness/zz_compact_large_go_test.go','rss_root_test.go.txt':'zz_compact_lineage_rss_test.go','attribution_test.go.txt':'zz_go_memory_attribution_test.go'}
for root in [workspace,before]:
 for name,target in probes.items():replace[str(root/target)]=str(archive/name)
if not args.check:(output/'overlay-v2.json').write_text(json.dumps({'Replace':replace},indent=2)+'\n')
if not args.check:
 (output/'screen-v2').mkdir()
 for name in ['run-screen-v2.sh','qualify-v2.sh','perf-v2.sh','strict.py','production-strict-census.json','languages.txt','source-reference-v2.json','owned_yaml_invariant_test.go.txt','owned-invariant-reference.json','check-owned-invariant.sh']:
  shutil.copyfile(archive/name,output/name)
 for name in probes:shutil.copyfile(archive/name,output/name)
 (output/'source.go.txt').write_bytes(gzip.decompress((archive/'source.go.txt.gz').read_bytes()))
 owned_replace=dict(replace);owned_replace[str(workspace/'zz_progress_owned_yaml_invariant_test.go')]=str(output/'owned_yaml_invariant_test.go.txt')
 (output/'owned-invariant-overlay.json').write_text(json.dumps({'Replace':owned_replace},indent=2)+'\n')
 rss=output/'rss-v2';rss.mkdir()
 for name in ['run.sh','repeat_rss.py']:shutil.copyfile(archive/'rss-v2'/name,rss/name)
 rss_replace={key:('/candidate'+value[len(str(output)):]) if value.startswith(str(output)+'/') else value for key,value in replace.items()}
 (rss/'overlay.json').write_text(json.dumps({'Replace':rss_replace},indent=2)+'\n')
owned_ref=json.loads((archive/'owned-invariant-reference.json').read_text())
assert hashlib.sha256((output/'owned_yaml_invariant_test.go.txt').read_bytes()).hexdigest()==owned_ref['probe_sha256']
ref=json.loads((archive/'source-reference-v2.json').read_text())
for name,sha in ref['observers'].items():assert hashlib.sha256((output/name).read_bytes()).hexdigest()==sha,('observer',name)
print('Verified 3512 baseline Go hashes per role and all 5 candidate files; two new internal files; no work-pin changes')

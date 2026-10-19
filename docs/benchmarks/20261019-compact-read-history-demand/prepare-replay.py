"""Prepare an external paired overlay from complete, pinned b17 checkouts."""
from pathlib import Path
import argparse,hashlib,json,shutil,subprocess

archive=Path(__file__).resolve().parent
parser=argparse.ArgumentParser()
parser.add_argument('--workspace',default='/workspace')
parser.add_argument('--baseline-root',default='/baseline')
parser.add_argument('--output',default='/evidence')
parser.add_argument('--native-tests',action='store_true')
args=parser.parse_args()
workspace=Path(args.workspace).resolve()
before=Path(args.baseline_root).resolve()
output=Path(args.output).resolve()
assert workspace!=before,'paired roles need distinct paths'
for checkout in [workspace,before]:
    assert checkout!=output and checkout not in output.parents,'output must be outside either checkout'
    assert (checkout/'go.mod').is_file(),'use a complete module, not the Go-only source snapshot'
pins=json.loads((archive/'baseline-source-pins.json').read_text())
assert len(pins)==3512
for checkout in [workspace,before]:
    for name,expected in pins.items():
        assert hashlib.sha256((checkout/name).read_bytes()).hexdigest()==expected,(checkout,name)
output.mkdir(parents=True,exist_ok=True)
runtime=output/'runtime'
runtime.mkdir(exist_ok=False)
changed=json.loads((archive/('native-changed-source-pins.json' if args.native_tests else 'runtime-pins.json')).read_text())
for name in changed:
    target=runtime/name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(workspace/name,target)
subprocess.run(['git','apply','--unidiff-zero',str(archive/('native.patch' if args.native_tests else 'runtime.patch'))],cwd=runtime,check=True)
replace={}
for name,expected in changed.items():
    target=runtime/name
    assert hashlib.sha256(target.read_bytes()).hexdigest()==expected,('candidate',name)
    replace[str(workspace/name)]=str(target)
probes={
    'canonical_work_census_test.go.txt':'zz_canonical_work_census_test.go',
    'counter_main.go.txt':'cmd/perfcounterledger/main.go',
    'large_go_test.go.txt':'cgo_harness/zz_compact_large_go_test.go',
    'rss/rss_root_test.go.txt':'zz_compact_lineage_rss_test.go',
}
for checkout in [workspace,before]:
    for name,target in probes.items():replace[str(checkout/target)]=str(archive/name)
    if checkout==before or not args.native_tests:
        replace[str(checkout/'zz_compact_read_history_demand_test.go')]=str(archive/'read_demand_test.go.txt')
result=output/'overlay.json'
result.write_text(json.dumps({'Replace':replace},indent=2)+'\n')
print('Verified 3512 hashes in each complete checkout and reconstructed the candidate:',result)

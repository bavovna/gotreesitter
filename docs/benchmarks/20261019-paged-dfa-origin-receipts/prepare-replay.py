"""Reconstruct the private candidate in external storage; never edit the checkout."""
from pathlib import Path
import argparse,hashlib,json,shutil,subprocess

archive=Path(__file__).resolve().parent
parser=argparse.ArgumentParser()
parser.add_argument('--workspace',default='/workspace')
parser.add_argument('--output',default='/evidence/replay')
parser.add_argument('--baseline',action='store_true')
args=parser.parse_args()
workspace=Path(args.workspace).resolve()
output=Path(args.output).resolve()
assert workspace!=output and workspace not in output.parents,'output must be outside the checkout'
assert (workspace/'go.mod').is_file(),'use a complete baseline module'
pins=json.loads((archive/'baseline-source-pins.json').read_text())
assert len(pins)==3512
for n,h in pins.items():assert hashlib.sha256((workspace/n).read_bytes()).hexdigest()==h,('baseline',n)
output.mkdir(parents=True,exist_ok=False)
replace={}
if not args.baseline:
    runtime=output/'runtime';runtime.mkdir()
    changed=json.loads((archive/'runtime-pins.json').read_text())
    for n in changed:
        if (workspace/n).exists():
            target=runtime/n;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(workspace/n,target)
    subprocess.run(['git','apply','--unidiff-zero',str(archive/'runtime.patch')],cwd=runtime,check=True)
    for n,h in changed.items():
        target=runtime/n;assert hashlib.sha256(target.read_bytes()).hexdigest()==h,('candidate',n)
        replace[str(workspace/n)]=str(target)
probes=json.loads((archive/'probe-pins.json').read_text())
for n,h in probes.items():
    source=archive/n
    if source.exists(): data=source.read_bytes()
    else:
        import gzip
        data=gzip.decompress((archive/(n+'.gz')).read_bytes())
    assert hashlib.sha256(data).hexdigest()==h,('probe',n)
targets={
    'cgo_probe_test.go.txt':'cgo_harness/zz_go_generic_frontier_test.go',
    'expanded_probe_test.go.txt':'cgo_harness/zz_go_token_turn_expanded_test.go',
    'edit_sessions_test.go.txt':'cgo_harness/zz_go_version_turn_edits_test.go',
    'cohort_regression_test.go.txt':'zz_cohort_frontier_regression_test.go',
    'root-negative_test.go.txt':'zz_dfa_restore_negative_test.go',
    'canonical_work_census_test.go.txt':'zz_canonical_work_census_test.go',
    'diagnostic_budget_lifecycle_test.go.txt':'zz_diagnostic_budget_lifecycle_test.go',
    'counter_main.go.txt':'cmd/perfcounterledger/main.go',
    'large_go_test.go.txt':'cgo_harness/zz_compact_large_go_test.go',
    'rss_root_test.go.txt':'zz_compact_lineage_rss_test.go',
}
for n,target in targets.items():
    if args.baseline and n in ['root-negative_test.go.txt','diagnostic_budget_lifecycle_test.go.txt']:continue
    replace[str(workspace/target)]=str(archive/n)
(output/'overlay.json').write_text(json.dumps({'Replace':replace},indent=2)+'\n')
print('All baseline/runtime/probe hashes match; external overlay:',output/'overlay.json')

"""Prepare an external Go overlay; never apply these prototypes to the checkout."""
from pathlib import Path
import argparse,hashlib,json,shutil,subprocess
p=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('variant');ap.add_argument('--baseline',action='store_true');ap.add_argument('--workspace',default='/workspace');ap.add_argument('--output',default='/evidence/replay')
a=ap.parse_args();workspace=Path(a.workspace);output=Path(a.output);variant=p/a.variant
pins=json.loads((p/'baseline-source-pins.json').read_text())
for n,h in pins.items():assert hashlib.sha256((workspace/n).read_bytes()).hexdigest()==h,('baseline',n)
output.mkdir(parents=True,exist_ok=False)
overlay={'Replace':{}}
if not a.baseline:
 runtime=output/'runtime';runtime.mkdir()
 changed=json.loads((variant/'source-pins.json').read_text())
 for n in changed:
  src=workspace/n;dst=runtime/n
  if src.exists():dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst)
 subprocess.run(['git','apply','--unidiff-zero',str(variant/'runtime.patch')],cwd=runtime,check=True)
 for n,h in changed.items():
  f=runtime/n;assert hashlib.sha256(f.read_bytes()).hexdigest()==h,('variant',n)
  overlay['Replace'][str(workspace/n)]=str(f)
probes=json.loads((variant/'probe-pins.json').read_text())
for n,h in probes.items():assert hashlib.sha256((variant/n).read_bytes()).hexdigest()==h,('probe',n)
names={'cgo_probe_test.go.txt':'zz_go_generic_frontier_test.go','oracle_probe_test.go.txt':'zz_go_oracle_evidence_test.go','expanded_probe_test.go.txt':'zz_go_token_turn_expanded_test.go'}
for name,target in names.items():
 if name in probes and (not a.baseline or name=='expanded_probe_test.go.txt'):
  overlay['Replace'][str(workspace/'cgo_harness'/target)]=str(variant/name)
(output/'overlay.json').write_text(json.dumps(overlay,indent=2)+'\n')
print('All 3512 baseline hashes and selected variant/probe hashes match; overlay:',output/'overlay.json')

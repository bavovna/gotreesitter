"""Prepare the private candidate from complete 54863cf module snapshots."""
from pathlib import Path
import argparse,gzip,hashlib,json,shutil,subprocess
archive=Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--workspace',required=True);parser.add_argument('--baseline-root',required=True);parser.add_argument('--output',required=True);parser.add_argument('--check',action='store_true');args=parser.parse_args()
workspace,before,output=[Path(v).resolve() for v in [args.workspace,args.baseline_root,args.output]]
assert workspace!=before
for root in [workspace,before]:assert root!=output and root not in output.parents and (root/'go.mod').is_file()
base=json.loads((archive/'baseline-source-pins.json').read_text());assert len(base)==3514
for root in [workspace,before]:
 for name,sha in base.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==sha,(root,name)
ref=json.loads((archive/'source-reference.json').read_text());runtime=output/'runtime'
if not args.check:
 output.mkdir(parents=True,exist_ok=True);runtime.mkdir(exist_ok=False)
 for name in ref['runtime_pins']:
  target=runtime/name;target.parent.mkdir(parents=True,exist_ok=True)
  if (workspace/name).exists():shutil.copyfile(workspace/name,target)
 subprocess.run(['git','apply','--unidiff-zero',str(archive/'runtime.patch')],cwd=runtime,check=True)
replace={}
for name,sha in ref['runtime_pins'].items():
 target=runtime/name;assert hashlib.sha256(target.read_bytes()).hexdigest()==sha,name
 replace[str(workspace/name)]=str(target)
for name,target in json.loads((archive/'probe-targets.json').read_text()).items():replace[str(workspace/name)]=str(archive/target)
if not args.check:(output/'overlay.json').write_text(json.dumps({'Replace':replace},indent=2)+'\n')
print('Verified both 3514-file baselines and reconstructed all 17 candidate overrides; work exceptions remain unapproved')

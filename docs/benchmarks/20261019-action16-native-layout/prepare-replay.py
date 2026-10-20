#!/usr/bin/env python3
import argparse,hashlib,json,os,shutil,subprocess,tarfile
from pathlib import Path
parser=argparse.ArgumentParser()
for name in ['baseline','candidate','evidence']:parser.add_argument('--'+name,required=True)
parser.add_argument('--check',action='store_true');args=parser.parse_args()
r=Path(__file__).resolve().parent
baseline,candidate,evidence=[Path(getattr(args,n)).resolve() for n in ['baseline','candidate','evidence']]
assert baseline!=candidate and baseline not in candidate.parents and candidate not in baseline.parents
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def manifest(root):
 names=subprocess.check_output(['rg','--files','-0','-g','*.go'],cwd=root).decode().split('\0')
 return {n:sha(root/n) for n in names if n}
for name,expected in json.loads((r/'archive-manifest.json').read_text()).items():assert sha(r/name)==expected,name
with tarfile.open(r/'complete-source-pins.tar.gz') as a:
 before=json.load(a.extractfile('baseline-source-pins.json'));after=json.load(a.extractfile('candidate-source-pins.json'))
assert manifest(baseline)==before
assert sha(r/'runtime.patch')==json.loads((r/'source-reference.json').read_text())['runtime_patch_sha256']
if not args.check:
 assert not candidate.exists()
 shutil.copytree(baseline,candidate,copy_function=os.link,ignore=shutil.ignore_patterns('.git'))
 runtime=json.loads((r/'runtime-pins.json').read_text())
 for name in runtime:
  f=candidate/name
  if f.exists():
   t=f.with_name(f.name+'.replay-temp');t.write_bytes(f.read_bytes());os.replace(t,f)
 subprocess.run(['git','-C',str(candidate),'apply',str(r/'runtime.patch')],check=True)
 evidence.mkdir(parents=True,exist_ok=True)
 with tarfile.open(r/'replay-inputs.tar.gz') as a:a.extractall(evidence,filter='data')
assert manifest(candidate)==after
assert manifest(baseline)==before
print(json.dumps({'baseline_go_files':len(before),'candidate_go_files':len(after),'all_hashes_exact':True,'check_only':args.check}))

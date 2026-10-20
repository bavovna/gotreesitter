#!/usr/bin/env python3
from pathlib import Path
import argparse,hashlib,json,os,shutil,tarfile
parser=argparse.ArgumentParser()
parser.add_argument('--baseline',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
parser.add_argument('--check',action='store_true')
args=parser.parse_args()
here=Path(__file__).resolve().parent
manifest=json.loads((here/'archive-manifest.json').read_text())
content={}
for name,receipt in manifest.items():
 archive=here/name
 assert hashlib.sha256(archive.read_bytes()).hexdigest()==receipt['sha256'],name
 with tarfile.open(archive,'r:gz') as tar:
  members=tar.getmembers();assert len(members)==len(receipt['members'])
  for member in members:
   assert member.isfile() and not member.name.startswith('/') and '..' not in Path(member.name).parts
   data=tar.extractfile(member).read()
   assert hashlib.sha256(data).hexdigest()==receipt['members'][member.name]['sha256'],member.name
   if name=='source-and-protocol.tar.gz':content[member.name]=data

def verify(source,pins):
 actual={str(p.relative_to(source)) for p in source.rglob('*.go') if '.git' not in p.parts and 'harness_out' not in p.parts}
 assert actual==set(pins),(str(source),sorted(actual-set(pins)),sorted(set(pins)-actual))
 for name,digest in pins.items():assert hashlib.sha256((source/name).read_bytes()).hexdigest()==digest,name

def clone(source,target):
 shutil.copytree(source,target,copy_function=os.link,symlinks=True,ignore=shutil.ignore_patterns('.git','harness_out','__pycache__','.canopy','node_modules'))
def apply(source,prefix):
 for name,data in content.items():
  if name.startswith(prefix+'/'):
   relative=name[len(prefix)+1:];p=source/relative;p.parent.mkdir(parents=True,exist_ok=True)
   tmp=p.with_name(p.name+'.replay-new');tmp.write_bytes(data)
   if p.suffix=='.sh':tmp.chmod(0o755)
   os.replace(tmp,p)
base=json.loads(content['native/baseline-source-pins.json'])
native=json.loads(content['native/candidate-source-pins.json'])
measured=json.loads(content['source-pins.json'])
public=json.loads(content['public-combined-source-pins.json'])
verify(args.baseline,base)
if not args.check:
 args.output.mkdir(exist_ok=False)
 clone(args.baseline,args.output/'candidate-native');apply(args.output/'candidate-native','runtime-files')
 clone(args.baseline,args.output/'reference-source');apply(args.output/'reference-source','measured-harness')
 clone(args.output/'candidate-native',args.output/'candidate-source');apply(args.output/'candidate-source','measured-harness')
 clone(args.output/'candidate-source',args.output/'public-combined-source');apply(args.output/'public-combined-source','public-harness');apply(args.output/'public-combined-source','public-test-fixes')
 evidence=args.output/'evidence';evidence.mkdir()
 for name in ('perf.sh','analyze-perf.py','smoke.sh','audit-smoke.py','public-checks.sh','combined-checks.sh','prior-qualified-counter-gate.json'):
  (evidence/name).write_bytes(content[name])
verify(args.output/'candidate-native',native)
verify(args.output/'reference-source',measured['reference'])
verify(args.output/'candidate-source',measured['candidate'])
verify(args.output/'public-combined-source',public)
print('Verified native, measured, and public source sets; no binaries or new-run completion markers supplied.')

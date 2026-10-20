#!/usr/bin/env python3
import argparse,hashlib,json,subprocess,tarfile
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--baseline',required=True);p.add_argument('--evidence',required=True);p.add_argument('--check',action='store_true');a=p.parse_args()
r=Path(__file__).resolve().parent;b=Path(a.baseline).resolve();e=Path(a.evidence).resolve()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for n,h in json.loads((r/'archive-manifest.json').read_text()).items():assert sha(r/n)==h,n
with tarfile.open(r/'evidence.tar.gz') as archive:
 pins=json.load(archive.extractfile('baseline-source-pins.json'))
 names=subprocess.check_output(['rg','--files','-0','-g','*.go'],cwd=b).decode().split('\0')
 assert {n:sha(b/n) for n in names if n}==pins
 if not a.check:
  e.mkdir(parents=True,exist_ok=False)
  for member in archive.getmembers():
   if member.isfile() and (member.name.endswith(('.go.txt','.json','.sh','.patch')) and member.name not in ['census.json']):
    archive.extract(member,e,filter='data')
reference=json.loads((r/'source-reference.json').read_text())
for n,h in reference['overlay_sha256'].items():assert sha(e/n)==h,n
assert sha(e/'instrumentation.patch')==reference['instrumentation_sha256']
print(json.dumps({'baseline_go_files':len(pins),'all_overlay_hashes_exact':True,'check_only':a.check}))

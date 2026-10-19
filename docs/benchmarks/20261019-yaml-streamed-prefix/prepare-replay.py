#!/usr/bin/env python3
"""Reconstruct the rejected private source outside the protected checkout."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tarfile

parser=argparse.ArgumentParser()
parser.add_argument('--baseline',required=True)
parser.add_argument('--candidate',required=True)
parser.add_argument('--evidence',required=True)
parser.add_argument('--check',action='store_true')
args=parser.parse_args()
receipt=Path(__file__).resolve().parent
baseline=Path(args.baseline).resolve();candidate=Path(args.candidate).resolve();evidence=Path(args.evidence).resolve()
assert baseline!=candidate and baseline not in candidate.parents and candidate not in baseline.parents
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def manifest(root):
    paths=subprocess.check_output(['rg','--files','-0','-g','*.go'],cwd=root).decode().split('\0')
    return {name:sha(root/name) for name in paths if name}
with tarfile.open(receipt/'complete-source-pins.tar.gz') as archive:
    base_pins=json.load(archive.extractfile('baseline-source-pins.json'))
    candidate_pins=json.load(archive.extractfile('candidate-source-pins.json'))
assert manifest(baseline)==base_pins,'baseline source differs'
reference=json.loads((receipt/'source-reference.json').read_text())
assert sha(receipt/'runtime.patch')==reference['runtime_patch_sha256']
if not args.check:
    assert not candidate.exists(),'use a fresh external candidate directory'
    shutil.copytree(baseline,candidate,copy_function=os.link,ignore=shutil.ignore_patterns('.git'))
    runtime=json.loads((receipt/'runtime-pins.json').read_text())
    # Replace linked source inodes before git apply can write them.
    for name in runtime:
        path=candidate/name
        if path.exists():
            temporary=path.with_name(path.name+'.replay-temp')
            temporary.write_bytes(path.read_bytes());os.replace(temporary,path)
    subprocess.run(['git','-C',str(candidate),'apply',str(receipt/'runtime.patch')],check=True)
    evidence.mkdir(parents=True,exist_ok=True)
    with tarfile.open(receipt/'replay-inputs.tar.gz') as archive:
        archive.extractall(evidence,filter='data')
    for name in ['shared_bench_test.go','attempt_census_test.go']:
        shutil.copyfile(receipt/(name+'.txt'),evidence/'pooled'/name)
    shutil.copyfile(receipt/'analyze-counters.py',evidence/'pooled/analyze-counters.py')
    shutil.copyfile(receipt/'analyze-perf.py',evidence/'pooled/analyze-perf.py')
    shutil.copyfile(receipt/'counter-gate.json',evidence/'pooled/counter-gate.json')
    # The focused overlay expects the runtime copies under /evidence/pooled.
    for name in runtime:
        target=evidence/'pooled/runtime'/name
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(candidate/name,target)
assert manifest(candidate)==candidate_pins,'reconstructed source differs'
assert manifest(baseline)==base_pins,'baseline was modified'
print(json.dumps({'baseline_go_files':len(base_pins),'candidate_go_files':len(candidate_pins),'exact':True,'check_only':args.check}))

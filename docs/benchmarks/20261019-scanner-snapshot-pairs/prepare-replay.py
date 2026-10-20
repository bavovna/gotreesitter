#!/usr/bin/env python3
import argparse,hashlib,json,os,shutil,subprocess,tarfile
from pathlib import Path

parser=argparse.ArgumentParser()
for name in ['baseline','candidate','evidence']:parser.add_argument('--'+name,required=True)
parser.add_argument('--check',action='store_true')
parser.add_argument('--native-tests',action='store_true');args=parser.parse_args()
receipt=Path(__file__).resolve().parent
baseline,candidate,evidence=[Path(getattr(args,n)).resolve() for n in ['baseline','candidate','evidence']]
assert baseline!=candidate and baseline not in candidate.parents and candidate not in baseline.parents
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def manifest(root):
    names=subprocess.check_output(['rg','--files','-0','-g','*.go'],cwd=root).decode().split('\0')
    return {name:sha(root/name) for name in names if name}
for name,expected in json.loads((receipt/'archive-manifest.json').read_text()).items():
    assert sha(receipt/name)==expected,name
with tarfile.open(receipt/'complete-source-pins.tar.gz') as archive:
    base_pins=json.load(archive.extractfile('baseline-source-pins.json'))
    candidate_pins=json.load(archive.extractfile('candidate-source-pins.json'))
if args.native_tests:
    candidate_pins=json.loads((receipt/'native-source-pins.json').read_text())
    assert sha(receipt/'native-tests.patch')==json.loads((receipt/'source-reference.json').read_text())['native_test_patch_sha256']
assert manifest(baseline)==base_pins
assert sha(receipt/'runtime.patch')==json.loads((receipt/'source-reference.json').read_text())['runtime_patch_sha256']
if not args.check:
    assert not candidate.exists()
    shutil.copytree(baseline,candidate,copy_function=os.link,ignore=shutil.ignore_patterns('.git'))
    runtime=json.loads((receipt/'runtime-pins.json').read_text())
    for name in runtime:
        path=candidate/name
        if path.exists():
            temporary=path.with_name(path.name+'.replay-temp');temporary.write_bytes(path.read_bytes());os.replace(temporary,path)
    subprocess.run(['git','-C',str(candidate),'apply',str(receipt/'runtime.patch')],check=True)
    if args.native_tests:
        path=candidate/'parsercore_phase0_per_version_lexer_snapshot_internal_test.go'
        temporary=path.with_name(path.name+'.replay-temp');temporary.write_bytes(path.read_bytes());os.replace(temporary,path)
        subprocess.run(['git','-C',str(candidate),'apply',str(receipt/'native-tests.patch')],check=True)
    evidence.mkdir(parents=True,exist_ok=True)
    with tarfile.open(receipt/'replay-inputs.tar.gz') as archive:archive.extractall(evidence,filter='data')
    for name in ['scanner_snapshot_pages_root_test.go.txt','owned_yaml_invariant_test.go.txt','shared_bench_test.go.txt','rss_root_test.go.txt','analyze-perf.py','analyze-counters.py','audit-qualification.py','native-check.sh','native-overlay.json']:
        shutil.copyfile(receipt/name,evidence/name)
    for name in runtime:
        target=evidence/'runtime'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(candidate/name,target)
assert manifest(candidate)==candidate_pins
assert manifest(baseline)==base_pins
print(json.dumps({'baseline_go_files':len(base_pins),'candidate_go_files':len(candidate_pins),'exact':True,'check_only':args.check,'native_tests':args.native_tests}))

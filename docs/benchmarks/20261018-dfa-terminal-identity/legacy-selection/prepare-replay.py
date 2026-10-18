from pathlib import Path
import hashlib,json,shutil,subprocess
p=Path('/evidence');d=p/'legacy-selection';runtime=p/'legacy-runtime';runtime.mkdir(exist_ok=False)
for n,h in json.loads((p/'baseline-source-pins.json').read_text()).items():assert hashlib.sha256((Path('/workspace')/n).read_bytes()).hexdigest()==h,('baseline',n)
pins=json.loads((d/'source-pins.json').read_text());overlay={'Replace':{}}
for n in pins:
 if n.startswith('runtime/'):
  rel=n.removeprefix('runtime/');dest=runtime/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(Path('/workspace')/rel,dest)
subprocess.check_call(['git','apply','--unidiff-zero',str(d/'runtime.patch')],cwd=runtime)
for n,h in pins.items():
 f=runtime/n.removeprefix('runtime/') if n.startswith('runtime/') else p/'probes'/n
 assert hashlib.sha256(f.read_bytes()).hexdigest()==h,('legacy',n)
 if n.startswith('runtime/'):overlay['Replace']['/workspace/'+n.removeprefix('runtime/')]=str(f)
overlay['Replace']['/workspace/cgo_harness/zz_go_legacy_selection_oracle_test.go']=str(p/'probes/oracle_probe_test.go.txt')
(p/'overlay.json').write_text(json.dumps(overlay,indent=2)+'\n')

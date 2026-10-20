"""Run in a fresh writable external evidence copy inside the pinned container."""
from pathlib import Path
import argparse,hashlib,json,shutil,subprocess
p=Path('/evidence');parser=argparse.ArgumentParser();parser.add_argument('variant',choices=['nil-scanner','pressure-only','early-identical','actual-election','oracle-attribution']);variant=parser.parse_args().variant
for n,h in json.loads((p/'baseline-source-pins.json').read_text()).items():assert hashlib.sha256((Path('/workspace')/n).read_bytes()).hexdigest()==h,('baseline',n)
pins=json.loads((p/variant/'source-pins.json').read_text());runtime=p/'runtime';runtime.mkdir(exist_ok=False)
for n in pins:
 if n.startswith('runtime/'):
  rel=n.removeprefix('runtime/');source=Path('/workspace')/rel;dest=runtime/rel
  if source.exists():dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,dest)
subprocess.check_call(['git','apply','--unidiff-zero',str(p/variant/'runtime.patch')],cwd=runtime)
overlay={'Replace':{}}
for n,h in pins.items():
 source=p/n if n.startswith('runtime/') else p/'probes'/n
 assert hashlib.sha256(source.read_bytes()).hexdigest()==h,('variant',n)
 if n.startswith('runtime/'):overlay['Replace']['/workspace/'+n.removeprefix('runtime/')]=str(source)
probe_names={'root_probe_test.go.txt':'zz_go_generic_frontier_test.go','cgo_probe_test.go.txt':'cgo_harness/zz_go_generic_frontier_test.go','root-negative_test.go.txt':'zz_dfa_terminal_source_negative_test.go','oracle_probe_test.go.txt':'cgo_harness/zz_dfa_selection_oracle_test.go'}
for n,target in probe_names.items():
 if n in pins:overlay['Replace']['/workspace/'+target]=str(p/'probes'/n)
for n in ['overlay.json','oracle-overlay.json']:(p/n).write_text(json.dumps(overlay,indent=2)+'\n')
print('All baseline and variant hashes match; overlay prepared:',variant)

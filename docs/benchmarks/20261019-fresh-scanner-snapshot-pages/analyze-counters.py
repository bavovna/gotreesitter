#!/usr/bin/env python3
import json,sys,tarfile
from pathlib import Path

receipt=Path(__file__).resolve().parent
evidence=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else receipt
with tarfile.open(receipt/'correctness-logs.tar.gz') as archive:
    baseline=archive.extractfile('baseline-public-and-attempt-census.log').read().decode()
def rows(text):
    result={}
    for line in text.splitlines():
        if 'PUBLIC_WORK ' in line:
            row=json.loads(line.split('PUBLIC_WORK ',1)[1]);result[(row['fixture'],row['mode'])]=row
    return result
a,b=rows(baseline),rows((evidence/'integrated-public-work.log').read_text())
assert len(a)==len(b)==6 and a==b
log=(evidence/'integrated-root.log').read_text()
assert '--- PASS: TestParserCoreFreshFullRunnerRepeatedCanonicalLifecycle' in log
assert '--- FAIL' not in log
report={'passed':True,'six_public_full_and_edit_rows_exact':True,'canonical_go_work_pins_pass':True}
(evidence/'counter-gate.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report))

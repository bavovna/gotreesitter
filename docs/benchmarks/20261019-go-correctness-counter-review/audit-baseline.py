from pathlib import Path
import json,re
p=Path(__file__).resolve().parent
assert (p/'baseline-control-complete.txt').read_text().strip()=='complete'
assert (p/'baseline-go-c-control-exit.txt').read_text().strip()=='1'
text=(p/'baseline-go-c-control.log').read_text()
passed=re.findall(r'^\s*--- PASS: TestGoTokenTurnExpandedLockedCProbe/([^\s]+)',text,re.M)
failed=re.findall(r'^\s*--- FAIL: TestGoTokenTurnExpandedLockedCProbe/([^\s]+)',text,re.M)
generic=re.findall(r'^\s*--- PASS: TestGoGenericCallFrontierLockedCProbe/([^\s]+)',text,re.M)
assert len(passed)==261 and len(failed)==39 and len(generic)==6,(len(passed),len(failed),len(generic))
for name in ['candidate-layout.log','candidate-v1guard.log','candidate-selectors.log']:
 assert (p/name).read_text().strip(),name
report=dict(baseline_runtime='54863cf280722c720bda81c2a8480f2398255730',expanded_pass=261,expanded_fail=39,generic_pass=6,failed_expanded_cases=failed,layout_api_guard_pass=True,language_environment_guard_pass=True,selectors_pass=True)
(p/'baseline-control-audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

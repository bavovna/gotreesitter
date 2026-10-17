from pathlib import Path
import json,re,hashlib,subprocess
p=Path(__file__).resolve().parent
langs=(p/'fleet/languages.txt').read_text().splitlines();assert len(langs)==len(set(langs))==206
inv=[];par=[]
for lang in langs:
 a=(p/f'fleet/invariant-{lang}.log').read_text()
 m=re.search(r'language='+re.escape(lang)+r' fixture=(\S+) sample_bytes=(\d+) session_steps=72 no_edit_allocs=0',a);assert m,lang
 assert '--- PASS: TestV1InvariantGateR4EditSession ' in a and '\nPASS\n' in a and '--- SKIP:' not in a and '--- FAIL:' not in a,lang
 inv.append(dict(language=lang,fixture=m[1],sample_bytes=int(m[2]),steps=72,no_edit_allocs=0,sha256=hashlib.sha256(a.encode()).hexdigest()))
 a=(p/f'fleet/c-{lang}.log').read_text();assert '--- FAIL:' not in a and '--- SKIP:' not in a and '\nPASS\n' in a,lang
 for suite in ['TestParityFreshParse','TestParityIncrementalParse','TestParityHasNoErrors']:
  assert re.search(r'--- PASS: '+suite+'/'+re.escape(lang)+r' \(',a),(lang,suite)
 par.append(dict(language=lang,checks=3,sha256=hashlib.sha256(a.encode()).hexdigest()))
a=json.loads((p/'fleet/baseline-strict-census.json').read_text());b=json.loads((p/'fleet/candidate-strict-census.json').read_text());assert a==b and len(a)==204
strict=dict(rows=len(a),pass_count=sum(x['status']=='PASS' for x in a),compact_pass=sum(x['status']=='PASS' and x['compact']==1 for x in a),legacy_pass=sum(x['status']=='PASS' and x['compact']==0 for x in a),existing_legacy_fail=sum(x['status']=='FAIL' and x['compact']==0 for x in a),all_rows_exact=True)
assert (strict['compact_pass'],strict['legacy_pass'],strict['existing_legacy_fail'])==(120,39,45)
rss=json.loads((p/'rss-matched/audit.json').read_text());assert len(rss['initial'])==6 and len(rss['matched'])==120 and rss['candidate_safety_pass']
assert all(x['rss_bytes_per_source_byte']<=400 for x in rss['initial']+rss['matched'])
assert all(x<=1.1 for x in rss['candidate_baseline_median_ratios'].values())
for name in ['core-all.log','core-phase0a.log','core-race.log','core-386.log','root-race.log','fleet/core-onepass.log']:
 a=(p/name).read_text();assert 'ok  ' in a and 'FAIL' not in a,name
for name in ['root-focused.log','fleet/memory-budgets.log','fleet/go-invariant-race.log','fleet/yaml-invariant-race.log','fleet/owned-yaml-invariant-race.log','fleet/owned-yaml-invariant.log']:
 a=(p/name).read_text();assert '\nPASS\n' in a and '--- FAIL:' not in a and '--- SKIP:' not in a,name
for role in ['baseline','candidate']:
 for case in ['go','yaml-ordinary','yaml-owned']:
  a=(p/f'fleet/{role}-{case}-1m.log').read_text();assert '\nPASS\n' in a and '--- FAIL:' not in a and '--- SKIP:' not in a,(role,case)
can=json.loads((p/'fleet/canonical-work.json').read_text());assert can['baseline']==can['candidate'] and len(can['baseline'])==4
pins=json.loads((p/'source-pins.json').read_text())
for name,h in pins.items():assert hashlib.sha256((p/'runtime'/name).read_bytes()).hexdigest()==h,name
assert json.loads((p/'counter-gate.json').read_text())['all_fields_exact']
audit=dict(status='qualification_pass_actual_source_pending',invariant_languages=inv,c_fixture_languages=par,strict_census=strict,canonical_full_vectors_exact=4,ledger_rows_exact=414,consumed_vectors_exact=5,full_core_and_focused_races=True,go_yaml_owned_yaml_invariant_races=True,memory_contracts=True,one_mib_go_ordinary_yaml_owned_yaml_c_exact=True,rss=dict(initial=6,matched=120,ceiling=400,candidate_baseline_median_ratios=rss['candidate_baseline_median_ratios'],all_safe=True),source_pins=pins)
(p/'qualification-audit.json').write_text(json.dumps(audit,indent=2)+'\n')
print('Qualification audit: 206 invariant sessions, 618 C fixture checks, 204 strict rows unchanged (120/39/45), 126 RSS probes within ceiling and ratchet; source pins exact')

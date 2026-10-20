from pathlib import Path
from statistics import median
import hashlib,json,os,re,subprocess
p=Path('/evidence');assert os.environ['GOMAXPROCS']=='1'
rows=[]
pins={role:hashlib.sha256((p/f'{role}.test').read_bytes()).hexdigest() for role in ['baseline','candidate']}
for seed in [None,*range(35201,35221)]:
    order=['baseline','candidate'] if seed is None or seed%2 else ['candidate','baseline']
    for position,role in enumerate(order,1):
        prefix=f'{seed if seed is not None else "initial"}-{role}'
        log=p/(prefix+'.log');rss=p/(prefix+'.rss')
        args=['/usr/bin/time','-v','-o',str(rss),str(p/f'{role}.test'),'-test.run','^TestCompactLineageRSS$/^go$','-test.count=1','-test.v','-test.timeout=4m']
        if seed is not None:args.append(f'-test.shuffle={seed}')
        with log.open('w') as stream:subprocess.run(args,cwd='/reference' if role=='baseline' else '/workspace',check=True,stdout=stream,stderr=subprocess.STDOUT)
        text=log.read_text();assert '--- PASS:' in text and '--- SKIP:' not in text
        assert 'bytes=1048591 ' in text and 'nodes=903086/' in text and 'tokens=425742 ' in text and 'compact=1 fallback=0' in text and 'stopReason=accepted' in text
        peak=int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',rss.read_text())[1])*1024
        row=dict(seed=seed,position=position,role=role,peak_rss_bytes=peak,rss_bytes_per_source_byte=peak/1048591);rows.append(row)
        print(row,flush=True)
        (p/'rows.json').write_text(json.dumps(rows,indent=2)+'\n')
assert all(hashlib.sha256((p/f'{role}.test').read_bytes()).hexdigest()==h for role,h in pins.items())
summary={}
for role in ['baseline','candidate']:
    values=[r['rss_bytes_per_source_byte'] for r in rows if r['role']==role and r['seed'] is not None];assert len(values)==20
    summary[role]=dict(median=median(values),maximum=max(values),count=len(values))
ratio=summary['candidate']['median']/summary['baseline']['median']
failures=[r for r in rows if r['role']=='candidate' and r['rss_bytes_per_source_byte']>400]
passed=not failures and ratio<=1.10
report=dict(scope='Go only after progress-based arena projection; memory safety, no timing claim',seeds='35201..35220',rows=rows,summary=summary,median_ratio=ratio,candidate_ceiling_failures=failures,passed=passed,binary_sha256=pins)
(p/'audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2),flush=True)
if not passed:raise SystemExit('Go RSS gate failed; retain all probes')
(p/'complete.txt').write_text('complete\n')

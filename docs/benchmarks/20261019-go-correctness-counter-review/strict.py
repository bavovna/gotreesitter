import collections,json,os,pathlib,re,subprocess,sys

p=pathlib.Path('/evidence/out')/sys.argv[1]
expected=json.loads(pathlib.Path('/evidence/production-strict-census.json').read_text())
by_language={r['language']:r for r in expected}
rows=[r for r in json.loads(pathlib.Path('/workspace/internal/benchfixtures/real_corpus.json').read_text())['entries'] if r['role']=='sample' and r.get('committed_path')]
assert len(rows)==204
results=[]
for row in rows:
    lang=row['language']
    env=dict(os.environ,GTS_ADMISSION_REAL_CORPUS_LANGS=lang)
    run=subprocess.run([str(p/'cgo.test'),'-test.run','^TestCompactR4StructuralLockedC$','-test.v','-test.count=1','-test.timeout=2m'],cwd='/workspace/cgo_harness',env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=130)
    (p/f'strict-{lang}.log').write_text(run.stdout)
    assert '--- SKIP' not in run.stdout,lang
    route=re.search(r'compact=(\d+) fallback=(\d+) reason=(.*)',run.stdout)
    assert route,lang
    result=dict(language=lang,status='PASS' if run.returncode==0 and '--- PASS:' in run.stdout else 'FAIL',compact=int(route[1]),fallback=int(route[2]),reason=route[3],first_difference=next((line.strip() for line in run.stdout.splitlines() if 'go=' in line),''))
    assert run.returncode in [0,1],(lang,run.returncode)
    results.append(result)
    (p/'strict-partial.json').write_text(json.dumps(results,indent=2)+'\n')
    # Keep existing baseline failures visible and stop at the first new C
    # mismatch. A changed successful route remains a reviewable observation.
    assert result['status']=='PASS' or by_language[lang]['status']=='FAIL',(lang,result)
    if result['compact']==1:assert result['status']=='PASS',(lang,result)
    print(sys.argv[1],lang,result['status'],result['compact'],result['fallback'],flush=True)
(p/'strict-census.json').write_text(json.dumps(results,indent=2)+'\n')
differences=[dict(language=r['language'],production=by_language[r['language']],candidate=r) for r in results if r!=by_language[r['language']]]
(p/'strict-differences.json').write_text(json.dumps(differences,indent=2)+'\n')
print('TOTAL',dict(collections.Counter(r['status'] for r in results)),'changed_rows',len(differences),flush=True)

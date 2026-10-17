"""Prepare a writable external evidence copy; run inside the pinned container."""
from pathlib import Path
import hashlib
import json
import shutil

p = Path('/evidence')
reference = json.loads((p / 'source-reference.json').read_text())
pins = json.loads((p / 'actual-source-pins.json').read_text())
new_files = {
    'internal/parsercorephase0/shift_owner.go',
    'internal/parsercorephase0/shift_owner_test.go',
}
for name, expected in pins.items():
    actual = hashlib.sha256((Path('/workspace') / name).read_bytes()).hexdigest()
    assert actual == expected, ('candidate', name)
    if name in new_files:
        assert not (Path('/baseline') / name).exists(), ('baseline new file', name)
        continue
    expected = reference['baseline_changed_source_pins'].get(name, expected)
    actual = hashlib.sha256((Path('/baseline') / name).read_bytes()).hexdigest()
    assert actual == expected, ('baseline', name)

for name in ['owned-benchmark', 'owned-ledger']:
    shutil.copyfile(p / (name + '.go.txt'), p / (name + '.go'))

shared = {
    'benchmark_admission_candidate_route_test.go': 'owned-benchmark.go',
    'cmd/perfcounterledger/main.go': 'owned-ledger.go',
    'deferred_publication_work_census_test.go': 'work-census.go.txt',
    'compact_go_full_consume_test.go': 'consume-bench.go.txt',
}
overlay = {'Replace': {
    root + '/' + name: str(p / source)
    for root in ['/baseline', '/workspace']
    for name, source in shared.items()
}}
(p / 'overlay.json').write_text(json.dumps(overlay, indent=2) + '\n')
fleet = p / 'fleet'
fleet.mkdir(exist_ok=True)
for source, dest in [
    ('fleet-run.sh', 'run.sh'), ('strict.py', 'strict.py'),
    ('languages.txt', 'languages.txt'),
    ('large_go_test.go.txt', 'large_go_test.go'),
    ('rss_root_test.go.txt', 'rss_root_test.go'),
    ('canonical_work_census_test.go.txt', 'canonical_work_census_test.go'),
]:
    shutil.copyfile(p / source, fleet / dest)
additional = {
    'cgo_harness/compact_lineage_large_go_probe_test.go': 'large_go_test.go',
    'compact_lineage_rss_probe_test.go': 'rss_root_test.go',
    'canonical_work_census_test.go': 'canonical_work_census_test.go',
}
overlay['Replace'].update({
    root + '/' + name: str(fleet / source)
    for root in ['/baseline', '/workspace']
    for name, source in additional.items()
})
(fleet / 'overlay.json').write_text(json.dumps(overlay, indent=2) + '\n')
shutil.copytree('/workspace/internal/parsercorephase0', p / 'coverage-core', dirs_exist_ok=True)
check = p / 'check-counters.py'
check.write_text(check.read_text().replace("q=Path('/reference')", "q=p/'reference'"))
(p / 'reference').mkdir(exist_ok=True)
print('Both source manifests match; diagnostic overlays and fleet probes prepared.')

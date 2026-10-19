#!/usr/bin/env python3
import json
from pathlib import Path

lab = Path(__file__).resolve().parent

def read(role, marker, keys):
    rows = {}
    for line in (lab / 'census' / (role + '.log')).read_text().splitlines():
        if marker not in line:
            continue
        row = json.loads(line.split(marker, 1)[1].strip())
        key = tuple(row[k] for k in keys)
        if key in rows:
            raise SystemExit('duplicate census row: ' + repr(key))
        rows[key] = row
    return rows

public = {r: read(r, 'PUBLIC_WORK ', ['fixture', 'mode']) for r in ['baseline', 'candidate']}
attempt = {r: read(r, 'ATTEMPT_WORK ', ['fixture', 'owned']) for r in ['baseline', 'candidate']}
assert len(public['baseline']) == len(public['candidate']) == 6
assert len(attempt['baseline']) == len(attempt['candidate']) == 4
assert public['baseline'].keys() == public['candidate'].keys()
assert attempt['baseline'].keys() == attempt['candidate'].keys()
changes, failures = [], []

def compare(fixture, metric, before, after, direction='down'):
    changes.append(dict(fixture=fixture, metric=metric, before=before, after=after))
    if (after > before if direction == 'down' else after < before):
        failures.append(changes[-1])

for key, before in public['baseline'].items():
    after = public['candidate'][key]
    name = '/'.join(key)
    for phase in ['full', 'edit']:
        for metric in ['nodes', 'tokens']:
            compare(name, phase+'/'+metric, before[phase][metric], after[phase][metric])
    for metric in ['reused_bytes', 'splices']:
        compare(name, 'edit/'+metric, before['edit'][metric], after['edit'][metric], 'up')
    if key[1] == 'legacy':
        compare(name, 'full/peak', before['full']['max_versions'], after['full']['max_versions'])
    else:
        owned = key[1] == 'owned'
        a, b = attempt['baseline'][(key[0], owned)], attempt['candidate'][(key[0], owned)]
        compare(name, 'full/total_peak_including_decline', a['total_peak'], b['total_peak'])
        compare(name, 'full/total_nodes_including_decline', a['total_nodes'], b['total_nodes'])
        # These fresh requests have one compact attempt and no retry. A
        # successful compact tree repeats that attempt's token total; a
        # fallback tree adds the separate legacy request.
        for row in [a, b]:
            assert row['attempt_prior_tokens'] == 0
            if row['compact']:
                assert row['returned_tokens'] == row['attempt_final_tokens']
        def total_tokens(row):
            return row['attempt_final_tokens'] + (row['returned_tokens'] if row['fallback'] else 0)
        compare(name, 'full/total_tokens_including_decline', total_tokens(a), total_tokens(b))
        if b['compact'] != 1 or b['fallback'] != 0:
            failures.append(dict(fixture=name, reason='candidate did not complete on compact'))

result = dict(passed=not failures, comparisons=changes, failures=failures,
    scope='Six public YAML full/edit cases; four retained-runner attempt censuses. '
          'The baseline ordinary route declines before returning its legacy tree. '
          'Peak comparisons include that compact attempt; the returned legacy peak alone does not.')
(lab/'counter-gate.json').write_text(json.dumps(result, indent=2)+'\n')
print(json.dumps(dict(passed=result['passed'], comparisons=len(changes), failures=failures), indent=2))
if failures:
    raise SystemExit(1)

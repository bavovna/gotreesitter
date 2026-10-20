#!/usr/bin/env bash
set -euo pipefail
test -f /candidate/qualify-complete.txt
test -f /candidate/qualification-audit.json
test -f /candidate/baseline-control-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
mkdir /evidence/probes
for role in baseline candidate; do
  if [[ $role == baseline ]]; then cd /reference; else cd /workspace; fi
  go test -c -tags gts_parsercorephase0 -o "/evidence/probes/$role-rss-root.test" . > "/evidence/probes/$role-build.log" 2>&1
  for name in go yaml_ordinary yaml_owned; do
    /usr/bin/time -v -o "/evidence/probes/$role-standalone-$name.rss" "/evidence/probes/$role-rss-root.test" -test.run "^TestCompactLineageRSS$/^${name}$" -test.count=1 -test.v -test.timeout=8m > "/evidence/probes/$role-standalone-$name.log" 2>&1
  done
done
python3 /evidence/repeat_rss.py > /evidence/rss-run.log 2>&1
printf 'complete\n' > /evidence/complete.txt

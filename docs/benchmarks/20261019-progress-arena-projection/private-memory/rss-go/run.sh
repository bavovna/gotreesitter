#!/usr/bin/env bash
set -euo pipefail
test -f /candidate/screen-complete.txt
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
for role in baseline candidate; do
  if [[ $role == baseline ]]; then cd /reference; else cd /workspace; fi
  go test -c -tags gts_parsercorephase0 -o "/evidence/$role.test" . > "/evidence/$role-build.log" 2>&1
done
python3 /evidence/repeat.py > /evidence/repeat.log 2>&1

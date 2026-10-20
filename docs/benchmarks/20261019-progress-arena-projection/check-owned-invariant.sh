#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/owned-invariant-overlay.json'
cd /workspace
GTS_ADMISSION_CANDIDATE=1 go test . -tags gts_parsercorephase0 -run '^TestProgressArenaOwnedYAMLInvariant$' -count=1 -v -timeout=8m > /evidence/out/candidate/owned-yaml-invariant.log 2>&1
printf 'complete\n' > /evidence/owned-invariant-complete.txt

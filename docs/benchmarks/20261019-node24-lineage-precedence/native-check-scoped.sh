#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/local/go/bin:$PATH GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false'
cd /candidate
go run ./cmd/v1guard -root /candidate > /evidence/native-v1guard.log 2>&1
go run ./cmd/citestplan -stale-run-names -repo-root /candidate > /evidence/native-selectors.log 2>&1
printf 'complete\n' > /evidence/native-complete.txt

#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test ./internal/parsercorephase0 -run '^TestFreshDFATerminalOriginAdapter' -count=1 -v -timeout=8m > /evidence/adapter-focused.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test ./internal/parsercorephase0 -run '^TestFreshDFATerminalOriginAdapter' -count=1 -v -timeout=8m > /evidence/adapter-386.log 2>&1
bash /evidence/baseline-control.sh
printf 'complete\n' > /evidence/preflight-complete.txt

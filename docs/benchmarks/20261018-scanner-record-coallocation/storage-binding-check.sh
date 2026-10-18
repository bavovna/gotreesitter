#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /workspace
go test . -tags gts_parsercorephase0 -run '^TestDiagnosticParserCoreVersionLexerCoallocatedStorageBudgetAndGeneration$' -count=1 -v -timeout=8m > /evidence/storage-binding.log 2>&1
go test . -tags gts_parsercorephase0 -race -run '^TestDiagnosticParserCoreVersionLexerCoallocatedStorageBudgetAndGeneration$' -count=1 -v -timeout=8m > /evidence/storage-binding-race.log 2>&1
GOARCH=386 CGO_ENABLED=0 go test . -tags gts_parsercorephase0 -run '^TestDiagnosticParserCoreVersionLexerCoallocatedStorageBudgetAndGeneration$' -count=1 -v -timeout=8m > /evidence/storage-binding-386.log 2>&1
printf 'complete\n' > /evidence/storage-binding-check-complete.txt
echo 'snapshot coallocation byte/boolean isolation, reserved-capacity accounting and reset-generation checks passed normally, under race and on 386'

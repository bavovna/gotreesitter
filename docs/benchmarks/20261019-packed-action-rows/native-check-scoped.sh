#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/perf/complete.txt
export PATH=/usr/local/go/bin:$PATH GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false'
cd /candidate
go run ./cmd/citestplan -stale-run-names -repo-root /candidate > /evidence/native-selectors.log 2>&1
for role in baseline candidate; do
 if [[ "$role" = baseline ]]; then cd /reference; else cd /candidate; fi
 go test . -tags gts_parsercorephase0 -run '^TestParserCoreLanguageTables(Footprint|CacheSharesAcrossParsers)$' -count=1 -v > "/evidence/$role-language-table-retention.log" 2>&1
done
printf 'complete\n' > /evidence/native-complete.txt

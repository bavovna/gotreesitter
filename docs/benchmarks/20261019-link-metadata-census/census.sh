#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/local/go/bin:$PATH GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
cd /reference
go test -c -tags gts_parsercorephase0 -o /evidence/census.test . > /evidence/build.log 2>&1
for name in go_query go_grammargen yaml_r4_owned yaml_8k_owned; do
 GTS_LINK_METADATA_CENSUS="$name" /evidence/census.test -test.run '^TestLinkMetadataSmallCensus$' -test.count=1 -test.v -test.timeout=4m > "/evidence/$name.log" 2>&1
done
GTS_LINK_METADATA_CENSUS=go_large /evidence/census.test -test.run '^TestCompactLineageRSS$/^go$' -test.count=1 -test.v -test.timeout=4m > /evidence/go_large.log 2>&1
GTS_LINK_METADATA_CENSUS=yaml_large_owned /evidence/census.test -test.run '^TestCompactLineageRSS$/^yaml_owned$' -test.count=1 -test.v -test.timeout=4m > /evidence/yaml_large_owned.log 2>&1
printf 'complete\n' > /evidence/complete.txt

#!/usr/bin/env bash
set -euo pipefail
export GOWORK=off GOMAXPROCS=1 GOFLAGS='-p=1 -buildvcs=false -overlay=/evidence/overlay.json'
for role in baseline candidate;do
 if [[ $role == baseline ]];then cd /baseline;else cd /workspace;fi
 go test -c -gcflags='github.com/odvcencio/gotreesitter/internal/parsercorephase0=-m=2' -o /evidence/$role-core.test ./internal/parsercorephase0 > /evidence/$role-compiler.log 2>&1
 /evidence/$role-core.test -test.run '^TestScannerFingerprint' -test.count=1 -test.v > /evidence/$role-fingerprint.log 2>&1
 go tool objdump -s 'github.com/odvcencio/gotreesitter/internal/parsercorephase0.ScannerFingerprint$' /evidence/$role-core.test > /evidence/$role-entry.asm
 echo "$role scanner fingerprint tests and compiler output captured"
done
printf 'complete\n' > /evidence/compiler-complete.txt

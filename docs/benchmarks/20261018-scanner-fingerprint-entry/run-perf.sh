#!/usr/bin/env bash
set -euo pipefail
test -f /evidence/screen-complete.txt
python3 - <<'PINS'
from pathlib import Path
import hashlib,json
p=Path('/evidence')
for n,h in json.loads((p/'source-pins.json').read_text()).items():assert hashlib.sha256((p/'runtime'/n).read_bytes()).hexdigest()==h,n
for n,h in json.loads((p/'baseline-source-pins.json').read_text()).items():assert hashlib.sha256((p/'baseline'/n).read_bytes()).hexdigest()==h,n
PINS
bash /evidence/perf.sh

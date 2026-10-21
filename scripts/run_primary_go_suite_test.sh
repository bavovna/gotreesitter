#!/usr/bin/env bash
set -euo pipefail
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
runner="$script_dir/run_randomized_benchmarks.sh"
work=$(mktemp -d "${TMPDIR:-/tmp}/gotreesitter-primary-contract.XXXXXX")
cleanup() {
 local status=$?
 if ((status != 0)); then
  for log in "$work"/*.log "$work/before.txt" "$work/after.txt"; do
   [[ -f "$log" ]] || continue
   printf 'diagnostic: %s\n' "$log" >&2
   tail -n 24 "$log" >&2
  done
 fi
 rm -rf -- "$work"
 return "$status"
}
trap cleanup EXIT
baseline="$work/baseline"
head="$work/head source \"quoted\""
mkdir -p -- "$work/suite temp \"quoted\""
fixture() {
 local root=$1 mode=${2:-normal}
 mkdir -p -- "$root"
 printf 'module fixture.invalid/primary\n\ngo 1.22.0\n' > "$root/go.mod"
 printf 'package gotreesitter\n' > "$root/core.go"
 cat > "$root/benchmark_test.go" <<'EOF'
package gotreesitter_test
import "testing"
var witness uint64
func work(b *testing.B) { b.ReportAllocs(); for i:=0;i<b.N;i++ { for j:=0;j<4096;j++ { witness+=uint64(j+1) } } }
func BenchmarkGoParseIncrementalSingleByteEditDFA(b *testing.B) { work(b);b.ReportMetric(22,"identity/op") }
func TestExisting(t *testing.T) {}
EOF
 if [[ "$mode" == fail ]]; then
  printf 'func BenchmarkGoParseFullDFA(b *testing.B) { b.Fatal("primary contract canary") }\n' >> "$root/benchmark_test.go"
 else
  printf 'func BenchmarkGoParseFullDFA(b *testing.B) { work(b);b.ReportMetric(11,"identity/op") }\n' >> "$root/benchmark_test.go"
 fi
 if [[ "$mode" != missing ]]; then
  printf 'func BenchmarkGoParseIncrementalNoEditDFA(b *testing.B) { work(b);b.ReportMetric(33,"identity/op") }\n' >> "$root/benchmark_test.go"
 fi
}
fixture "$baseline"
fixture "$head"
printf 'package gotreesitter_test\nimport "testing"\nfunc TestAdditionalOne(t *testing.T) {}\nfunc TestAdditionalTwo(t *testing.T) {}\n' > "$head/additional_test.go"
sha256sum -- "$baseline/go.mod" "$baseline/core.go" "$baseline/benchmark_test.go" "$head/go.mod" "$head/core.go" "$head/benchmark_test.go" "$head/additional_test.go" > "$work/input-before.sha256"
(
 cd -- "$head"
 TMPDIR="$work/suite temp \"quoted\"" bash "$runner" --primary-go-suite \
  --output "$work/after.txt" --baseline-root "$baseline" --baseline-output "$work/before.txt" \
  --lock-path "$work/positive.lock" --runs 4 --seed-start 1 --benchtime 1x --tags '' > "$work/positive.log" 2>&1
)
for role in before after; do
 [[ "$(tail -n 1 "$work/$role.txt")" == '# status: complete' ]]
 [[ "$(awk '/^Benchmark/ {n++} END {print n+0}' "$work/$role.txt")" == 12 ]]
 awk '
  /^Benchmark/ {
   name=$1;sub(/-[0-9]+$/,"",name)
   expected=(name=="BenchmarkGoParseFullDFA"?11:name=="BenchmarkGoParseIncrementalSingleByteEditDFA"?22:name=="BenchmarkGoParseIncrementalNoEditDFA"?33:0)
   found=0;for(i=4;i<=NF;i+=2)if($i=="identity/op"){found=1;if($(i-1)!=expected)bad=1}
   if(!found||!expected)bad=1
  }
  END {exit bad}
 ' "$work/$role.txt"
 [[ "$(awk '/^# workload order:/ {print}' "$work/$role.txt" | sort -u | wc -l)" -ge 2 ]]
 grep -F '# primary Go suite source SHA256:' "$work/$role.txt" > "$work/$role-hash.txt"
 awk '/^# workload order:/ {print}' "$work/$role.txt" > "$work/$role-order.txt"
 ! grep -q '^BenchmarkGTSSeededPrimary/' "$work/$role.txt"
done
cmp "$work/before-hash.txt" "$work/after-hash.txt"
cmp "$work/before-order.txt" "$work/after-order.txt"
sha256sum -- "$baseline/go.mod" "$baseline/core.go" "$baseline/benchmark_test.go" "$head/go.mod" "$head/core.go" "$head/benchmark_test.go" "$head/additional_test.go" > "$work/input-after.sha256"
cmp "$work/input-before.sha256" "$work/input-after.sha256"
[[ ! -e "$baseline/zz_gts_seeded_primary_benchmark_test.go" && ! -e "$head/zz_gts_seeded_primary_benchmark_test.go" ]]
shopt -s nullglob
leftovers=("$work/suite temp \"quoted\""/gotreesitter-primary-suite.*)
[[ "${#leftovers[@]}" == 0 ]]
printf '%s\n' 'ok - actual Go paired trio stays ordered with different registered tests, quoted paths, source identity and temporary cleanup'

reject() {
 local label=$1
 shift
 if (
  cd -- "$head"
  bash "$runner" --primary-go-suite --output "$work/$label.txt" --lock-path "$work/$label.lock" --runs 1 --benchtime 1x "$@"
 ) > "$work/$label.log" 2>&1; then
  printf 'not ok - accepted %s\n' "$label" >&2; exit 1
 fi
}
reject custom-selector --bench-regex '^BenchmarkGoParseFullDFA$'
reject wrong-package --package ./nested
reject wrong-required-set --require-benchmarks BenchmarkGoParseFullDFA
printf '%s\n' 'ok - primary suite rejects conflicting selectors, packages and partial required sets'

printf '{"Replace":{}}\n' > "$work/existing-overlay.json"
if (
 cd -- "$head"
 GOFLAGS="-overlay=$work/existing-overlay.json" bash "$runner" --primary-go-suite --output "$work/overlay.txt" --lock-path "$work/overlay.lock" --runs 1 --benchtime 1x
) > "$work/overlay.log" 2>&1; then
 printf '%s\n' 'not ok - replaced an existing Go overlay' >&2; exit 1
fi
grep -F 'cannot replace an existing Go overlay' "$work/overlay.log" >/dev/null
printf '%s\n' 'ok - primary suite preserves an existing Go overlay by refusing composition'

anchor="$head/benchmark_test.go"
cp -- "$anchor" "$work/original-anchor.go.txt"
printf 'func BenchmarkGTSSeededPrimary(b *testing.B) {}\n' >> "$anchor"
sha256sum -- "$anchor" > "$work/anchor-before.sha256"
reject existing-suite
grep -F 'primary suite benchmark already exists' "$work/existing-suite.log" >/dev/null
sha256sum -- "$anchor" > "$work/anchor-after.sha256"
cmp "$work/anchor-before.sha256" "$work/anchor-after.sha256"
rm -- "$anchor"
ln -s -- "$work/nonexistent" "$anchor"
reject dangling-source
grep -F 'requires a regular benchmark_test.go' "$work/dangling-source.log" >/dev/null
[[ -L "$anchor" ]]
rm -- "$anchor"
mv -- "$work/original-anchor.go.txt" "$anchor"
printf '%s\n' 'ok - primary suite preserves existing suite source and refuses symlink anchors'

for mode in missing fail; do
 fixture "$work/$mode" "$mode"
 if (
  cd -- "$work/$mode"
  bash "$runner" --primary-go-suite --output "$work/$mode-after.txt" --baseline-root "$baseline" --baseline-output "$work/$mode-before.txt" --lock-path "$work/$mode.lock" --runs 1 --seed-start 1 --benchtime 1x
 ) > "$work/$mode.log" 2>&1; then
  printf 'not ok - accepted %s benchmark\n' "$mode" >&2; exit 1
 fi
 for role in before after; do [[ "$(tail -n 1 "$work/$mode-$role.txt")" == '# status: incomplete' ]]; done
done
grep -F 'undefined: BenchmarkGoParseIncrementalNoEditDFA' "$work/missing.log" >/dev/null
grep -F 'primary contract canary' "$work/fail-after.txt" >/dev/null
printf '%s\n' 'ok - missing workloads and actual Go benchmark failures remain fatal and leave both outputs incomplete'

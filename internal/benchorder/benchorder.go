// Package benchorder runs benchmark workloads in an explicit seeded order.
// The order does not depend on unrelated tests registered in the package.
package benchorder

import (
	"fmt"
	"math/rand"
	"slices"
	"strings"
	"testing"
)

// SeedEnv is set once per process by scripts/run_randomized_benchmarks.sh.
const SeedEnv = "GTS_BENCHMARK_SEED"

// Case is one independently timed benchmark workload.
type Case struct {
	Label string
	Run   func(*testing.B)
}

// Run invokes each workload once in seeded order. Each subbenchmark retains
// testing.B's normal calibration, timers, and memory accounting. The caller
// supplies the seed; this support package reads no process settings.
func Run(b *testing.B, cases []Case, seed int64) {
	b.Helper()
	ordered, err := order(cases, seed)
	if err != nil {
		b.Fatal(err)
	}
	for _, c := range ordered {
		b.Run(c.Label, c.Run)
	}
}

func order(cases []Case, seed int64) ([]Case, error) {
	if len(cases) == 0 {
		return nil, fmt.Errorf("benchmark suite has no workloads")
	}
	result := slices.Clone(cases)
	slices.SortFunc(result, func(a, b Case) int { return strings.Compare(a.Label, b.Label) })
	for i, c := range result {
		if c.Label == "" || strings.ContainsAny(c.Label, " \t\r\n/") || c.Run == nil {
			return nil, fmt.Errorf("invalid benchmark workload %q", c.Label)
		}
		if i > 0 && result[i-1].Label == c.Label {
			return nil, fmt.Errorf("duplicate benchmark workload %q", c.Label)
		}
	}
	rand.New(rand.NewSource(seed)).Shuffle(len(result), func(i, j int) { result[i], result[j] = result[j], result[i] })
	return result, nil
}

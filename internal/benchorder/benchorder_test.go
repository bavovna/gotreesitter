package benchorder

import (
	"reflect"
	"slices"
	"testing"
)

func TestOrderPreservesWorkloadsAndIgnoresRegistrationOrder(t *testing.T) {
	runs := map[string]int{}
	makeCase := func(name string) Case { return Case{Label: name, Run: func(*testing.B) { runs[name]++ }} }
	original := []Case{makeCase("cold"), makeCase("edit"), makeCase("warm"), makeCase("no_edit"), makeCase("corpus")}
	reversed := slices.Clone(original)
	slices.Reverse(reversed)
	seen := map[string]bool{}
	for seed := int64(0); seed < 20; seed++ {
		a, err := order(original, seed)
		if err != nil {
			t.Fatal(err)
		}
		b, err := order(reversed, seed)
		if err != nil {
			t.Fatal(err)
		}
		names := func(cases []Case) []string {
			out := make([]string, len(cases))
			for i, c := range cases {
				out[i] = c.Label
			}
			return out
		}
		if !reflect.DeepEqual(names(a), names(b)) {
			t.Fatalf("seed %d depends on registration order", seed)
		}
		seen[fmtNames(a)] = true
		for _, c := range a {
			c.Run(nil)
		}
	}
	if len(runs) != len(original) {
		t.Fatal("a workload disappeared")
	}
	if len(seen) < 2 {
		t.Fatal("seeds did not change workload order")
	}
	for name, count := range runs {
		if count != 20 {
			t.Fatalf("workload %s invoked %d times", name, count)
		}
	}
	if original[0].Label != "cold" || reversed[0].Label != "corpus" {
		t.Fatal("ordering mutated caller storage")
	}
}

func fmtNames(cases []Case) string {
	var result string
	for _, c := range cases {
		result += c.Label + ","
	}
	return result
}

func TestOrderRejectsAmbiguousOrMissingWorkloads(t *testing.T) {
	run := func(*testing.B) {}
	for _, cases := range [][]Case{nil, {{Label: "", Run: run}}, {{Label: "same", Run: run}, {Label: "same", Run: run}}, {{Label: "missing"}}, {{Label: "space name", Run: run}}, {{Label: "nested/name", Run: run}}} {
		if _, err := order(cases, 1); err == nil {
			t.Fatalf("accepted invalid cases: %+v", cases)
		}
	}
}

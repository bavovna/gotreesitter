package parsercorephase0

import "testing"

func TestNegativeLexProbeMemoDomain(t *testing.T) {
	var m NegativeLexProbeMemo
	if _, _, ok := m.Lookup(0, 0); ok {
		t.Fatal("zero value is not a result")
	}
	for _, state := range []StateID{0, 1, 7, 8, 65535, 65536, 65537, 0xffffffff} {
		m.Record(state, 123, 456, 789)
		span, produced, ok := m.Lookup(state, 123)
		if !ok || span != 456 || produced != 789 {
			t.Fatal(state, span, produced, ok)
		}
		if _, _, ok := m.Lookup(state, 124); ok {
			t.Fatal("wrong start matched")
		}
		if _, _, ok := m.Lookup(state^65536, 123); ok {
			t.Fatal("upper state bits aliased", state)
		}
		other := state ^ 8
		if _, _, ok := m.Lookup(other, 123); ok {
			t.Fatal("slot collision matched")
		}
		m.Record(other, 123, 1, 2)
		if _, _, ok := m.Lookup(state, 123); ok {
			t.Fatal("replaced slot matched")
		}
		m.Clear()
		if _, _, ok := m.Lookup(other, 123); ok {
			t.Fatal("cleared entry matched")
		}
	}
}
func TestCaptureLexProbeReadSpanExactAndPanic(t *testing.T) {
	span := uint32(400)
	value, observed := CaptureLexProbeReadSpan(&span, func() int {
		if span != 0 {
			t.Fatal("prior dependency leaked")
		}
		span = 37
		return 9
	})
	if value != 9 || observed != 37 || span != 400 {
		t.Fatal(value, observed, span)
	}
	func() {
		defer func() {
			if recover() != "probe" {
				t.Fatal("panic lost")
			}
		}()
		CaptureLexProbeReadSpan(&span, func() int { span = 500; panic("probe") })
	}()
	if span != 500 {
		t.Fatal("panic lost dependency", span)
	}
}

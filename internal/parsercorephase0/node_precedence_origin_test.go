package parsercorephase0

import (
	"errors"
	"math"
	"testing"
)

func TestNodePrecedenceOriginSkipsNarrowPrefix(t *testing.T) {
	c := newTinyCoreWithLimits(t, Limits{MaxNodes: 20000})
	for i := 0; i < 10000; i++ {
		if _, err := c.appendNodeAtWithMaximum(nodeRecord{state: 1, pathCount: 1}, 0, int64(i%17)); err != nil {
			t.Fatal(err)
		}
	}
	before := c.FootprintBytes()
	first, err := c.appendNodeAtWithMaximum(nodeRecord{state: 2, pathCount: 1}, 0, math.MinInt64)
	if err != nil {
		t.Fatal(err)
	}
	second, err := c.appendNodeAtWithMaximum(nodeRecord{state: 3, pathCount: 1}, 0, math.MaxInt64)
	if err != nil {
		t.Fatal(err)
	}
	if c.nodePrecedenceWideBase != first || len(c.nodePrecedenceWide) != 2 {
		t.Fatalf("origin=%d first=%d len=%d", c.nodePrecedenceWideBase, first, len(c.nodePrecedenceWide))
	}
	if cap(c.nodePrecedenceWide) > cap(c.nodes)-int(first)+1 {
		t.Fatal("wide buffer reserves skipped prefix")
	}
	if got := storedNodeMaximumForTest(t, c, first); got != math.MinInt64 {
		t.Fatal(got)
	}
	if got := storedNodeMaximumForTest(t, c, second); got != math.MaxInt64 {
		t.Fatal(got)
	}
	if got := storedNodeMaximumForTest(t, c, 9999); got != int64(9998%17) {
		t.Fatal("narrow prefix changed", got)
	}
	if c.FootprintBytes() <= before {
		t.Fatal("wide backing not charged")
	}
	c.nodeLineages[0].precedenceInline = wideNodePrecedence
	if _, err := c.storedNodePrecedence(1); !errors.Is(err, errMissingWideNodePrecedence) {
		t.Fatal("pre-origin value resolved", err)
	}
}

func TestNodePrecedenceOriginFirstPublicationRollback(t *testing.T) {
	c := newTinyCoreWithLimits(t, Limits{})
	if _, err := c.Seed(1, 0); err != nil {
		t.Fatal(err)
	}
	abort := errors.New("abandon first wide value")
	var abandoned NodeID
	err := c.ApplySchedulerAtomic(func(SchedulerTransactionToken) error {
		var e error
		abandoned, e = c.appendNodeAtWithMaximum(nodeRecord{state: 2, pathCount: 1}, 0, math.MinInt64)
		if e != nil {
			return e
		}
		return abort
	})
	if !errors.Is(err, abort) || c.nodePrecedenceWideBase != 0 || len(c.nodePrecedenceWide) != 0 {
		t.Fatalf("rollback origin=%d len=%d err=%v", c.nodePrecedenceWideBase, len(c.nodePrecedenceWide), err)
	}
	replacement, err := c.appendNodeAtWithMaximum(nodeRecord{state: 3, pathCount: 1}, 0, math.MaxInt64)
	if err != nil {
		t.Fatal(err)
	}
	if replacement != abandoned || c.nodePrecedenceWideBase != replacement || storedNodeMaximumForTest(t, c, replacement) != math.MaxInt64 {
		t.Fatal("reused ID retained old origin/value")
	}
	if err := c.Reset(); err != nil {
		t.Fatal(err)
	}
	if c.nodePrecedenceWideBase != 0 || len(c.nodePrecedenceWide) != 0 {
		t.Fatal("reset retained origin")
	}
	if _, err := c.Seed(1, 0); err != nil {
		t.Fatal(err)
	}
	first, err := c.appendNodeAtWithMaximum(nodeRecord{state: 4, pathCount: 1}, 0, math.MinInt64)
	if err != nil {
		t.Fatal(err)
	}
	if first != replacement || storedNodeMaximumForTest(t, c, first) != math.MinInt64 {
		t.Fatal("reset reused stale value")
	}
	if err := c.ResetReleasingRetention(); err != nil {
		t.Fatal(err)
	}
	if c.nodePrecedenceWideBase != 0 || c.nodePrecedenceWide != nil {
		t.Fatal("release retained origin/backing")
	}
}

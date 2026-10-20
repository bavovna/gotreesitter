package parsercorephase0

import (
	"errors"
	"math"
	"strings"
	"testing"
	"unsafe"
)

func storedNodeMaximumForTest(t *testing.T, c *Core, id NodeID) int64 {
	t.Helper()
	got, err := c.nodePrecedenceMaximum(id)
	if err != nil {
		t.Fatal(err)
	}
	return got.value
}

func TestNodePrecedenceFullWidthAndInlineBoundaries(t *testing.T) {
	if size := unsafe.Sizeof(nodeRecord{}); size != 16 {
		t.Fatalf("node size=%d, want 16", size)
	}
	for _, score := range []int64{0, -32767, 32767, -32768, 32768, math.MinInt64, math.MaxInt64} {
		core := newTinyCoreWithLimits(t, Limits{})
		seed, err := core.Seed(1, 0)
		if err != nil {
			t.Fatal(err)
		}
		payload := appendShallowPayload(t, core, shallowPayloadSpec{symbol: 20, startByte: 0, endByte: 1, childSymbols: []Symbol{30}})
		child, err := core.appendAdjacencyNode(2, 1, []linkRecord{{prev: seed.Node, payload: payload, scoreDelta: score}})
		if err != nil {
			t.Fatalf("score=%d: %v", score, err)
		}
		if got := storedNodeMaximumForTest(t, core, child); got != score {
			t.Fatalf("stored=%d want=%d", got, score)
		}
		wide := score < -32767 || score > 32767
		if (len(core.nodePrecedenceWide) != 0) != wide {
			t.Fatalf("score=%d wide storage length=%d", score, len(core.nodePrecedenceWide))
		}
		if cap(core.nodePrecedenceWide) > core.nodes.Capacity() {
			t.Fatal("wide capacity exceeds node capacity")
		}
		if score == math.MinInt64 || score == math.MaxInt64 {
			delta := int64(1)
			if score < 0 {
				delta = -1
			}
			if _, err := core.linkPrecedenceMaximum(linkRecord{prev: child, payload: payload, scoreDelta: delta}); err == nil || !strings.Contains(err.Error(), "overflow") {
				t.Fatalf("full-width overflow not detected: score=%d err=%v", score, err)
			}
		}
	}
}

func TestNodePrecedenceRollbackResetAndReusedIDs(t *testing.T) {
	core := newTinyCoreWithLimits(t, Limits{})
	seed, err := core.Seed(1, 0)
	if err != nil {
		t.Fatal(err)
	}
	first, err := core.appendNodeAtWithMaximum(nodeInput{state: 2, pathCount: 1}, 0, math.MinInt64)
	if err != nil {
		t.Fatal(err)
	}
	oldLength := len(core.nodePrecedenceWide)
	aborted := errors.New("abort after wide precedence")
	var abandoned NodeID
	err = core.ApplySchedulerAtomic(func(SchedulerTransactionToken) error {
		var err error
		abandoned, err = core.appendNodeAtWithMaximum(nodeInput{state: 3, pathCount: 1}, 0, math.MaxInt64)
		if err != nil {
			return err
		}
		if got := storedNodeMaximumForTest(t, core, abandoned); got != math.MaxInt64 {
			t.Fatalf("wide=%d", got)
		}
		return aborted
	})
	if !errors.Is(err, aborted) || len(core.nodePrecedenceWide) != oldLength {
		t.Fatalf("rollback err=%v length=%d want=%d", err, len(core.nodePrecedenceWide), oldLength)
	}
	if got := storedNodeMaximumForTest(t, core, first); got != math.MinInt64 {
		t.Fatal("rollback changed historical maximum")
	}
	next, err := core.appendNodeAtWithMaximum(nodeInput{state: 3, pathCount: 1}, 0, -7)
	if err != nil {
		t.Fatal(err)
	}
	if next != abandoned || storedNodeMaximumForTest(t, core, next) != -7 {
		t.Fatal("reused NodeID inherited old wide value")
	}
	if err := core.Reset(); err != nil {
		t.Fatal(err)
	}
	if len(core.nodePrecedenceWide) != 0 {
		t.Fatal("reset retained logical wide entries")
	}
	replacement, err := core.Seed(1, 0)
	if err != nil {
		t.Fatal(err)
	}
	if replacement.Node != seed.Node || storedNodeMaximumForTest(t, core, replacement.Node) != 0 {
		t.Fatal("reset revived a wide value")
	}
	if err := core.ResetReleasingRetention(); err != nil {
		t.Fatal(err)
	}
	if core.nodePrecedenceWide != nil {
		t.Fatal("decline cleanup retained wide allocation")
	}
}

func TestNodePrecedenceWideStorageFootprintAndMissingValue(t *testing.T) {
	c := &Core{nodePrecedenceWide: make([]int64, 1, 19)}
	if c.StorageBytes() != 8 || c.FootprintBytes() != 19*8 {
		t.Fatalf("wide accounting live=%d retained=%d", c.StorageBytes(), c.FootprintBytes())
	}
	core := newTinyCoreWithLimits(t, Limits{})
	seed, err := core.Seed(1, 0)
	if err != nil {
		t.Fatal(err)
	}
	core.nodeLineages[seed.Node-1].precedenceInline = wideNodePrecedence
	if _, err := core.nodePrecedenceMaximum(seed.Node); !errors.Is(err, errMissingWideNodePrecedence) {
		t.Fatalf("missing wide storage err=%v", err)
	}
}

func TestNodePrecedencePreservesLineageUpdatesAndRollback(t *testing.T) {
	for _, score := range []int64{-555, math.MaxInt64} {
		core := newTinyCoreWithLimits(t, Limits{})
		if _, err := core.Seed(1, 0); err != nil {
			t.Fatal(err)
		}
		id, err := core.appendNodeAtWithMaximum(nodeInput{state: 2, pathCount: 1}, 0, score)
		if err != nil {
			t.Fatal(err)
		}
		first := nodeLineageRecord{set: NewAlternativeSetMember(1, 0), lineage: 3, rank: CleanPathRankSelected}
		if err := core.publishNodeLineage(id, first); err != nil {
			t.Fatal(err)
		}
		before := core.nodeLineages[id-1]
		aborted := errors.New("rollback lineage metadata")
		err = core.ApplyAtomic(func() error {
			if err := core.recordHeadOwner(Head{Node: id}, 77); err != nil {
				return err
			}
			set := NewAlternativeSetMember(2, 0)
			for i := uint16(1); i < 40; i++ {
				core.alternativeSetInsert(&set, packAlternativeSetMember(2, i))
			}
			if err := core.recordNodeLineageSet(Head{Node: id}, set, true); err != nil {
				return err
			}
			if got := storedNodeMaximumForTest(t, core, id); got != score {
				t.Fatalf("metadata changed precedence %d to %d", score, got)
			}
			return aborted
		})
		if !errors.Is(err, aborted) || core.nodeLineages[id-1] != before {
			t.Fatalf("lineage rollback err=%v", err)
		}
		view, err := core.lineageView(id)
		if err != nil {
			t.Fatal(err)
		}
		if err := core.publishNodeLineage(id, view.record()); err != nil {
			t.Fatal(err)
		}
		if got := storedNodeMaximumForTest(t, core, id); got != score {
			t.Fatalf("publication changed precedence %d to %d", score, got)
		}
	}
}

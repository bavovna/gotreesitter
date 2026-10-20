package parsercorephase0

import (
	"errors"
	"math"
	"sort"
	"testing"
	"unsafe"
)

// Existing corruption probes continue to alter the same logical path count.
func setNodePathCountForTest(c *Core, id NodeID, value uint64) {
	if id == 0 || uint64(id) > uint64(len(c.nodes)) {
		panic("invalid test node")
	}
	for len(c.nodeLineages) < len(c.nodes) {
		c.nodeLineages = append(c.nodeLineages, nodeLineageHot{})
	}
	for i, r := range c.nodePathCountsWide {
		if r.node == id {
			copy(c.nodePathCountsWide[i:], c.nodePathCountsWide[i+1:])
			c.nodePathCountsWide = c.nodePathCountsWide[:len(c.nodePathCountsWide)-1]
			break
		}
	}
	flags := c.appendNodePathCount(id, value)
	sort.Slice(c.nodePathCountsWide, func(i, j int) bool { return c.nodePathCountsWide[i].node < c.nodePathCountsWide[j].node })
	c.nodeLineages[id-1].flags = c.nodeLineages[id-1].flags&^nodePathCountMask | flags
}
func TestNodePathCountFullWidthAndMetadataPublication(t *testing.T) {
	c := newTinyCoreWithLimits(t, Limits{})
	if unsafe.Sizeof(nodeRecord{}) != 16 || unsafe.Sizeof(nodeLineageHot{}) != 16 {
		t.Fatal("hot layout grew")
	}
	values := []uint64{0, 1, 2, 61, 62, 63, 1 << 32, math.MaxUint64 - 1, math.MaxUint64}
	for _, value := range values {
		id, err := c.appendNodeAtWithMaximum(nodeInput{state: 1, pathCount: value}, 0, 0)
		if err != nil {
			t.Fatal(err)
		}
		if err := c.publishNodeLineage(id, nodeLineageRecord{owner: 99, converged: true, blended: true, rank: CleanPathRankSelected}); err != nil {
			t.Fatal(err)
		}
		got, err := c.HeadExactPathCount(Head{Node: id})
		if err != nil || got != value {
			t.Fatalf("count=%d want=%d err=%v", got, value, err)
		}
	}
	if len(c.nodePathCountsWide) != 4 {
		t.Fatalf("unexpected wide entries %d", len(c.nodePathCountsWide))
	}
}
func TestNodePathCountRollbackResetAndReusedID(t *testing.T) {
	c := newTinyCoreWithLimits(t, Limits{})
	first, err := c.appendNodeAtWithMaximum(nodeInput{state: 1, pathCount: math.MaxUint64 - 1}, 0, 0)
	if err != nil {
		t.Fatal(err)
	}
	sentinel := errors.New("rollback")
	var abandoned NodeID
	err = c.ApplyAtomic(func() error {
		var appendErr error
		abandoned, appendErr = c.appendNodeAtWithMaximum(nodeInput{state: 1, pathCount: 1 << 40}, 0, 0)
		if appendErr != nil {
			return appendErr
		}
		return sentinel
	})
	if !errors.Is(err, sentinel) {
		t.Fatal(err)
	}
	if len(c.nodePathCountsWide) != 1 {
		t.Fatal("rollback retained abandoned metadata")
	}
	reused, err := c.appendNodeAtWithMaximum(nodeInput{state: 1, pathCount: 2}, 0, 0)
	if err != nil || reused != abandoned {
		t.Fatal(reused, abandoned, err)
	}
	if got, err := c.HeadExactPathCount(Head{Node: reused}); err != nil || got != 2 {
		t.Fatal(got, err)
	}
	if got, err := c.HeadExactPathCount(Head{Node: first}); err != nil || got != math.MaxUint64-1 {
		t.Fatal(got, err)
	}
	if err := c.Reset(); err != nil {
		t.Fatal(err)
	}
	if len(c.nodePathCountsWide) != 0 {
		t.Fatal("reset kept logical wide metadata")
	}
}

func TestNodePathCountGeneratedFullWidthRoundTrip(t *testing.T) {
	c := newTinyCoreWithLimits(t, Limits{MaxNodes: 4096})
	value := uint64(0x6a09e667f3bcc909)
	for i := 0; i < 2048; i++ {
		value ^= value << 13
		value ^= value >> 7
		value ^= value << 17
		id, err := c.appendNodeAtWithMaximum(nodeInput{state: 1, pathCount: value}, 0, 0)
		if err != nil {
			t.Fatal(err)
		}
		got, err := c.HeadExactPathCount(Head{Node: id})
		if err != nil || got != value {
			t.Fatalf("count truncated at %d: %d/%d %v", i, got, value, err)
		}
	}
}

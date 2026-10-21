package parsercorephase0

import (
	"math/rand"
	"testing"
)

func TestNodeRecordBlocksGrowthChargesTablesAndPreservesCompleteBlocks(t *testing.T) {
	for _, count := range []int{0, 1, 96, nodeRecordBlockSize - 1, nodeRecordBlockSize, nodeRecordBlockSize + 1, 2 * nodeRecordBlockSize, 2*nodeRecordBlockSize + 37} {
		var s nodeRecordBlocks
		planned := s.GrowthFootprintBytes(count)
		s.Grow(count)
		if s.Len() != 0 || s.Capacity() != count || s.FootprintBytes() != planned {
			t.Fatalf("count=%d length=%d capacity=%d footprint=%d planned=%d", count, s.Len(), s.Capacity(), s.FootprintBytes(), planned)
		}
		for s.Len() < count {
			index := s.Len()
			if _, ok := s.Append(nodeRecord{byteOffset: uint32(index)}, uint32(count)); !ok {
				t.Fatal("reserved append")
			}
		}
		if s.FootprintBytes() != planned {
			t.Fatal("reserved append allocated uncharged capacity")
		}
	}
	var s nodeRecordBlocks
	s.Grow(2 * nodeRecordBlockSize)
	for s.Len() < 2*nodeRecordBlockSize {
		if _, ok := s.Append(nodeRecord{byteOffset: uint32(s.Len())}, 4*nodeRecordBlockSize); !ok {
			t.Fatal("append")
		}
	}
	first, second := s.At(1), s.At(nodeRecordBlockSize+1)
	before, planned := s.FootprintBytes(), s.GrowthFootprintBytes(3*nodeRecordBlockSize+123)
	s.Grow(3*nodeRecordBlockSize + 123)
	if s.At(1) != first || s.At(nodeRecordBlockSize+1) != second {
		t.Fatal("growth copied a complete block")
	}
	if s.FootprintBytes()-before > planned {
		t.Fatal("growth exceeded its plan")
	}
}

func TestNodeRecordBlocksReserveCeilingIncludesMetadata(t *testing.T) {
	rng := rand.New(rand.NewSource(45201))
	for i := 0; i < 1000; i++ {
		nodes := 1 + rng.Intn(1<<20)
		links := nodes
		subtrees, children := rng.Intn(1<<20), rng.Intn(1<<20)
		ceiling := uint64(1 + rng.Intn(24<<20))
		n, l, s, c := boundedRecordReserveCounts(nodes, links, subtrees, children, ceiling)
		if n != l || n > nodes || l > links || s > subtrees || c > children {
			t.Fatal("reserve changed shape or exceeded record limits")
		}
		if got := reserveTotalBytes(n, l, s, c); got > ceiling {
			t.Fatalf("metadata escaped reserve ceiling: %d > %d", got, ceiling)
		}
	}
}

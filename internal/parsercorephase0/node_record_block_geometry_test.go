package parsercorephase0

import (
	"testing"
	"unsafe"
)

func TestNodeRecordBlocksCachedGeometryFollowsEveryMutation(t *testing.T) {
	check := func(label string, s *nodeRecordBlocks) {
		t.Helper()
		slots := cap(s.first)
		bytes := uint64(slots)*uint64(unsafe.Sizeof(nodeRecord{})) + uint64(cap(s.blocks))*uint64(unsafe.Sizeof(nodeRecordBlock{})) + uint64(cap(s.spare))*uint64(unsafe.Sizeof([]nodeRecord{}))
		for _, block := range s.blocks {
			slots += cap(block.records)
			bytes += uint64(cap(block.records)) * uint64(unsafe.Sizeof(nodeRecord{}))
		}
		for _, records := range s.spare {
			bytes += uint64(cap(records)) * uint64(unsafe.Sizeof(nodeRecord{}))
		}
		if s.Capacity() != slots || s.FootprintBytes() != bytes {
			t.Fatalf("%s: cached slots/bytes=%d/%d actual=%d/%d", label, s.Capacity(), s.FootprintBytes(), slots, bytes)
		}
	}
	var s nodeRecordBlocks
	check("zero", &s)
	s.Grow(nodeRecordBlockSize + 17)
	check("reserve partial tail", &s)
	for s.Len() < 3*nodeRecordBlockSize+1 {
		if _, ok := s.Append(nodeRecord{}, 5*nodeRecordBlockSize); !ok {
			t.Fatal("append")
		}
		if s.Len()%257 == 0 {
			check("append and tail growth", &s)
		}
	}
	check("complete append", &s)
	if !s.RetireBlock(0) {
		t.Fatal("retire")
	}
	check("retire into pool", &s)
	clone := s.CloneActive()
	check("clone holes", &clone)
	if !s.Truncate(2*nodeRecordBlockSize + 1) {
		t.Fatal("truncate")
	}
	check("truncate", &s)
	s.Reset()
	check("reset retired arena", &s)
	s.Grow(4*nodeRecordBlockSize + 33)
	check("reserve from pool", &s)
	for s.Len() < 4*nodeRecordBlockSize+33 {
		if _, ok := s.Append(nodeRecord{}, 5*nodeRecordBlockSize); !ok {
			t.Fatal("pool append")
		}
	}
	check("fill reused pool", &s)
	s.Reset()
	check("fast reset", &s)
	if _, ok := s.Append(nodeRecord{}, 5*nodeRecordBlockSize); !ok {
		t.Fatal("prefix reuse")
	}
	check("prefix reuse", &s)
}

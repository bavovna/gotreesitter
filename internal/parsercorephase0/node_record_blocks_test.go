package parsercorephase0

import (
	"math/rand"
	"testing"
	"unsafe"
)

func TestNodeRecordBlocksStableIDsAndRecycledStorage(t *testing.T) {
	s := nodeRecordBlocks{first: make([]nodeRecord, 0, 8)}
	// Pin a small first span to exercise block transitions without a large
	// contiguous prefix. A real caller must freeze that span before blocking.
	s.first = make([]nodeRecord, 8, nodeRecordBlockSize)
	s.length = 8
	s.refreshGeometry()
	limit := uint32(5 * nodeRecordBlockSize)
	for s.Len() < 3*nodeRecordBlockSize+1 {
		index := s.Len()
		id, ok := s.Append(nodeRecord{state: StateID(index + 1), byteOffset: uint32(index)}, limit)
		if !ok || int(id) != index+1 {
			t.Fatal("append did not preserve logical identity")
		}
	}
	oldID := nodeRecordBlockSize + 1
	oldAddress := s.At(oldID - 1)
	retained := s.At(2 * nodeRecordBlockSize)
	if !s.RetireBlock(0) || s.At(oldID-1) != nil {
		t.Fatal("retired ID remained readable")
	}
	if s.RetireBlock(2) || s.RetireBlock(0) {
		t.Fatal("retired append tail or twice")
	}
	// Finish the current tail, then allocate the next block from the spare.
	for s.Len() < 4*nodeRecordBlockSize+1 {
		index := s.Len()
		if _, ok := s.Append(nodeRecord{byteOffset: uint32(index)}, limit); !ok {
			t.Fatal("append failed")
		}
	}
	if s.At(4*nodeRecordBlockSize) != oldAddress {
		t.Fatal("did not recycle backing block")
	}
	if s.At(oldID-1) != nil || s.At(2*nodeRecordBlockSize) != retained {
		t.Fatal("recycling aliased stale or retained logical IDs")
	}
	if s.At(4*nodeRecordBlockSize).byteOffset != 4*nodeRecordBlockSize {
		t.Fatal("new logical ID did not contain its record")
	}
}

func TestNodeRecordBlocksBoundsLimitAndReset(t *testing.T) {
	var s nodeRecordBlocks
	if id, ok := s.Append(nodeRecord{}, 0); ok || id != 0 || s.Len() != 0 {
		t.Fatal("zero limit mutated arena")
	}
	for i := 0; i < 257; i++ {
		id, ok := s.Append(nodeRecord{byteOffset: uint32(i)}, 257)
		if !ok || id != NodeID(i+1) {
			t.Fatal("bounded append")
		}
	}
	before := s.FootprintBytes()
	if _, ok := s.Append(nodeRecord{}, 257); ok || s.FootprintBytes() != before {
		t.Fatal("limit allocated storage")
	}
	if s.At(-1) != nil || s.At(257) != nil {
		t.Fatal("invalid index readable")
	}
	s.Reset()
	if s.Len() != 0 || s.At(0) != nil {
		t.Fatal("reset retained logical records")
	}
	if id, ok := s.Append(nodeRecord{byteOffset: 99}, 257); !ok || id != 1 || s.At(0).byteOffset != 99 {
		t.Fatal("reset could not reuse storage")
	}
}

func TestNodeRecordBlocksRandomRecordsAndCompleteFootprint(t *testing.T) {
	var s nodeRecordBlocks
	rng := rand.New(rand.NewSource(45101))
	records := make([]nodeRecord, 2*nodeRecordBlockSize+37)
	for i := range records {
		records[i] = nodeRecord{state: StateID(rng.Uint32()), byteOffset: rng.Uint32(), firstLink: rng.Uint32(), linkCount: rng.Uint32()}
		if _, ok := s.Append(records[i], uint32(len(records))); !ok {
			t.Fatal("append")
		}
	}
	for i, want := range records {
		if got := s.At(i); got == nil || *got != want {
			t.Fatalf("record %d changed", i)
		}
	}
	bytes := uint64(cap(s.first))*uint64(unsafe.Sizeof(nodeRecord{})) + uint64(cap(s.blocks))*uint64(unsafe.Sizeof(nodeRecordBlock{})) + uint64(cap(s.spare))*uint64(unsafe.Sizeof([]nodeRecord{}))
	for _, b := range s.blocks {
		bytes += uint64(cap(b.records)) * uint64(unsafe.Sizeof(nodeRecord{}))
	}
	if bytes != s.FootprintBytes() {
		t.Fatal("unused slots or metadata escaped accounting")
	}
}

func TestNodeRecordBlocksMixedTailResetDoesNotAccumulateSpareBlocks(t *testing.T) {
	var s nodeRecordBlocks
	var warm uint64
	for cycle := 0; cycle < 12; cycle++ {
		for _, size := range []int{2*nodeRecordBlockSize + 37, 3*nodeRecordBlockSize + 123} {
			s.Reset()
			for s.Len() < size {
				if _, ok := s.Append(nodeRecord{}, uint32(size)); !ok {
					t.Fatal("append")
				}
			}
		}
		if cycle == 3 {
			warm = s.FootprintBytes()
		}
		if cycle > 3 && s.FootprintBytes() != warm {
			t.Fatalf("mixed tails grew retained storage: %d -> %d", warm, s.FootprintBytes())
		}
	}
}

func TestNodeRecordBlocksRollbackAndClonePreserveIdentity(t *testing.T) {
	var s nodeRecordBlocks
	limit := uint32(4 * nodeRecordBlockSize)
	for s.Len() < 3*nodeRecordBlockSize+37 {
		index := s.Len()
		if _, ok := s.Append(nodeRecord{byteOffset: uint32(index)}, limit); !ok {
			t.Fatal("append")
		}
	}
	mark := s.Len() - 17
	before := s.FootprintBytes()
	if !s.Truncate(mark) || s.At(mark) != nil || s.FootprintBytes() != before {
		t.Fatal("rollback lost retained buffers or exposed tail")
	}
	for s.Len() < mark+17 {
		index := s.Len()
		if _, ok := s.Append(nodeRecord{byteOffset: uint32(index)}, limit); !ok {
			t.Fatal("reappend")
		}
	}
	if s.FootprintBytes() != before {
		t.Fatal("rollback refill allocated new capacity")
	}
	clone := s.CloneActive()
	if clone.Len() != s.Len() || clone.FootprintBytes() != s.CloneActiveFootprintBytes() {
		t.Fatal("clone allocation plan mismatch")
	}
	for index := 0; index < s.Len(); index++ {
		a, b := s.At(index), clone.At(index)
		if a == b || a == nil || b == nil || *a != *b {
			t.Fatalf("clone identity or alias at %d", index)
		}
	}
	clone.At(0).byteOffset = 99
	if s.At(0).byteOffset != 0 {
		t.Fatal("clone mutated source")
	}
}

func TestNodeRecordBlocksRetirementRejectsOldCheckpointAndClonesHoles(t *testing.T) {
	s := nodeRecordBlocks{first: make([]nodeRecord, nodeRecordBlockSize), length: nodeRecordBlockSize}
	s.refreshGeometry()
	for s.Len() < 3*nodeRecordBlockSize+1 {
		index := s.Len()
		if _, ok := s.Append(nodeRecord{byteOffset: uint32(index)}, 4*nodeRecordBlockSize); !ok {
			t.Fatal("append")
		}
	}
	if !s.RetireBlock(0) {
		t.Fatal("retire")
	}
	before, length := s.FootprintBytes(), s.Len()
	if s.Truncate(nodeRecordBlockSize+3) || s.Len() != length || s.FootprintBytes() != before {
		t.Fatal("old checkpoint resurrected a retired ID or partially changed storage")
	}
	clone := s.CloneActive()
	if clone.At(nodeRecordBlockSize) != nil || clone.FootprintBytes() != s.CloneActiveFootprintBytes() {
		t.Fatal("clone lost retired hole or charged spare")
	}
	if clone.Truncate(nodeRecordBlockSize + 3) {
		t.Fatal("clone forgot retirement watermark")
	}
	if len(clone.spare) != 0 || cap(clone.spare) != 0 {
		t.Fatal("clone retained unused source blocks")
	}
	if clone.At(2*nodeRecordBlockSize) == s.At(2*nodeRecordBlockSize) {
		t.Fatal("clone borrowed active storage")
	}
	s.Reset()
	if _, ok := s.Append(nodeRecord{}, 1); !ok {
		t.Fatal("reset did not reset lifetime")
	}
}

func TestNodeRecordBlocksSmallCloneCostIsExact(t *testing.T) {
	for _, count := range []int{0, 1, 17, 257, 1023} {
		var s nodeRecordBlocks
		for s.Len() < count {
			if _, ok := s.Append(nodeRecord{}, uint32(count)); !ok {
				t.Fatal("append")
			}
		}
		clone := s.CloneActive()
		if clone.FootprintBytes() != s.CloneActiveFootprintBytes() {
			t.Fatalf("rounded clone capacity escaped plan at %d", count)
		}
	}
}

func TestNodeRecordBlocksMaximumLimitStartsSuffix(t *testing.T) {
	s := nodeBlocksFromSliceForTest(make([]nodeRecord, nodeRecordBlockSize))
	record := nodeRecord{byteOffset: 71, firstLink: 23}
	id, ok := s.Append(record, ^uint32(0))
	if !ok || id != nodeRecordBlockSize+1 || s.At(nodeRecordBlockSize) == nil || *s.At(nodeRecordBlockSize) != record {
		t.Fatal("maximum uint32 limit failed at the first blocked record")
	}
	if cap(s.blocks[0].records) != nodeRecordBlockSize {
		t.Fatal("maximum limit did not reserve one bounded suffix block")
	}
}

func TestNodeRecordBlocksRetirementRejectsMaximumInt32Tail(t *testing.T) {
	// Retired holes keep this boundary check small on both native and 386.
	const logicalLength = int(^uint32(0) >> 1)
	const last = (logicalLength - nodeRecordBlockSize) >> nodeRecordBlockShift
	s := nodeRecordBlocks{
		first:          make([]nodeRecord, nodeRecordBlockSize),
		blocks:         make([]nodeRecordBlock, last+1),
		length:         logicalLength,
		retiredThrough: nodeRecordBlockSize + last*nodeRecordBlockSize,
	}
	s.blocks[last].records = make([]nodeRecord, logicalLength-s.retiredThrough)
	s.refreshGeometry()
	before := s.FootprintBytes()
	if s.RetireBlock(last) || s.blocks[last].records == nil || len(s.spare) != 0 || s.FootprintBytes() != before {
		t.Fatal("retirement accepted the append tail at the int32 boundary")
	}
}

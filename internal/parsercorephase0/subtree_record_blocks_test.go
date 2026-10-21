package parsercorephase0

import (
	"math/rand"
	"testing"
	"unsafe"
)

func TestSubtreeRecordBlocksRecordsAcrossGrowthAndMaximumLimit(t *testing.T) {
	var s subtreeRecordBlocks
	rng := rand.New(rand.NewSource(46101))
	want := make([]subtreeRecord, 3*subtreeRecordBlockSize+311)
	for i := range want {
		want[i] = subtreeRecord{symbol: Symbol(rng.Uint32()), productionID: uint16(rng.Uint32()), dynamicPrecedence: int16(rng.Uint32()), externalProvenanceState: subtreeExternalProvenanceState(rng.Intn(4)), missing: rng.Intn(2) == 1, startByte: rng.Uint32(), endByte: rng.Uint32(), firstChild: rng.Uint32(), childCount: rng.Uint32(), firstField: rng.Uint32(), fieldCount: rng.Uint32(), firstAlias: rng.Uint32(), aliasCount: rng.Uint32(), extra: rng.Intn(2) == 1, external: rng.Intn(2) == 1, terminal: rng.Intn(2) == 1, fragile: rng.Intn(2) == 1}
		id, ok := s.Append(want[i], ^uint32(0))
		if !ok || int(id) != i+1 {
			t.Fatal("record identity changed")
		}
	}
	if len(s.blocks) < 2 {
		t.Fatal("did not exercise suffix transitions")
	}
	for i, record := range want {
		if got := s.At(i); got == nil || *got != record {
			t.Fatalf("record %d changed", i)
		}
	}
	if s.At(-1) != nil || s.At(s.Len()) != nil {
		t.Fatal("invalid identity became readable")
	}
	bounded := subtreeBlocksFromSliceForTest(make([]subtreeRecord, subtreeRecordBlockSize))
	if id, ok := bounded.Append(subtreeRecord{startByte: 71}, ^uint32(0)); !ok || id != subtreeRecordBlockSize+1 || cap(bounded.blocks[0].records) != subtreeRecordBlockSize {
		t.Fatal("maximum-width limit failed to start a bounded suffix")
	}
	before := s.FootprintBytes()
	if _, ok := s.Append(subtreeRecord{}, uint32(s.Len())); ok || s.FootprintBytes() != before {
		t.Fatal("limit mutated storage")
	}
}

func TestSubtreeRecordBlocksGeometryRollbackCloneAndReset(t *testing.T) {
	check := func(label string, s *subtreeRecordBlocks) {
		t.Helper()
		slots := cap(s.first)
		bytes := uint64(slots)*uint64(unsafe.Sizeof(subtreeRecord{})) + uint64(cap(s.blocks))*uint64(unsafe.Sizeof(subtreeRecordBlock{}))
		for _, b := range s.blocks {
			slots += cap(b.records)
			bytes += uint64(cap(b.records)) * uint64(unsafe.Sizeof(subtreeRecord{}))
		}
		if s.Capacity() != slots || s.FootprintBytes() != bytes {
			t.Fatalf("%s: cached geometry changed", label)
		}
	}
	var s subtreeRecordBlocks
	check("zero", &s)
	if id, ok := s.Append(subtreeRecord{}, 0); ok || id != 0 || s.FootprintBytes() != 0 {
		t.Fatal("zero limit allocated")
	}
	for _, want := range []int{1, 17, subtreeRecordBlockSize - 1, subtreeRecordBlockSize + 9, 3*subtreeRecordBlockSize + 13} {
		before := s.FootprintBytes()
		plan := s.GrowthFootprintBytes(want)
		s.Grow(want)
		check("grow", &s)
		if s.Capacity() < want || s.FootprintBytes()-before > plan {
			t.Fatal("reserve exceeded its charged growth plan")
		}
	}
	for i := 0; i < 3*subtreeRecordBlockSize+13; i++ {
		if _, ok := s.Append(subtreeRecord{startByte: uint32(i), childCount: uint32(i % 7)}, ^uint32(0)); !ok {
			t.Fatal("append")
		}
	}
	check("fill", &s)
	clone := s.CloneActive()
	check("clone", &clone)
	if clone.FootprintBytes() != s.CloneActiveFootprintBytes() || clone.Len() != s.Len() {
		t.Fatal("clone capacity plan changed")
	}
	for i := 0; i < s.Len(); i++ {
		if *s.At(i) != *clone.At(i) || s.At(i) == clone.At(i) {
			t.Fatal("clone records changed or alias")
		}
	}
	clone.At(subtreeRecordBlockSize + 1).startByte = 99
	if s.At(subtreeRecordBlockSize+1).startByte == 99 {
		t.Fatal("clone suffix aliases source")
	}
	before := s.FootprintBytes()
	if s.Truncate(-1) || s.Truncate(s.Len()+1) || !s.Truncate(subtreeRecordBlockSize+7) || s.At(s.Len()) != nil || s.FootprintBytes() != before {
		t.Fatal("rollback changed retained capacity or exposed records")
	}
	check("rollback", &s)
	for s.Len() < 3*subtreeRecordBlockSize+13 {
		if _, ok := s.Append(subtreeRecord{endByte: 89}, ^uint32(0)); !ok {
			t.Fatal("refill")
		}
	}
	s.Reset()
	check("reset", &s)
	if s.Len() != 0 || s.FootprintBytes() != before || s.At(0) != nil {
		t.Fatal("reset lost capacity or exposed records")
	}
	if n := testing.AllocsPerRun(10, func() {
		s.Reset()
		for i := 0; i < 257; i++ {
			s.Append(subtreeRecord{}, ^uint32(0))
		}
	}); n != 0 {
		t.Fatalf("warm reset/refill allocations=%v", n)
	}
}

func TestSubtreeRecordBlocksCloneAppendReserveChargesBoundaryMetadata(t *testing.T) {
	for _, length := range []int{0, 17, subtreeRecordBlockSize - 1, subtreeRecordBlockSize, subtreeRecordBlockSize + 1, 2 * subtreeRecordBlockSize} {
		var live subtreeRecordBlocks
		live.Grow(length)
		for i := 0; i < length; i++ {
			live.Append(subtreeRecord{startByte: uint32(i)}, ^uint32(0))
		}
		shadow := live.cloneActive(1)
		if shadow.Len() != length || shadow.Capacity() != length+1 || shadow.FootprintBytes() != live.cloneFootprintBytes(1) {
			t.Fatalf("length %d: clone reserve was not exact and fully charged", length)
		}
		before := shadow.FootprintBytes()
		if id, ok := shadow.Append(subtreeRecord{endByte: 99}, ^uint32(0)); !ok || int(id) != length+1 || shadow.FootprintBytes() != before {
			t.Fatalf("length %d: reserved append grew backing storage", length)
		}
		for i := 0; i < length; i++ {
			if *shadow.At(i) != *live.At(i) || shadow.At(i) == live.At(i) {
				t.Fatal("clone altered or borrowed a source record")
			}
		}
	}
}

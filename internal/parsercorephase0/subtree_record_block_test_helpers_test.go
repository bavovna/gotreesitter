package parsercorephase0

import "testing"

func subtreeBlocksFromSliceForTest(records []subtreeRecord) subtreeRecordBlocks {
	arena := subtreeRecordBlocks{first: records, length: len(records)}
	arena.refreshGeometry()
	return arena
}

func (s *subtreeRecordBlocks) snapshotForTest() []subtreeRecord {
	if s.Len() == 0 {
		if s.first == nil {
			return nil
		}
		return []subtreeRecord{}
	}
	records := make([]subtreeRecord, s.Len())
	for i := range records {
		p := s.At(i)
		if p == nil {
			panic("test snapshot encountered a unpublished subtree")
		}
		records[i] = *p
	}
	return records
}

func (s *subtreeRecordBlocks) appendSliceForTest(records []subtreeRecord) {
	for _, r := range records {
		if _, ok := s.Append(r, ^uint32(0)); !ok {
			panic("test node append failed")
		}
	}
}

func TestSubtreeRecordBlocksSnapshotPreservesNilness(t *testing.T) {
	var arena subtreeRecordBlocks
	if arena.snapshotForTest() != nil {
		t.Fatal("unallocated nil arena became non-nil")
	}
	arena.Grow(17)
	if snapshot := arena.snapshotForTest(); snapshot == nil || len(snapshot) != 0 {
		t.Fatal("empty allocated arena lost its nilness distinction")
	}
	if _, ok := arena.Append(subtreeRecord{}, 17); !ok {
		t.Fatal("append")
	}
	if !arena.Truncate(0) {
		t.Fatal("rollback")
	}
	if arena.snapshotForTest() == nil {
		t.Fatal("rollback hid retained empty storage")
	}
}

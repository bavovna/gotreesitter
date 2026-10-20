package parsercorephase0

import "testing"

func nodeBlocksFromSliceForTest(records []nodeRecord) nodeRecordBlocks {
	arena := nodeRecordBlocks{first: records, length: len(records)}
	arena.refreshGeometry()
	return arena
}

func (s *nodeRecordBlocks) snapshotForTest() []nodeRecord {
	if s.Len() == 0 {
		if s.first == nil {
			return nil
		}
		return []nodeRecord{}
	}
	records := make([]nodeRecord, s.Len())
	for i := range records {
		p := s.At(i)
		if p == nil {
			panic("test snapshot encountered a retired node")
		}
		records[i] = *p
	}
	return records
}

func (s *nodeRecordBlocks) appendSliceForTest(records []nodeRecord) {
	for _, r := range records {
		if _, ok := s.Append(r, ^uint32(0)); !ok {
			panic("test node append failed")
		}
	}
}

func TestNodeRecordBlocksSnapshotPreservesNilness(t *testing.T) {
	var arena nodeRecordBlocks
	if arena.snapshotForTest() != nil {
		t.Fatal("unallocated nil arena became non-nil")
	}
	arena.Grow(17)
	if snapshot := arena.snapshotForTest(); snapshot == nil || len(snapshot) != 0 {
		t.Fatal("empty allocated arena lost its nilness distinction")
	}
	if _, ok := arena.Append(nodeRecord{}, 17); !ok {
		t.Fatal("append")
	}
	if !arena.Truncate(0) {
		t.Fatal("rollback")
	}
	if arena.snapshotForTest() == nil {
		t.Fatal("rollback hid retained empty storage")
	}
}

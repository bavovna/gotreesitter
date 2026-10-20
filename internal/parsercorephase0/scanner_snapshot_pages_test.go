package parsercorephase0

import (
	"bytes"
	"testing"
)

func TestScannerSnapshotPagesPreservePublishedRecordsAfterRolloverAndReset(t *testing.T) {
	var pages ScannerSnapshotPages[scannerSnapshotTestRecord]
	payload, start, end, tried := []byte{1, 2}, []byte{3, 4}, []byte{5, 6}, make([]bool, 113)
	tried[17] = true
	first, a, b, c, d, owner := pages.New(payload, start, end, tried)
	first.Payload, first.Start, first.End, first.Tried = a, b, c, d
	if owner == nil || owner.FootprintBytes() == 0 {
		t.Fatal("page has no charged storage")
	}
	payload[0], start[0], end[0], tried[17] = 9, 9, 9, false
	for i := 0; i < 19; i++ {
		record, p, s, e, z, nextOwner := pages.New([]byte{byte(i + 20)}, start, end, tried)
		record.Payload, record.Start, record.End, record.Tried = p, s, e, z
		if record == first || (i < 1 && nextOwner != owner) {
			t.Fatal("record address reused or initial page split")
		}
	}
	pages.Reset()
	if small, wide := pages.CurrentStorage(); small != nil || wide != nil {
		t.Fatal("reset retained current pages")
	}
	for i := 0; i < 20; i++ {
		record, p, s, e, z, newOwner := pages.New(payload, start, end, tried)
		record.Payload, record.Start, record.End, record.Tried = p, s, e, z
		if record == first || newOwner == owner {
			t.Fatal("reset recycled published storage")
		}
	}
	if !bytes.Equal(first.Payload, []byte{1, 2}) || !bytes.Equal(first.Start, []byte{3, 4}) || !bytes.Equal(first.End, []byte{5, 6}) || !first.Tried[17] {
		t.Fatal("published scanner state changed")
	}
}

func TestScannerSnapshotPagesPreserveShapesAndDisjointCapacity(t *testing.T) {
	for _, size := range []int{1, 32, 33, 64, 65} {
		var pages ScannerSnapshotPages[scannerSnapshotTestRecord]
		input := bytes.Repeat([]byte{3}, size)
		record, p, s, e, z, owner := pages.New(input, nil, []byte{}, make([]bool, 113))
		record.Payload, record.Start, record.End, record.Tried = p, s, e, z
		if !bytes.Equal(p, input) || s != nil || e == nil || len(z) != 113 {
			t.Fatalf("shape changed at %d", size)
		}
		if (size <= 32) != (owner != nil) {
			t.Fatalf("coallocation contract changed at %d", size)
		}
		peer, q, _, _, _, _ := pages.New(input, nil, nil, make([]bool, 113))
		if peer == record {
			t.Fatal("record shared with peer")
		}
		p[0] = 7
		if q[0] != 3 {
			t.Fatal("peer aliases a mutable field")
		}
	}
}

func TestScannerSnapshotPagesAllocationBound(t *testing.T) {
	input, tried := []byte{1, 2, 3}, make([]bool, 113)
	var pages ScannerSnapshotPages[scannerSnapshotTestRecord]
	allocs := testing.AllocsPerRun(100, func() {
		pages.Reset()
		for i := 0; i < 64; i++ {
			record, p, s, e, z, owner := pages.New(input, nil, nil, tried)
			record.Payload, record.Start, record.End, record.Tried = p, s, e, z
			if owner == nil {
				panic("missing page")
			}
			scannerSnapshotRecordSink = record
		}
	})
	if allocs != 32 {
		t.Fatalf("64 immutable records allocated %g objects, want 32", allocs)
	}
}

package parsercorephase0

import (
	"bytes"
	"reflect"
	"runtime"
	"testing"
)

type scannerSnapshotTestRecord struct {
	Payload, Start, End []byte
	Tried               []bool
	Marker              *int
}

func TestScannerSnapshotRecordIsolation(t *testing.T) {
	for _, payloadLen := range []int{8, 40, 70} {
		for _, triedLen := range []int{3, 65, 113, 128, 129} {
			source := bytes.Repeat([]byte{7}, payloadLen+4)
			payload, start, end := source[:payloadLen], source[1:3], source[2:4]
			tried := make([]bool, triedLen)
			tried[0], tried[triedLen-1] = true, true
			r, p, s, e, z := NewScannerSnapshotRecord[scannerSnapshotTestRecord](payload, start, end, tried)
			if !bytes.Equal(payload, p) || !bytes.Equal(start, s) || !bytes.Equal(end, e) || !reflect.DeepEqual(tried, z) {
				t.Fatalf("state changed: bytes=%d mask=%d", payloadLen, triedLen)
			}
			r.Payload, r.Start, r.End, r.Tried = p, s, e, z
			marker := 9
			r.Marker = &marker
			source[0], source[1], tried[0] = 0, 1, false
			if p[0] != 7 || s[0] != 7 || !z[0] {
				t.Fatal("record aliases caller storage")
			}
			p[1] = 2
			if s[0] != 7 || e[0] != 7 {
				t.Fatal("byte fields overlap")
			}
			p = append(p, 3)
			s[0] = 4
			if p[len(p)-1] != 3 || e[0] != 7 || !z[0] {
				t.Fatal("append crossed a private field boundary")
			}
			other, op, os, oe, oz := NewScannerSnapshotRecord[scannerSnapshotTestRecord](r.Payload, r.Start, r.End, r.Tried)
			other.Payload, other.Start, other.End, other.Tried = op, os, oe, oz
			op[0], oz[0] = 5, false
			runtime.GC()
			if r.Payload[0] != 7 || !r.Tried[0] || *r.Marker != 9 || other.Payload[0] != 5 || other.Tried[0] {
				t.Fatal("separate freezes alias or lost their record storage")
			}
		}
	}
}

func TestScannerSnapshotRecordAbsentEmptyAndBudget(t *testing.T) {
	for mask := 0; mask < 8; mask++ {
		fields := [3][]byte{}
		for i := range fields {
			if mask&(1<<i) != 0 {
				fields[i] = []byte{}
			}
		}
		for _, tried := range [][]bool{nil, {}, make([]bool, 113)} {
			_, p, s, e, z := NewScannerSnapshotRecord[int](fields[0], fields[1], fields[2], tried)
			for i, f := range [3][]byte{p, s, e} {
				if (f == nil) != (fields[i] == nil) || len(f) != 0 {
					t.Fatalf("mask %d field %d changed absence", mask, i)
				}
			}
			if (z == nil) != (tried == nil) || !reflect.DeepEqual(z, tried) {
				t.Fatal("trial mask changed absence or contents")
			}
		}
	}
	for _, size := range []int{1, 32, 33, 64} {
		for last := 0; last < 3; last++ {
			fields := [3][]byte{bytes.Repeat([]byte{7}, size), nil, nil}
			for i := 1; i <= last; i++ {
				fields[i] = []byte{}
			}
			_, p, s, e, z := NewScannerSnapshotRecord[int](fields[0], fields[1], fields[2], make([]bool, 113))
			reserved := 32
			if size > 32 {
				reserved = 64
			}
			if cap(p)+cap(s)+cap(e) != reserved || cap(z) != 128 {
				t.Fatalf("reserved storage missing from budget: size=%d last=%d caps=%d/%d/%d/%d", size, last, cap(p), cap(s), cap(e), cap(z))
			}
		}
	}
}

var scannerSnapshotRecordSink *scannerSnapshotTestRecord

func TestScannerSnapshotRecordAllocationBound(t *testing.T) {
	payload, start, end, tried := []byte("payload"), []byte("start"), []byte("end"), make([]bool, 113)
	allocs := testing.AllocsPerRun(100, func() {
		r, p, s, e, z := NewScannerSnapshotRecord[scannerSnapshotTestRecord](payload, start, end, tried)
		r.Payload, r.Start, r.End, r.Tried = p, s, e, z
		scannerSnapshotRecordSink = r
	})
	if allocs != 1 {
		t.Fatalf("record and four fields allocate %.0f objects, want one", allocs)
	}
}

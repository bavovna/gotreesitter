package parsercorephase0

import (
	"errors"
	"math"
	"math/rand"
	"reflect"
	"testing"
)

func TestCompactLinkStorageExactWideValuesAndFlags(t *testing.T) {
	if packedLinkRecordBytes != 20 || wideLinkRecordBytes != 24 {
		t.Fatalf("storage geometry: packed=%d wide=%d", packedLinkRecordBytes, wideLinkRecordBytes)
	}
	records := []linkRecord{
		{prev: 1, payload: 2, next: 3},
		{prev: 4, payload: 5, scoreDelta: -32768, order: math.MaxUint32, flags: linkFlagHasOrder},
		{scoreDelta: 32767, order: 1, flags: linkFlagRecoveryDiscontinuity},
		{prev: 6, payload: 7, scoreDelta: math.MinInt64, order: math.MaxUint64, flags: linkFlagHasOrder},
		{prev: 8, payload: 9, scoreDelta: math.MaxInt64, order: math.MaxUint32 + 1},
		{prev: 10, payload: 11, flags: ^uint32(0)},
	}
	stored := linkStorageFromRecords(records)
	if got := stored.Values(); !reflect.DeepEqual(got, records) {
		t.Fatalf("logical round trip: got=%+v want=%+v", got, records)
	}
	for _, index := range []int{1, 3, 0, 5, 2, 4} {
		wide := linkRecord{prev: NodeID(index + 12), payload: SubtreeID(index + 20), scoreDelta: math.MinInt64 + int64(index), order: math.MaxUint64 - uint64(index), flags: uint32(1) << uint(index+2)}
		records[index] = wide
		stored.Set(index, wide)
		if !reflect.DeepEqual(stored.Values(), records) {
			t.Fatalf("wide insertion/update at %d", index)
		}
		narrow := linkRecord{prev: 1, payload: 2, scoreDelta: int64(index) - 3, order: uint64(index)}
		records[index] = narrow
		stored.Set(index, narrow)
		if !reflect.DeepEqual(stored.Values(), records) {
			t.Fatalf("wide removal at %d", index)
		}
	}
}

func TestCompactLinkStorageRollbackAndCloneIsolation(t *testing.T) {
	var stored linkRecordStorage
	var records []linkRecord
	for i := 0; i < 200; i++ {
		record := linkRecord{prev: NodeID(i), payload: SubtreeID(i + 1), order: uint64(i)}
		if i%7 == 0 {
			record.scoreDelta = math.MaxInt64 - int64(i)
			record.order = math.MaxUint64 - uint64(i)
		}
		stored.Append(record)
		records = append(records, record)
	}
	clone := stored.CloneActive()
	allocated := stored.FootprintBytes()
	stored.Truncate(73)
	if stored.FootprintBytes() != allocated {
		t.Fatal("rollback omitted retained allocation capacity")
	}
	for i := 73; i < 100; i++ {
		stored.Append(linkRecord{prev: 1, payload: 2, scoreDelta: math.MinInt64 + int64(i), order: math.MaxUint64})
	}
	if !reflect.DeepEqual(clone.Values(), records) {
		t.Fatal("rollback/reappend mutated snapshot")
	}
	if got := stored.Values()[:73]; !reflect.DeepEqual(got, records[:73]) {
		t.Fatal("rollback changed prefix")
	}
	if clone.FootprintBytes() != clone.CloneActiveFootprintBytes() {
		t.Fatal("snapshot capacity accounting")
	}
	stored.Truncate(0)
	if stored.Len() != 0 || len(stored.wide) != 0 || !reflect.DeepEqual(clone.Values(), records) {
		t.Fatal("reset retained live records or changed clone")
	}
}

func TestCompactLinkStorageDifferentialMutations(t *testing.T) {
	rng := rand.New(rand.NewSource(762901))
	var stored linkRecordStorage
	var records []linkRecord
	next := func() linkRecord {
		r := linkRecord{prev: NodeID(rng.Uint32()), payload: SubtreeID(rng.Uint32()), next: LinkID(rng.Uint32()), scoreDelta: int64(rng.Intn(65536)) - 32768, order: uint64(rng.Uint32()), flags: uint32(rng.Intn(4))}
		if rng.Intn(4) == 0 {
			r.scoreDelta = int64(rng.Uint64())
			r.order = rng.Uint64()
			r.flags = rng.Uint32()
		}
		return r
	}
	for step := 0; step < 4000; step++ {
		switch rng.Intn(5) {
		case 0:
			if len(records) > 0 {
				n := rng.Intn(len(records) + 1)
				records = records[:n]
				stored.Truncate(n)
			}
		case 1:
			if len(records) > 0 {
				i := rng.Intn(len(records))
				record := next()
				records[i] = record
				stored.Set(i, record)
			}
		case 2:
			clone := stored.CloneActive()
			if !reflect.DeepEqual(clone.Values(), records) && !(len(records) == 0 && clone.Len() == 0) {
				t.Fatalf("snapshot mismatch at %d", step)
			}
		default:
			record := next()
			records = append(records, record)
			stored.Append(record)
		}
		if stored.Len() != len(records) {
			t.Fatalf("length mismatch at %d", step)
		}
		for i, want := range records {
			if got := stored.At(i); got != want {
				t.Fatalf("step=%d index=%d got=%+v want=%+v", step, i, got, want)
			}
		}
	}
}

// Real core rollback must truncate the wide sidecar together with its owner
// links. Retained capacity remains chargeable until explicitly released.
func TestCompactLinkStorageCoreRollbackAndBudgetAccounting(t *testing.T) {
	c := reserveTestCore(t, reserveTestLimits())
	small := linkRecord{prev: 1, payload: 2, scoreDelta: -17, order: 23, flags: linkFlagHasOrder}
	large := linkRecord{prev: 3, payload: 4, scoreDelta: math.MaxInt64, order: math.MaxUint64, flags: linkFlagHasOrder}
	c.appendGraphLink(small)
	c.appendGraphLink(large)
	before := c.links.Values()
	oldWork := c.Work()
	sentinel := errors.New("rollback wide graph links")
	err := c.ApplyAtomic(func() error {
		for i := 0; i < 37; i++ {
			c.appendGraphLink(large)
		}
		return sentinel
	})
	if !errors.Is(err, sentinel) || !reflect.DeepEqual(c.links.Values(), before) || c.Work() != oldWork {
		t.Fatalf("core rollback changed links or work: err=%v", err)
	}
	if len(c.links.wide) != 1 {
		t.Fatalf("rollback retained %d live wide records", len(c.links.wide))
	}
	linkFootprint := func() uint64 {
		withoutLinks := *c
		withoutLinks.links = linkRecordStorage{}
		return c.FootprintBytes() - withoutLinks.FootprintBytes()
	}
	wantLive := uint64(2*20 + 24)
	wantRetained := uint64(cap(c.links.records))*20 + uint64(cap(c.links.wide))*24
	if c.StorageBytes() != wantLive || linkFootprint() != wantRetained {
		t.Fatalf("link accounting: live=%d/%d retained=%d/%d", c.StorageBytes(), wantLive, linkFootprint(), wantRetained)
	}
	if err := c.Reset(); err != nil {
		t.Fatal(err)
	}
	if c.StorageBytes() != 0 || linkFootprint() != wantRetained || len(c.links.wide) != 0 {
		t.Fatal("reset lost retained-capacity accounting or retained live records")
	}
	if err := c.ResetReleasingRetention(); err != nil {
		t.Fatal(err)
	}
	if linkFootprint() != 0 || c.links.records != nil || c.links.wide != nil {
		t.Fatal("decline retained link storage")
	}
}

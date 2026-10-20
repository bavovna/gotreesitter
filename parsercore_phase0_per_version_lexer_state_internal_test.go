//go:build gts_parsercorephase0

package gotreesitter

import (
	"reflect"
	"testing"
	"unsafe"

	core "github.com/odvcencio/gotreesitter/internal/parsercorephase0"
)

func TestDiagnosticParserCorePerVersionStateKeepsHeaderSize(t *testing.T) {
	want := uintptr(80)
	if unsafe.Sizeof(uintptr(0)) == 4 {
		want = 76
	}
	if got := unsafe.Sizeof(diagnosticParserCoreHeader{}); got != want {
		t.Fatalf("diagnostic parser core header is %d bytes, want %d", got, want)
	}
}

func TestDiagnosticParserCorePerVersionStatePublishesImmutableCopies(t *testing.T) {
	first := &diagnosticParserCoreS3Region{state: 7, startByte: 2, endByte: 4}
	second := &diagnosticParserCoreS3Region{state: 9, startByte: 4, endByte: 6}
	var header diagnosticParserCoreHeader
	header.openRecoveryRegion(first)
	copyOfHeader := header
	initialState := header.versionState

	header.setRecoveryRegion(second)

	if header.versionState == initialState {
		t.Fatal("setRecoveryRegion reused the previous immutable wrapper")
	}
	if got := header.recoveryRegion(); got == second || !reflect.DeepEqual(got, second) {
		t.Fatalf("updated region=%+v, want an independent copy of %+v", got, second)
	}
	if got := copyOfHeader.recoveryRegion(); got == first || !reflect.DeepEqual(got, first) {
		t.Fatalf("copied header region=%+v, want an independent copy of %+v", got, first)
	}
	if copyOfHeader.versionState != initialState {
		t.Fatal("updating the live header changed the copied header state")
	}
}

func TestDiagnosticParserCorePerVersionStateCloseDoesNotMutateSnapshot(t *testing.T) {
	region := &diagnosticParserCoreS3Region{state: 3, children: []core.SubtreeID{11}}
	var header diagnosticParserCoreHeader
	header.openRecoveryRegion(region)
	snapshot := header

	header.closeRecoveryRegion()

	if header.versionState != nil || header.recoveryRegion() != nil {
		t.Fatal("closeRecoveryRegion left recovery state live")
	}
	if snapshot.versionState == nil || snapshot.recoveryRegion() == region || !reflect.DeepEqual(snapshot.recoveryRegion(), region) {
		t.Fatal("closing the live header changed its copied recovery state")
	}
	if snapshot.versionState.recovery.Value().Region != snapshot.recoveryRegion() {
		t.Fatal("closing the live header mutated the immutable wrapper")
	}
}

func TestDiagnosticParserCorePerVersionStateRollbackRestoresCopy(t *testing.T) {
	first := &diagnosticParserCoreS3Region{state: 1, startByte: 5, endByte: 7}
	second := &diagnosticParserCoreS3Region{state: 2, startByte: 7, endByte: 9}
	headers := []diagnosticParserCoreHeader{{}}
	headers[0].openRecoveryRegion(first)
	originalState := headers[0].versionState
	var scratch diagnosticParserCoreHeaderRollbackScratch
	if err := scratch.begin(headers); err != nil {
		t.Fatalf("begin rollback snapshot: %v", err)
	}
	headers[0].setRecoveryRegion(second)
	scratch.finish(&headers, true)

	if got := headers[0].recoveryRegion(); got == first || !reflect.DeepEqual(got, first) {
		t.Fatalf("rolled-back region=%+v, want an independent copy of %+v", got, first)
	}
	if headers[0].versionState != originalState {
		t.Fatal("rollback did not restore the original immutable wrapper")
	}
	if scratch.busy || len(scratch.headers) != 0 {
		t.Fatal("rollback scratch remained active after finish")
	}
}

func TestDiagnosticParserCorePerVersionStateSetNilCloses(t *testing.T) {
	var header diagnosticParserCoreHeader
	header.openRecoveryRegion(&diagnosticParserCoreS3Region{state: 4})
	header.setRecoveryRegion(nil)
	if header.versionState != nil || header.recoveryRegion() != nil {
		t.Fatal("setRecoveryRegion(nil) did not close recovery state")
	}
}

func TestVersionStateStorageSplitsRareRecoveryMetadata(t *testing.T) {
	want := uintptr(32)
	if unsafe.Sizeof(uintptr(0)) == 4 {
		want = 20
	}
	if got := unsafe.Sizeof(diagnosticParserCoreVersionState{}); got != want {
		t.Fatalf("version state=%d bytes, want%d", got, want)
	}
	var header diagnosticParserCoreHeader
	header.publishVersionState(nil, nil, 0, 0, 0, ^uint32(0), true)
	baseline := header
	if header.versionState.recovery != nil {
		t.Fatal("ordinary node baseline allocated recovery metadata")
	}
	snapshot := &diagnosticParserCoreVersionLexerSnapshot{}
	header.publishVersionState(nil, snapshot, ^uint32(0), 0, 0, 7, true)
	if got, set := baseline.recoveryNodeBaseline(); !set || got != ^uint32(0) {
		t.Fatal("published baseline changed")
	}
	if header.versionLexerRequestReference() != ^uint32(0) || header.versionState.recovery != nil {
		t.Fatal("full-width request changed or allocated cold metadata")
	}
	region := &diagnosticParserCoreS3Region{}
	header.publishVersionState(region, snapshot, 1, ^uint64(0), ^uint64(0)-1, 9, true)
	old := header
	header.publishVersionState(region, snapshot, 2, ^uint64(0), ^uint64(0)-1, 11, true)
	if header.versionState == old.versionState || header.versionState.recovery != old.versionState.recovery {
		t.Fatal("lexer update did not share immutable recovery metadata")
	}
	if old.versionLexerRequestReference() != 1 || old.recoveryGroupIdentity() != ^uint64(0) || old.recoveryMissingGroupIdentity() != ^uint64(0)-1 {
		t.Fatal("published recovery identity changed")
	}
	header.publishVersionState(nil, snapshot, 3, 0, 0, 0, false)
	closed := header
	if got := recoveredRootGroupOf(closed); got != (recoveredRootGroup{recovery: ^uint64(0), missing: ^uint64(0) - 1}) {
		t.Fatal("closed acceptance identity changed")
	}
	header.clearAcceptanceGroup()
	if header.versionState == nil || header.versionState.recovery != nil || header.versionLexerSnapshot() != snapshot {
		t.Fatal("clearing closed group retained cold metadata or lost cursor")
	}
	if !recoveredRootGroupOf(closed).valid() {
		t.Fatal("clearing changed an immutable rollback copy")
	}
}

func TestVersionStateStorageCountsSharedRecoveryOnce(t *testing.T) {
	compact, head, _ := newDiagnosticParserCoreCanonicalTestCore(t)
	region := &diagnosticParserCoreS3Region{children: make([]core.SubtreeID, 1, 3)}
	first := diagnosticParserCoreHeader{head: head}
	first.publishVersionState(region, nil, 1, 17, 19, 3, true)
	second := first
	second.publishVersionState(region, nil, 2, 17, 19, 5, true)
	if first.versionState.recovery != second.versionState.recovery {
		t.Fatal("shared recovery precondition failed")
	}
	scheduler := &diagnosticParserCoreGenericScheduler{compact: compact, headers: []diagnosticParserCoreHeader{first, second}}
	base := diagnosticParserCoreSchedulerFootprintBytes(&diagnosticParserCoreGenericScheduler{compact: compact})
	got := diagnosticParserCoreSchedulerFootprintBytes(scheduler) - base
	want := uint64(2)*uint64(unsafe.Sizeof(diagnosticParserCoreHeader{})) + uint64(2)*uint64(unsafe.Sizeof(diagnosticParserCoreVersionState{})) + uint64(unsafe.Sizeof(core.FrozenValue[diagnosticParserCoreVersionRecoveryState]{})) + diagnosticParserCoreVersionS3RegionFootprintBytes(region) + uint64(cap(scheduler.footprintRefs))*uint64(unsafe.Sizeof(diagnosticParserCoreFootprintRef{}))
	if got != want {
		t.Fatalf("shared recovery footprint=%d want%d", got, want)
	}
	if allocs := testing.AllocsPerRun(100, func() { diagnosticParserCoreSchedulerFootprintBytes(scheduler) }); allocs != 0 {
		t.Fatalf("steady footprint allocated %v", allocs)
	}
}

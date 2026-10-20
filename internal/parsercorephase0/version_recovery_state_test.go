package parsercorephase0

import "testing"

func TestVersionRecoveryStatePreservesFullIdentity(t *testing.T) {
	type group struct{ recovery, missing uint64 }
	value := VersionRecoveryState[*int, group]{Region: new(int), RecoveryGroup: ^uint64(0), MissingGroup: ^uint64(0) - 1, AcceptanceGroup: group{^uint64(0) - 2, ^uint64(0) - 3}}
	original := ReuseVersionRecoveryState(nil, value)
	if original == nil || original.Value() != value {
		t.Fatal("full-width recovery identity changed")
	}
	if ReuseVersionRecoveryState(original, value) != original {
		t.Fatal("equal immutable state was not shared")
	}
	next := value
	next.AcceptanceGroup.missing--
	replacement := ReuseVersionRecoveryState(original, next)
	if replacement == original || replacement.Value() != next || original.Value() != value {
		t.Fatal("update changed an older recovery holder")
	}
	if ReuseVersionRecoveryState(original, VersionRecoveryState[*int, group]{}) != nil || original.Value() != value {
		t.Fatal("zero state retained storage or changed a published holder")
	}
}

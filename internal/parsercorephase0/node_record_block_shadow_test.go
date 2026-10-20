//go:build gts_eof_recovery_shadow

package parsercorephase0

import "testing"

func TestDiagnosticNodeBlocksRejectInteriorAndUnusedAliases(t *testing.T) {
	var live nodeRecordBlocks
	live.Grow(3 * nodeRecordBlockSize)
	for live.Len() < nodeRecordBlockSize+2 {
		if _, ok := live.Append(nodeRecord{}, 3*nodeRecordBlockSize); !ok {
			t.Fatal("append")
		}
	}
	clone := live.CloneActive()
	if !equalDiagnosticNodeBlocks(&live, &clone) || !disjointDiagnosticNodeBlocks(&live, &clone) {
		t.Fatal("independent clone failed")
	}
	clone.first = live.first[1:]
	if disjointDiagnosticNodeBlocks(&live, &clone) {
		t.Fatal("interior prefix alias accepted")
	}
	clone = live.CloneActive()
	clone.blocks[0].records = live.blocks[0].records[1:1]
	if disjointDiagnosticNodeBlocks(&live, &clone) {
		t.Fatal("zero-length retained tail alias accepted")
	}
	clone = live.CloneActive()
	clone.spare = [][]nodeRecord{live.first[:0]}
	if disjointDiagnosticNodeBlocks(&live, &clone) {
		t.Fatal("spare alias accepted")
	}
	clone = live.CloneActive()
	clone.blocks = live.blocks[1:1]
	if disjointDiagnosticNodeBlocks(&live, &clone) {
		t.Fatal("unused pointer-table alias accepted")
	}
}

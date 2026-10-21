//go:build gts_eof_recovery_shadow

package parsercorephase0

import "testing"

func TestDiagnosticSubtreeBlocksRejectInteriorAndUnusedAliases(t *testing.T) {
	var live subtreeRecordBlocks
	live.Grow(3*subtreeRecordBlockSize + 13)
	for i := 0; i < subtreeRecordBlockSize+7; i++ {
		live.Append(subtreeRecord{startByte: uint32(i)}, ^uint32(0))
	}
	clone := live.CloneActive()
	if !equalDiagnosticSubtreeBlocks(&live, &clone) || !disjointDiagnosticSubtreeBlocks(&live, &clone) {
		t.Fatal("detached clone changed records or borrowed backing storage")
	}
	alias := subtreeRecordBlocks{first: live.first[1:2], length: 1}
	if disjointDiagnosticSubtreeBlocks(&live, &alias) {
		t.Fatal("interior prefix alias escaped")
	}
	alias = subtreeRecordBlocks{first: live.blocks[2].records[:0]}
	if disjointDiagnosticSubtreeBlocks(&live, &alias) {
		t.Fatal("unused reserved block alias escaped")
	}
	alias = subtreeRecordBlocks{blocks: live.blocks[1:1]}
	if disjointDiagnosticSubtreeBlocks(&live, &alias) {
		t.Fatal("unused metadata-table alias escaped")
	}
}

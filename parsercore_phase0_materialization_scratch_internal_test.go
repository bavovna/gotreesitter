//go:build gts_parsercorephase0

package gotreesitter

import (
	"errors"
	"testing"

	core "github.com/odvcencio/gotreesitter/internal/parsercorephase0"
)

func TestDiagnosticParserCoreMaterializationComparisonMatchesIndependentTrial(t *testing.T) {
	prepared, err := parserCoreWarmPrepare()
	if err != nil {
		t.Fatal(err)
	}
	paths, err := prepared.acceptedCore.Derivations(prepared.acceptedHead)
	if err != nil || len(paths) != 1 {
		t.Fatalf("derivations=%d err=%v", len(paths), err)
	}
	var publishScratch parserCoreRunnerScratch
	comparisonScratch := parserCoreRunnerScratch{materializationPurpose: core.MaterializationForComparison}
	build := func(scratch *parserCoreRunnerScratch, source []byte) (*Tree, error) {
		return materializeDiagnosticParserCoreAcceptedSelection(prepared.acceptedCore, prepared.acceptedHead,
			paths[0].Payloads, prepared.parser, source, scratch, true, false)
	}
	published, err := build(&publishScratch, prepared.source)
	if err != nil {
		t.Fatal(err)
	}
	defer published.Release()
	// Before buffer reuse, acceptance trials passed nil scratch and walked
	// without replay. Preserve every node attribute of that reference path.
	independentTrial, err := build(nil, prepared.source)
	if err != nil {
		t.Fatal(err)
	}
	defer independentTrial.Release()
	if !compactAcceptanceDerivationTreesEqual(prepared.lang, published.root, independentTrial.root) {
		t.Fatal("states-free trial differs from published public syntax")
	}
	if err := compactEagerCompareTrees(prepared.lang, published, independentTrial); err == nil {
		t.Fatal("fixture did not distinguish published replay from a temporary trial")
	}
	for i := 0; i < 3; i++ {
		comparison, err := build(&comparisonScratch, prepared.source)
		if err != nil {
			t.Fatal(err)
		}
		if err := compactEagerCompareTrees(prepared.lang, independentTrial, comparison); err != nil {
			comparison.Release()
			t.Fatal(err)
		}
		if !comparison.incrementalReuseDisabled || comparison.ParseRuntime().CompactExternalScannerCheckpointTransferProven {
			comparison.Release()
			t.Fatal("temporary comparison tree advertises incremental provenance")
		}
		comparison.root.symbol++
		if published.root.symbol == comparison.root.symbol || published.arena == comparison.arena {
			comparison.Release()
			t.Fatal("comparison construction shared the published tree's storage")
		}
		comparison.Release()
	}
	if tree, err := build(&comparisonScratch, nil); err == nil || tree != nil {
		if tree != nil {
			tree.Release()
		}
		t.Fatal("comparison omitted source-coverage validation")
	}
	if tree, err := build(&comparisonScratch, prepared.source); err != nil {
		t.Fatal("failed comparison poisoned the scratch:", err)
	} else {
		tree.Release()
	}
}

func TestDiagnosticParserCoreMaterializationScratchReusesVaryingWidths(t *testing.T) {
	var scratch diagnosticParserCoreMaterializationScratch
	widths := []int{1, 12, 3, 31, 2, 31}
	var peakCapacity int
	for _, width := range widths {
		entries := scratch.entriesFor(width)
		if len(entries) != width || cap(entries) < width || cap(entries) < peakCapacity {
			t.Fatalf("entries width=%d len=%d cap=%d peak=%d", width, len(entries), cap(entries), peakCapacity)
		}
		peakCapacity = cap(entries)
		for index := range entries {
			entries[index] = newStackEntryNode(StateID(index+1), &Node{symbol: Symbol(index + 1)})
		}
	}
	scratch.reduce.nodes = append(scratch.reduce.nodes, &Node{})
	scratch.reset()
	if len(scratch.entries) != 0 || len(scratch.reduce.nodes) != 0 {
		t.Fatalf("reset retained logical entries=%d reduce_nodes=%d", len(scratch.entries), len(scratch.reduce.nodes))
	}
	for index, entry := range scratch.entries[:cap(scratch.entries)] {
		if entry.node != nil {
			t.Fatalf("reset retained entry pointer at capacity index %d", index)
		}
	}
}

func TestDiagnosticParserCoreMaterializationScratchRestoresParserAfterError(t *testing.T) {
	wantErr := errors.New("stop materialization")
	previous := &reduceBuildScratch{nodes: []*Node{{symbol: 7}}}
	parser := &Parser{reduceScratch: previous}
	var captured *diagnosticParserCoreMaterializationScratch
	err := withDiagnosticParserCoreMaterializationScratch(parser, func(scratch *diagnosticParserCoreMaterializationScratch) error {
		captured = scratch
		if parser.reduceScratch != &scratch.reduce {
			t.Fatal("parser did not install materialization-local reduce scratch")
		}
		entries := scratch.entriesFor(8)
		for index := range entries {
			entries[index] = newStackEntryNode(0, &Node{symbol: Symbol(index + 1)})
		}
		scratch.reduce.nodes = append(scratch.reduce.nodes, &Node{symbol: 9})
		return wantErr
	})
	if !errors.Is(err, wantErr) {
		t.Fatalf("materialization error=%v want=%v", err, wantErr)
	}
	if parser.reduceScratch != previous || captured == nil || len(captured.entries) != 0 || len(captured.reduce.nodes) != 0 {
		t.Fatalf("error cleanup parser_scratch=%p want=%p captured=%+v", parser.reduceScratch, previous, captured)
	}
	if err := withDiagnosticParserCoreMaterializationScratch(parser, func(scratch *diagnosticParserCoreMaterializationScratch) error {
		if len(scratch.entries) != 0 || len(scratch.reduce.nodes) != 0 {
			t.Fatalf("next materialization inherited scratch entries=%d reduce_nodes=%d", len(scratch.entries), len(scratch.reduce.nodes))
		}
		return nil
	}); err != nil {
		t.Fatal(err)
	}
	if parser.reduceScratch != previous {
		t.Fatal("successful reuse did not restore previous parser scratch")
	}
}

func TestDiagnosticParserCoreMaterializationScratchPreservesUnaryCollapse(t *testing.T) {
	prepared, err := parserCoreWarmPrepare()
	if err != nil {
		t.Fatal(err)
	}
	var symbol Symbol
	for candidate, meta := range prepared.lang.SymbolMetadata {
		if meta.Visible && meta.Named {
			symbol = Symbol(candidate)
			break
		}
	}
	if symbol == 0 {
		t.Fatal("authenticated Go grammar has no visible named symbol for unary collapse test")
	}
	arena := acquireNodeArena(arenaClassFull)
	defer arena.Release()
	child := newLeafNodeInArena(arena, symbol, true, 0, 1, Point{}, Point{Column: 1})
	var scratch diagnosticParserCoreMaterializationScratch
	wide := scratch.entriesFor(17)
	for index := range wide {
		wide[index] = newStackEntryNode(0, &Node{symbol: Symbol(index + 1)})
	}
	entries := scratch.entriesFor(1)
	entries[0] = newStackEntryNode(0, child)
	action := ParseAction{Type: ParseActionReduce, Symbol: symbol, ChildCount: 1}
	if collapsed := prepared.parser.collapsibleRawUnarySelfReduction(action, Token{}, arena, entries, 0, 1); collapsed != child {
		t.Fatalf("reused entry scratch changed raw unary collapse: got=%p want=%p", collapsed, child)
	}
}

func TestDiagnosticParserCoreMaterializationScratchPreservesCanonicalMetadataAndReuse(t *testing.T) {
	prepared, err := parserCoreWarmPrepare()
	if err != nil {
		t.Fatal(err)
	}
	previous := &reduceBuildScratch{}
	prepared.parser.reduceScratch = previous
	defer func() { prepared.parser.reduceScratch = nil }()

	materialized, err := prepared.materialize(prepared.acceptedCore, prepared.acceptedHead)
	if err != nil {
		t.Fatal(err)
	}
	defer func() {
		if materialized != nil {
			materialized.Release()
		}
	}()
	if prepared.parser.reduceScratch != previous {
		t.Fatal("accepted materialization did not restore the parser's previous reduce scratch")
	}
	production, err := prepared.parser.Parse(prepared.source)
	if err != nil {
		t.Fatal(err)
	}
	defer production.Release()
	parserCoreWarmRequireDeepEqual(t, materialized, production, prepared.lang)

	fields, aliases := 0, 0
	stack := []*Node{materialized.root}
	for len(stack) != 0 {
		parent := stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		fieldIDs := parent.fieldIDs()
		aliasSeq := prepared.parser.reduceAliasSequence(parent.productionID)
		structural := 0
		for index, child := range parent.children {
			if index < len(fieldIDs) && fieldIDs[index] != 0 {
				fields++
			}
			if !child.isExtra() {
				if structural < len(aliasSeq) && aliasSeq[structural] != 0 {
					aliases++
					if child.symbol != aliasSeq[structural] {
						t.Fatalf("aliased child symbol=%d want=%d production=%d structural=%d", child.symbol, aliasSeq[structural], parent.productionID, structural)
					}
				}
				structural++
			}
			stack = append(stack, child)
		}
	}
	if fields == 0 || aliases == 0 {
		t.Fatalf("canonical metadata coverage fields=%d aliases=%d", fields, aliases)
	}

	materialized.Release()
	materialized = nil
	materialized, err = prepared.materialize(prepared.acceptedCore, prepared.acceptedHead)
	if err != nil {
		t.Fatalf("repeated materialization after release: %v", err)
	}
	parserCoreWarmRequireExactTree(t, materialized, len(prepared.source))
	parserCoreWarmRequireParentLinks(t, materialized)
}

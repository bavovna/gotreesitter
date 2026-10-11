//go:build gts_parsercorephase0 && !gts_no_parsercorephase0

package gotreesitter

import (
	"testing"

	core "github.com/odvcencio/gotreesitter/internal/parsercorephase0"
)

type sharedRecoveryAliasTable struct{ genericConflictTable }

type tiedAcceptanceAliasTable struct {
	genericConflictTable
	divergent bool
}

func (t *tiedAcceptanceAliasTable) ProductionAliases(production uint16, count int) ([]core.Symbol, error) {
	if count == 1 && (production == 1 || production == 2 && !t.divergent) {
		return []core.Symbol{3}, nil
	}
	return nil, nil
}

func TestCompactAcceptanceRetainsEquivalentAliasesAndRejectsDifferentAliases(t *testing.T) {
	for _, divergent := range []bool{false, true} {
		table := &tiedAcceptanceAliasTable{divergent: divergent, genericConflictTable: genericConflictTable{
			cells: map[genericConflictCell][]core.Action{
				{state: 1, symbol: 1}: {{Type: core.ActionShift, State: 2}},
				{state: 2, symbol: 0}: {
					{Type: core.ActionReduce, Symbol: 2, ChildCount: 1, ProductionID: 1},
					{Type: core.ActionReduce, Symbol: 2, ChildCount: 1, ProductionID: 2},
				},
			},
			gotos: map[genericConflictCell]core.StateID{{state: 1, symbol: 2}: 3},
		}}
		compact, err := core.New(table, core.Limits{})
		if err != nil {
			t.Fatal(err)
		}
		t.Cleanup(func() { _ = compact.ResetReleasingRetention() })
		seed, err := compact.Seed(1, 0)
		if err != nil {
			t.Fatal(err)
		}
		shifted, err := compact.Shift(seed, 1, 0, core.Token{Symbol: 1, EndByte: 1}, core.ForkOrder{})
		if err != nil {
			t.Fatal(err)
		}
		var head core.Head
		for ordinal := 0; ordinal < 2; ordinal++ {
			heads, err := compact.Reduce(shifted, 0, ordinal, core.ForkOrder{})
			if err != nil || len(heads) != 1 {
				t.Fatalf("heads=%v err=%v", heads, err)
			}
			head = heads[0]
		}
		paths, err := compact.Derivations(head)
		if err != nil || len(paths) != 2 {
			t.Fatalf("paths=%v err=%v", paths, err)
		}
		lang := &Language{
			Name: "acceptance_alias_fixture", TokenCount: 2, SymbolCount: 4,
			SymbolNames:    []string{"end", "identifier", "root", "type_identifier"},
			SymbolMetadata: []SymbolMetadata{{}, {Visible: true, Named: true}, {Visible: true, Named: true}, {Visible: true, Named: true}},
		}
		parser := &Parser{language: lang, reduceAliasSeq: [][]Symbol{nil, {3}, {3}}}
		if divergent {
			parser.reduceAliasSeq[2] = nil
		}
		var scratch parserCoreRunnerScratch
		tree, proved := compactAcceptanceElectionMaterialize(compact, parser, []byte("x"),
			false, true, head, paths, paths[0], &scratch)
		if divergent {
			if proved || tree != nil {
				if tree != nil {
					tree.Release()
				}
				t.Fatal("distinct aliases were accepted as equivalent")
			}
			continue
		}
		if !proved || tree == nil {
			t.Fatal("equivalent aliases did not retain a publication")
		}
		if tree.root.Child(0).Symbol() != 3 {
			tree.Release()
			t.Fatal("retained tree lost its alias")
		}
		var independentScratch parserCoreRunnerScratch
		independent, err := materializeDiagnosticParserCoreAcceptedSelection(compact, head, paths[0].Payloads,
			parser, []byte("x"), &independentScratch, false, false)
		if err != nil {
			tree.Release()
			t.Fatal(err)
		}
		if err := compactEagerCompareTrees(lang, independent, tree); err != nil {
			independent.Release()
			tree.Release()
			t.Fatal(err)
		}
		independent.Release()
		tree.Release()

		// Exercise the scheduler-to-publication handoff, including the final
		// acceptance bookkeeping that follows the materiality gate.
		runner := parserCoreFreshFullRunner{parser: parser}
		defer runner.scratch.acceptanceMaterialization.Discard()
		scheduler := diagnosticParserCoreGenericScheduler{
			compact: compact,
			headers: []diagnosticParserCoreHeader{{head: head, accepted: true}},
			token:   Token{StartByte: 1, EndByte: 1},
			receipt: &DiagnosticParserCoreGenericScheduler{},
			options: DiagnosticParserCorePrefixOptions{
				materializationParser:            parser,
				materializationSource:            []byte("x"),
				materializationContextSet:        true,
				acceptanceMaterializationScratch: &runner.scratch,
			},
		}
		if err := scheduler.completeAcceptance(); err != nil {
			t.Fatal("tied scheduler acceptance:", err)
		}
		retained := runner.scratch.acceptanceMaterialization.Retained()
		if retained == nil {
			t.Fatal("tied acceptance did not retain its verified publication")
		}
		selected, err := runner.materializeSelection([]byte("x"), compact, &scheduler)
		if err != nil {
			t.Fatal("selected publication:", err)
		}
		if selected != retained || runner.scratch.acceptanceMaterialization.Retained() != nil {
			selected.Release()
			t.Fatal("publication rebuilt the verified selection or retained ownership")
		}
		selected.Release()
	}
}

func (*sharedRecoveryAliasTable) ProductionAliases(production uint16, count int) ([]core.Symbol, error) {
	if production == 1 && count == 1 {
		return []core.Symbol{3}, nil
	}
	return nil, nil
}

func TestCompactSharedRecoveryAuthenticatesDirectTerminalAlias(t *testing.T) {
	table := &sharedRecoveryAliasTable{genericConflictTable{
		cells: map[genericConflictCell][]core.Action{
			{state: 1, symbol: 1}: {{Type: core.ActionShift, State: 2}},
			{state: 2, symbol: 0}: {{Type: core.ActionReduce, Symbol: 2, ChildCount: 1, ProductionID: 1}},
		},
		gotos: map[genericConflictCell]core.StateID{{state: 1, symbol: 2}: 3},
	}}
	compact, err := core.New(table, core.Limits{})
	if err != nil {
		t.Fatal(err)
	}
	defer compact.ResetReleasingRetention()
	seed, err := compact.Seed(1, 0)
	if err != nil {
		t.Fatal(err)
	}
	shifted, err := compact.Shift(seed, 1, 0, core.Token{Symbol: 1, EndByte: 1}, core.ForkOrder{})
	if err != nil {
		t.Fatal(err)
	}
	heads, err := compact.Reduce(shifted, 0, 0, core.ForkOrder{})
	if err != nil || len(heads) != 1 {
		t.Fatalf("reduction heads=%v err=%v", heads, err)
	}
	paths, err := compact.Derivations(heads[0])
	if err != nil || len(paths) != 1 {
		t.Fatalf("derivations=%v err=%v", paths, err)
	}
	lang := &Language{
		Name: "shared_alias_fixture", TokenCount: 2, SymbolCount: 4,
		SymbolNames:    []string{"end", "identifier", "root", "type_identifier"},
		SymbolMetadata: []SymbolMetadata{{}, {Visible: true, Named: true}, {Visible: true, Named: true}, {Visible: true, Named: true}},
	}
	parser := &Parser{language: lang, reduceAliasSeq: [][]Symbol{nil, {3}}}
	var scratch parserCoreRunnerScratch
	tree, err := materializeDiagnosticParserCoreAcceptedSelection(compact, heads[0], paths[0].Payloads, parser, []byte("x"), &scratch, false, true)
	if err != nil || tree == nil {
		t.Fatalf("shared alias materialization: %v", err)
	}
	defer tree.Release()
	root := tree.RootNode()
	if root.ChildCount() != 1 || root.Child(0).Symbol() != 3 || root.Child(0).StartByte() != 0 || root.Child(0).EndByte() != 1 {
		t.Fatalf("shared alias projection=%s", root.SExpr(lang))
	}
	if lang.CompactOwnedEOFRecoveryCertified || len(lang.CompactRecoveryTerminalAliasRules) != 0 {
		t.Fatal("fixture unexpectedly supplied artifact alias authority")
	}
}

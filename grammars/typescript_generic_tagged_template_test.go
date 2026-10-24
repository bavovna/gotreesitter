package grammars

import (
	"reflect"
	"testing"

	gotreesitter "github.com/odvcencio/gotreesitter"
)

func TestTypeScriptGenericTaggedTemplates(t *testing.T) {
	cases := []struct {
		name     string
		source   string
		comments []string
	}{
		{name: "scalar", source: "const value = tag<string>`text`;"},
		{name: "array", source: "const value = tag<string[]>`text ${item}`;"},
		{name: "nested", source: "const value = tag<Array<string[]>>`text`;"},
		{name: "object property", source: "const value = { result: tag<string[]>`text` };"},
		{name: "template text", source: "const value = tag<string[]>`\n// template text\n/* template text */\n`;\n// actual comment", comments: []string{"// actual comment"}},
		{name: "nested template and regex", source: "const value = tag<string[]>`${flag ? `/*` : /{/.test(text)}`;\n// actual comment", comments: []string{"// actual comment"}},
		{name: "interpolation comment", source: "const value = tag<string[]>`${\n// interpolation comment\nitem\n}`;", comments: []string{"// interpolation comment"}},
	}
	for _, grammar := range []struct {
		name string
		load func() *gotreesitter.Language
	}{{"typescript", TypescriptLanguage}, {"tsx", TsxLanguage}} {
		t.Run(grammar.name, func(t *testing.T) {
			lang := grammar.load()
			for _, tc := range cases {
				t.Run(tc.name, func(t *testing.T) {
					parser := gotreesitter.NewParser(lang)
					tree, err := parser.ParseStrict([]byte(tc.source))
					if err != nil {
						t.Fatal(err)
					}
					if tree == nil {
						t.Fatal("missing parse tree")
					}
					defer tree.Release()
					root := tree.RootNode()
					if root == nil {
						t.Fatal("missing root node")
					}
					if root.HasErrorOrMissing() {
						t.Fatalf("invalid parse: %s", root.SExpr(lang))
					}
					if root.EndByte() != uint32(len(tc.source)) {
						t.Fatalf("end=%d want=%d", root.EndByte(), len(tc.source))
					}
					var comments []string
					genericCall := false
					var visit func(*gotreesitter.Node)
					visit = func(node *gotreesitter.Node) {
						if node.Type(lang) == "call_expression" && node.ChildByFieldName("type_arguments", lang) != nil {
							genericCall = true
						}
						if node.Type(lang) == "comment" {
							comments = append(comments, tc.source[node.StartByte():node.EndByte()])
						}
						for i := range node.ChildCount() {
							visit(node.Child(i))
						}
					}
					visit(root)
					if !genericCall {
						t.Fatalf("missing generic call: %s", root.SExpr(lang))
					}
					if !reflect.DeepEqual(comments, tc.comments) {
						t.Fatalf("comments=%q want=%q", comments, tc.comments)
					}
				})
			}
		})
	}
}

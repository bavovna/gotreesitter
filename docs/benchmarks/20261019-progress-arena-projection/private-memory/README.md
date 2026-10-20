# Private C-correct protocol memory screen

This is the first projection prototype, not the qualified production variant.
It uses two scheduler checks and a separate `projectAt` field. The independent
production variant uses one check, an internal budget helper, and a midpoint
rounded up for odd-length inputs. Timings are not transferred between them.

Apply `runtime.patch` after reconstructing the 15-file paged candidate from
`../../20261019-paged-dfa-origin-receipts`. Copy the unchanged baseline
`parsercore_phase0_arena_reserve.go` into that candidate runtime directory first;
it was not among the previous 15 overrides. The source reference pins all 18
resulting files. Use the previous frozen observer sources and remap overlay paths.

The scoped screen passes complete Core tests, 386 projection checks, Go's
72-step invariant session, 306 clean C cases and 144 C edit steps. Four canonical
trees and complete counter vectors equal the preceding private protocol. The
one-MiB Go complete work and arena volume also match. This retains the protocol's
65 canonical counter increases relative to production; no exception is approved.

The allocation probe drops 837,475,240 to 602,340,424 bytes (-28.08%). Core
capacity drops 156,322,036 to 138,411,556 bytes (-11.46%). All 42 Go RSS processes
pass: candidate maximum 334.046 B/source byte; matched median ratio 0.937044.
This is a narrow Go memory result. It does not supply full fleet or three-case
RSS qualification for this combined source, a timing claim, or graduation.

No private protocol code is promoted. Original flat and paged failures remain in
the preceding receipts, including the 404.158 B/source-byte paged failure.

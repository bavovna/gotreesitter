TEXT github.com/odvcencio/gotreesitter/internal/parsercorephase0.ScannerFingerprint(SB) /baseline/internal/parsercorephase0/scanner_fingerprint.go
  scanner_fingerprint.go:16	0x5f18e0		4989e4			MOVQ SP, R12											
  scanner_fingerprint.go:16	0x5f18e3		4981ec58100000		SUBQ $0x1058, R12										
  scanner_fingerprint.go:16	0x5f18ea		0f8276020000		JB 0x5f1b66											
  scanner_fingerprint.go:16	0x5f18f0		4d3b6610		CMPQ R12, 0x10(R14)										
  scanner_fingerprint.go:16	0x5f18f4		0f866c020000		JBE 0x5f1b66											
  scanner_fingerprint.go:16	0x5f18fa		55			PUSHQ BP											
  scanner_fingerprint.go:16	0x5f18fb		4889e5			MOVQ SP, BP											
  scanner_fingerprint.go:16	0x5f18fe		4881ecd0100000		SUBQ $0x10d0, SP										
  scanner_fingerprint.go:16	0x5f1905		4889842400110000	MOVQ AX, 0x1100(SP)										
  scanner_fingerprint.go:16	0x5f190d		48899c2408110000	MOVQ BX, 0x1108(SP)										
  scanner_fingerprint.go:16	0x5f1915		440f11bc24e0100000	MOVUPS X15, 0x10e0(SP)										
  scanner_fingerprint.go:16	0x5f191e		440f11bc24f0100000	MOVUPS X15, 0x10f0(SP)										
  scanner_fingerprint.go:17	0x5f1927		4885c0			TESTQ AX, AX											
  scanner_fingerprint.go:17	0x5f192a		0f842d020000		JE 0x5f1b5d											
  scanner_fingerprint.go:20	0x5f1930		90			NOPL												
  value.go:3054			0x5f1931		4889842498100000	MOVQ AX, 0x1098(SP)										
  value.go:3054			0x5f1939		48899c24a0100000	MOVQ BX, 0x10a0(SP)										
  value.go:157			0x5f1941		488b942498100000	MOVQ 0x1098(SP), DX										
  value.go:158			0x5f1949		4885d2			TESTQ DX, DX											
  value.go:158			0x5f194c		7423			JE 0x5f1971											
  type.go:193			0x5f194e		440fb64a17		MOVZX 0x17(DX), R9										
  value.go:161			0x5f1953		4589ca			MOVL R9, R10											
  value.go:161			0x5f1956		4183e11f		ANDL $0x1f, R9											
  value.go:163			0x5f195a		4d89cb			MOVQ R9, R11											
  value.go:163			0x5f195d		4981c980000000		ORQ $0x80, R9											
  type.go:204			0x5f1964		41f6c220		TESTL $0x20, R10										
  value.go:165			0x5f1968		4d0f44d9		CMOVE R9, R11											
  scanner_fingerprint.go:17	0x5f196c		4889d9			MOVQ BX, CX											
  value.go:162			0x5f196f		eb0a			JMP 0x5f197b											
  scanner_fingerprint.go:34	0x5f1971		4889d9			MOVQ BX, CX											
  scanner_fingerprint.go:34	0x5f1974		4531db			XORL R11, R11											
  scanner_fingerprint.go:34	0x5f1977		31d2			XORL DX, DX											
  scanner_fingerprint.go:34	0x5f1979		31db			XORL BX, BX											
  value.go:86			0x5f197b		4d89d8			MOVQ R11, R8											
  value.go:86			0x5f197e		4183e31f		ANDL $0x1f, R11											
  value.go:1818			0x5f1982		90			NOPL												
  scanner_fingerprint.go:21	0x5f1983		4983fb16		CMPQ R11, $0x16											
  scanner_fingerprint.go:21	0x5f1987		0f8472010000		JE 0x5f1aff											
  scanner_fingerprint.go:17	0x5f198d		48898c24a8100000	MOVQ CX, 0x10a8(SP)										
  scanner_fingerprint.go:17	0x5f1995		4889842400110000	MOVQ AX, 0x1100(SP)										
  scanner_fingerprint.go:29	0x5f199d		488d7c2458		LEAQ 0x58(SP), DI										
  scanner_fingerprint.go:29	0x5f19a2		b900020000		MOVL $0x200, CX											
  scanner_fingerprint.go:29	0x5f19a7		31c0			XORL AX, AX											
  scanner_fingerprint.go:29	0x5f19a9		f348ab			REP; STOSQ AX, ES:0(DI)										
  scanner_fingerprint.go:30	0x5f19ac		488d442458		LEAQ 0x58(SP), AX										
  scanner_fingerprint.go:30	0x5f19b1		b900100000		MOVL $0x1000, CX										
  scanner_fingerprint.go:30	0x5f19b6		4889d7			MOVQ DX, DI											
  scanner_fingerprint.go:30	0x5f19b9		4889de			MOVQ BX, SI											
  scanner_fingerprint.go:30	0x5f19bc		31db			XORL BX, BX											
  scanner_fingerprint.go:30	0x5f19be		6690			NOPW												
  scanner_fingerprint.go:30	0x5f19c0		e8db010000		CALL github.com/odvcencio/gotreesitter/internal/parsercorephase0.appendScannerIdentity(SB)	
  scanner_fingerprint.go:30	0x5f19c5		4084ff			TESTL DI, DI											
  scanner_fingerprint.go:31	0x5f19c8		7467			JE 0x5f1a31											
  scanner_fingerprint.go:36	0x5f19ca		e81116f4ff		CALL crypto/sha256.Sum256(SB)									
  scanner_fingerprint.go:36	0x5f19cf		0f100424		MOVUPS 0(SP), X0										
  scanner_fingerprint.go:36	0x5f19d3		0f11842478100000	MOVUPS X0, 0x1078(SP)										
  scanner_fingerprint.go:36	0x5f19db		0f10442410		MOVUPS 0x10(SP), X0										
  scanner_fingerprint.go:36	0x5f19e0		0f11842488100000	MOVUPS X0, 0x1088(SP)										
  scanner_fingerprint.go:36	0x5f19e8		0f10842478100000	MOVUPS 0x1078(SP), X0										
  scanner_fingerprint.go:36	0x5f19f0		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:36	0x5f19f8		0f10842488100000	MOVUPS 0x1088(SP), X0										
  scanner_fingerprint.go:36	0x5f1a00		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:36	0x5f1a08		0f10842478100000	MOVUPS 0x1078(SP), X0										
  scanner_fingerprint.go:36	0x5f1a10		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:36	0x5f1a18		0f10842488100000	MOVUPS 0x1088(SP), X0										
  scanner_fingerprint.go:36	0x5f1a20		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:36	0x5f1a28		4881c4d0100000		ADDQ $0x10d0, SP										
  scanner_fingerprint.go:36	0x5f1a2f		5d			POPQ BP												
  scanner_fingerprint.go:36	0x5f1a30		c3			RET												
  scanner_fingerprint.go:34	0x5f1a31		488b942400110000	MOVQ 0x1100(SP), DX										
  scanner_fingerprint.go:34	0x5f1a39		48899424b0100000	MOVQ DX, 0x10b0(SP)										
  scanner_fingerprint.go:34	0x5f1a41		4c8b8424a8100000	MOVQ 0x10a8(SP), R8										
  scanner_fingerprint.go:34	0x5f1a49		4c898424b8100000	MOVQ R8, 0x10b8(SP)										
  scanner_fingerprint.go:34	0x5f1a51		48899424c0100000	MOVQ DX, 0x10c0(SP)										
  scanner_fingerprint.go:34	0x5f1a59		4c898424c8100000	MOVQ R8, 0x10c8(SP)										
  scanner_fingerprint.go:34	0x5f1a61		488d0570cd2500		LEAQ 0x25cd70(IP), AX										
  scanner_fingerprint.go:34	0x5f1a68		bb06000000		MOVL $0x6, BX											
  scanner_fingerprint.go:34	0x5f1a6d		488d8c24b0100000	LEAQ 0x10b0(SP), CX										
  scanner_fingerprint.go:34	0x5f1a75		bf02000000		MOVL $0x2, DI											
  scanner_fingerprint.go:34	0x5f1a7a		4889fe			MOVQ DI, SI											
  scanner_fingerprint.go:34	0x5f1a7d		0f1f00			NOPL 0(AX)											
  scanner_fingerprint.go:34	0x5f1a80		e81ba2eeff		CALL fmt.Sprintf(SB)										
  scanner_fingerprint.go:34	0x5f1a85		4889d9			MOVQ BX, CX											
  scanner_fingerprint.go:34	0x5f1a88		4889c3			MOVQ AX, BX											
  scanner_fingerprint.go:34	0x5f1a8b		488d842458100000	LEAQ 0x1058(SP), AX										
  scanner_fingerprint.go:34	0x5f1a93		e808eee6ff		CALL runtime.stringtoslicebyte(SB)								
  scanner_fingerprint.go:34	0x5f1a98		e84315f4ff		CALL crypto/sha256.Sum256(SB)									
  scanner_fingerprint.go:34	0x5f1a9d		0f100424		MOVUPS 0(SP), X0										
  scanner_fingerprint.go:34	0x5f1aa1		0f11842478100000	MOVUPS X0, 0x1078(SP)										
  scanner_fingerprint.go:34	0x5f1aa9		0f10442410		MOVUPS 0x10(SP), X0										
  scanner_fingerprint.go:34	0x5f1aae		0f11842488100000	MOVUPS X0, 0x1088(SP)										
  scanner_fingerprint.go:34	0x5f1ab6		0f10842478100000	MOVUPS 0x1078(SP), X0										
  scanner_fingerprint.go:34	0x5f1abe		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:34	0x5f1ac6		0f10842488100000	MOVUPS 0x1088(SP), X0										
  scanner_fingerprint.go:34	0x5f1ace		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:34	0x5f1ad6		0f10842478100000	MOVUPS 0x1078(SP), X0										
  scanner_fingerprint.go:34	0x5f1ade		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:34	0x5f1ae6		0f10842488100000	MOVUPS 0x1088(SP), X0										
  scanner_fingerprint.go:34	0x5f1aee		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:34	0x5f1af6		4881c4d0100000		ADDQ $0x10d0, SP										
  scanner_fingerprint.go:34	0x5f1afd		5d			POPQ BP												
  scanner_fingerprint.go:34	0x5f1afe		c3			RET												
  scanner_fingerprint.go:24	0x5f1aff		440f117c2438		MOVUPS X15, 0x38(SP)										
  scanner_fingerprint.go:24	0x5f1b05		440f117c2448		MOVUPS X15, 0x48(SP)										
  scanner_fingerprint.go:25	0x5f1b0b		c644243816		MOVB $0x16, 0x38(SP)										
  scanner_fingerprint.go:26	0x5f1b10		4889d0			MOVQ DX, AX											
  scanner_fingerprint.go:26	0x5f1b13		4c89c1			MOVQ R8, CX											
  scanner_fingerprint.go:26	0x5f1b16		e865fdedff		CALL reflect.Value.Pointer(SB)									
  binary.go:124			0x5f1b1b		4889442439		MOVQ AX, 0x39(SP)										
  scanner_fingerprint.go:27	0x5f1b20		0f10442438		MOVUPS 0x38(SP), X0										
  scanner_fingerprint.go:27	0x5f1b25		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:27	0x5f1b2d		0f10442448		MOVUPS 0x48(SP), X0										
  scanner_fingerprint.go:27	0x5f1b32		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:27	0x5f1b3a		0f10442438		MOVUPS 0x38(SP), X0										
  scanner_fingerprint.go:27	0x5f1b3f		0f118424e0100000	MOVUPS X0, 0x10e0(SP)										
  scanner_fingerprint.go:27	0x5f1b47		0f10442448		MOVUPS 0x48(SP), X0										
  scanner_fingerprint.go:27	0x5f1b4c		0f118424f0100000	MOVUPS X0, 0x10f0(SP)										
  scanner_fingerprint.go:27	0x5f1b54		4881c4d0100000		ADDQ $0x10d0, SP										
  scanner_fingerprint.go:27	0x5f1b5b		5d			POPQ BP												
  scanner_fingerprint.go:27	0x5f1b5c		c3			RET												
  scanner_fingerprint.go:18	0x5f1b5d		4881c4d0100000		ADDQ $0x10d0, SP										
  scanner_fingerprint.go:18	0x5f1b64		5d			POPQ BP												
  scanner_fingerprint.go:18	0x5f1b65		c3			RET												
  scanner_fingerprint.go:16	0x5f1b66		4889442428		MOVQ AX, 0x28(SP)										
  scanner_fingerprint.go:16	0x5f1b6b		48895c2430		MOVQ BX, 0x30(SP)										
  scanner_fingerprint.go:16	0x5f1b70		e8abdfe8ff		CALL runtime.morestack_noctxt.abi0(SB)								
  scanner_fingerprint.go:16	0x5f1b75		488b442428		MOVQ 0x28(SP), AX										
  scanner_fingerprint.go:16	0x5f1b7a		488b5c2430		MOVQ 0x30(SP), BX										
  scanner_fingerprint.go:16	0x5f1b7f		90			NOPL												
  scanner_fingerprint.go:16	0x5f1b80		e95bfdffff		JMP github.com/odvcencio/gotreesitter/internal/parsercorephase0.ScannerFingerprint(SB)		

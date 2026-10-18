TEXT github.com/odvcencio/gotreesitter/internal/parsercorephase0.ScannerFingerprint(SB) /workspace/internal/parsercorephase0/scanner_fingerprint.go
  scanner_fingerprint.go:14	0x5f18e0		4c8d6424e0		LEAQ -0x20(SP), R12										
  scanner_fingerprint.go:14	0x5f18e5		4d3b6610		CMPQ R12, 0x10(R14)										
  scanner_fingerprint.go:14	0x5f18e9		0f8662010000		JBE 0x5f1a51											
  scanner_fingerprint.go:14	0x5f18ef		55			PUSHQ BP											
  scanner_fingerprint.go:14	0x5f18f0		4889e5			MOVQ SP, BP											
  scanner_fingerprint.go:14	0x5f18f3		4881ec98000000		SUBQ $0x98, SP											
  scanner_fingerprint.go:14	0x5f18fa		48898424c8000000	MOVQ AX, 0xc8(SP)										
  scanner_fingerprint.go:14	0x5f1902		48899c24d0000000	MOVQ BX, 0xd0(SP)										
  scanner_fingerprint.go:14	0x5f190a		440f11bc24a8000000	MOVUPS X15, 0xa8(SP)										
  scanner_fingerprint.go:14	0x5f1913		440f11bc24b8000000	MOVUPS X15, 0xb8(SP)										
  scanner_fingerprint.go:14	0x5f191c		0f1f4000		NOPL 0(AX)											
  scanner_fingerprint.go:15	0x5f1920		4885c0			TESTQ AX, AX											
  scanner_fingerprint.go:15	0x5f1923		0f841f010000		JE 0x5f1a48											
  scanner_fingerprint.go:18	0x5f1929		90			NOPL												
  value.go:3054			0x5f192a		4889842488000000	MOVQ AX, 0x88(SP)										
  value.go:3054			0x5f1932		48899c2490000000	MOVQ BX, 0x90(SP)										
  value.go:157			0x5f193a		488b942488000000	MOVQ 0x88(SP), DX										
  value.go:158			0x5f1942		4885d2			TESTQ DX, DX											
  value.go:158			0x5f1945		7423			JE 0x5f196a											
  type.go:193			0x5f1947		440fb64217		MOVZX 0x17(DX), R8										
  value.go:161			0x5f194c		4589c1			MOVL R8, R9											
  value.go:161			0x5f194f		4183e01f		ANDL $0x1f, R8											
  value.go:163			0x5f1953		4d89c2			MOVQ R8, R10											
  value.go:163			0x5f1956		4981c880000000		ORQ $0x80, R8											
  type.go:204			0x5f195d		41f6c120		TESTL $0x20, R9											
  value.go:165			0x5f1961		4d0f44d0		CMOVE R8, R10											
  scanner_fingerprint.go:15	0x5f1965		4889d9			MOVQ BX, CX											
  value.go:162			0x5f1968		eb0a			JMP 0x5f1974											
  scanner_fingerprint.go:27	0x5f196a		4889d9			MOVQ BX, CX											
  scanner_fingerprint.go:27	0x5f196d		4531d2			XORL R10, R10											
  scanner_fingerprint.go:27	0x5f1970		31d2			XORL DX, DX											
  scanner_fingerprint.go:27	0x5f1972		31db			XORL BX, BX											
  value.go:86			0x5f1974		4d89d0			MOVQ R10, R8											
  value.go:86			0x5f1977		4183e21f		ANDL $0x1f, R10											
  value.go:1818			0x5f197b		90			NOPL												
  value.go:1818			0x5f197c		0f1f4000		NOPL 0(AX)											
  scanner_fingerprint.go:19	0x5f1980		4983fa16		CMPQ R10, $0x16											
  scanner_fingerprint.go:19	0x5f1984		7561			JNE 0x5f19e7											
  scanner_fingerprint.go:22	0x5f1986		440f117c2448		MOVUPS X15, 0x48(SP)										
  scanner_fingerprint.go:22	0x5f198c		440f117c2458		MOVUPS X15, 0x58(SP)										
  scanner_fingerprint.go:23	0x5f1992		c644244816		MOVB $0x16, 0x48(SP)										
  scanner_fingerprint.go:24	0x5f1997		4889d0			MOVQ DX, AX											
  scanner_fingerprint.go:24	0x5f199a		4c89c1			MOVQ R8, CX											
  scanner_fingerprint.go:24	0x5f199d		0f1f00			NOPL 0(AX)											
  scanner_fingerprint.go:24	0x5f19a0		e8dbfeedff		CALL reflect.Value.Pointer(SB)									
  binary.go:124			0x5f19a5		4889442449		MOVQ AX, 0x49(SP)										
  scanner_fingerprint.go:25	0x5f19aa		0f10442448		MOVUPS 0x48(SP), X0										
  scanner_fingerprint.go:25	0x5f19af		0f118424a8000000	MOVUPS X0, 0xa8(SP)										
  scanner_fingerprint.go:25	0x5f19b7		0f10442458		MOVUPS 0x58(SP), X0										
  scanner_fingerprint.go:25	0x5f19bc		0f118424b8000000	MOVUPS X0, 0xb8(SP)										
  scanner_fingerprint.go:25	0x5f19c4		0f10442448		MOVUPS 0x48(SP), X0										
  scanner_fingerprint.go:25	0x5f19c9		0f118424a8000000	MOVUPS X0, 0xa8(SP)										
  scanner_fingerprint.go:25	0x5f19d1		0f10442458		MOVUPS 0x58(SP), X0										
  scanner_fingerprint.go:25	0x5f19d6		0f118424b8000000	MOVUPS X0, 0xb8(SP)										
  scanner_fingerprint.go:25	0x5f19de		4881c498000000		ADDQ $0x98, SP											
  scanner_fingerprint.go:25	0x5f19e5		5d			POPQ BP												
  scanner_fingerprint.go:25	0x5f19e6		c3			RET												
  scanner_fingerprint.go:27	0x5f19e7		4889c7			MOVQ AX, DI											
  scanner_fingerprint.go:27	0x5f19ea		4889ce			MOVQ CX, SI											
  scanner_fingerprint.go:27	0x5f19ed		4889d0			MOVQ DX, AX											
  scanner_fingerprint.go:27	0x5f19f0		4c89c1			MOVQ R8, CX											
  scanner_fingerprint.go:27	0x5f19f3		e8e8090000		CALL github.com/odvcencio/gotreesitter/internal/parsercorephase0.scannerValueFingerprint(SB)	
  scanner_fingerprint.go:27	0x5f19f8		0f100424		MOVUPS 0(SP), X0										
  scanner_fingerprint.go:27	0x5f19fc		0f11442468		MOVUPS X0, 0x68(SP)										
  scanner_fingerprint.go:27	0x5f1a01		0f10442410		MOVUPS 0x10(SP), X0										
  scanner_fingerprint.go:27	0x5f1a06		0f11442478		MOVUPS X0, 0x78(SP)										
  scanner_fingerprint.go:27	0x5f1a0b		0f10442468		MOVUPS 0x68(SP), X0										
  scanner_fingerprint.go:27	0x5f1a10		0f118424a8000000	MOVUPS X0, 0xa8(SP)										
  scanner_fingerprint.go:27	0x5f1a18		0f10442478		MOVUPS 0x78(SP), X0										
  scanner_fingerprint.go:27	0x5f1a1d		0f118424b8000000	MOVUPS X0, 0xb8(SP)										
  scanner_fingerprint.go:27	0x5f1a25		0f10442468		MOVUPS 0x68(SP), X0										
  scanner_fingerprint.go:27	0x5f1a2a		0f118424a8000000	MOVUPS X0, 0xa8(SP)										
  scanner_fingerprint.go:27	0x5f1a32		0f10442478		MOVUPS 0x78(SP), X0										
  scanner_fingerprint.go:27	0x5f1a37		0f118424b8000000	MOVUPS X0, 0xb8(SP)										
  scanner_fingerprint.go:27	0x5f1a3f		4881c498000000		ADDQ $0x98, SP											
  scanner_fingerprint.go:27	0x5f1a46		5d			POPQ BP												
  scanner_fingerprint.go:27	0x5f1a47		c3			RET												
  scanner_fingerprint.go:16	0x5f1a48		4881c498000000		ADDQ $0x98, SP											
  scanner_fingerprint.go:16	0x5f1a4f		5d			POPQ BP												
  scanner_fingerprint.go:16	0x5f1a50		c3			RET												
  scanner_fingerprint.go:14	0x5f1a51		4889442428		MOVQ AX, 0x28(SP)										
  scanner_fingerprint.go:14	0x5f1a56		48895c2430		MOVQ BX, 0x30(SP)										
  scanner_fingerprint.go:14	0x5f1a5b		0f1f440000		NOPL 0(AX)(AX*1)										
  scanner_fingerprint.go:14	0x5f1a60		e8bbe0e8ff		CALL runtime.morestack_noctxt.abi0(SB)								
  scanner_fingerprint.go:14	0x5f1a65		488b442428		MOVQ 0x28(SP), AX										
  scanner_fingerprint.go:14	0x5f1a6a		488b5c2430		MOVQ 0x30(SP), BX										
  scanner_fingerprint.go:14	0x5f1a6f		e96cfeffff		JMP github.com/odvcencio/gotreesitter/internal/parsercorephase0.ScannerFingerprint(SB)		

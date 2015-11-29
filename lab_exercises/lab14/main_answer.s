	.file	"main.c"
	.section	.rodata
.LC0:
	.string	"Hello Lucki"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L2
.L6:
	jmp	.L3
.L5:
	cmpl	$5, -8(%rbp)    ; i == 5 ? 
	jne	.L4             ; i >= 5 ?
	movl	$.LC0, %edi
	call	puts
.L4:
	addl	$1, -4(%rbp)    ; p += 1
.L3:
	cmpl	$14, -4(%rbp)   ; p < 15?
	jle	.L5
	addl	$1, -8(%rbp)    ; p >= 15
.L2:
	cmpl	$9, -8(%rbp)    ; i < 10?
	jle	.L6
	leave                   ; i >= 10 Stop.
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04) 4.8.4"
	.section	.note.GNU-stack,"",@progbits

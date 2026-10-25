	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	jmp	main.end
	.text
main.end:
	movq	$9, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
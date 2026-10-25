	.data
	.globl	format
format:
	.asciz	"test alignment"
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	format(%rip), %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	printf
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
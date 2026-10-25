	.data
	.globl	gbl
gbl:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$0, %rax
	movq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	leaq	gbl(%rip), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-24(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
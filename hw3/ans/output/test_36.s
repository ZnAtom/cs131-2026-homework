	.data
	.globl	hd
hd:
	.quad	1
	.quad	md
	.data
	.globl	md
md:
	.quad	2
	.quad	tl
	.data
	.globl	tl
tl:
	.quad	3
	.quad	0
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$88, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	hd(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	leaq	hd(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
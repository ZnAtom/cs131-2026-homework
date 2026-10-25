	.data
	.globl	gint
gint:
	.quad	42
	.data
	.globl	v1
v1:
	.quad	0
	.quad	gint
	.data
	.globl	v2
v2:
	.quad	1
	.quad	0
	.data
	.globl	gstr
gstr:
	.asciz	"hello, world!"
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$72, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	leaq	v2(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	$5, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	leaq	v2(%rip), %rax
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -72(%rbp)
	andq	$-16, %rsp
	movq	-48(%rbp), %rdi
	movq	$0, %rax
	callq	foo
	movq	-72(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -16(%rbp)
	movq	$6, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
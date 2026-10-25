	.data
	.globl	matrixA
matrixA:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.data
	.globl	matrixB
matrixB:
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.text
	.globl	multiply
multiply:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -8(%rbp)
	movq	$0, %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	main.loop
	.text
main.loop:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$4, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	main.body
	jmp	main.end
	.text
main.body:
	leaq	matrixA(%rip), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	leaq	matrixB(%rip), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -144(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	-80(%rbp), %rsi
	movq	$0, %rax
	callq	multiply
	movq	-144(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	main.loop
	.text
main.end:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
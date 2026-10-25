	.data
	.globl	nums
nums:
	.quad	5
	.quad	1
	.quad	4
	.quad	2
	.quad	3
	.quad	6
	.quad	10
	.quad	9
	.quad	7
	.quad	8
	.text
	.globl	iter
iter:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$104, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	iter.loop
	.text
iter.loop:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$10, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	iter.body
	jmp	iter.post
	.text
iter.body:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-56(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -104(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	-8(%rbp), %r11
	movq	$0, %rax
	callq	*%r11
	movq	-104(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	-56(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	iter.loop
	.text
iter.post:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	print
print:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsp, %r11
	movq	%r11, -32(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	$0, %rax
	callq	ll_ltoa
	movq	-32(%rbp), %rsp
	movq	%rax, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -32(%rbp)
	andq	$-16, %rsp
	movq	-16(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -32(%rbp)
	andq	$-16, %rsp
	leaq	print(%rip), %rdi
	leaq	nums(%rip), %rsi
	movq	$0, %rax
	callq	iter
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
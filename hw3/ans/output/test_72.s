	.data
	.globl	array_g
array_g:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.text
	.globl	triangle
triangle:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	movq	$1, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	triangle.loop
	.text
triangle.loop:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -40(%rbp)
	leaq	array_g(%rip), %rax
	movq	-40(%rbp), %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	-32(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	leaq	array_g(%rip), %rax
	movq	-32(%rbp), %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-64(%rbp), %rdi
	movq	-32(%rbp), %rsi
	movq	$0, %rax
	callq	check
	movq	-120(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	triangle.success
	jmp	triangle.fail
	.text
triangle.success:
	movq	-32(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-96(%rbp), %rax
	movq	-8(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	triangle.loop
	jmp	triangle.exit
	.text
triangle.exit:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
triangle.fail:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	check
check:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	$2, %r10
	imulq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	check.success
	jmp	check.fail
	.text
check.fail:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
check.success:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	movq	$10, %rdi
	movq	$0, %rax
	callq	triangle
	movq	-56(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	movq	$45, %rdi
	movq	$9, %rsi
	movq	$0, %rax
	callq	check
	movq	-56(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	$1, %rax
	movq	-32(%rbp), %r10
	subq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	-40(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
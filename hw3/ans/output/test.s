	.data
	.globl	values
values:
	.quad	1
	.quad	-2
	.quad	3
	.quad	4
	.text
	.globl	double
double:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	-8(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	sum_positive
sum_positive:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sum_positive.loop
	.text
sum_positive.loop:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	$4, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	sum_positive.exit
	jmp	sum_positive.check
	.text
sum_positive.check:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	sum_positive.body
	jmp	sum_positive.skip
	.text
sum_positive.body:
	movq	%rsp, %r11
	movq	%r11, -160(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	$0, %rax
	callq	double
	movq	-160(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sum_positive.loop
	.text
sum_positive.skip:
	movq	-48(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sum_positive.loop
	.text
sum_positive.exit:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
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
	leaq	values(%rip), %rdi
	movq	$0, %rax
	callq	sum_positive
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
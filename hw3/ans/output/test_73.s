	.data
	.globl	input_arr
input_arr:
	.quad	1
	.quad	2
	.quad	3
	.quad	3
	.quad	4
	.text
	.globl	find_dup
find_dup:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$216, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	find_dup.phase_1_loop
	.text
find_dup.phase_1_loop:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-56(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-88(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-104(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-72(%rbp), %rax
	movq	-120(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	find_dup.phase_2_loop
	jmp	find_dup.phase_1_loop
	.text
find_dup.phase_2_loop:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-144(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -176(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-176(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-160(%rbp), %rax
	movq	-192(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -208(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	find_dup.return_slow
	jmp	find_dup.phase_2_loop
	.text
find_dup.return_slow:
	movq	-160(%rbp), %rax
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
	movq	$0, %rax
	callq	find_dup
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
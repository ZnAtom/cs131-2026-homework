	.data
	.globl	base
base:
	.quad	2
	.data
	.globl	factor
factor:
	.quad	2
	.data
	.globl	answer
answer:
	.quad	2
	.quad	4
	.quad	8
	.quad	16
	.quad	32
	.quad	64
	.quad	128
	.quad	256
	.quad	512
	.quad	1024
	.data
	.globl	temp
temp:
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
	.globl	check_answer
check_answer:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	check_answer.loop_check_cond
	.text
check_answer.loop_check_cond:
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
	jne	check_answer.loop_check_body
	jmp	check_answer.loop_check_exit
	.text
check_answer.loop_check_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
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
	movq	-72(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -88(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	check_answer.loop_check_cond
	jmp	check_answer.loop_check_bad
	.text
check_answer.loop_check_bad:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
check_answer.loop_check_exit:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	geometric_series
geometric_series:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$168, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	geometric_series.loop_geo_cond
	.text
geometric_series.loop_geo_cond:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	$10, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	geometric_series.loop_geo_body
	jmp	geometric_series.loop_geo_exit
	.text
geometric_series.loop_geo_body:
	movq	-48(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	geometric_series.use_base_value
	jmp	geometric_series.use_array_value
	.text
geometric_series.use_base_value:
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-8(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	geometric_series.loop_geo_cond
	.text
geometric_series.use_array_value:
	movq	-48(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-104(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	-16(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-128(%rbp), %r10
	movq	-136(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	geometric_series.loop_geo_cond
	.text
geometric_series.loop_geo_exit:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	leaq	base(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	leaq	factor(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	leaq	temp(%rip), %rdx
	movq	$0, %rax
	callq	geometric_series
	movq	-40(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	leaq	answer(%rip), %rdi
	leaq	temp(%rip), %rsi
	movq	$0, %rax
	callq	check_answer
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
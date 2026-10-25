	.data
	.globl	target
target:
	.quad	800
	.data
	.globl	array_size
array_size:
	.quad	10
	.data
	.globl	nums
nums:
	.quad	123
	.quad	934
	.quad	3
	.quad	342
	.quad	732
	.quad	396
	.quad	502
	.quad	221
	.quad	6
	.quad	797
	.text
	.globl	two_sum
two_sum:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$216, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	movq	$0, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	leaq	array_size(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	$-1, %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	two_sum.outer_loop
	.text
two_sum.outer_loop:
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	two_sum.inner_loop
	.text
two_sum.inner_loop:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-72(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-80(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-104(%rbp), %rax
	movq	-112(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	leaq	target(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	two_sum.found
	jmp	two_sum.not_found
	.text
two_sum.found:
	movq	-72(%rbp), %rax
	movq	-80(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	two_sum.end_loop
	.text
two_sum.not_found:
	movq	-80(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	cmpq	$0, %rax
	jne	two_sum.end_inner_loop
	jmp	two_sum.inner_loop
	.text
two_sum.end_inner_loop:
	movq	-72(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	cmpq	$0, %rax
	jne	two_sum.end_loop
	jmp	two_sum.outer_loop
	.text
two_sum.end_loop:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	-208(%rbp), %rax
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
	leaq	nums(%rip), %rdi
	movq	$0, %rax
	callq	two_sum
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.data
	.globl	glb_arr
glb_arr:
	.quad	1
	.quad	1
	.quad	4
	.quad	3
	.quad	3
	.text
	.globl	singleNumber
singleNumber:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$152, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	$0, %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	singleNumber.loop
	.text
singleNumber.loop:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	singleNumber.compute
	jmp	singleNumber.ret_ext
	.text
singleNumber.compute:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-72(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	-96(%rbp), %r10
	xorq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	singleNumber.loop_inc
	.text
singleNumber.loop_inc:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	singleNumber.loop
	.text
singleNumber.ret_ext:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
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
	leaq	glb_arr(%rip), %rdi
	movq	$5, %rsi
	movq	$0, %rax
	callq	singleNumber
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
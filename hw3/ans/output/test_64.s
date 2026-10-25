	.data
	.globl	arr
arr:
	.quad	10
	.quad	2
	.quad	7
	.quad	4
	.quad	1
	.quad	2
	.quad	3
	.quad	1
	.quad	1
	.quad	4
	.data
	.globl	arr_len
arr_len:
	.quad	10
	.data
	.globl	my_k
my_k:
	.quad	12
	.text
	.globl	lenOfLongSubarr
lenOfLongSubarr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$256, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	$0, %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lenOfLongSubarr.outer_loop
	.text
lenOfLongSubarr.outer_loop:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	lenOfLongSubarr.inner_loop_entry
	jmp	lenOfLongSubarr.outer_loop_end
	.text
lenOfLongSubarr.inner_loop_entry:
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -80(%rbp)
	movq	$0, %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -96(%rbp)
	movq	-64(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lenOfLongSubarr.inner_loop
	.text
lenOfLongSubarr.inner_loop:
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	cmpq	$0, %rax
	jne	lenOfLongSubarr.loop_body
	jmp	lenOfLongSubarr.inner_loop_end
	.text
lenOfLongSubarr.loop_body:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-8(%rbp), %rax
	movq	-112(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	-128(%rbp), %rax
	movq	-144(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-152(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	cmpq	$0, %rax
	jne	lenOfLongSubarr.update_maxlength
	jmp	lenOfLongSubarr.inner_loop_cont
	.text
lenOfLongSubarr.update_maxlength:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -176(%rbp)
	movq	-112(%rbp), %rax
	movq	-64(%rbp), %r10
	subq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	-176(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	cmpq	$0, %rax
	jne	lenOfLongSubarr.store_maxlength
	jmp	lenOfLongSubarr.inner_loop_cont
	.text
lenOfLongSubarr.store_maxlength:
	movq	-192(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lenOfLongSubarr.inner_loop_cont
	.text
lenOfLongSubarr.inner_loop_cont:
	movq	-112(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -216(%rbp)
	movq	-216(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lenOfLongSubarr.inner_loop
	.text
lenOfLongSubarr.inner_loop_end:
	movq	-64(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lenOfLongSubarr.outer_loop
	.text
lenOfLongSubarr.outer_loop_end:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	arr_len(%rip), %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	leaq	my_k(%rip), %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -64(%rbp)
	andq	$-16, %rsp
	leaq	arr(%rip), %rdi
	movq	-32(%rbp), %rsi
	movq	-48(%rbp), %rdx
	movq	$0, %rax
	callq	lenOfLongSubarr
	movq	-64(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
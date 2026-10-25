	.data
	.globl	test_case
test_case:
	.quad	10
	.quad	9
	.quad	2
	.quad	5
	.quad	3
	.quad	7
	.quad	101
	.quad	18
	.data
	.globl	memo
memo:
	.quad	-1
	.quad	-1
	.quad	-1
	.quad	-1
	.quad	-1
	.quad	-1
	.quad	-1
	.quad	-1
	.text
	.globl	max_in_memo
max_in_memo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -8(%rbp)
	movq	$-1, %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	max_in_memo.loop
	.text
max_in_memo.loop:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$8, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	max_in_memo.after_loop
	jmp	max_in_memo.loop_body
	.text
max_in_memo.loop_body:
	leaq	memo(%rip), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	max_in_memo.new_max
	jmp	max_in_memo.repeat_loop
	.text
max_in_memo.new_max:
	movq	-64(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	jmp	max_in_memo.repeat_loop
	.text
max_in_memo.repeat_loop:
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	max_in_memo.loop
	.text
max_in_memo.after_loop:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	lis
lis:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$224, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	movq	$1, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lis.loop
	.text
lis.loop:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-8(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	lis.after_loop
	jmp	lis.loop_body
	.text
lis.loop_body:
	leaq	memo(%rip), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	$-1, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	lis.recurse
	jmp	lis.after_memo
	.text
lis.recurse:
	movq	%rsp, %r11
	movq	%r11, -224(%rbp)
	andq	$-16, %rsp
	movq	-48(%rbp), %rdi
	movq	$0, %rax
	callq	lis
	movq	-224(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lis.after_memo
	.text
lis.after_memo:
	leaq	test_case(%rip), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	leaq	test_case(%rip), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-8(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-112(%rbp), %rax
	movq	-128(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	lis.can_incr_subseq
	jmp	lis.repeat_loop
	.text
lis.can_incr_subseq:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	-144(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	cmpq	$0, %rax
	jne	lis.new_max_found
	jmp	lis.repeat_loop
	.text
lis.new_max_found:
	movq	-160(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lis.repeat_loop
	.text
lis.repeat_loop:
	movq	-48(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	lis.loop
	.text
lis.after_loop:
	leaq	memo(%rip), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-8(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -200(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	-208(%rbp), %r10
	movq	-200(%rbp), %rax
	movq	%r10, (%rax)
	movq	-208(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	$7, %rdi
	movq	$0, %rax
	callq	lis
	movq	-40(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	$0, %rax
	callq	max_in_memo
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
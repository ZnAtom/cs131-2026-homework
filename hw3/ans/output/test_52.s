	.data
	.globl	gbl
gbl:
	.quad	10
	.quad	5
	.quad	1
	.quad	3
	.quad	7
	.quad	4
	.quad	8
	.quad	2
	.quad	6
	.quad	9
	.quad	10
	.data
	.globl	expected_arr
expected_arr:
	.quad	10
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.quad	10
	.text
	.globl	is_sorted
is_sorted:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$136, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	is_sorted.loop_entry
	.text
is_sorted.loop_entry:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	is_sorted.loop_body
	jmp	is_sorted.exit
	.text
is_sorted.loop_body:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-72(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-72(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-72(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-96(%rbp), %rax
	movq	-104(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	cmpq	$0, %rax
	jne	is_sorted.loop_entry
	jmp	is_sorted.exit_false
	.text
is_sorted.exit_false:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
is_sorted.exit:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	sort
sort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$312, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sort.loop_entry1
	.text
sort.loop_entry1:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-56(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	sort.loop_body1
	jmp	sort.exit
	.text
sort.loop_body1:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	$1, %rax
	movq	-104(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sort.entry2
	.text
sort.entry2:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	-128(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	cmpq	$0, %rax
	jne	sort.loop_body2
	jmp	sort.swap
	.text
sort.loop_body2:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-152(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -168(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-160(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movq	-176(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	cmpq	$0, %rax
	jne	sort.update_min_idx
	jmp	sort.merge
	.text
sort.update_min_idx:
	movq	-160(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sort.merge
	.text
sort.merge:
	movq	$1, %rax
	movq	-160(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -216(%rbp)
	movq	-216(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sort.entry2
	.text
sort.swap:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -232(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -240(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-232(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -248(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$88, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	-240(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -256(%rbp)
	movq	-248(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -264(%rbp)
	movq	-256(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -272(%rbp)
	movq	-264(%rbp), %r10
	movq	-256(%rbp), %rax
	movq	%r10, (%rax)
	movq	-272(%rbp), %r10
	movq	-248(%rbp), %rax
	movq	%r10, (%rax)
	movq	$1, %rax
	movq	-240(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -296(%rbp)
	movq	-296(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	sort.loop_entry1
	.text
sort.exit:
	movq	$0, %rax
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
	leaq	gbl(%rip), %rdi
	movq	$0, %rax
	callq	sort
	movq	-40(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	leaq	gbl(%rip), %rdi
	leaq	expected_arr(%rip), %rsi
	movq	$0, %rax
	callq	is_sorted
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
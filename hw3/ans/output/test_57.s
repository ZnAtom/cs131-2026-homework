	.data
	.globl	arr
arr:
	.quad	10
	.quad	2
	.quad	7
	.quad	4
	.quad	5
	.quad	1
	.quad	9
	.quad	3
	.quad	6
	.quad	8
	.data
	.globl	sorted_arr
sorted_arr:
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
	.globl	check_sorted
check_sorted:
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
	jmp	check_sorted.iterate
	.text
check_sorted.iterate:
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
	jne	check_sorted.check_arrs
	jmp	check_sorted.end_sorted
	.text
check_sorted.check_arrs:
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
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-72(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	check_sorted.iterate
	jmp	check_sorted.end_not_sorted
	.text
check_sorted.end_not_sorted:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
check_sorted.end_sorted:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	insertion_sort
insertion_sort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$216, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$1, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	jmp	insertion_sort.loop
	.text
insertion_sort.loop:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	insertion_sort.end
	jmp	insertion_sort.loop_body
	.text
insertion_sort.loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	insertion_sort.inner_loop_check
	.text
insertion_sort.inner_loop_check:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	insertion_sort.inner_loop_check2
	jmp	insertion_sort.increment
	.text
insertion_sort.inner_loop_check2:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-80(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-72(%rbp), %rax
	movq	-120(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	cmpq	$0, %rax
	jne	insertion_sort.inner_loop
	jmp	insertion_sort.increment
	.text
insertion_sort.inner_loop:
	movq	-80(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-136(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-120(%rbp), %r10
	movq	-144(%rbp), %rax
	movq	%r10, (%rax)
	movq	-80(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	insertion_sort.inner_loop_check
	.text
insertion_sort.increment:
	movq	-80(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-136(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-72(%rbp), %r10
	movq	-144(%rbp), %rax
	movq	%r10, (%rax)
	movq	$1, %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	insertion_sort.loop
	.text
insertion_sort.end:
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
	leaq	arr(%rip), %rdi
	movq	$10, %rsi
	movq	$0, %rax
	callq	insertion_sort
	movq	-40(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	leaq	sorted_arr(%rip), %rdi
	leaq	arr(%rip), %rsi
	movq	$0, %rax
	callq	check_sorted
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
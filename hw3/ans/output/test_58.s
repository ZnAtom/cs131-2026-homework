	.data
	.globl	unsorted_array_1
unsorted_array_1:
	.quad	-95
	.quad	18
	.quad	-50
	.quad	-22
	.quad	-51
	.quad	-1
	.quad	94
	.quad	6
	.quad	82
	.quad	82
	.quad	-23
	.quad	44
	.data
	.globl	unsorted_array_2
unsorted_array_2:
	.quad	2
	.quad	79
	.quad	-8
	.quad	-86
	.quad	6
	.quad	-29
	.quad	88
	.quad	-80
	.quad	2
	.quad	21
	.quad	-26
	.quad	-13
	.data
	.globl	unsorted_array_3
unsorted_array_3:
	.quad	16
	.quad	-1
	.quad	3
	.quad	51
	.quad	30
	.quad	49
	.quad	-48
	.quad	-99
	.quad	-13
	.quad	57
	.quad	-63
	.quad	29
	.data
	.globl	unsorted_array_4
unsorted_array_4:
	.quad	91
	.quad	87
	.quad	-80
	.quad	60
	.quad	-43
	.quad	-79
	.quad	-12
	.quad	-52
	.quad	-42
	.quad	69
	.quad	87
	.quad	-86
	.data
	.globl	unsorted_array_5
unsorted_array_5:
	.quad	89
	.quad	89
	.quad	74
	.quad	89
	.quad	-50
	.quad	7
	.quad	-46
	.quad	-37
	.quad	30
	.quad	-50
	.quad	34
	.quad	-80
	.text
	.globl	is_sorted
is_sorted:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	movq	$11, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	$0, %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	is_sorted.loop_cond
	.text
is_sorted.loop_cond:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	-32(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	is_sorted.loop_body
	jmp	is_sorted.sorted
	.text
is_sorted.loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$96, %r10
	addq	%r10, %rax
	movq	-56(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	$1, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	-96(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setle	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	is_sorted.increment
	jmp	is_sorted.not_sorted
	.text
is_sorted.increment:
	movq	-56(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	is_sorted.loop_cond
	.text
is_sorted.not_sorted:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
is_sorted.sorted:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	swap
swap:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	bubblesort
bubblesort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$216, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	movq	$12, %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	jmp	bubblesort.outer_loop_entry
	.text
bubblesort.outer_loop_entry:
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	jmp	bubblesort.outer_loop_cond
	.text
bubblesort.outer_loop_cond:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	bubblesort.inner_loop_entry
	jmp	bubblesort.exit
	.text
bubblesort.inner_loop_entry:
	movq	$0, %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-56(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %r10
	subq	%r10, %rax
	movq	%rax, -96(%rbp)
	jmp	bubblesort.inner_loop_cond
	.text
bubblesort.inner_loop_cond:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-96(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	cmpq	$0, %rax
	jne	bubblesort.swap_check
	jmp	bubblesort.inner_loop_exit
	.text
bubblesort.swap_check:
	movq	-112(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$96, %r10
	addq	%r10, %rax
	movq	-112(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$96, %r10
	addq	%r10, %rax
	movq	-128(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-136(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-144(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-152(%rbp), %rax
	movq	-160(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	cmpq	$0, %rax
	jne	bubblesort.do_swap
	jmp	bubblesort.no_swap
	.text
bubblesort.do_swap:
	movq	%rsp, %r11
	movq	%r11, -216(%rbp)
	andq	$-16, %rsp
	movq	-136(%rbp), %rdi
	movq	-144(%rbp), %rsi
	movq	$0, %rax
	callq	swap
	movq	-216(%rbp), %rsp
	movq	%rax, -176(%rbp)
	jmp	bubblesort.no_swap
	.text
bubblesort.no_swap:
	movq	-112(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	bubblesort.inner_loop_cond
	.text
bubblesort.inner_loop_exit:
	movq	-64(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	bubblesort.outer_loop_cond
	.text
bubblesort.exit:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$136, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_1(%rip), %rdi
	movq	$0, %rsi
	movq	$11, %rdx
	movq	$0, %rax
	callq	bubblesort
	movq	-136(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_2(%rip), %rdi
	movq	$0, %rsi
	movq	$11, %rdx
	movq	$0, %rax
	callq	bubblesort
	movq	-136(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_3(%rip), %rdi
	movq	$0, %rsi
	movq	$11, %rdx
	movq	$0, %rax
	callq	bubblesort
	movq	-136(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_4(%rip), %rdi
	movq	$0, %rsi
	movq	$11, %rdx
	movq	$0, %rax
	callq	bubblesort
	movq	-136(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_5(%rip), %rdi
	movq	$0, %rsi
	movq	$11, %rdx
	movq	$0, %rax
	callq	bubblesort
	movq	-136(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_1(%rip), %rdi
	movq	$0, %rax
	callq	is_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_2(%rip), %rdi
	movq	$0, %rax
	callq	is_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_5(%rip), %rdi
	movq	$0, %rax
	callq	is_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_4(%rip), %rdi
	movq	$0, %rax
	callq	is_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	unsorted_array_3(%rip), %rdi
	movq	$0, %rax
	callq	is_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-80(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-88(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
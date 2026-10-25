	.data
	.globl	original_list
original_list:
	.quad	2
	.quad	1
	.quad	3
	.quad	5
	.quad	4
	.data
	.globl	sorted_list
sorted_list:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.data
	.globl	pre_swap_list
pre_swap_list:
	.quad	2
	.quad	1
	.quad	3
	.quad	5
	.quad	4
	.data
	.globl	swapped_list
swapped_list:
	.quad	3
	.quad	1
	.quad	2
	.quad	5
	.quad	4
	.data
	.globl	pre_partition_list
pre_partition_list:
	.quad	2
	.quad	1
	.quad	3
	.quad	5
	.quad	4
	.data
	.globl	partitioned_list
partitioned_list:
	.quad	2
	.quad	1
	.quad	3
	.quad	4
	.quad	5
	.text
	.globl	swap
swap:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-16(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-24(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	partition
partition:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$208, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-24(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-16(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -72(%rbp)
	movq	-16(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	jmp	partition.loop
	.text
partition.loop:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setle	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	partition.cont
	jmp	partition.end
	.text
partition.cont:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-96(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	cmpq	$0, %rax
	jne	partition.swap
	jmp	partition.increment
	.text
partition.swap:
	movq	$1, %rax
	movq	-88(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	%rsp, %r11
	movq	%r11, -208(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-152(%rbp), %rsi
	movq	-96(%rbp), %rdx
	movq	$0, %rax
	callq	swap
	movq	-208(%rbp), %rsp
	movq	%rax, -160(%rbp)
	jmp	partition.increment
	.text
partition.increment:
	movq	$1, %rax
	movq	-96(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	jmp	partition.loop
	.text
partition.end:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movq	$1, %rax
	movq	-184(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -192(%rbp)
	movq	%rsp, %r11
	movq	%r11, -208(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-192(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	swap
	movq	-208(%rbp), %rsp
	movq	%rax, -200(%rbp)
	movq	-192(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	quicksort
quicksort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	quicksort.sort
	jmp	quicksort.endsort
	.text
quicksort.sort:
	movq	%rsp, %r11
	movq	%r11, -80(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	partition
	movq	-80(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -80(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-48(%rbp), %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-80(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -80(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-64(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-80(%rbp), %rsp
	movq	%rax, -72(%rbp)
	jmp	quicksort.endsort
	.text
quicksort.endsort:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	check
check:
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
	jmp	check.loop
	.text
check.loop:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$5, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	check.equal
	jmp	check.check
	.text
check.check:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
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
	movq	$1, %rax
	movq	-40(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	check.loop
	jmp	check.noteq
	.text
check.equal:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
check.noteq:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	printarr
printarr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	-16(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	printarr.loop
	.text
printarr.loop:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	printarr.end
	jmp	printarr.check
	.text
printarr.check:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-48(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	$0, %rax
	callq	ll_ltoa
	movq	-112(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	-80(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-112(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	$1, %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	printarr.loop
	.text
printarr.end:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$152, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	original_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	original_list(%rip), %rdi
	movq	$0, %rsi
	movq	$4, %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-152(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	original_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	original_list(%rip), %rdi
	leaq	sorted_list(%rip), %rsi
	movq	$0, %rax
	callq	check
	movq	-152(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_swap_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_swap_list(%rip), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	movq	$0, %rax
	callq	swap
	movq	-152(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_swap_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_swap_list(%rip), %rdi
	leaq	swapped_list(%rip), %rsi
	movq	$0, %rax
	callq	check
	movq	-152(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_partition_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_partition_list(%rip), %rdi
	movq	$0, %rsi
	movq	$4, %rdx
	movq	$0, %rax
	callq	partition
	movq	-152(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	movq	-96(%rbp), %rdi
	movq	$0, %rax
	callq	ll_ltoa
	movq	-152(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	movq	-104(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-152(%rbp), %rsp
	movq	%rax, -112(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_partition_list(%rip), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	printarr
	movq	-152(%rbp), %rsp
	movq	%rax, -120(%rbp)
	movq	%rsp, %r11
	movq	%r11, -152(%rbp)
	andq	$-16, %rsp
	leaq	pre_partition_list(%rip), %rdi
	leaq	partitioned_list(%rip), %rsi
	movq	$0, %rax
	callq	check
	movq	-152(%rbp), %rsp
	movq	%rax, -128(%rbp)
	movq	-48(%rbp), %rax
	movq	-80(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-128(%rbp), %rax
	movq	-136(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
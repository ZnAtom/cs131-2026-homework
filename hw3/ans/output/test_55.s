	.data
	.globl	gtest1
gtest1:
	.quad	8
	.quad	7
	.quad	2
	.quad	1
	.quad	0
	.quad	9
	.quad	3
	.quad	2
	.quad	1
	.data
	.globl	ans1
ans1:
	.quad	0
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.quad	3
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest2
gtest2:
	.quad	1
	.quad	5
	.quad	3
	.quad	8
	.quad	2
	.quad	6
	.quad	9
	.quad	4
	.quad	7
	.data
	.globl	ans2
ans2:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest3
gtest3:
	.quad	9
	.quad	3
	.quad	6
	.quad	1
	.quad	5
	.quad	2
	.quad	7
	.quad	8
	.quad	4
	.data
	.globl	ans3
ans3:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest4
gtest4:
	.quad	5
	.quad	2
	.quad	8
	.quad	9
	.quad	1
	.quad	4
	.quad	6
	.quad	3
	.quad	7
	.data
	.globl	ans4
ans4:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.text
	.globl	eq9
eq9:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$9, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	$0, %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	eq9.loop_entry
	.text
eq9.loop_entry:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	eq9.loop_body
	jmp	eq9.loop_exit_s
	.text
eq9.loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-88(%rbp), %rax
	movq	-104(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	eq9.loop_next
	jmp	eq9.loop_exit_f
	.text
eq9.loop_next:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	eq9.loop_entry
	.text
eq9.loop_exit_s:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
eq9.loop_exit_f:
	movq	$0, %rax
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
	.globl	partition
partition:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$240, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
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
	jmp	partition.loop_entry
	.text
partition.loop_entry:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	cmpq	$0, %rax
	jne	partition.loop_body
	jmp	partition.loop_exit
	.text
partition.loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-88(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setle	%al
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	cmpq	$0, %rax
	jne	partition.loop_swap
	jmp	partition.loop_next
	.text
partition.loop_swap:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	$1, %rax
	movq	-128(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-88(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -160(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-152(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -168(%rbp)
	movq	%rsp, %r11
	movq	%r11, -240(%rbp)
	andq	$-16, %rsp
	movq	-168(%rbp), %rdi
	movq	-160(%rbp), %rsi
	movq	$0, %rax
	callq	swap
	movq	-240(%rbp), %rsp
	movq	%rax, -176(%rbp)
	jmp	partition.loop_next
	.text
partition.loop_next:
	movq	-88(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	jmp	partition.loop_entry
	.text
partition.loop_exit:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -200(%rbp)
	movq	$1, %rax
	movq	-200(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -208(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-208(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -216(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-24(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -224(%rbp)
	movq	%rsp, %r11
	movq	%r11, -240(%rbp)
	andq	$-16, %rsp
	movq	-216(%rbp), %rdi
	movq	-224(%rbp), %rsi
	movq	$0, %rax
	callq	swap
	movq	-240(%rbp), %rsp
	movq	%rax, -232(%rbp)
	movq	-208(%rbp), %rax
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
	jne	quicksort.recursion
	jmp	quicksort.exit
	.text
quicksort.recursion:
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
	movq	-40(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -80(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-48(%rbp), %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-80(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -80(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-56(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-80(%rbp), %rsp
	movq	%rax, -72(%rbp)
	jmp	quicksort.exit
	.text
quicksort.exit:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest1(%rip), %rdi
	movq	$0, %rsi
	movq	$8, %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-112(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest1(%rip), %rdi
	leaq	ans1(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest2(%rip), %rdi
	movq	$0, %rsi
	movq	$8, %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-112(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest2(%rip), %rdi
	leaq	ans2(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest3(%rip), %rdi
	movq	$0, %rsi
	movq	$8, %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-112(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest3(%rip), %rdi
	leaq	ans3(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest4(%rip), %rdi
	movq	$0, %rsi
	movq	$8, %rdx
	movq	$0, %rax
	callq	quicksort
	movq	-112(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest4(%rip), %rdi
	leaq	ans4(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	-32(%rbp), %rax
	movq	-48(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-64(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	-80(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
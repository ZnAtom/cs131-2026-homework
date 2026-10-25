	.data
	.globl	weights1
weights1:
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.data
	.globl	values1
values1:
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.data
	.globl	capacity1
capacity1:
	.quad	5
	.data
	.globl	expected1
expected1:
	.quad	7
	.data
	.globl	weights2
weights2:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.data
	.globl	values2
values2:
	.quad	1
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.data
	.globl	capacity2
capacity2:
	.quad	8
	.data
	.globl	expected2
expected2:
	.quad	10
	.data
	.globl	weights3
weights3:
	.quad	5
	.quad	4
	.quad	3
	.quad	2
	.quad	1
	.data
	.globl	values3
values3:
	.quad	6
	.quad	5
	.quad	4
	.quad	3
	.quad	2
	.data
	.globl	capacity3
capacity3:
	.quad	10
	.data
	.globl	expected3
expected3:
	.quad	14
	.text
	.globl	knapsack
knapsack:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %r10
	orq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	knapsack.base_case_end
	jmp	knapsack.continue1
	.text
knapsack.base_case_end:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
knapsack.continue1:
	movq	-8(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	-32(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	knapsack.recursive_case1
	jmp	knapsack.continue2
	.text
knapsack.recursive_case1:
	movq	%rsp, %r11
	movq	%r11, -160(%rbp)
	andq	$-16, %rsp
	movq	-64(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-160(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
knapsack.continue2:
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-32(%rbp), %rax
	movq	-80(%rbp), %r10
	subq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	%rsp, %r11
	movq	%r11, -160(%rbp)
	andq	$-16, %rsp
	movq	-64(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-120(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-160(%rbp), %rsp
	movq	%rax, -128(%rbp)
	movq	-112(%rbp), %rax
	movq	-128(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	%rsp, %r11
	movq	%r11, -160(%rbp)
	andq	$-16, %rsp
	movq	-64(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-160(%rbp), %rsp
	movq	%rax, -144(%rbp)
	movq	-136(%rbp), %rax
	movq	-144(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	cmpq	$0, %rax
	jne	knapsack.include_item
	jmp	knapsack.dont_include_item
	.text
knapsack.include_item:
	movq	-136(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
knapsack.dont_include_item:
	movq	-144(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$184, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	weights1(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	leaq	values1(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	leaq	capacity1(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -184(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	-24(%rbp), %rsi
	movq	-32(%rbp), %rdx
	movq	-40(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-184(%rbp), %rsp
	movq	%rax, -48(%rbp)
	leaq	expected1(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	leaq	weights2(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	leaq	values2(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	leaq	capacity2(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -184(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	-72(%rbp), %rsi
	movq	-80(%rbp), %rdx
	movq	-88(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-184(%rbp), %rsp
	movq	%rax, -96(%rbp)
	leaq	expected2(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-96(%rbp), %rax
	movq	-104(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -112(%rbp)
	leaq	weights3(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	leaq	values3(%rip), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	leaq	capacity3(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	%rsp, %r11
	movq	%r11, -184(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	-120(%rbp), %rsi
	movq	-128(%rbp), %rdx
	movq	-136(%rbp), %rcx
	movq	$0, %rax
	callq	knapsack
	movq	-184(%rbp), %rsp
	movq	%rax, -144(%rbp)
	leaq	expected3(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-144(%rbp), %rax
	movq	-152(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -160(%rbp)
	movq	-64(%rbp), %rax
	movq	-112(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	-160(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
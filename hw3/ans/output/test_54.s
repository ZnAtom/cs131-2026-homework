	.data
	.globl	input_arr
input_arr:
	.quad	-13
	.quad	3
	.quad	5
	.quad	15
	.quad	17
	.quad	27
	.quad	28
	.quad	37
	.quad	45
	.quad	54
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	input_arr(%rip), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$45, %rsi
	movq	$0, %rdx
	movq	$9, %rcx
	movq	$0, %rax
	callq	binary_search
	movq	-40(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	binary_search
binary_search:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	cmpq	$0, %rax
	jne	binary_search.ret_base
	jmp	binary_search.loop
	.text
binary_search.loop:
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	$1, %rcx
	sarq	%cl, %rax
	movq	%rax, -56(%rbp)
	movq	-8(%rbp), %rax
	movq	-56(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	binary_search.ret_found
	jmp	binary_search.divide
	.text
binary_search.divide:
	movq	-16(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	binary_search.is_less
	jmp	binary_search.is_greater
	.text
binary_search.is_less:
	movq	-56(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movq	$0, %rax
	callq	binary_search
	movq	-128(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
binary_search.is_greater:
	movq	-56(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-112(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movq	$0, %rax
	callq	binary_search
	movq	-128(%rbp), %rsp
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
binary_search.ret_base:
	movq	$-1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
binary_search.ret_found:
	movq	-56(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
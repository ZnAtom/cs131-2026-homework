	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -48(%rbp)
	andq	$-16, %rsp
	leaq	foo(%rip), %rdi
	movq	$0, %rax
	callq	ll_callback
	movq	-48(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -48(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	ll_ltoa
	movq	-48(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -48(%rbp)
	andq	$-16, %rsp
	movq	-32(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-48(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
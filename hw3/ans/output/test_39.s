	.text
	.globl	factorial
factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	jne	factorial.ret1
	jmp	factorial.recurse
	.text
factorial.ret1:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
factorial.recurse:
	movq	-8(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -48(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	factorial
	movq	-48(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	-32(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -32(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	$0, %rax
	callq	factorial
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
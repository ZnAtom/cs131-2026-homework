	.data
	.globl	format
format:
	.asciz	"test alignment"
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	format(%rip), %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %rax
	movq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -48(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	printf
	movq	-48(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
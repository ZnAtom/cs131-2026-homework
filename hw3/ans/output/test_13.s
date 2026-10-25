	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$5, %rax
	movq	$12, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	jmp	main.next
	.text
main.next:
	jmp	main.end
	.text
main.end:
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
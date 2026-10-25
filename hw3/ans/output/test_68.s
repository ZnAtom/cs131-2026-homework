	.data
	.globl	coeff_arr
coeff_arr:
	.quad	2
	.quad	-6
	.quad	2
	.quad	-1
	.text
	.globl	horner
horner:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	$0, %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	horner.loop_bound
	.text
horner.loop_bound:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	horner.calc
	jmp	horner.horner_done
	.text
horner.calc:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	movq	-80(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-24(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-96(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-80(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	horner.loop_bound
	.text
horner.horner_done:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
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
	leaq	coeff_arr(%rip), %rdi
	movq	$4, %rsi
	movq	$3, %rdx
	movq	$0, %rax
	callq	horner
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
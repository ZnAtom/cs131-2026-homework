	.text
	.globl	factorial
factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	$1, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	factorial.start
	.text
factorial.start:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	factorial.then
	jmp	factorial.end
	.text
factorial.then:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	factorial.start
	.text
factorial.end:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	factorial2
factorial2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	$1, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	factorial2.start
	.text
factorial2.start:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	jne	factorial2.then
	jmp	factorial2.end
	.text
factorial2.then:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	imulq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	jmp	factorial2.start
	.text
factorial2.end:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -64(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	$0, %rax
	callq	factorial
	movq	-64(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -64(%rbp)
	andq	$-16, %rsp
	movq	$5, %rdi
	movq	$0, %rax
	callq	factorial2
	movq	-64(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
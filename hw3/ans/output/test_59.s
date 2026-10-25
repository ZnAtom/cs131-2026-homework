	.data
	.globl	fib_arr
fib_arr:
	.quad	1
	.quad	0
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
	movq	$1, %rsi
	movq	$0, %rax
	callq	rec_fibonacci
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	rec_fibonacci
rec_fibonacci:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	jne	rec_fibonacci.end
	jmp	rec_fibonacci.recurse
	.text
rec_fibonacci.recurse:
	leaq	fib_arr(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	leaq	fib_arr(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	$1, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-88(%rbp), %rsi
	movq	$0, %rax
	callq	rec_fibonacci
	movq	-120(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
rec_fibonacci.end:
	leaq	fib_arr(%rip), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
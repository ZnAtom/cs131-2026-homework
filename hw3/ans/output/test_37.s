	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	$42, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	$0, %rax
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
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	$100, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setne	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	main.then
	jmp	main.else
	.text
main.then:
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	$0, %rax
	callq	foo
	movq	-112(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	main.end
	.text
main.else:
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	$0, %rax
	callq	bar
	movq	-112(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	main.end
	.text
main.end:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
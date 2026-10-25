	.text
	.globl	baz
baz:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	%r8 , -40(%rbp)
	movq	%r9 , -48(%rbp)
	movq	16(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-24(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	-32(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-40(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-56(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-64(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	%r8 , -40(%rbp)
	movq	%r9 , -48(%rbp)
	movq	16(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-24(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	-32(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-40(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -144(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	-80(%rbp), %rsi
	movq	-88(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movq	-40(%rbp), %r8 
	movq	-48(%rbp), %r9 
	movq	-64(%rbp), %r10
	pushq	%r10
	movq	-56(%rbp), %r10
	pushq	%r10
	movq	$0, %rax
	callq	baz
	movq	-144(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-96(%rbp), %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-56(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	-64(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	-104(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsp, %r11
	movq	%r11, -24(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-8(%rbp), %rsi
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rcx
	movq	-8(%rbp), %r8 
	movq	-8(%rbp), %r9 
	movq	-8(%rbp), %r10
	pushq	%r10
	movq	-8(%rbp), %r10
	pushq	%r10
	movq	$0, %rax
	callq	bar
	movq	-24(%rbp), %rsp
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
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
	movq	$1, %rdi
	movq	$0, %rax
	callq	foo
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
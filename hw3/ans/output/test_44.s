	.data
	.globl	toofew
toofew:
	.asciz	"argc < 3"
	.data
	.globl	toomany
toomany:
	.asciz	"argc > 3"
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	$3, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	jne	main.few
	jmp	main.else
	.text
main.few:
	leaq	toofew(%rip), %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-32(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-120(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.else:
	movq	-8(%rbp), %rax
	movq	$3, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	main.many
	jmp	main.right
	.text
main.many:
	leaq	toomany(%rip), %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-56(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-120(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.right:
	movq	-16(%rbp), %rax
	movq	$1, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-16(%rbp), %rax
	movq	$2, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-80(%rbp), %rdi
	movq	-96(%rbp), %rsi
	movq	$0, %rax
	callq	ll_strcat
	movq	-120(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	movq	-104(%rbp), %rdi
	movq	$0, %rax
	callq	ll_puts
	movq	-120(%rbp), %rsp
	movq	%rax, -112(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.data
	.globl	input_array1
input_array1:
	.quad	-2
	.quad	-3
	.quad	4
	.quad	-1
	.quad	-2
	.quad	1
	.quad	5
	.quad	-3
	.data
	.globl	size1
size1:
	.quad	8
	.data
	.globl	input_array2
input_array2:
	.quad	1
	.quad	2
	.quad	3
	.quad	-2
	.quad	5
	.data
	.globl	size2
size2:
	.quad	5
	.data
	.globl	input_array3
input_array3:
	.quad	-2
	.quad	1
	.quad	-3
	.quad	4
	.quad	-1
	.quad	2
	.quad	1
	.quad	-5
	.quad	4
	.data
	.globl	size3
size3:
	.quad	9
	.text
	.globl	max_of_two
max_of_two:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	jne	max_of_two.return_num1
	jmp	max_of_two.return_num2
	.text
max_of_two.return_num1:
	movq	-8(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
max_of_two.return_num2:
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	kadane
kadane:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$184, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	$-2147483648, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	$0, %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	jmp	kadane.loop
	.text
kadane.loop:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	kadane.body
	jmp	kadane.end
	.text
kadane.body:
	movq	-8(%rbp), %rax
	movq	-72(%rbp), %r10
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
	movq	-96(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	%rsp, %r11
	movq	%r11, -184(%rbp)
	andq	$-16, %rsp
	movq	-112(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rax
	callq	max_of_two
	movq	-184(%rbp), %rsp
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	%rsp, %r11
	movq	%r11, -184(%rbp)
	andq	$-16, %rsp
	movq	-120(%rbp), %rdi
	movq	-136(%rbp), %rsi
	movq	$0, %rax
	callq	max_of_two
	movq	-184(%rbp), %rsp
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-72(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	jmp	kadane.loop
	.text
kadane.end:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	input_array3(%rip), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	leaq	size3(%rip), %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	-40(%rbp), %rsi
	movq	$0, %rax
	callq	kadane
	movq	-56(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
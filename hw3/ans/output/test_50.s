	.data
	.globl	my_arr
my_arr:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
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
	leaq	my_arr(%rip), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	movq	$0, %rcx
	movq	$0, %rax
	callq	get_matrix_sum
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	get_matrix_sum
get_matrix_sum:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-24(%rbp), %rax
	movq	$6, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	cmpq	$0, %rax
	jne	get_matrix_sum.end
	jmp	get_matrix_sum.check
	.text
get_matrix_sum.check:
	movq	-32(%rbp), %rax
	movq	$6, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	get_matrix_sum.next_row
	jmp	get_matrix_sum.add_col
	.text
get_matrix_sum.next_row:
	movq	-24(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-56(%rbp), %rdx
	movq	$0, %rcx
	movq	$0, %rax
	callq	get_matrix_sum
	movq	-112(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_matrix_sum.add_col:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$288, %r10
	addq	%r10, %rax
	movq	-24(%rbp), %r10
	imulq	$48, %r10
	addq	%r10, %rax
	movq	-32(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-16(%rbp), %rax
	movq	-80(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-32(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-88(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movq	$0, %rax
	callq	get_matrix_sum
	movq	-112(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_matrix_sum.end:
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
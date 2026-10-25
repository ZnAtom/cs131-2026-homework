	.data
	.globl	n2
n2:
	.quad	0
	.quad	0
	.quad	2
	.data
	.globl	n3
n3:
	.quad	0
	.quad	0
	.quad	3
	.data
	.globl	root1
root1:
	.quad	n2
	.quad	n3
	.quad	1
	.data
	.globl	n2_2
n2_2:
	.quad	0
	.quad	0
	.quad	2
	.data
	.globl	n3_2
n3_2:
	.quad	0
	.quad	0
	.quad	3
	.data
	.globl	root2
root2:
	.quad	n2_2
	.quad	n3_2
	.quad	1
	.data
	.globl	n3_3
n3_3:
	.quad	0
	.quad	0
	.quad	3
	.data
	.globl	root3
root3:
	.quad	0
	.quad	n3_3
	.quad	1
	.text
	.globl	is_same_tree
is_same_tree:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$200, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	$1, %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	is_same_tree.ret_true
	jmp	is_same_tree.one_null
	.text
is_same_tree.one_null:
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %r10
	orq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	$1, %rax
	movq	-56(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	is_same_tree.ret_false
	jmp	is_same_tree.no_null
	.text
is_same_tree.no_null:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$16, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$16, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-80(%rbp), %rax
	movq	-96(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	is_same_tree.equal_val
	jmp	is_same_tree.ret_false
	.text
is_same_tree.equal_val:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -168(%rbp)
	movq	%rsp, %r11
	movq	%r11, -200(%rbp)
	andq	$-16, %rsp
	movq	-120(%rbp), %rdi
	movq	-152(%rbp), %rsi
	movq	$0, %rax
	callq	is_same_tree
	movq	-200(%rbp), %rsp
	movq	%rax, -176(%rbp)
	movq	%rsp, %r11
	movq	%r11, -200(%rbp)
	andq	$-16, %rsp
	movq	-136(%rbp), %rdi
	movq	-168(%rbp), %rsi
	movq	$0, %rax
	callq	is_same_tree
	movq	-200(%rbp), %rsp
	movq	%rax, -184(%rbp)
	movq	-176(%rbp), %rax
	movq	-184(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	cmpq	$0, %rax
	jne	is_same_tree.ret_true
	jmp	is_same_tree.ret_false
	.text
is_same_tree.ret_true:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
is_same_tree.ret_false:
	movq	$0, %rax
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
	leaq	root1(%rip), %rdi
	leaq	root2(%rip), %rsi
	movq	$0, %rax
	callq	is_same_tree
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
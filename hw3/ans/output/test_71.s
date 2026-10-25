	.data
	.globl	test1
test1:
	.quad	0
	.quad	0
	.quad	1
	.quad	100
	.data
	.globl	test2
test2:
	.quad	test1
	.quad	0
	.quad	2
	.quad	200
	.data
	.globl	test3
test3:
	.quad	0
	.quad	0
	.quad	4
	.quad	300
	.data
	.globl	test
test:
	.quad	test2
	.quad	test3
	.quad	3
	.quad	400
	.data
	.globl	testB
testB:
	.quad	0
	.quad	0
	.quad	1
	.quad	435
	.data
	.globl	testC
testC:
	.quad	0
	.quad	0
	.quad	3
	.quad	765
	.data
	.globl	testA
testA:
	.quad	testB
	.quad	testC
	.quad	2
	.quad	2356
	.data
	.globl	testE
testE:
	.quad	0
	.quad	0
	.quad	5
	.quad	65
	.data
	.globl	testF
testF:
	.quad	0
	.quad	0
	.quad	7
	.quad	42
	.data
	.globl	testD
testD:
	.quad	testE
	.quad	testF
	.quad	6
	.quad	658
	.data
	.globl	testNew
testNew:
	.quad	testA
	.quad	testD
	.quad	4
	.quad	5346
	.text
	.globl	find_value
find_value:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	jne	find_value.not_found
	jmp	find_value.found
	.text
find_value.not_found:
	movq	$-1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_value.found:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	addq	$16, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	find_value.return_value
	jmp	find_value.search_subtree
	.text
find_value.return_value:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	addq	$24, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_value.search_subtree:
	movq	-16(%rbp), %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	find_value.left_subtree
	jmp	find_value.right_subtree
	.text
find_value.left_subtree:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	movq	-88(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	$0, %rax
	callq	find_value
	movq	-128(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_value.right_subtree:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$32, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	movq	-112(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	$0, %rax
	callq	find_value
	movq	-128(%rbp), %rsp
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
	subq	$256, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	test(%rip), %rdi
	movq	$1, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	test(%rip), %rdi
	movq	$2, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	test(%rip), %rdi
	movq	$3, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	$100, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-32(%rbp), %rax
	movq	$200, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -56(%rbp)
	movq	-40(%rbp), %rax
	movq	$400, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$1, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$2, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$3, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$4, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -112(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$5, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -120(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$6, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -128(%rbp)
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	leaq	testNew(%rip), %rdi
	movq	$7, %rsi
	movq	$0, %rax
	callq	find_value
	movq	-256(%rbp), %rsp
	movq	%rax, -136(%rbp)
	movq	-88(%rbp), %rax
	movq	$435, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -144(%rbp)
	movq	-96(%rbp), %rax
	movq	$2356, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -152(%rbp)
	movq	-104(%rbp), %rax
	movq	$765, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -160(%rbp)
	movq	-112(%rbp), %rax
	movq	$5346, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -168(%rbp)
	movq	-120(%rbp), %rax
	movq	$65, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -176(%rbp)
	movq	-128(%rbp), %rax
	movq	$658, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -184(%rbp)
	movq	-136(%rbp), %rax
	movq	$42, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -192(%rbp)
	movq	-144(%rbp), %rax
	movq	-152(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -200(%rbp)
	movq	-160(%rbp), %rax
	movq	-168(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -208(%rbp)
	movq	-176(%rbp), %rax
	movq	-184(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -216(%rbp)
	movq	-192(%rbp), %rax
	movq	-200(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -224(%rbp)
	movq	-208(%rbp), %rax
	movq	-216(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -232(%rbp)
	movq	-224(%rbp), %rax
	movq	-232(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -240(%rbp)
	movq	-240(%rbp), %rax
	movq	-80(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	cmpq	$0, %rax
	jne	main.pass
	jmp	main.fail
	.text
main.pass:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.fail:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
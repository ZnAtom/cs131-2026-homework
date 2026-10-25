	.data
	.globl	node1
node1:
	.quad	0
	.quad	0
	.quad	100
	.data
	.globl	node2
node2:
	.quad	node1
	.quad	0
	.quad	10
	.data
	.globl	node3
node3:
	.quad	0
	.quad	0
	.quad	1
	.data
	.globl	test1
test1:
	.quad	node2
	.quad	node3
	.quad	5
	.data
	.globl	test2
test2:
	.quad	test1
	.quad	0
	.quad	1000
	.data
	.globl	test3
test3:
	.quad	test2
	.quad	0
	.quad	100
	.text
	.globl	find_max
find_max:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$256, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.return_default
	jmp	find_max.not_null
	.text
find_max.return_default:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_max.not_null:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$16, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	$0, %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -72(%rbp)
	movq	$0, %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	jmp	find_max.loop
	.text
find_max.loop:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$16, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-96(%rbp), %rax
	movq	-104(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.update_max
	jmp	find_max.check_left
	.text
find_max.update_max:
	movq	-96(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	find_max.check_left
	.text
find_max.check_left:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.check_right
	jmp	find_max.visit_left
	.text
find_max.visit_left:
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	movq	-136(%rbp), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-256(%rbp), %rsp
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	jmp	find_max.check_right
	.text
find_max.check_right:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$24, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.end_loop
	jmp	find_max.visit_right
	.text
find_max.visit_right:
	movq	%rsp, %r11
	movq	%r11, -256(%rbp)
	andq	$-16, %rsp
	movq	-176(%rbp), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-256(%rbp), %rsp
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	jmp	find_max.end_loop
	.text
find_max.end_loop:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -224(%rbp)
	movq	-216(%rbp), %rax
	movq	-224(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.left_greater
	jmp	find_max.right_greater
	.text
find_max.left_greater:
	movq	-208(%rbp), %rax
	movq	-216(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -240(%rbp)
	movq	-240(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.return_middle_max
	jmp	find_max.return_left_max
	.text
find_max.return_left_max:
	movq	-216(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_max.right_greater:
	movq	-208(%rbp), %rax
	movq	-224(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	cmpq	$0, %rax
	jne	find_max.return_middle_max
	jmp	find_max.return_right_max
	.text
find_max.return_right_max:
	movq	-224(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_max.return_middle_max:
	movq	-208(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	test1(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	$100, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test2
	jmp	main.FAIL
	.text
main.test2:
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	test2(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$1000, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test3
	jmp	main.FAIL
	.text
main.test3:
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	test3(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$1000, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	main.node1
	jmp	main.FAIL
	.text
main.node1:
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	node1(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	$100, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	main.node2
	jmp	main.FAIL
	.text
main.node2:
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	node2(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	$100, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	cmpq	$0, %rax
	jne	main.node3
	jmp	main.FAIL
	.text
main.node3:
	movq	%rsp, %r11
	movq	%r11, -120(%rbp)
	andq	$-16, %rsp
	leaq	node3(%rip), %rdi
	movq	$0, %rax
	callq	find_max
	movq	-120(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	$1, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	main.PASS
	jmp	main.FAIL
	.text
main.PASS:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.FAIL:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
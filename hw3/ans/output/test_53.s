	.data
	.globl	test1
test1:
	.quad	5
	.quad	1
	.quad	5
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	5
	.quad	5
	.quad	5
	.data
	.globl	test2
test2:
	.quad	2
	.quad	1
	.quad	2
	.quad	2
	.quad	2
	.quad	4
	.quad	2
	.quad	5
	.quad	5
	.quad	2
	.data
	.globl	test3
test3:
	.quad	3
	.quad	4
	.quad	3
	.data
	.globl	test4
test4:
	.quad	3
	.data
	.globl	test5
test5:
	.quad	-1
	.quad	-1
	.quad	3
	.quad	5
	.quad	-1
	.quad	-1
	.data
	.globl	test6
test6:
	.quad	2
	.quad	2
	.quad	1
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.text
	.globl	at
at:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$0, %r10
	addq	%r10, %rax
	movq	-16(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	majority
majority:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$264, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.base
	jmp	majority.label1
	.text
majority.label1:
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %rcx
	sarq	%cl, %rax
	movq	%rax, -48(%rbp)
	movq	$1, %rax
	movq	-48(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -264(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-48(%rbp), %rdx
	movq	$0, %rax
	callq	majority
	movq	-264(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -264(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-56(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	majority
	movq	-264(%rbp), %rsp
	movq	%rax, -72(%rbp)
	jmp	majority.recresults
	.text
majority.recresults:
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.retleft
	jmp	majority.label2
	.text
majority.label2:
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -88(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -96(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -104(%rbp)
	movq	$0, %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %r10
	movq	-104(%rbp), %rax
	movq	%r10, (%rax)
	jmp	majority.loopconditions
	.text
majority.loopconditions:
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.loopend
	jmp	majority.loopbody
	.text
majority.loopbody:
	movq	%rsp, %r11
	movq	%r11, -264(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-136(%rbp), %rsi
	movq	$0, %rax
	callq	at
	movq	-264(%rbp), %rsp
	movq	%rax, -152(%rbp)
	jmp	majority.left
	.text
majority.left:
	movq	-152(%rbp), %rax
	movq	-64(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.incrleft
	jmp	majority.right
	.text
majority.incrleft:
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -168(%rbp)
	movq	$1, %rax
	movq	-168(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	jmp	majority.right
	.text
majority.right:
	movq	-152(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.incrright
	jmp	majority.loopincr
	.text
majority.incrright:
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -200(%rbp)
	movq	$1, %rax
	movq	-200(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -208(%rbp)
	movq	-208(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	jmp	majority.loopincr
	.text
majority.loopincr:
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -224(%rbp)
	movq	$1, %rax
	movq	-224(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %r10
	movq	-104(%rbp), %rax
	movq	%r10, (%rax)
	jmp	majority.loopconditions
	.text
majority.loopend:
	movq	-168(%rbp), %rax
	movq	-200(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	cmpq	$0, %rax
	jne	majority.retleft
	jmp	majority.retright
	.text
majority.retleft:
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
majority.retright:
	movq	-72(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
majority.base:
	movq	%rsp, %r11
	movq	%r11, -264(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	$0, %rax
	callq	at
	movq	-264(%rbp), %rsp
	movq	%rax, -256(%rbp)
	movq	-256(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$168, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	test1(%rip), %rax
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rsi
	movq	$9, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	$5, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test2
	jmp	main.FAIL
	.text
main.test2:
	leaq	test2(%rip), %rax
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-48(%rbp), %rdi
	movq	$0, %rsi
	movq	$9, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$2, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test3
	jmp	main.FAIL
	.text
main.test3:
	leaq	test3(%rip), %rax
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-72(%rbp), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	$3, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test4
	jmp	main.FAIL
	.text
main.test4:
	leaq	test4(%rip), %rax
	movq	%rax, -96(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-96(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	$3, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test5
	jmp	main.FAIL
	.text
main.test5:
	leaq	test5(%rip), %rax
	movq	%rax, -120(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-120(%rbp), %rdi
	movq	$0, %rsi
	movq	$5, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	$-1, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test6
	jmp	main.FAIL
	.text
main.test6:
	leaq	test6(%rip), %rax
	movq	%rax, -144(%rbp)
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-144(%rbp), %rdi
	movq	$0, %rsi
	movq	$6, %rdx
	movq	$0, %rax
	callq	majority
	movq	-168(%rbp), %rsp
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	$2, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	cmpq	$0, %rax
	jne	main.NEXT
	jmp	main.FAIL
	.text
main.NEXT:
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
	.data
	.globl	gtest1
gtest1:
	.quad	8
	.quad	7
	.quad	2
	.quad	1
	.quad	0
	.quad	9
	.quad	3
	.quad	2
	.quad	1
	.data
	.globl	ans1
ans1:
	.quad	0
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.quad	3
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest2
gtest2:
	.quad	1
	.quad	5
	.quad	3
	.quad	8
	.quad	2
	.quad	6
	.quad	9
	.quad	4
	.quad	7
	.data
	.globl	ans2
ans2:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest3
gtest3:
	.quad	9
	.quad	3
	.quad	6
	.quad	1
	.quad	5
	.quad	2
	.quad	7
	.quad	8
	.quad	4
	.data
	.globl	ans3
ans3:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.data
	.globl	gtest4
gtest4:
	.quad	5
	.quad	2
	.quad	8
	.quad	9
	.quad	1
	.quad	4
	.quad	6
	.quad	3
	.quad	7
	.data
	.globl	ans4
ans4:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.text
	.globl	eq9
eq9:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$9, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	$0, %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	eq9.loop_entry
	.text
eq9.loop_entry:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-40(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	jne	eq9.loop_body
	jmp	eq9.loop_exit_s
	.text
eq9.loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-88(%rbp), %rax
	movq	-104(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	cmpq	$0, %rax
	jne	eq9.loop_next
	jmp	eq9.loop_exit_f
	.text
eq9.loop_next:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	eq9.loop_entry
	.text
eq9.loop_exit_s:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
eq9.loop_exit_f:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	swap
swap:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %r10
	movq	-8(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %r10
	movq	-16(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	heapify
heapify:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$336, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	movq	-24(%rbp), %rax
	movq	$2, %r10
	imulq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -80(%rbp)
	movq	-24(%rbp), %rax
	movq	$2, %r10
	imulq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	$2, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -120(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-112(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-136(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-144(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-152(%rbp), %rax
	movq	-160(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -168(%rbp)
	movq	-120(%rbp), %rax
	movq	-168(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	cmpq	$0, %rax
	jne	heapify.l_update
	jmp	heapify.r_cmp
	.text
heapify.l_update:
	movq	-112(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	heapify.r_cmp
	.text
heapify.r_cmp:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -200(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-192(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -208(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-216(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -224(%rbp)
	movq	-208(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -232(%rbp)
	movq	-224(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -240(%rbp)
	movq	-232(%rbp), %rax
	movq	-240(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -248(%rbp)
	movq	-200(%rbp), %rax
	movq	-248(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -256(%rbp)
	movq	-256(%rbp), %rax
	cmpq	$0, %rax
	jne	heapify.r_update
	jmp	heapify.check_for_swap
	.text
heapify.r_update:
	movq	-192(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	heapify.check_for_swap
	.text
heapify.check_for_swap:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -272(%rbp)
	movq	-272(%rbp), %rax
	movq	-24(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setne	%al
	movq	%rax, -280(%rbp)
	movq	-280(%rbp), %rax
	cmpq	$0, %rax
	jne	heapify.do_swap
	jmp	heapify.exit
	.text
heapify.do_swap:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-24(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -288(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -296(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-296(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -304(%rbp)
	movq	-288(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -312(%rbp)
	movq	%rsp, %r11
	movq	%r11, -336(%rbp)
	andq	$-16, %rsp
	movq	-288(%rbp), %rdi
	movq	-304(%rbp), %rsi
	movq	$0, %rax
	callq	swap
	movq	-336(%rbp), %rsp
	movq	%rax, -320(%rbp)
	movq	%rsp, %r11
	movq	%r11, -336(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-296(%rbp), %rdx
	movq	$0, %rax
	callq	heapify
	movq	-336(%rbp), %rsp
	movq	%rax, -328(%rbp)
	jmp	heapify.exit
	.text
heapify.exit:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	heapsort
heapsort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$240, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -72(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -80(%rbp)
	movq	-72(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -96(%rbp)
	movq	$0, %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	jmp	heapsort.fst_loop_entry
	.text
heapsort.fst_loop_entry:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-112(%rbp), %rax
	movq	-120(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	cmpq	$0, %rax
	jne	heapsort.loop_body
	jmp	heapsort.snd_loop_entry
	.text
heapsort.loop_body:
	movq	%rsp, %r11
	movq	%r11, -240(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-112(%rbp), %rdx
	movq	$0, %rax
	callq	heapify
	movq	-240(%rbp), %rsp
	movq	%rax, -136(%rbp)
	movq	-112(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	jmp	heapsort.fst_loop_entry
	.text
heapsort.snd_loop_entry:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -168(%rbp)
	movq	-160(%rbp), %rax
	movq	-168(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	cmpq	$0, %rax
	jne	heapsort.snd_loop_body
	jmp	heapsort.snd_loop_exit
	.text
heapsort.snd_loop_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	$0, %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -184(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$72, %r10
	addq	%r10, %rax
	movq	-160(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -192(%rbp)
	movq	%rsp, %r11
	movq	%r11, -240(%rbp)
	andq	$-16, %rsp
	movq	-184(%rbp), %rdi
	movq	-192(%rbp), %rsi
	movq	$0, %rax
	callq	swap
	movq	-240(%rbp), %rsp
	movq	%rax, -200(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	%rsp, %r11
	movq	%r11, -240(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-160(%rbp), %rsi
	movq	-208(%rbp), %rdx
	movq	$0, %rax
	callq	heapify
	movq	-240(%rbp), %rsp
	movq	%rax, -216(%rbp)
	movq	-160(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -224(%rbp)
	movq	-224(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	jmp	heapsort.snd_loop_entry
	.text
heapsort.snd_loop_exit:
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
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest1(%rip), %rdi
	movq	$9, %rsi
	movq	$0, %rax
	callq	heapsort
	movq	-112(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest1(%rip), %rdi
	leaq	ans1(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest2(%rip), %rdi
	movq	$9, %rsi
	movq	$0, %rax
	callq	heapsort
	movq	-112(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest2(%rip), %rdi
	leaq	ans2(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest3(%rip), %rdi
	movq	$9, %rsi
	movq	$0, %rax
	callq	heapsort
	movq	-112(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest3(%rip), %rdi
	leaq	ans3(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest4(%rip), %rdi
	movq	$9, %rsi
	movq	$0, %rax
	callq	heapsort
	movq	-112(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -112(%rbp)
	andq	$-16, %rsp
	leaq	gtest4(%rip), %rdi
	leaq	ans4(%rip), %rsi
	movq	$0, %rax
	callq	eq9
	movq	-112(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	-32(%rbp), %rax
	movq	-48(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-64(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-80(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
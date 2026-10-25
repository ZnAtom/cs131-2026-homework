	.data
	.globl	array
array:
	.quad	23
	.quad	10
	.quad	20
	.quad	11
	.quad	12
	.quad	6
	.quad	7
	.data
	.globl	sorted_array
sorted_array:
	.quad	6
	.quad	7
	.quad	10
	.quad	11
	.quad	12
	.quad	20
	.quad	23
	.text
	.globl	flip
flip:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$216, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-16(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	flip.setup_flip
	.text
flip.setup_flip:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	flip.flip_op
	jmp	flip.end_flip
	.text
flip.flip_op:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	movq	-88(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	movq	-120(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %r10
	movq	-128(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %r10
	movq	-32(%rbp), %rax
	movq	%r10, (%rax)
	jmp	flip.setup_flip
	.text
flip.end_flip:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	findMax
findMax:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$176, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	findMax.setup_cmp
	.text
findMax.setup_cmp:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	-16(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	cmpq	$0, %rax
	jne	findMax.compare
	jmp	findMax.end
	.text
findMax.compare:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	movq	-72(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	-96(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	findMax.end
	jmp	findMax.update_max
	.text
findMax.update_max:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	findMax.setup_cmp
	.text
findMax.end:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	pancakeSort
pancakeSort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	pancakeSort.start_pancake
	.text
pancakeSort.start_pancake:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$1, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	pancakeSort.pancake_op
	jmp	pancakeSort.end_pancake
	.text
pancakeSort.pancake_op:
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	leaq	array(%rip), %rdi
	movq	-16(%rbp), %rsi
	movq	$0, %rax
	callq	findMax
	movq	-128(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-56(%rbp), %rax
	movq	-72(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setne	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	jne	pancakeSort.flip
	jmp	pancakeSort.end_flip
	.text
pancakeSort.flip:
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	leaq	array(%rip), %rdi
	movq	-56(%rbp), %rsi
	movq	$0, %rax
	callq	flip
	movq	-128(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -128(%rbp)
	andq	$-16, %rsp
	leaq	array(%rip), %rdi
	movq	-72(%rbp), %rsi
	movq	$0, %rax
	callq	flip
	movq	-128(%rbp), %rsp
	movq	%rax, -96(%rbp)
	jmp	pancakeSort.end_flip
	.text
pancakeSort.end_flip:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-104(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	pancakeSort.start_pancake
	.text
pancakeSort.end_pancake:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	isEqual
isEqual:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$136, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	isEqual.iterate
	.text
isEqual.iterate:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$7, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	isEqual.check
	jmp	isEqual.equal
	.text
isEqual.check:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	movq	-56(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$56, %r10
	addq	%r10, %rax
	movq	-80(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-72(%rbp), %rax
	movq	-96(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	isEqual.move_pointer
	jmp	isEqual.not_equal
	.text
isEqual.move_pointer:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	isEqual.iterate
	.text
isEqual.equal:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
isEqual.not_equal:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
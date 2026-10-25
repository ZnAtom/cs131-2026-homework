	.data
	.globl	nonPowerOfTwoElem
nonPowerOfTwoElem:
	.quad	9
	.quad	0
	.data
	.globl	powerOfTwoElem
powerOfTwoElem:
	.quad	64
	.quad	nonPowerOfTwoElem
	.data
	.globl	head
head:
	.quad	31
	.quad	powerOfTwoElem
	.text
	.globl	numOneBits
numOneBits:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	jne	numOneBits.retZero
	jmp	numOneBits.rec
	.text
numOneBits.retZero:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
numOneBits.rec:
	movq	-8(%rbp), %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	numOneBits
	movq	-56(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	$1, %r10
	andq	%r10, %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	isPowerOfTwo
isPowerOfTwo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setle	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	jne	isPowerOfTwo.retFalse
	jmp	isPowerOfTwo.continue
	.text
isPowerOfTwo.retFalse:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
isPowerOfTwo.continue:
	movq	%rsp, %r11
	movq	%r11, -40(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	$0, %rax
	callq	numOneBits
	movq	-40(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	$1, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	isPowerOfTwo.retTrue
	jmp	isPowerOfTwo.retFalse
	.text
isPowerOfTwo.retTrue:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	findFirstPowerOfTwo
findFirstPowerOfTwo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$72, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	jne	findFirstPowerOfTwo.retFalse
	jmp	findFirstPowerOfTwo.continue
	.text
findFirstPowerOfTwo.retFalse:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
findFirstPowerOfTwo.continue:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -72(%rbp)
	andq	$-16, %rsp
	movq	-32(%rbp), %rdi
	movq	$0, %rax
	callq	isPowerOfTwo
	movq	-72(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	cmpq	$0, %rax
	jne	findFirstPowerOfTwo.retTrue
	jmp	findFirstPowerOfTwo.rec
	.text
findFirstPowerOfTwo.retTrue:
	movq	-32(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
findFirstPowerOfTwo.rec:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -72(%rbp)
	andq	$-16, %rsp
	movq	-56(%rbp), %rdi
	movq	$0, %rax
	callq	findFirstPowerOfTwo
	movq	-72(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
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
	leaq	head(%rip), %rdi
	movq	$0, %rax
	callq	findFirstPowerOfTwo
	movq	-32(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
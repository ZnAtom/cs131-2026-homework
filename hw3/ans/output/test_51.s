	.data
	.globl	my_arr1
my_arr1:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	4
	.quad	3
	.quad	2
	.data
	.globl	my_arr2
my_arr2:
	.quad	1
	.quad	10
	.quad	9
	.quad	7
	.quad	6
	.quad	5
	.quad	4
	.quad	2
	.text
	.globl	local_max
local_max:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$168, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	-16(%rbp), %r10
	subq	%r10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	$2, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	cmpq	$0, %rax
	jne	local_max.base_case
	jmp	local_max.general_case
	.text
local_max.base_case:
	movq	-16(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
local_max.general_case:
	movq	-24(%rbp), %rax
	movq	-16(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$1, %rcx
	sarq	%cl, %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-64(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-64(%rbp), %rax
	movq	$1, %r10
	subq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-88(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-88(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$64, %r10
	addq	%r10, %rax
	movq	-112(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	-104(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	local_max.rec_call_left
	jmp	local_max.check2
	.text
local_max.check2:
	movq	-128(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	cmpq	$0, %rax
	jne	local_max.rec_call_right
	jmp	local_max.is_max
	.text
local_max.is_max:
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
local_max.rec_call_left:
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-64(%rbp), %rdx
	movq	$0, %rax
	callq	local_max
	movq	-168(%rbp), %rsp
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
local_max.rec_call_right:
	movq	%rsp, %r11
	movq	%r11, -168(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-64(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	$0, %rax
	callq	local_max
	movq	-168(%rbp), %rsp
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
local_max.test:
	movq	$200, %rax
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
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	leaq	my_arr1(%rip), %rdi
	movq	$0, %rsi
	movq	$7, %rdx
	movq	$0, %rax
	callq	local_max
	movq	-56(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	$4, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	main.test2
	jmp	main.fail
	.text
main.test2:
	movq	%rsp, %r11
	movq	%r11, -56(%rbp)
	andq	$-16, %rsp
	leaq	my_arr2(%rip), %rdi
	movq	$0, %rsi
	movq	$7, %rdx
	movq	$0, %rax
	callq	local_max
	movq	-56(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	$2, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -48(%rbp)
	movq	-32(%rbp), %rax
	cmpq	$0, %rax
	jne	main.pass
	jmp	main.fail
	.text
main.fail:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.pass:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
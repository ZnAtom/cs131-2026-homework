	.data
	.globl	first_arr
first_arr:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	second_arr
second_arr:
	.quad	2
	.quad	4
	.quad	5
	.quad	8
	.quad	9
	.data
	.globl	expected_arr
expected_arr:
	.quad	1
	.quad	2
	.quad	2
	.quad	3
	.quad	4
	.quad	4
	.quad	5
	.quad	5
	.quad	8
	.quad	9
	.data
	.globl	first_arr2
first_arr2:
	.quad	1
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	second_arr2
second_arr2:
	.quad	4
	.quad	4
	.quad	5
	.quad	5
	.quad	10
	.data
	.globl	expected_arr2
expected_arr2:
	.quad	1
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.quad	4
	.quad	4
	.quad	5
	.quad	5
	.quad	10
	.data
	.globl	first_arr3
first_arr3:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	second_arr3
second_arr3:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	expected_arr3
expected_arr3:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.data
	.globl	first_arr4
first_arr4:
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	second_arr4
second_arr4:
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.data
	.globl	expected_arr4
expected_arr4:
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.quad	3
	.data
	.globl	first_arr5
first_arr5:
	.quad	7
	.quad	8
	.quad	9
	.quad	9
	.quad	10
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.data
	.globl	second_arr5
second_arr5:
	.quad	10
	.quad	11
	.quad	13
	.quad	13
	.quad	15
	.data
	.globl	expected_arr5
expected_arr5:
	.quad	7
	.quad	8
	.quad	9
	.quad	9
	.quad	10
	.quad	10
	.quad	11
	.quad	13
	.quad	13
	.quad	15
	.text
	.globl	is_equal
is_equal:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movq	$0, %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	is_equal.for_condition
	.text
is_equal.for_condition:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$10, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	is_equal.for_body
	jmp	is_equal.success
	.text
is_equal.for_body:
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-40(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-72(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	is_equal.continue
	jmp	is_equal.fail
	.text
is_equal.continue:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	$1, %r10
	addq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%r10, (%rax)
	jmp	is_equal.for_condition
	.text
is_equal.fail:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
is_equal.success:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	merge_sorted
merge_sorted:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$368, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -64(%rbp)
	movq	-32(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -72(%rbp)
	movq	-16(%rbp), %rax
	movq	-32(%rbp), %r10
	addq	%r10, %rax
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -88(%rbp)
	movq	-64(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	movq	-72(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	movq	-88(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	jmp	merge_sorted.while
	.text
merge_sorted.while:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	cmpq	$0, %rax
	jne	merge_sorted.check_i_greater_or_equal_0
	jmp	merge_sorted.done
	.text
merge_sorted.check_i_greater_or_equal_0:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setge	%al
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	cmpq	$0, %rax
	jne	merge_sorted.num_comparison
	jmp	merge_sorted.nums2_greater
	.text
merge_sorted.num_comparison:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-152(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -168(%rbp)
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-160(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -176(%rbp)
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movq	-176(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-184(%rbp), %rax
	movq	-192(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	setg	%al
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	cmpq	$0, %rax
	jne	merge_sorted.nums1_greater
	jmp	merge_sorted.nums2_greater
	.text
merge_sorted.nums1_greater:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-208(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -224(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-216(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -240(%rbp)
	movq	-240(%rbp), %r10
	movq	-224(%rbp), %rax
	movq	%r10, (%rax)
	movq	-208(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -256(%rbp)
	movq	-216(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -264(%rbp)
	movq	-256(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	movq	-264(%rbp), %r10
	movq	-40(%rbp), %rax
	movq	%r10, (%rax)
	jmp	merge_sorted.while
	.text
merge_sorted.nums2_greater:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -296(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$80, %r10
	addq	%r10, %rax
	movq	-288(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -304(%rbp)
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$40, %r10
	addq	%r10, %rax
	movq	-296(%rbp), %r10
	imulq	$8, %r10
	addq	%r10, %rax
	movq	%rax, -312(%rbp)
	movq	-312(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -320(%rbp)
	movq	-320(%rbp), %r10
	movq	-304(%rbp), %rax
	movq	%r10, (%rax)
	movq	-288(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -336(%rbp)
	movq	-296(%rbp), %rax
	movq	$-1, %r10
	addq	%r10, %rax
	movq	%rax, -344(%rbp)
	movq	-336(%rbp), %r10
	movq	-56(%rbp), %rax
	movq	%r10, (%rax)
	movq	-344(%rbp), %r10
	movq	-48(%rbp), %rax
	movq	%r10, (%rax)
	jmp	merge_sorted.while
	.text
merge_sorted.done:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$136, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr(%rip), %rdi
	movq	$5, %rsi
	leaq	second_arr(%rip), %rdx
	movq	$5, %rcx
	movq	$0, %rax
	callq	merge_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -24(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr(%rip), %rdi
	leaq	expected_arr(%rip), %rsi
	movq	$0, %rax
	callq	is_equal
	movq	-136(%rbp), %rsp
	movq	%rax, -32(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr2(%rip), %rdi
	movq	$5, %rsi
	leaq	second_arr2(%rip), %rdx
	movq	$5, %rcx
	movq	$0, %rax
	callq	merge_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -40(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr2(%rip), %rdi
	leaq	expected_arr2(%rip), %rsi
	movq	$0, %rax
	callq	is_equal
	movq	-136(%rbp), %rsp
	movq	%rax, -48(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr3(%rip), %rdi
	movq	$5, %rsi
	leaq	second_arr3(%rip), %rdx
	movq	$5, %rcx
	movq	$0, %rax
	callq	merge_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -56(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr3(%rip), %rdi
	leaq	expected_arr3(%rip), %rsi
	movq	$0, %rax
	callq	is_equal
	movq	-136(%rbp), %rsp
	movq	%rax, -64(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr4(%rip), %rdi
	movq	$5, %rsi
	leaq	second_arr4(%rip), %rdx
	movq	$5, %rcx
	movq	$0, %rax
	callq	merge_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -72(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr4(%rip), %rdi
	leaq	expected_arr4(%rip), %rsi
	movq	$0, %rax
	callq	is_equal
	movq	-136(%rbp), %rsp
	movq	%rax, -80(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr5(%rip), %rdi
	movq	$5, %rsi
	leaq	second_arr5(%rip), %rdx
	movq	$5, %rcx
	movq	$0, %rax
	callq	merge_sorted
	movq	-136(%rbp), %rsp
	movq	%rax, -88(%rbp)
	movq	%rsp, %r11
	movq	%r11, -136(%rbp)
	andq	$-16, %rsp
	leaq	first_arr5(%rip), %rdi
	leaq	expected_arr5(%rip), %rsi
	movq	$0, %rax
	callq	is_equal
	movq	-136(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rax
	movq	-48(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-64(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-80(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	-96(%rbp), %r10
	andq	%r10, %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
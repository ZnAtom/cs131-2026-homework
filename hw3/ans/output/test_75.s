	.text
	.globl	find_cycle_rec_helper
find_cycle_rec_helper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$104, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	jne	find_cycle_rec_helper.no_cycle_found
	jmp	find_cycle_rec_helper.incr_fast
	.text
find_cycle_rec_helper.incr_fast:
	movq	-16(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$0, %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$0, %rax
	jne	find_cycle_rec_helper.no_cycle_found
	jmp	find_cycle_rec_helper.find_nexts
	.text
find_cycle_rec_helper.find_nexts:
	movq	-40(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-64(%rbp), %rax
	movq	-80(%rbp), %r10
	cmpq	%r10, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	jne	find_cycle_rec_helper.cycle_found
	jmp	find_cycle_rec_helper.recursive_call
	.text
find_cycle_rec_helper.recursive_call:
	movq	%rsp, %r11
	movq	%r11, -104(%rbp)
	andq	$-16, %rsp
	movq	-80(%rbp), %rdi
	movq	-64(%rbp), %rsi
	movq	$0, %rax
	callq	find_cycle_rec_helper
	movq	-104(%rbp), %rsp
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_cycle_rec_helper.cycle_found:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
find_cycle_rec_helper.no_cycle_found:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	find_cycle
find_cycle:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsp, %r11
	movq	%r11, -24(%rbp)
	andq	$-16, %rsp
	movq	-8(%rbp), %rdi
	movq	-8(%rbp), %rsi
	movq	$0, %rax
	callq	find_cycle_rec_helper
	movq	-24(%rbp), %rsp
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$392, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	subq	$16, %rsp
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	subq	$16, %rsp
	movq	%rsp, %rax
	movq	%rax, -32(%rbp)
	subq	$16, %rsp
	movq	%rsp, %rax
	movq	%rax, -40(%rbp)
	subq	$16, %rsp
	movq	%rsp, %rax
	movq	%rax, -48(%rbp)
	subq	$16, %rsp
	movq	%rsp, %rax
	movq	%rax, -56(%rbp)
	movq	-24(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -64(%rbp)
	movq	-32(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -72(%rbp)
	movq	-40(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -80(%rbp)
	movq	-48(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -88(%rbp)
	movq	-56(%rbp), %rax
	movq	$0, %r10
	imulq	$16, %r10
	addq	%r10, %rax
	addq	$8, %rax
	movq	%rax, -96(%rbp)
	jmp	main.empty_list
	.text
main.empty_list:
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	$0, %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	cmpq	$0, %rax
	jne	main.failure
	jmp	main.singleton
	.text
main.singleton:
	movq	$0, %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	cmpq	$0, %rax
	jne	main.failure
	jmp	main.self_loop
	.text
main.self_loop:
	movq	-24(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	cmpq	$0, %rax
	jne	main.long_no_cycle_odd
	jmp	main.failure
	.text
main.long_no_cycle_odd:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	cmpq	$0, %rax
	jne	main.failure
	jmp	main.two_cycle
	.text
main.two_cycle:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -208(%rbp)
	movq	-208(%rbp), %rax
	cmpq	$0, %rax
	jne	main.long_no_cycle_even
	jmp	main.failure
	.text
main.long_no_cycle_even:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	$0, %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	cmpq	$0, %rax
	jne	main.failure
	jmp	main.long_even_cycle
	.text
main.long_even_cycle:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -288(%rbp)
	movq	-288(%rbp), %rax
	cmpq	$0, %rax
	jne	main.long_odd_cycle
	jmp	main.failure
	.text
main.long_odd_cycle:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	-24(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -336(%rbp)
	movq	-336(%rbp), %rax
	cmpq	$0, %rax
	jne	main.cycle_in_middle
	jmp	main.failure
	.text
main.cycle_in_middle:
	movq	-32(%rbp), %r10
	movq	-64(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-72(%rbp), %rax
	movq	%r10, (%rax)
	movq	-48(%rbp), %r10
	movq	-80(%rbp), %rax
	movq	%r10, (%rax)
	movq	-56(%rbp), %r10
	movq	-88(%rbp), %rax
	movq	%r10, (%rax)
	movq	-40(%rbp), %r10
	movq	-96(%rbp), %rax
	movq	%r10, (%rax)
	movq	%rsp, %r11
	movq	%r11, -392(%rbp)
	andq	$-16, %rsp
	movq	-24(%rbp), %rdi
	movq	$0, %rax
	callq	find_cycle
	movq	-392(%rbp), %rsp
	movq	%rax, -384(%rbp)
	movq	-384(%rbp), %rax
	cmpq	$0, %rax
	jne	main.success
	jmp	main.failure
	.text
main.success:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.failure:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
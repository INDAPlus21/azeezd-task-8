# This template is mainly extracted from:
# INDAPlus21/AssignmentInstructions/assembly-task-8/sieve/template.asm
.data
primes: 	.space 1000
err_msg: 	.asciiz "Invalid Input! Expected integer n, where 1 < n < 1001.\n"
	
.text
main:
	# Read input integer
	li $v0, 5
	syscall
	
	## Validate input
	# Check upper bound: >=1000 (If less than 1001 => OK)
	slti $t0, $v0, 1001
	beq $t0, $zero, invalid_input
	nop
	# Check lower bound: <=1 (If less than 1 => NOT OK)
	slti $t0, $v0, 1 
	bne $t0, $zero, invalid_input
	nop
	
	# Initialise Prime Array
	la $t0, primes
	li $t1, 999
	li $t2, 0
	li $t3, 1
	init_loop:
		# Loop through prime space and set it all to 1
		sb $t3 ($t0)
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		bne $t2, $t1, init_loop
		nop

	move $t0, $v0 	# size: t0 = size
	li $t2, 2		# p: t2 = 2

	sieve_loop:
		mul $t3, $t2, $t2 	# t3 = p * p
		sle $t4, $t3, $t0 	# t4 = t3 <= t0 ?
		beq $t4, 0, sieve_loop_end 
		nop
		
		la $t1, primes		# t1 = ptr to primes
		add $t1, $t1, $t2 	# ptr to primes += p
		lb $t5, ($t1)		# t5 = deref primes
		bne $t5, 1, elimination_end
		nop

		move $t6, $t3 # t6: i = p * p
		elimination:
			sle $t5, $t6, $t0 # t5: i <= size?
			beq $t5, 0, elimination_end
			nop

			la $t1, primes 		# t1 = ptr to primes
			add $t1, $t1, $t6	# t1 += i
			sb $zero, ($t1)		# primes = 0

			add $t6, $t6, $t2	# i += p
			j elimination
			nop
		elimination_end:
		add $t2, $t2, 1 		# p += 1
		j sieve_loop
		nop
	sieve_loop_end:

	li $t2, 2 # p = 2
	print_loop:
		sle $t3, $t2, $t0 	# t3 = p <= size?
		beq $t3, 0, print_loop_end
		nop

		la $t1, primes 		# $t1 = ptr to primes
		add $t1, $t1, $t2	# ptr to primes += p
		lb $t1, ($t1)		# t1 = deref primes		

		beq $t1, $zero, print_loop_no_prime # t1 == 0?
		nop

		li $v0, 1			# print int syscall
		move $a0, $t2		# arg = p
		syscall

		li $v0, 11			# print char syscall
		li $a0, '\n'		# arg = newline
		syscall

		print_loop_no_prime:
		add $t2, $t2, 1		# p += 1
		j print_loop
		nop
	print_loop_end:
	j terminate
	nop
	

invalid_input:
	li $v0, 4
	la $a0, err_msg
	syscall
	
terminate:
	li $v0, 10
	syscall

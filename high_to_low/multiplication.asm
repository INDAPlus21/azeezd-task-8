# The PUSH and POP macros are taken from
# INDAPlus21/assembly-task-8/examples/hello-world/hello-world-function.asm
# Used to push and pop values into the stack
.macro PUSH(%reg)
	addi $sp, $sp, -4
	sw	 %reg,0($sp)	
.end_macro

.macro POP(%reg)
	lw   %reg, 0($sp)
	addi $sp, $sp, 4
.end_macro

# Define multiply and factorial as global routines
.globl multiply
.globl factorial

.data
input_msg: .asciiz "\nType a number to calculate its factorial (-1 to exit): "

.text
	## Main is an infinite loop until user types -1. (No error checking)
	main:
		## Print input message
		li $v0, 4
		la $a0, input_msg
		syscall
		
		# Read input integer
		li $v0, 5
		syscall
		beq $v0, -1, end # if (input == -1) jump to program termination
		
		# calculate factorial(input)
		move $a0, $v0
		jal factorial
		
		# print calculated value
		move $a0, $v0
		li $v0, 1
		syscall
		
		j main # Jump back to main
		
		# END OF PROGRAM
		end:
		li $v0, 10
		syscall
	
	# FUNCTION: MULTIPLY 
	# REGISTERS: a0, a1
	# RETURNS: v0 = a0 * a1
	multiply:
		li $v0, 0 # Return value (sum)
		li $t0, 0 # Let i = 0
		mul_loop:
			beq $t0, $a0, mul_end # If (i == a0) stop
			add $t0, $t0, 1 # i++
			add $v0, $v0, $a1 # sum = sum + a1 
			j mul_loop # loop again
			nop
		mul_end:
			jr $ra # Return to caller
			nop
			
	
	# FUNCION: FACTORIAL
	# REGISTERS: a0
	# RETURNS v0 = a0 factorial
	factorial:
		# SAVING CALLER'S ADDRESS: Assuming functions (multiply) called here do not guarantee save-safety
		PUSH($ra)
		# Let n: s0 = a0
		move $s0, $a0
		# Let fac: s1 = 1
		li $s1, 1
		 
		fac_loop: # Start of loop
			# If n == 0 stop
			beq $s0, $zero, fac_end
			
			# Multiply(fac, n)
			move $a0, $s0
			move $a1, $s1
			jal multiply
			nop
			
			# fac = result of multiplication
			move $s1, $v0
		
			# decrement n
			add $s0, $s0, -1
		
			# loop back
			j fac_loop
		fac_end:
			move $v0, $s1
			POP($ra)
			jr $ra
			

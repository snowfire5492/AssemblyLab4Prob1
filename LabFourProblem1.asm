########################################################################
# Student: Eric Schenck						Date: 11/24/17
# Description: LabFourProblem1.asm - write nested function calls and a main program that calls the Func function
#				on the following data and prints out the result. use a = 0 , b =2 , c = 8 , d = 3
#
######################################################################## 						
#
# Registers Used:
#	$a0: Used for a argument & to print the final results
#	$a1: Used for b argument
#	$a2: Used for c argument
#	$a3: Used for d argument
#	$t0: Used to add (a+b) and then store value m in Max() and store return value temporarily
#	$t1: Used to sub (c-d) and then store value n in Max()
#	$v0: Used for return variable from Func and also Syscall 
#	$ra: return address 
#	$sp: stack pointer
#
########################################################################
# PseudoCode
# 
# int Func( int a, int b, int c, int d){
#	return Max( a+b , c-d );
#     }
#
# int Max( int m, int n){
#	if( m > n ) 
#		return m;
#	else
#		return n;
#     }
#
#########################################################################
		.data
resultmsg:	.asciiz "\n Results of Program 1 : (Max) == "

		.text
		.globl main
		
main: 		
		move $a0, $zero			# $a0 : a = 0
		li $a1, 2			# $a1 : b = 2
		li $a2, 8			# $a2 : c = 8
		li $a3, 3			# $a3 : d = 3	
		
		jal Func 			# calling the Func fucntion
		
		move $t0, $v0			# holding return value temporarily
		
		la $a0, resultmsg		# loading output message
		li $v0, 4			# code to print string
		syscall
		
		move $a0, $t0			# moving result into output register
		li $v0, 1			# code to print integer
		syscall
																			
																		
Exit:		li $v0, 10 			# System code to exit
		syscall				# make system call 

########################################################################
		
		.text

Func:		add $t0, $a0, $a1		# $t0 = a + b 
		sub $t1, $a2, $a3		# $t1 = c - d
		
		addi $sp, $sp, -12		# using the stack, backing up address and sending arguments to Max function
		sw $ra, 8($sp)			# return address to stack
		sw $t1, 4($sp)			# saving argument (c-d) to stack
		sw $t0, 0($sp)			# saving argument (a+b) to stack
		
		jal Max				# calling the max function
		
		lw $v0, 4($sp)			# loading the return value from stack into $v0
		lw $ra, 8($sp)			# loading Func return address back into $ra
		addi $sp, $sp, 12		# getting rid of stack allocation
		
returnFunc:	jr $ra				# return from Func function with return value stored in $v0
		
Max:		lw $t0, 0($sp)			# grabbing (a+b) saving to $t0 : represents int m 
		lw $t1, 4($sp)			# grabbing (c-d) saving to $t1 : represents int n
		
		ble $t0, $t1, Else		# if (m <= n) goto Else
		sw $t0, 4($sp)			# saving $t0 ( m ) to the stack for return
		j return			# goto return
				
Else:		sw $t1, 4($sp)			# saving $t1 ( n ) to the stack for return
		j return			# goto return 
		
return:		jr $ra				# return

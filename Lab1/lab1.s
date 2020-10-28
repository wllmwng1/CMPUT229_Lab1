# The following format is required for all submissions in CMPUT 229
#
# The following copyright notice does not apply to this file
# It is included here because it should be included in all
# solutions submitted by students.
#
#----------------------------------------------------------------
#
# CMPUT 229 Student Submission License
# Version 1.0
# Copyright 2017 <student name>
#
# Redistribution is forbidden in all circumstances. Use of this software
# without explicit authorization from the author is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution is confidential and remains confidential 
# after it is submitted for grading.
#
# Copying any part of this solution without including this copyright notice
# is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including 
# the URL or other repository locating information, to the following email
# address:
#
#          cmput229@ualberta.ca
#
#---------------------------------------------------------------
# Assignment:           1
# Due Date:             January 15, 2000
# Name:                 William Wong
# Unix ID:              wwong1
# Lecture Section:      A1
# Instructor:           Jose Amaral
# Lab Section:          D09 (Friday 1400 - 1650)
# Teaching Assistant:   Unknown
#---------------------------------------------------------------


#---------------------------------------------------------------
# The calculator program loads a0 and a1 as the input parameters,
# using the calculator method to read the input as a post-fix
# notation and return the result of the calculations using the
# print_integer system call.
#
# Inputs:
#
#	a0: contains the address of the input token list
#	a1: contains the address of the top of the stack
#
# Register Usage:
#	t1: Holds the current token being read
#	t2: Holds one part of the stack when needed
#	t3: Holds another part of the stack when needed
#	t4: Adds/Subs the two parts of the stack together
#
# Returns:
#	v0: Holds the top of the stack at termination
#
#---------------------------------------------------------------

.text
calculator:
	lw $t1 0($a0)		#load word from input list $a0
	blt $t1 0 operator	#if less than zero go to operator
	sw $t1 0($a1)		#push $t1 into stack $a1
	addi $a1 $a1 -4		#increment $a1 to next part of stack
	addi $a0 $a0 4		#increment $a0 to next value in list
	j calculator		#jump back to calculator

operator:
	ble $t1 -3 termination	#if less or equal to -3 go to termination
	ble $t1 -2 minus	#if less or equal to -2 go to minus
	addi $a1 $a1 4		#increment $a1 to previous part of stack
	lw $t2 0($a1)		#load word from top of stack
	addi $a1 $a1 4		#increment $a1 to previous part of stack
	lw $t3 0($a1)		#load word from top of stack
	add $t4 $t2 $t3		#add $t2 and $t3 together
	sw $t4 0($a1)		#push $t4 into stack $a1
	addi $a1 $a1 -4		#increment $a1 to next part of stack
	addi $a0 $a0 4		#increment $a0 to next value in list
	j calculator		#jump back to calculator

minus:
	addi $a1 $a1 4		#increment $a1 to previous part of stack
	lw $t2 0($a1)		#load word from top of stack
	addi $a1 $a1 4		#increment $a1 to previous part of stack
	lw $t3 0($a1)		#load word from top of stack
	sub $t4 $t3 $t2		#subtract $t2 and $t3 together
	sw $t4 0($a1)		#push $t4 into stack $a1
	addi $a1 $a1 -4		#increment $a1 to next part of stack
	addi $a0 $a0 4		#increment $a0 to next value in list
	j calculator		#jump back to calculator

termination:
	addi $a1 $a1 4		#increment $a1 to previous part of stack
	lw $t2 0($a1)		#load word from from top of stack
	move $a0,$t2		#move $t2 into $a0
	li $v0, 1		#invoke system call no. 1
	syscall			#make the call
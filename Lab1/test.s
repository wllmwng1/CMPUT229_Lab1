#
# CMPUT 229 Public Materials License
# Version 1.0
#
# Copyright 2017 University of Alberta
# Copyright 2017 Kristen Newbury
#
# This software is distributed to students in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the disclaimer below in the documentation
#    and/or other materials provided with the distribution.
#
# 2. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#-------------------------------
# Lab- Reverse Polish Notation Calculator
#
# Author: Kristen Newbury
# Date: August 9 2017
#
# Adapted from:
# Control Flow Lab - Student Testbed
# Author: Taylor Lloyd
# Date: July 19, 2012
#
# This program reads a file and places it in memory
# and then jumps to the student code under the label "calculator" -
# which is responsible for printing the output.
#
#-------------------------------
.data
.align 2
inputStream:    #space for input sequence of tokens to be stored
.space 2048
noFileStr:
.asciiz "Couldn't open specified file.\n"
.align 2
stack:          #space for stack
.space 2048
stackBeginning: #beginning of the stack
.word 0
.text
main:

    lw	$a0 4($a1)	# Put the filename pointer into $a0
    li	$a1 0		# Read Only
    li	$a2 0		# No Mode Specified
    li	$v0 13		# Open File
    syscall
    bltz	$v0 main_err	# Negative means open failed

    move	$a0 $v0		#point at open file
    la	$a1 inputStream	# write into my binary space
    li	$a2 2048        # read a file of at max 2kb
    li	$v0 14          # Read File Syscall
    syscall

    la	$a0 inputStream	#supply pointers as arguments
    la  $a1 stackBeginning
    jal	calculator      #call the student subroutine/jump to code under the label 'calculator'

    j	main_done

main_err:
    la	$a0 noFileStr   #print error message in the event of an error when trying to read a file
    li	$v0 4
    syscall
main_done:

    li      $v0 10      #exit program syscall
    syscall
#-------------------end of common file-------------------------------------------------
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
	move $v0, $t2
	jr $ra

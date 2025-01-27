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
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
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
#------------------------------
# Introductory Lab - Buggy Program
# Author: Kristen Newbury
# Date: August 7 2017
#
# Something doesn't work. This code should check
# to see if the string in Str is a palindrome.
# (A palindrome is a string that is equivalent
# to the reverse of itself.
# example of a palindrome: noon
# example that is NOT a palindrome: racecars)
#
# The string is in $a0
# Reverse is in $a1
#------------------------------
.data
Reverse:
	.space 50
.align 2
Str:
	.asciiz "racecar"
noPal:
    .asciiz "This was not a palindrome\n"
yesPal:
     .asciiz "This was a palindrome\n"
.text
main:
    la	$s0 Str
    la	$s1 Reverse

    copyLoop:

        lb      $t0 0($s0)

        sb      $t0 0($s1)
        addi    $s0 $s0 1
        	addi	$s1 $s1 1

        bnez	$t0 copyLoop

doneCopy:

    la      $a0 yesPal
    la      $s0 Str
    addi $s1 $s1 -2
    checkLoop:

        lb  $t0 0($s0)
        lb  $t1 0($s1)
	

        bne $t0 $t1 notPalindrome

        beq $t0 $zero done

        addi	$s0 $s0 1
        addi	$s1 $s1 -1
        j   checkLoop

notPalindrome:
    la	$a0 noPal
done:
    li	$v0 4
    syscall

    jr	$ra

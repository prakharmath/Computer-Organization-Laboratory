
##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter 2 integers: "
err:
       .asciiz "\n Please enter non-negative integers\n"
msg:
       .asciiz "\nGCD is: "
newspace:
       .asciiz " "
newline:
       .asciiz "\n"


###########Code Segment#####################
       .text
       .globl main

check_non_negative_values:
       
       slt $t0,$a0,$zero
       bne $t0,$zero,fail

       slt $t0,$a1,$zero
       bne $t0,$zero,fail

       li $v0,1
       jr $ra
       fail:
       li $v0,0
       jr $ra

find_gcd:
       bne $a0,$zero,recurse       # Base conditions
       move $v0,$a1
       jr $ra

       recurse:      
       div $a1,$a0
       move $a1,$a0
       mfhi $a0             # b%a
       addi $sp,$sp,-4      # Allocate space to store return address in stack
       sw $ra,($sp)
       jal find_gcd         # Recurse
       lw $ra,($sp)
       addi $sp,$sp,4       # Free space
       jr $ra

main:

       la $a0,prompt     
       li $v0,4          
       syscall

       li $v0,5
       syscall
       move $s0,$v0

       li $v0,5
       syscall
       move $s1,$v0

       move $a0,$s0  #1st argument
       move $a1,$s1  #2nd argument

       jal check_non_negative_values # Sanity Checking

       beq $v0,$zero,sanity_fail

       move $a0,$s0         # 1st argument
       move $a1,$s1         # 2nd argument

       slt $t0,$a0,$a1      # swap if $a0 > $a1
       bne $t0,$zero,go

       move $a0,$s1
       move $a1,$s0

       go:
       jal find_gcd  # returns gcd in $v0
       move $s2,$v0

       la $a0,msg    
       li $v0,4          
       syscall

       move $a0,$s2
       li $v0,1
       syscall
       j main

       sanity_fail:
       la $a0,err
       li $v0,4
       syscall
       j main



       
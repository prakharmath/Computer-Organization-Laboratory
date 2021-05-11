##########Data Segment########################
.data
promptforsize:
       .asciiz  "\nEnter the size of the array " 
windowsize:
       .asciiz "\n Enter the length of the window"
array:
    .asciiz "\n Enter the contents of the array "
newspace:
       .asciiz " "
       errormessage:
    .asciiz "\n Please enter a valid window size"
success:
      .asciiz "\n The sum of the window and its corresponding average of its elements is \n"
newline:
       .asciiz "\n"
arr:
      .align 2
###########Code Segment#####################
       .text
       .globl main
main:

       la $a0,promptforsize     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall   #asking the user for the size of the array
       li $v0,5
       syscall
       move $t0,$v0
       move $t1,$t0
       sll $t0,$t0,3   #dynamic memory allocation during runtime for the array 
       li $v0,9
       move $a0,$t0
       syscall
       move $t3,$v0     #loading the address of the array 
       move $t4,$t3
       la $a0,windowsize     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string  
       syscall           #asking for the window size from the user 
       li $v0,5
       syscall
       move $t0,$t1
       move $t1,$v0
       move $t2,$t0
       slt $t7,$t0,$t1       #checking if we have a valid window size
       bne $t7,$zero,error
       la $a0,array     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall 
       read:  #reading the array
          li $v0,5
          syscall
          sw $v0,($t3)
          addi $t3,$t3,4
          addi $t2,$t2,-1
          bne $t2,$zero,read
       move $t3,$t4
       li $t5,0
       move $t2,$t1
       for: #looping to find the sum of first window of the array
         beq $t2,$zero,breaking
         addi $t2,$t2,-1
         lw $t6,($t3)
         add $t5,$t5,$t6      #finding the sum of the first window of the array 
         addi $t3,$t3,4
         j for
       breaking:
       la $a0,success     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall   #asking the user for the size of the array

       div $t7,$t5,$t1     #dividing to find the average of the array 
       move $a0,$t5
       li $v0,1  #prints the int
       syscall
              la $a0,newspace     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall

       move $a0,$t7
       li $v0,1  #prints the int
       syscall
       lw $s0,($t4)
       move $t2,$t0
       sub $t2,$t2,$t1
       la $a0,newline     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall

       for1:#looping to find the average of the subsequent windowsize
          beq $t2,$zero,exit
          addi $t2,$t2,-1
          sub $t5,$t5,$s0
          lw $t6,($t3)
          add $t5,$t5,$t6
          addi $t3,$t3,4
          move $a0,$t5
       li $v0,1  #prints the int
       syscall
              la $a0,newspace     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall
          div $t7,$t5,$t1
          move $a0,$t7
          li $v0,1 #prints the int
          syscall
          la $a0,newline     # loads $a0 with the address of string with label 'prompt'
          li $v0,4             # prints the string
          syscall
          addi $t4,$t4,4
          lw $s0,($t4)
          j for1
       exit:
       j main
       error:
       la $a0,errormessage     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall
       j main


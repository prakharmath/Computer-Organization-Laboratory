##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter 8 integers: "
newspace:
       .asciiz " "
newline:
       .asciiz "\n"
msg:
        .asciiz "\n Sorted in ascending order: "

array:
      .align 2
      .space 32      # 8 integers 4 bytes each
###########Code Segment#####################
       .text
       .globl main


form_array:
       li $t1,8
       move $t2,$a0
       read:       # Take input array
       li $v0,5
       syscall
       sw $v0,($t2)
       addi $t2,$t2,4
       addi $t1,$t1,-1
       bne $t1,$zero,read

       jr $ra

Partition:
       addi $t0,$a1,1 # i= start+1
       move $t1,$t0   # j=start +1
       sll $t3,$a1,2
       add $t3,$t3,$a0
       lw $t2,($t3)  # pivot = array[start]
       addi $t3,$t3,4
       move $t6,$t3
       move $t5,$a2
       addi $t5,$t5,1
       loop:  # loop j from start+1 to end
              beq $t1,$t5,ret      
              lw $t4,($t3)
              slt $t7,$t4,$t2

              beq $t7,$zero,skip

              lw $t8,($t6)  # swap if array[j]<pivot
              sw $t8,($t3)
              sw $t4,($t6)

              addi $t6,$t6,4
              addi $t0,$t0,1

              skip:
              addi $t1,$t1,1
              addi $t3,$t3,4

              j loop
       ret:
       sll $t3,$a1,2
       add $t3,$t3,$a0
       lw $t7,($t3)
       addi $t6,$t6,-4
       lw $t5,($t6)         # swap pivot and array[i-1]
       sw $t5,($t3)
       sw $t7,($t6)
       addi $t0,$t0,-1
       move $v0,$t0
       jr $ra



Quicksort:

       slt $t0,$a1,$a2      # base condition check if start<end
       bne $t0,$zero,recurse
       jr $ra

       recurse:
       addi $sp,$sp,-16     # allocate space in stack
       sw $ra,8($sp) # return address
       sw $a1,4($sp) # start
       sw $a2,($sp)  # end
       jal Partition # returns pivot position
       sw $v0,12($sp) # pivot position
       move $a2,$v0
       addi $a2,$a2,-1
       jal Quicksort # sorts array[start...pivot-1]
       lw $a1,12($sp)
       addi $a1,$a1,1
       lw $a2,($sp)
       jal Quicksort # sorts array[pivot+1....end]

       lw $ra,8($sp) # retrieve return address from stack
       addi $sp,$sp,16     # remove space allocated from space
       jr $ra

main:

       la $a0,prompt
       li $v0,4
       syscall

       la $s0,array
       move $a0,$s0
       jal form_array

       la $a0,array
       li $a1,0
       li $a2,7
       
       jal Quicksort

       la $a0,msg
       li $v0,4
       syscall

       print:
       li $t4,8
       la $t0,array    
       printing:     # output array 
              beq $t4,$zero,exit
              addi $t4,$t4,-1
              lw $t3,($t0)
              addi $t0,$t0,4
              move $a0,$t3
              li $v0,1  #prints the int
              syscall
              la $a0,newspace #loads $a0 with the address 
              li $v0,4  #prints the string
              syscall
       j printing

       exit:
       j main


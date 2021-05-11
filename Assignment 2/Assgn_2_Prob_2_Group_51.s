##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter 8 integers: "
newspace:
       .asciiz " "
newline:
       .asciiz "\n"

arr:
      .align 2
      .space 32      # 8 integers 4 bytes each
###########Code Segment#####################
       .text
       .globl main
main:

       la $a0,prompt     # loads $a0 with the address of string with label 'prompt'
       li $v0,4             # prints the string
       syscall

       la $t0,arr
       li $t1, 8
       read:                # Take input from user and store in array
            li $v0,5
            syscall
            sw $v0,($t0)
            addi $t0,$t0,4
            addi $t1,$t1,-1
            bne $t1,$zero,read
       
       li $t1,8             # i=8
        for1:                      # Loop i from 8 to 1
            beq $t1,$zero,print    
            addi $t1,$t1,-1
            li $t2,7
            
            for2:                  # inner loop j 
                 la $t0,arr
                 beq $t2,$zero,for1
                 addi $t2,$t2,-1
                 sll $t3,$t2,2
                 add $t0,$t0,$t3
                 lw $t4,($t0)
                 lw $t5,4($t0)
                 slt $t6,$t5,$t4
                 beq $t6,$zero,for2       
                 sw $t4,4($t0)      # swap arr[j], swap[j+1] if arr[j]>arr[j+1]
                 sw $t5,($t0)      
                 j for2
            j for1
            
       print:
       li $t4,8
       la $t0,arr    
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




##########Data Segment########################
.data
prompt:
       .asciiz  "Enter a number: "
msg:
       .asciiz "Result is : "
e:   .asciiz "Enter a non-negative integer:\n "
newline:
       .asciiz "\n"
###########Code Segment#####################
       .text
       .globl main
main:

       la $a0,prompt #loads $a0 with the address 
       li $v0,4  #prints the string
       syscall

       li $v0,5  #reads first integer
       syscall
       move $t0, $v0 #result returned in $v0
    
       li $t1,0
       li $t2,1

       slt $t5, $t0,$zero
       bne $t5,$zero, err

       while:      #Calculating the nth fibonacci number
            beq $t0,$zero,exit
            addi $t0,$t0,-1
            move $t3,$t2
            add $t2,$t2,$t1
            move $t1,$t3
            j while

       
       exit:

       la $a0,msg
       li $v0,4
       syscall

       move $a0,$t1
       li $v0,1 #prints the  fibonacci number
       syscall
   
      li $v0,10  #exit
      syscall


      err:
       la $a0,e #loads $a0 with the address 
       li $v0,4  #prints the string
       syscall
       j main

##########Data Segment########################
.data
prompt:
       .asciiz  "Enter two numbers: "
msg:
       .asciiz "The gcd of the two numbers is : "
e:   .asciiz "Enter Positive integers: \n "
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
       
       li $v0,5  #reads second integer
       syscall
       move $t1, $v0 #result returned in $v0 

       slt $t5, $t0,$zero
       bne $t5,$zero, err

       slt $t5, $t1,$zero
       bne $t5,$zero, err

       beq $t0,$zero,err

       beq $t1,$zero,err

       while:
            slt $t5,$t1,$t0
            beq $t5,$zero,skip
              move $t2,$t1 #swapping if t1 becomes greater than t0
              move $t1,$t0
              move $t0,$t2
            skip:
            beq $t0,$zero,exit
            sub $t1,$t1,$t0
            j while
      
       exit:

       la $a0,msg
       li $v0,4
       syscall

       move $a0,$t1
       li $v0,1 #prints the gcd of the two numbers using repeated subtraction
       syscall
   
      li $v0,10  #exit
      syscall


      err:
       la $a0,e #loads $a0 with the address 
       li $v0,4  #prints the string
       syscall    #error message when enetered integers are not positive

       j main
      #  li $v0,10  #exit
      # syscall

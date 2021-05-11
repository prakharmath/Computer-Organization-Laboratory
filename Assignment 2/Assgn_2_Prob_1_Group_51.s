##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter 8 integers: "
num: 
	.asciiz "Enter the number to search:"
msg:
       .asciiz "Index is : "
msg2:
       .asciiz "Not found :("
e:   .asciiz "Enter numbers in ascending order:\n "
newline:
       .asciiz "\n"

array:
	.align 2
  .space 32  # 8 integers 4 bytes each 
###########Code Segment#####################
       .text
       .globl main
main:

       la $a0,prompt # loads $a0 with the address of string with label 'prompt'
       li $v0,4  # prints the string
       syscall

       la $t0,array
       li $t1, 8
       read:         # Take input from user and store in array
       	li $v0,5
       	syscall
       	sw $v0,($t0)
       	addi $t0,$t0,4
       	addi $t1,$t1,-1
       	bne $t1,$zero,read


       li $t1, 7
       la $t0,array 	

       check:        # sanity check: elements are in ascending order
       	lw $t2,($t0)
       	lw $t3,4($t0)
       	addi $t3,$t3,1
       	slt $t4,$t2,$t3
       	beq $t4,$zero,err
       	addi $t0,$t0,4
       	addi $t1,$t1,-1
       	bne $t1,$zero,check

       la $a0,num 
       li $v0,4  
       syscall
       li $v0,5
       syscall

       move $t5,$v0 # t5=query: number to be searched

       # $t1=l , $t2=r , $t3=mid, 

       li $t1,0 # L
       li $t2,7 # R

       while: # Binary Search 
              move $s1,$t2       
              addi $s1,$s1,1
              slt $t4,$t1,$s1
              beq $t4,$zero,fail  # loop till l<=r
              add $t3,$t1,$t2
              la $t0,array 
              srl $t3,$t3,1
              move $t7,$t3 # index of mid
              sll $t3,$t3,2
              add $t0,$t0,$t3
              lw $t6,($t0)
              beq $t6,$t5,suc # arr[mid]==query , break and finish

              slt $t4,$t6,$t5 

              beq $t4,$zero,dec

              move $t1,$t7        # comes here if arr[mid] < query
              addi $t1,$t1,1      # l=mid+1
              j while

              dec:                    # comes here if arr[mid] > query
              addi $t2,$t7,-1   # r=mid-1
       j while




      suc:                  # Found the query
       la $a0,msg 
       li $v0,4  
       syscall

       srl $t3,$t3,2
       addi $t3,$t3,1

       move $a0,$t3
       li $v0,1  # prints the index
       syscall
       j main

       fail:         # query not found
       la $a0,msg2
       li $v0,4  
       syscall
       j main
       err:   # Sanity check fails
       la $a0,e 
       li $v0,4  
       syscall
       j main


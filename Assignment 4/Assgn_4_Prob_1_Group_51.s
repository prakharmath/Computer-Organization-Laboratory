##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter 8 integers: "
newspace:
       .asciiz " "
newline:
       .asciiz "\n"
msg:
        .asciiz "\n Sorted in descending order: "

array:
      .align 2
      .space 32      # 8 integers 4 bytes each
###########Code Segment#####################
       .text
       .globl main

InsertionSort:

    li $t0,0 # i
    li $t6,8
    loop1:  # outer loop
        addi $t0,$t0,1
        beq $t0,$t6,ret
        move $t1,$t0 # t1=j
        move $t2,$t1
        sll $t2,$t2,2
        add $t2,$t2,$a0
        lw $t3,($t2)
        loop2:  # inner loop
            addi $t1,$t1,-1
            addi $t2,$t2,-4
            slt $t7,$t1,$zero
            bne $t7,$zero,loop1
            lw $t4,($t2)
            slt $t5,$t4,$t3
            
            beq $t5,$zero,loop1

            sw $t4,4($t2) # swap array[j] and array[j+1] if arr[j]<arr[j+1]
            sw $t3,($t2)

            j loop2
    
    ret:
        jr $ra


main:

    la $a0,prompt
    li $v0,4
    syscall

    la $s0,array
    li $s1,8
    move $s2,$s0
    read:       # Take input array
        li $v0,5
        syscall
        sw $v0,($s2)
        addi $s2,$s2,4
        addi $s1,$s1,-1
        bne $s1,$zero,read

    la $a0,array # pass address of array to function

    jal InsertionSort # procedure call

    la $a0,array
    li $s4,8

    la $a0,msg
    li $v0,4
    syscall

    printing:     # output array 
        beq $s4,$zero,exit
        addi $s4,$s4,-1
        lw $s3,($s0)
        addi $s0,$s0,4
        move $a0,$s3
        li $v0,1  # prints the int
        syscall
        la $a0,newspace 
        li $v0,4  
        syscall
        j printing

    exit:
        li $v0,10
        syscall
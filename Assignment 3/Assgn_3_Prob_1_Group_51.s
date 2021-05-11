##########Data Segment########################
.data
prompt:
       .asciiz  "\nEnter string(max 100 characters): "
msg:
       .asciiz "Index is : "
newline:
       .asciiz "\n"

array:
    .space 100

###########Code Segment#####################
       .text
       .globl main
main:

    la $a0,prompt # loads $a0 with the address of string with label 'prompt'
    li $v0,4  # prints the string
    syscall

    la $a0,array    # read user input
    li $a1, 100
    li $v0,8
    syscall
    
    # add $s0,$zero,$zero
    # lui $s0,8192   # 0x 2000 0000 upper 16 bits ( in decimal hex 2000 is 8192)



    la $t0,array    # t0 contains address of user string
    li $t1,0        # i
    li $t6,65       # A's ascii code
    li $t7,91       # Z

    loop:
        add $t2,$t1,$t0 # t2 points to array[i]
        lb $t3,($t2)     # t3 stores the value of ith character

        beq $t3,$zero,print # null character -> string ends

        slt $s7,$t3,$t7     
        slt $s6,$t3,$t6
        # array[i] <=Z and array[i]>=A if s7==1 and s6==0
        beq $s7,$zero,done
        bne $s6,$zero,done

        addi $t3,$t3,32     # upper case to lower case

        done:
        sb $t3,($t2)
        addi $t1,$t1,1
        j loop

    print:
        la $a0,array    
        li $v0,4
        syscall



    exit:
        j main
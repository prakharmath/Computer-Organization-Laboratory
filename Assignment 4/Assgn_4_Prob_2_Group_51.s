

##########Data Segment########################
.data
arr:
    .asciiz "\n Please enter the contents of the 4X4 Matrix row by row "
msg:
    .asciiz "\n Saddle point (value,row,column): "
fail:
       .asciiz "\n No saddle point found.\n"
newspace:
       .asciiz " "
newline:
       .asciiz "\n"
db:
       .asciiz "Hello\n"
array:
      .align 2
      .space 64
###########Code Segment#####################
       .text	
       .globl main


FindSaddle:
       li $t0,4 # i
       li $a3,0 # no saddle point found flag
       move $a1,$a0  # address of 2d array
       loopi:               # row =i
              addi $t0,-1
              slt $t7,$t0,$zero
              bne $t7,$zero,ex3
              li $t1,4 # j  
              
              loopj:        # col =j
                     addi $t1,-1
                     slt $t7,$t1,$zero
                     bne $t7,$zero,loopi

                     move $t2,$t0
                     sll $t2,$t2,2
                     add $t2,$t2,$t1
                     sll $t2,$t2,2
                     add $t2,$t2,$a1
                     lw $t3,($t2)  # t3= array[i][j]

                     li $t7,1      # flag variable (unique max in row and min in column)
                     li $t6,1      # flag variable (unique min in row and max in column)

                     li $t4,4
                     loopk:        # compares array[i][j] with all elements in row i
                            addi $t4,$t4,-1
                            slt $t5,$t4,$zero
                            bne $t5,$zero,ex
                            beq $t4,$t1,loopk

                            move $t9,$t0
                            sll $t9,$t9,2
                            add $t9,$t9,$t4
                            sll $t9,$t9,2
                            add $t9,$t9,$a1
                            lw $t8,($t9)      # t8 =array[i][k]
                           

                            sle $a2,$t3,$t8
                            bne $a2,$zero,setflag
                            j skip1
                            setflag:
                                   li $t7,0     
                            skip1:
                            sle $a2,$t8,$t3
                            bne $a2,$zero,setflag2
                            j skip2
                            setflag2:
                                   li $t6,0
                            skip2:
                            j loopk

                     ex:
                     li $t4,4
                     loopk2:       # compares array[i][j] with all elements in column j
                            addi $t4,$t4,-1
                            slt $t5,$t4,$zero
                            bne $t5,$zero,ex2
                            beq $t4,$t0,loopk2

                            move $t9,$t4
                            sll $t9,$t9,2
                            add $t9,$t9,$t1
                            sll $t9,$t9,2
                            add $t9,$t9,$a1
                            lw $t8,($t9)      # t8 =array[k][j]

                            sle $a2,$t8,$t3
                            bne $a2,$zero,setflag3
                            j skip3
                            setflag3:
                                   li $t7,0
                            skip3:
                            sle $a2,$t3,$t8
                            bne $a2,$zero,setflag4
                            j skip4
                            setflag4:
                                   li $t6,0
                            skip4:
                            j loopk2
                            ex2:

                           add $t8,$t7,$t6
    
                     beq $t8,$zero,loopj

                     la $a0,msg    # array[i][j] is a saddle point
                     li $v0,4
                     syscall
                     move $a0,$t3
                     li $v0,1
                     syscall
                     la $a0,newspace
                     li $v0,4
                     syscall
                     move $a0,$t0
                     addi $a0,$a0,1
                     li $v0,1
                     syscall
                     la $a0,newspace
                     li $v0,4
                     syscall
                     move $a0,$t1
                     addi $a0,$a0,1
                     li $v0,1
                     syscall
                     li $a3,1
                     j loopj
 ex3:     
       bne $a3,$zero,ret    
       la $a0,fail          # if no saddle point found
       li $v0,4
       syscall

ret:
       jr $ra

main:
	la $a0,arr
	li $v0,4
	syscall
	la $s0,array
	move $s1,$s0
	li $s2,4 #row number
	readrow: #reading the row
        addi $s2,$s2,-1
        slt $s4,$s2,$zero
        bne $s4,$zero,done
	    li $s3,4 #column number
	    readcolumn: #reading the column
	              li $v0,5
	              syscall
	              sw $v0,($s1)
	              addi $s1,$s1,4
	              addi $s3,$s3,-1
	              bne $s3,$zero,readcolumn
	    j readrow
	done:
       
       move $a0,$s0
       jal FindSaddle

       li $v0,10
       syscall





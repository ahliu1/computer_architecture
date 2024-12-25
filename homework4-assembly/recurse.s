.data
    message: .asciiz "enter n here: "
    newline: .asciiz "\n"

.text 
.align 2

.globl main
main:
    # backing up return address, we always need this even without t0 and t1
    addi $sp, $sp, -4 # stack makes room for new function's variables
    sw $ra, 0($sp)
    # get user input in first
    # prompting
    li $v0, 4
    la $a0, message
    syscall

    # reading user input
    li $v0, 5
    syscall

    move $a0, $v0
    
    jal func

    move $a0, $v0
    li $v0, 1
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

func:
    # addi and lw stuff here
    addi $sp, $sp, -8 # change size depending on how many things we save
    sw $ra, 0($sp)       # Save return address
    sw $s0, 4($sp)       # Save $s0 (callee-saved register)

    # jump to _exit_func if base case
    beq $a0, 0, _exit_func

    move $s0, $a0

    addi $a0, $a0, -1
    jal func

    # make t1- aka the N + 1
    addi $s0, $s0, 1
    # then do t1 = 2 * t2
    li $t0, 2
    mul $s0, $s0, $t0

    # then do t2 = t2 - 17
    addi $s0, $s0, -17

    li $t0, 3

    mul $v0, $v0, $t0
    
    add $v0, $s0, $v0

    lw $s0, 4($sp)        # Restore saved $s0
    lw $ra, 0($sp)        # Restore return address
    addi $sp, $sp, 8      # Reclaim stack space
    jr $ra                # Return to caller

_exit_func:
    # return base case here (2)
    li $v0, 2

    lw $s0, 4($sp)        # Restore saved $s0
    lw $ra, 0($sp)        # Restore return address
    addi $sp, $sp, 8      # Reclaim stack space
    jr $ra                # Return to caller

.data
    message: .asciiz "enter n here: "
    newline: .asciiz "\n"

.text 
.align 2

.globl main
main:
    # save callee saved register on the stack
    addi $sp, $sp, -4 # subtracting 4 from the stack pointer, creating room on stack to store value (4 bytes to store addy)
    sw $ra, 0($sp)

    # get user input in first
    # prompting
    li $v0, 4
    la $a0, message
    syscall

    # reading user input
    li $v0, 5
    syscall

    # move value read into t1
    move $t1, $v0

    # if the user input is 0, print out random value -2 and exit main
    beqz $t1, ret_1

    # num variable = 1 (for calculation logic purposes), store in $t2
    li $t2, 1

    j _for_loop

start:
    addi $v0, $t2, -3 # v0- return value
    move $a0, $v0
    li $v0, 1 #1 is command to print integers
    syscall

    j _end_prog

ret_1: 
    # just print out random value -2 and exit main??? idk is this allowed
    # maybe handling unloading stack here????
    li $v0, 1
    li $a0, -2
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    j _end_prog


_for_loop:
    # if a0 = 0, go to main
    blez $t1, start

    mul $t2, $t2, 3
    addi $t1, $t1, -1
    j _for_loop

_end_prog:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0, 0
    jr $ra

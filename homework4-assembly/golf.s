.data
    message0: .asciiz "enter par: "
    message1: .asciiz "enter golfer score: "
    message2: .asciiz "enter golfer name: "
    plus: .asciiz "+"
    end: .asciiz "DONE\n"
    newline: .asciiz "\n"
    line: .space 64
    debug: .asciiz "checkpoint"

.text
.align 2

.globl main

# s0: new node
# s1: head
# s4: par
# t0: pointer to allocated memory, 0: string, 64: score, 68: next pointer
main:
    # TODO: set up stack stuff:
    addi $sp, $sp, -16
    sw $s0, 0($sp) # new node
    sw $s1, 4($sp) # store the head
    sw $s4, 8($sp)
    sw $ra, 12($sp)

    # read the par
    # take user input for par 
    li $v0, 4
    la $a0, message0
    syscall

    # process user input
    li $v0, 5
    syscall
    move $s4, $v0

    li $s1, 0

    move $a0, $s4 # par
    move $a1, $s1 # head
    jal read

    lw $ra, 12($sp)
    lw $s0, 0($sp) # new node
    lw $s1, 4($sp) # store the head
    lw $s4, 8($sp)
    addi $sp, $sp, 16

    jr $ra

read: # a0: par, a1: head
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s4, 4($sp)
    sw $s1, 8($sp)
    sw $s0, 12($sp) # new node!!!
    move $s4, $a0 # par
    move $s1, $a1 # head
read_loop:
    # take user input for golfer name
    li $v0, 4
    la $a0, message2
    syscall

    # process user input
    li $v0, 8
    la $a0, line
    li $a1, 64 # max length of name is 64 chars
    syscall

    # call strcmp to see if end of file has been reached
    la $a0, line
    la $a1, end
    jal strcmp 
    beqz $v0, exit_read

    # doing malloc stuff
    li $a0, 72 # 64 bytes + 4 + 4 
    li $v0, 9
    syscall
    move $s0, $v0 # hold pointer to allocated memory in s0

    # make new node, copy name to memory
    la $a0, line # get addy
    #new strip code start
    jal strip_nl

    # new strip code end
    move $a1, $s0 # get dest 
    jal strcpy

    # take user input for golfer score 
    li $v0, 4
    la $a0, message1
    syscall

    # process user input
    li $v0, 5
    syscall
    sub $v0, $v0, $s4 # subtract par from the score
    sw $v0, 64($s0)

    # newline for formatting
    li $v0, 4
    la $a0, newline
    syscall
    
    # make next pointer null
    sw $0, 68($s0)

    # jal insert function, a0: new_node,  a1: head
    move $a0, $s0
    move $a1, $s1
    jal insert

    # end of deugging
    move $s1, $v0

    j read_loop

strip_nl:
    move $t0, $a0
strip_loop:
    lb $t1, 0($t0)
    beqz $t1, end_strip
    li $t2, 10
    beq $t1, $t2, add_space

    addi $t0, $t0, 1
    j strip_loop
add_space:
    li $t3, 32
    sb $t3, 0($t0)
    addi $t0, $t0, 1
    sb $0, 0($t0)

end_strip:
    jr $ra

exit_read:
  # clean up stack stuff
  move $a0, $s1 # move head into print argument
  jal print
  lw $ra, 0($sp)
  lw $s4, 4($sp)
  lw $s1, 8($sp)
  lw $s0, 12($sp) 
  addi $sp, $sp, 16
  jr $ra

print:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $t3, $a0 # moving head argument into $t3

print_loop:
    beqz $t3, end_print # if head is null
    lw $t4, 64($t3) # t4: temporary stat
    bgtz $t4, pos_score # if score greater than 0, branch to positive score handling

    # else: handle positive scores
    # print name
    li $v0, 4
    move $a0, $t3
    syscall

    # print score
    li $v0, 1
    move $a0, $t4
    syscall

    # new line
    li $v0, 4
    la $a0, newline
    syscall

    # move next pointer, head = head->next
    lw $t3, 68($t3)

    j print_loop

pos_score:
    # print name
    li $v0, 4
    move $a0, $t3
    syscall

    # print positive sign
    li $v0, 4
    la $a0, plus 
    syscall 

    # print score
    li $v0, 1
    move $a0, $t4
    syscall

    # new line
    li $v0, 4
    la $a0, newline
    syscall

    # move next pointer, head = head->next
    lw $t3, 68($t3)

    j print_loop  

end_print:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

insert:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp) # node to insert
    sw $s1, 8($sp) # head node
    sw $s2, 12($sp) # new before node
    sw $s3, 16($sp)

    move $s0, $a0 # s0: new node
    move $s1, $a1 # s1: head

    move $a0, $s0 # s0: new node
    move $a1, $s1 # s1: head

    jal compare

    li $t2, 1 # t2: just register for checking if true
    # if v0 from compare is 1, we're going to make the new node our new head
    beq $s1, $0, insert_front
    beq $v0, $t2, insert_front

    # make a new before node, move head into it
    move $s2, $s1

insert_while:
    # make a new next node $s3, set it equal to before->next
    lw $s3, 68($s2)
    #sw $s3, 16($sp)
    move $a0, $s0 # move node into argument for compare
    move $a1, $s3 # move next node into argument for compare
    jal compare

    # compare(current node, next node) is true
    li $t2, 1 # t2: just register for checking if true
    beq $v0, $t2, if_compare
    move $s2, $s3 # before = next
    j insert_while

if_compare:
    sw $s3, 68($s0)
    sw $s0, 68($s2)
    # return head
    move $v0, $s1
    j end_insert

insert_front:

#insert_func:
    # s0->next = s1
    sw $s1, 68($s0)
    # s1 = s0
    move $s1, $s0 #s0 is our new head (s1 is head, so move the s0 value in)
    move $v0, $s1 # is this right? return head

end_insert:
    lw $ra, 0($sp)
    lw $s0, 4($sp) # node to insert
    lw $s1, 8($sp) # head node
    lw $s2, 12($sp) # new before node
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

compare:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0 # new node
    move $s1, $a1 # head node

    beqz $s1, compare_true
    # temp pointers: t5: new node score, t6: head node score
    lw $t5, 64($s0)
    lw $t6, 64($s1)

    blt $t5, $t6, compare_true
    bgt $t5, $t6, compare_false

    move $a0, $s0
    move $a1, $s1

    jal strcmp # for non DONE 

    # if greater than 0, return false
    bgtz $v0, compare_false

compare_true:
    li $v0, 1 # return 1 if true
    j end_compare

compare_false:
    li $v0, 0
    j end_compare

end_compare:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Compares two strings alphabetically (only for DONE)
# Registers:
# - $a0 (argument): Pointer to the first input, moved as we loop
# - $a1 (argument): Pointer to the second input, moved as we loop
# - $t0: Current character from 0($a0)
# - $t1: Current character from 0($a1)
# - $v0 (return): =0 if strings are equal, <0 if $a0 < $a1, >0 if $a0 > $a1
# Leaf function, so using caller-saved to avoid needing to save any registers
strcmp:
  # Load current characer from the string
  # (In addition to being the start of the function, this is also a loop)
  lb $t0, 0($a0)
  lb $t1, 0($a1)
  
  # If the characters differ, we are done looping
  bne $t0, $t1, done_with_strcmp_loop
  
  # Otherwise, increment and go back to the start, unless we’ve reached NULL
  addi $a0, $a0, 1
  addi $a1, $a1, 1
  bnez $t0, strcmp

  
  # If characters differ or we’ve reached the end, return
done_with_strcmp_loop:
  sub $v0, $t0, $t1
  jr $ra


# Copies a string from one location to another
# Registers:
# - $a0 (argument): Pointer to the input string
# - $a1 (argument): Pointer to the destination
# - $t0: Current character of the string
# Leaf function, so using caller-saved to avoid needing to save any registers
strcpy:
  # Loop over the input string until we reach the NULL character, copying one character at a time
  # Modify $a0 and $a1 as we go to point to each character's initial and final location
_strcpy_loop:
  # Copy the character from the source to the destination
  lb $t0, 0($a0)
  sb $t0, 0($a1)
  # Check if we've reached the end of the string
  beqz $t0, _strcpy_done
  # Increment our pointers and loop
  addi $a0, $a0, 1
  addi $a1, $a1, 1
  b _strcpy_loop
_strcpy_done:
  # Return
  jr $ra

# Homework 4: Assembly (MIPS)

Calling conventions were followed for all programs.

## Sequence
Write a MIPS program called sequence.s that prints out the Nth number of a sequence (specified below), where N is an integer that is input to the program on the command line. Each number in the sequence, S_N , is defined as S_N = 3^N – 3. The input value of N will be greater than or equal to zero. Your program should prompt the user for the value of N via the console and receive input from the user via the console using syscalls.

## Recurse
Write a recursive MIPS program called recurse.s that computes f(N), where N is an integer greater than or equal to zero that is input to the program. f(N) = 2*(N+1) + 3*f(N-1) - 17. The base case is f(0)=2. Your code must be recursive, and it must follow proper MIPS calling conventions. Your program should prompt the user for the value of N via the console and receive input from the user via the console using syscalls.

## Golf
This homework involves writing a MIPS assembly program called golf.s to process golfer statistics. The program reads input from the console, storing golfer names and their shot counts in a linked list. The input consists of an integer (par value), followed by pairs of golfer data: a name (string) and the number of shots taken (integer). The input ends with the string "DONE".

### Requirements:
#### Input Handling:

The program prompts the user for input: first an integer for par, then alternating golfer names and shot counts. <br\ >
The last line of input is "DONE", signaling the end of input.

#### Output:

For each golfer, the program calculates their relationship to par (shots taken minus par). If the result is positive, a "+" sign is included. <br\ >
The output is sorted by the relationship to par, with ties broken alphabetically by the golfer's name.

#### Dynamic Memory Allocation:

The program must dynamically allocate memory on the heap to store golfer data as it is read in. <br\ >
It should be able to handle an arbitrary number of golfers, not limited to a fixed number.

#### Sorting:
Implement a custom sorting function to order golfers first by their relationship to par and then alphabetically by name for those with equal scores. <br\ >
The sorting algorithm should be efficient enough to handle up to 5000 golfers without timing out on GradeScope.

#### Performance:
The program must efficiently process input and produce sorted output in under 20 minutes in the GradeScope environment, avoiding overly slow algorithms.

#### Constraints:
Names will not exceed 63 characters. <br\ >
The program must adhere to MIPS calling conventions.




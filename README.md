# CS Projects Repository

Repository containing projects from CS/ECE 250: Computer Architecture with Prof. Sorin (Fall 2024). 

---

## Homework 3: Introduction to C

### Sequence
- **File:** `sequence.c`
- **Description:** Non-recursive C program that computes the Nth number in the sequence \( S_N = 3^N - 3 \).
- **Input:** Command-line argument \( N \geq 0 \).
- **Restrictions:** Cannot use `math.h` or `pow` libraries.

### Recursion
- **File:** `recurse.c`
- **Description:** Recursive C program that computes \( f(N) = 2 \times (N+1) + 3 \times f(N-1) - 17 \) with a base case of \( f(0) = 2 \).
- **Input:** Command-line argument \( N > 0 \).

### Golf
- **File:** `golf.c`
- **Description:** Reads golfer stats from a file, calculates their relationship to par, and outputs sorted results.
- **Input Format:** File containing par value, golfer names, and shots taken, ending with "DONE".
- **Output:** Sorted list of golfers by relationship to par, ties broken alphabetically.
- **Features:** Custom sorting function.

---

## Homework 4: Assembly (MIPS)

### Sequence
- **File:** `sequence.s`
- **Description:** MIPS assembly program that computes the Nth number in the sequence \( S_N = 3^N - 3 \).
- **Input:** Console input \( N \geq 0 \).

### Recursion
- **File:** `recurse.s`
- **Description:** Recursive MIPS program that computes \( f(N) = 2 \times (N+1) + 3 \times f(N-1) - 17 \) with a base case of \( f(0) = 2 \).
- **Input:** Console input \( N \geq 0 \).

### Golf
- **File:** `golf.s`
- **Description:** MIPS program that processes golfer stats dynamically, calculates relationships to par, and outputs sorted results.
- **Input Handling:** Console input, dynamically allocated memory for arbitrary golfer counts.
- **Output:** Sorted list of golfers by relationship to par, ties broken alphabetically.

---

## Homework 5: Digital Logic Design (Logisim)

### Boolean Algebra
- **Part 1:** Truth table and circuit for \( \text{Output} = [(!C \cdot B) \oplus (A \oplus (B \cdot C))] + A \cdot !C \).
- **Part 2:** Sum-of-products circuit implementation based on a given truth table.
- **Files:** `circuit1a.circ`, `circuit1c.circ`.

### Adder/Subtractor Design
- **File:** `my_adder.circ`
- **Description:** 16-bit ripple-carry adder/subtractor with overflow detection. Includes a 1-bit full adder as a module.

### Finite State Machine
- **File:** `robot.circ`
- **Description:** FSM to control a robot arm's movement within 4 positions, with speed and direction inputs.
- **Features:** Handles boundary conditions, outputs position and blocked status.

---

## Homework 6: Processor Core Design

### Duke 250/16 CPU
- **File:** `cpu.circ`
- **Description:** 16-bit RISC architecture CPU with single-cycle execution.
- **Features:**
  - Supports arithmetic, logical, memory, and control flow operations.
  - Includes ALU, register file, program counter, instruction/data memory, and I/O support.
  - Implements a custom instruction set.
- **Running the CPU:**
  - Load instruction and data memory files in Logisim Evolution.
  - Pulse the reset input and use the clock to execute instructions.
 
  ---

  ## Duke Community Standard
  Intellectual and academic honesty are at the heart of the academic life of any university. It is the responsibility of all students to understand and abide by Duke's expectations regarding academic work. Students found guilty of plagiarism, lying, cheating or other forms of academic dishonesty may be suspended.

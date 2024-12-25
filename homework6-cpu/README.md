# Homework 6: Processor Core Design

Implementation of the Duke 250/16, a 16-bit MIPS-like RISC architecture CPU designed for a single-cycle execution in Logism Evolution.

## Features

- **Architecture:** 16-bit, word-addressed RISC.
- **Instruction Set:** Supports arithmetic, logical, memory, and control flow operations.
- **Components:**
  - ALU (Arithmetic Logic Unit)
  - Register File with 8 general-purpose registers ($r0-$r7)
  - Program Counter (PC) with reset functionality
  - Instruction and Data Memory (Harvard architecture)
  - Keyboard and TTY (Input/Output support)

---

## Instruction Set Architecture (ISA)

| Instruction | Opcode | Type | Operation                                          |
|-------------|--------|------|---------------------------------------------------|
| `add`       | 0000   | R    | $rd = $rs + $rt                                   |
| `sub`       | 0001   | R    | $rd = $rs - $rt                                   |
| `addi`      | 0010   | I    | $rt = $rs + Imm                                   |
| `not`       | 0011   | R    | $rd = NOT($rs)                                    |
| `xor`       | 0100   | R    | $rd = $rs XOR $rt                                 |
| `sll`       | 0101   | R    | $rd = $rs << shamt                                |
| `srl`       | 0110   | R    | $rd = $rs >> shamt (logical shift)                |
| `lw`        | 0111   | I    | $rt = Mem[$rs + D]                                |
| `sw`        | 1000   | I    | Mem[$rs + D] = $rt                                |
| `beqz`      | 1001   | I    | if ($rs == 0) PC = PC + 1 + B; else PC = PC + 1   |
| `blt`       | 1010   | I    | if ($rs < $rt) PC = PC + 1 + B; else PC = PC + 1  |
| `j`         | 1011   | J    | PC = L                                            |
| `jr`        | 1100   | R    | PC = $rs                                          |
| `jal`       | 1101   | J    | $r7 = PC + 1; PC = L                              |
| `input`     | 1110   | R    | $rd = Keyboard Input                              |
| `output`    | 1111   | R    | Print $rs on TTY display                          |

---

## Register Conventions

| Register | Usage                     |
|----------|---------------------------|
| $r0      | Constant value 0          |
| $r1-$r5  | General-purpose registers |
| $r6      | Stack pointer             |
| $r7      | Link register (used by `jal`) |

---

## Running the CPU

1. **Setup in Logisim Evolution:**
   - Open `cpu.circ` in Logisim Evolution.
   - Load the program's instruction and data memory files into the ROM and RAM components.

2. **Initial Configuration:**
   - Set the clock to low (poke the clock pin if necessary).
   - Pulse the `reset` input to clear the PC, TTY, and register contents.

3. **Execution Steps:**
   - If input data is needed for the program, load it into the keyboard device in Logisim.
   - Manually tick the clock (`Ctrl+T`) or enable automatic ticking (`Ctrl+K`) to begin execution.

4. **Testing and Validation:**
   - Use the provided `hwtest.py` script for automated testing:
     ```bash
     python hwtest.py
     ```
   - Verify that all tests pass and inspect `_diff_*.txt` files for debugging failed cases.

5. **Demo Programs:**
   - Assemble and load demo programs (`demo-fib-print`, `demo-prime-print`) using the included assembler tool.
   - Run the demo programs at a high clock speed to observe outputs on the TTY.

---

## Notes

- **Testing Tools:** Compatible with Python and Java (1.6/1.7/1.8) on Duke Linux or similar environments.
- **Known Limitations:** Load-word (`lw`) immediately after store-word (`sw`) is unsupported due to ISA hazards.
- **Reset Functionality:** Resets registers, PC, and I/O devices without affecting memory.

---

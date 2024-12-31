# Homework 7: Cache

Implementation of `cachesim`, a simulator for a single-level cache and the memory underneath it using Java. The simulator supports a configurable cache size, associativity, block size, and FIFO replacement policy.

## Features

- **Configurable Cache Parameters:**
  - Cache size (up to 2MB)
  - Associativity (1-way to fully associative)
  - Block size (2 to 1024 bytes)
- **FIFO Replacement Policy:** First block brought into a set is the first one evicted.
- **Write-back and Write-allocate Policies:** Dirty bits are tracked for write-back operations.
- **Memory Representation:** Simulates 16MB of main memory with initial values of 0.
- **24-bit Addressing:** Simulates addresses up to \(2^{24} - 1\) (16MB).

---

## Program Arguments

The program accepts the following arguments:

| Argument          | Description                                                    |
|-------------------|----------------------------------------------------------------|
| `<trace-file>`    | Name of the file holding the memory access trace.             |
| `<cache-size-kB>` | Total cache capacity in kilobytes (e.g., 1024 for 1MB).        |
| `<associativity>` | Set associativity (e.g., 1 for direct-mapped, 4 for 4-way).    |
| `<block-size>`    | Size of cache blocks in bytes (e.g., 32, 64).                  |

### Example Command:
```bash
java cachesim traces/example.txt 16 1 8

# 🖥️ 4-Bit Nanoprocessor — General Design

A fully functional **4-bit nanoprocessor** implemented in VHDL, designed for deployment on the **Digilent Basys 3 FPGA** board. This design realizes a complete, single-cycle datapath with a hardcoded program ROM, supporting arithmetic, immediate load, and conditional branch operations.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Instruction Set Architecture (ISA)](#instruction-set-architecture-isa)
- [Module Hierarchy](#module-hierarchy)
- [Component Descriptions](#component-descriptions)
- [Hardcoded Program](#hardcoded-program)
- [I/O Pinout](#io-pinout)
- [Project Structure](#project-structure)
- [Simulation](#simulation)
- [How to Run on FPGA](#how-to-run-on-fpga)

---

## Overview

The **General Design** nanoprocessor is a minimal yet complete processor built from first principles in VHDL. It executes instructions fetched from an 8-word read-only program memory at a human-observable speed (~1 Hz), driven by an on-chip clock divider derived from the Basys 3's 100 MHz oscillator.

**Key characteristics:**

| Property              | Value                        |
|-----------------------|------------------------------|
| Data width            | 4-bit                        |
| Instruction width     | 12-bit                       |
| Register file         | 8 × 4-bit (R0 – R7)          |
| Program memory        | 8 words × 12-bit ROM         |
| Address space (PC)    | 3-bit (8 locations)          |
| ALU operations        | ADD, SUB (via NEG)           |
| Target FPGA           | Digilent Basys 3 (Artix-7)   |
| Clock                 | 100 MHz input → ~1 Hz slow   |

---

## Architecture

```
        ┌───────────┐
        │  Slow Clk │◄── 100 MHz
        └─────┬─────┘
              │ slow_clk
        ┌─────▼──────┐     12-bit instruction
        │     PC     │──────────────────────────────────┐
        └─────┬──────┘                                  │
              │ pc_addr (3-bit)                          │
        ┌─────▼──────┐                                  │
        │ Program ROM│                                  │
        └─────┬──────┘                                  │
              │ instruction [11:0]                       │
        ┌─────▼──────────┐                              │
        │ Instr. Decoder │──── control signals ─────────┘
        └────────────────┘
              │
    ┌─────────┼─────────┐
    │         │         │
┌───▼───┐ ┌──▼──┐  ┌───▼────┐
│ MUX8  │ │ MUX2│  │RegBank │
│(Sel A)│ │(WB) │  │R0–R7   │
└───┬───┘ └──▲──┘  └───┬────┘
    │        │          │
┌───▼───┐   ALU         │
│ MUX8  │◄──┘   ◄───────┘
│(Sel B)│
└───────┘
```

The processor follows a **single-stage fetch-decode-execute** pipeline where each clock cycle fetches a new instruction, decodes it, and commits the result.

---

## Instruction Set Architecture (ISA)

Instructions are **12 bits** wide, with a **2-bit opcode** in bits `[11:10]`.

```
 Bit:   11  10 | 9  8  7 | 6  5  4 | 3  2  1  0
               |         |         |
               | Ra[2:0] | Rb[2:0] | imm[3:0]
       Opcode  |    Register / Immediate fields
```

| Opcode | Mnemonic     | Operation                                   |
|--------|--------------|---------------------------------------------|
| `00`   | `ADD Ra, Rb` | Ra ← Ra + Rb                                |
| `01`   | `NEG R`      | R ← 0 − R  (two's complement negation)      |
| `10`   | `MOVI R, d`  | R ← d  (load 4-bit immediate)               |
| `11`   | `JZR R, d`   | if R = 0 then PC ← d  (conditional branch)  |

> **Note:** R0 is hardwired to `0000`. Writing to R0 has no persistent effect, making it usable as a zero source for the NEG operation (0 − R = −R).

---

## Module Hierarchy

```
Nanoprocessor  (top)
├── slow_clock
├── program_rom
├── instruction_decoder
├── pc
│   ├── pc_register
│   ├── adder_3bit
│   └── mux2_3bit
├── register_bank
│   ├── decoder_3_to_8
│   └── register_4bit  (×8)
├── mux8_4bit  (ALU input A)
├── mux8_4bit  (ALU input B)
├── mux8_4bit  (JZR register select)
├── ADD_SUB_4bit  (ALU)
│   ├── RCA_4bit
│   │   ├── FA  (×4)
│   │   └── HA
│   └── (carry/overflow/zero logic)
└── mux2_4bit  (writeback select)
```

---

## Component Descriptions

### `slow_clock`
Divides the 100 MHz board clock down to approximately **1 Hz** using a 25,000,000-count toggle register. Outputs a slow square-wave clock (`clk_out`) that drives the PC and register bank.

### `program_rom`
A **8 × 12-bit** combinatorial ROM. The address is the 3-bit PC output and the output is a 12-bit instruction word. Content is fixed at elaboration time.

### `instruction_decoder`
A purely combinatorial decoder. Reads the 2-bit opcode and the `zero_flag` input to assert the correct control signals:
- `reg_write_en` / `reg_write_sel` — register file write port
- `read_sel_a` / `read_sel_b` — register read port selects (for MUX8 inputs)
- `alu_sub` — selects ADD (`0`) or SUB (`1`) in the ALU
- `wb_sel_imm` — routes immediate value instead of ALU result to write-back
- `pc_load` — triggers a branch in the PC module

### `pc` (Program Counter)
Composed of three sub-components:
- **`pc_register`** — 3-bit D flip-flop storing the current address
- **`adder_3bit`** — increments PC by 1 each cycle
- **`mux2_3bit`** — selects between PC+1 (sequential) and jump target (`pc_load`)

### `register_bank`
Eight 4-bit registers (R0–R7). A `decoder_3_to_8` converts the 3-bit `write_sel` into individual write-enable lines for each `register_4bit` instance. R0 resets to `0000` and remains `0000` when not explicitly written (behaves as a zero register in practice).

### `ADD_SUB_4bit` (ALU)
A 4-bit ripple-carry adder/subtractor built from:
- **`HA`** (Half Adder)
- **`FA`** (Full Adder) × 4 chained as **`RCA_4bit`**
- Subtraction is performed by inverting `B` and asserting carry-in (two's complement)
- Outputs: result `Y[3:0]`, `carry`, `overflow`, `zero`

### `mux8_4bit`
An 8-to-1 multiplexer with a 3-bit select. Three instances exist in the design:
1. Select operand A for the ALU from the register bank
2. Select operand B for the ALU from the register bank
3. Select the register to test for `JZR` zero detection

### `mux2_4bit`
A 2-to-1 multiplexer for the writeback path — selects between the ALU result and the sign-extended 4-bit immediate value.

### `7seg` / `seven_seg_top`
BCD-to-7-segment display driver for presenting results on the Basys 3's onboard 4-digit display.

---

## Hardcoded Program

The ROM contains a sequential summation program that accumulates the sum **1 + 2 + 3 = 6** into register R7:

| Address | Encoding       | Instruction      | Operation             |
|---------|----------------|------------------|-----------------------|
| `000`   | `101110000000` | `MOVI R7, 0`     | R7 ← 0               |
| `001`   | `100010000001` | `MOVI R1, 1`     | R1 ← 1               |
| `010`   | `001110010000` | `ADD  R7, R1`    | R7 ← 0 + 1 = 1       |
| `011`   | `100010000010` | `MOVI R1, 2`     | R1 ← 2               |
| `100`   | `001110010000` | `ADD  R7, R1`    | R7 ← 1 + 2 = 3       |
| `101`   | `100010000011` | `MOVI R1, 3`     | R1 ← 3               |
| `110`   | `001110010000` | `ADD  R7, R1`    | R7 ← 3 + 3 = 6       |
| `111`   | `110000000110` | `JZR  R0, 6`     | Always jump to `110`  |

**Expected final result:** R7 = `0110` (6), displayed on LEDs and 7-segment display.

---

## I/O Pinout

| Signal        | Direction | Basys 3 Pin | Description                          |
|---------------|-----------|-------------|--------------------------------------|
| `Clk_100MHz`  | Input     | W5          | 100 MHz on-board oscillator          |
| `reset`       | Input     | V17 (SW0)   | Active-high synchronous reset        |
| `result[3:0]` | Output    | L1,P1,N3,P3 | R7 value displayed on LEDs           |
| `zero`        | Output    | U16         | ALU zero flag LED                    |
| `overflow`    | Output    | E19         | ALU overflow flag LED                |

---

## Project Structure

```
GeneralDesign/
├── constrains/
│   └── Nanoprocessor.xdc       # Basys 3 pin constraints
├── sim/
│   ├── 7seg/
│   │   └── seven_seg_tb.vhd
│   ├── alu/
│   │   ├── ADD_SUB_4bit_tb.vhd
│   │   ├── FA_tb.vhd
│   │   ├── HA_tb.vhd
│   │   └── RCA_4bit_tb.vhd
│   ├── decoder/
│   │   └── decorder_3to8_tb.vhd
│   ├── instruction_decoder/
│   │   └── instruction_decoder_tb.vhd
│   ├── mux/
│   │   ├── MUX2_3bit_tb.vhd
│   │   ├── mux2_4bit_tb.vhd
│   │   └── mux8_4bit_tb.vhd
│   ├── pc/
│   │   ├── Adder_3bit_tb.vhd
│   │   ├── pc_register_tb.vhd
│   │   └── pc_tb.vhd
│   ├── slow_clock/
│   │   └── slow_clock_tb.vhd
│   └── top/
│       └── Nanoprocessor_tb.vhd
└── src/
    ├── 7seg/
    │   ├── 7seg.vhd             # BCD-to-7seg decoder
    │   └── seven_seg_top.vhd    # 7-seg display controller
    ├── alu/
    │   ├── ADD_SUB_4bit.vhd     # 4-bit add/subtract unit
    │   ├── FA.vhd               # Full adder
    │   ├── HA.vhd               # Half adder
    │   └── RCA_4bit.vhd         # Ripple carry adder
    ├── decoder/
    │   └── decoder_3_to_8.vhd   # 3-to-8 line decoder
    ├── extra/
    │   └── comparator.vhd       # 4-bit signed/unsigned comparator
    ├── instruction_decoder/
    │   └── instruction_decoder.vhd
    ├── mux/
    │   ├── MUX2_3bit.vhd        # 2-to-1 MUX, 3-bit
    │   ├── mux2_4bit.vhd        # 2-to-1 MUX, 4-bit
    │   └── mux8_4bit.vhd        # 8-to-1 MUX, 4-bit
    ├── pc/
    │   ├── Adder_3bit.vhd       # 3-bit incrementer
    │   ├── pc.vhd               # Program counter (top)
    │   └── pc_register.vhd      # 3-bit PC register
    ├── registers/
    │   ├── register_4bit.vhd    # 4-bit D flip-flop register
    │   └── register_bank.vhd    # 8-register file
    ├── rom/
    │   └── program_rom.vhd      # 8×12 ROM with program
    ├── slow_clock/
    │   └── slow_clock.vhd       # 100 MHz → ~1 Hz clock divider
    └── top/
        └── Nanoprocessor.vhd    # Top-level integration
```

---

## Simulation

Each module has a corresponding testbench located in the `sim/` directory. To run simulations in **Vivado**:

1. Open the project in Vivado.
2. Add the relevant `src/` and `sim/` files to the project.
3. Set the desired `_tb.vhd` file as the **top-level simulation source**.
4. Click **Run Simulation → Run Behavioral Simulation**.

The top-level testbench (`Nanoprocessor_tb.vhd`) drives `reset` high for several cycles, then releases it and runs the clock for a sufficient number of cycles to observe the full program execution.

---

## How to Run on FPGA

1. **Open Vivado** and create a new RTL project.
2. Add all `.vhd` files from `src/` as design sources.
3. Add `constrains/Nanoprocessor.xdc` as the constraints file.
4. Set `Nanoprocessor.vhd` as the **top module**.
5. Run **Synthesis** → **Implementation** → **Generate Bitstream**.
6. Connect the Basys 3 board via USB.
7. Open the **Hardware Manager** and program the device.
8. Observe results:
   - **LEDs**: R7 result bits (4-bit binary output)
   - **SW0**: Toggle reset to restart execution
   - The result will stabilize at `0110` (6) visible on the LEDs

---

*Generated for the CO326 Computer Organization & Design project — University of Moratuwa.*
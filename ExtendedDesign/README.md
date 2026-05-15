# 🖥️ 4-Bit Nanoprocessor — Extended Design

An **extended, feature-rich 4-bit nanoprocessor** implemented in VHDL for the **Digilent Basys 3 FPGA** board. This design builds upon the General Design by significantly expanding the instruction set, upgrading the ALU with logical and comparison operations, adding a dedicated flags register, and introducing two interactive execution modes: **automatic clocked execution** and **single-step debugging** via a physical button.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Instruction Set Architecture (ISA)](#instruction-set-architecture-isa)
- [Module Hierarchy](#module-hierarchy)
- [Component Descriptions](#component-descriptions)
- [Execution Modes](#execution-modes)
- [Flags Register](#flags-register)
- [Hardcoded Program](#hardcoded-program)
- [I/O Pinout](#io-pinout)
- [Project Structure](#project-structure)
- [Simulation](#simulation)
- [How to Run on FPGA](#how-to-run-on-fpga)
- [Key Differences from General Design](#key-differences-from-general-design)

---

## Overview

The **Extended Design** nanoprocessor is a substantially enhanced version of the general nanoprocessor. It introduces a **14-bit instruction word**, a **10-instruction ISA** supporting arithmetic, logical, comparison, and control-flow operations, a **dedicated flags register** (Zero, Overflow, GT, EQ, LT), and hardware support for **live instruction injection** via the Basys 3 switches.

**Key characteristics:**

| Property               | Value                                          |
|------------------------|------------------------------------------------|
| Data width             | 4-bit                                          |
| Instruction width      | **14-bit**                                     |
| Register file          | 8 × 4-bit (R0 – R7)                            |
| Program memory         | 8 words × 14-bit ROM                           |
| Address space (PC)     | 3-bit (8 locations)                            |
| ALU operations         | ADD, SUB, NEG, CMP, CMPU, OR, AND, XOR, NOT    |
| Flags                  | Zero (Z), Overflow (V), Greater (GT), Equal (EQ), Less (LT) |
| Execution modes        | Auto (slow clock) & Single-step (button)       |
| Instruction source     | ROM or live 14-bit switch input                |
| Target FPGA            | Digilent Basys 3 (Artix-7)                     |
| Clock                  | 100 MHz input → enable pulse generator         |

---

## Architecture

```
        ┌───────────────────────────────────────┐
        │            Slow Clock                 │
        │  (100 MHz → enable pulse generator)  │
        └──────────────┬────────────────────────┘
                       │ enable
        ┌──────────────▼────────────────────────┐
        │           Step Button                 │
        │  (debounced single-cycle pulse)       │
        └──────────────┬────────────────────────┘
                       │ step_pulse
                       │
              mode_sel ◄── SW15
                       │
              ┌────────▼────────┐
              │  run_enable MUX │ (auto or step)
              └────────┬────────┘
                       │ run_enable
        ┌──────────────┼─────────────────────────────────────┐
        │              │                                     │
  ┌─────▼──────┐  ┌────▼─────┐  ┌───────────┐  ┌──────────┐│
  │     PC     │  │ Reg Bank │  │  Flags    │  │  14-bit  ││
  │ (3-bit)    │  │  R0–R7   │  │ Z/V/GT/EQ │  │   ROM    ││
  └─────┬──────┘  └────┬─────┘  │   /LT     │  └──────────┘│
        │              │        └───────────┘               │
        │ pc_addr      │                                     │
  ┌─────▼──────┐       │                         ┌──────────┴┐
  │ Inst. Sel  │◄──────┼─── SW14-1 (sw_inst)    │  program  │
  │(ROM or SW) │       │                         │   ROM     │
  └─────┬──────┘       │                         └───────────┘
        │ selected_inst│
  ┌─────▼──────────┐   │
  │ Instr. Decoder │   │
  └───────┬────────┘   │
          │ control    │
    ┌─────┼────────────┘
    │     │
┌───▼──┐ ┌▼───────┐
│ MUX8 │ │ MUX8   │
│(A)   │ │(B)     │
└──┬───┘ └──┬─────┘
   │        │
┌──▼────────▼──┐
│   top_alu    │
│  (14 ops)    │──► Z, V, GT, EQ, LT ──► Flags Register
└──────┬───────┘
       │ Y
┌──────▼──────┐
│  mux2_4bit  │ (ALU vs immediate)
└──────┬──────┘
       │
  Register Writeback
```

---

## Instruction Set Architecture (ISA)

Instructions are **14 bits** wide, with a **4-bit opcode** in bits `[13:10]`.

```
 Bit:  13 12 11 10 | 9  8  7 | 6  5  4 | 3  2  1  0
                   |         |         |
                   | Ra[2:0] | Rb[2:0] | imm[3:0]
         Opcode    |     Register / Immediate fields
```

| Opcode  | Mnemonic      | Operation                                           | Flags Updated   |
|---------|---------------|-----------------------------------------------------|-----------------| 
| `0000`  | `ADD Ra, Rb`  | Ra ← Ra + Rb                                        | Z, V            |
| `0001`  | `SUB Ra, Rb`  | Ra ← Ra − Rb                                        | Z, V            |
| `0010`  | `CMPU Ra, Rb` | Unsigned compare Ra vs Rb (no writeback)            | GT, EQ, LT      |
| `0011`  | `CMP Ra, Rb`  | Signed compare Ra vs Rb (no writeback)              | GT, EQ, LT      |
| `0100`  | `OR Ra, Rb`   | Ra ← Ra OR Rb                                       | Z               |
| `0101`  | `AND Ra, Rb`  | Ra ← Ra AND Rb                                      | Z               |
| `0110`  | `XOR Ra, Rb`  | Ra ← Ra XOR Rb                                      | Z               |
| `0111`  | `NOT Ra`      | Ra ← NOT Ra                                         | Z               |
| `1000`  | `MOVI R, d`   | R ← d  (load 4-bit immediate)                       | —               |
| `1001`  | `NEG R`       | R ← 0 − R  (two's complement negation)              | Z, V            |
| `1010`  | `JZR R, d`    | if R = 0 then PC ← d                               | —               |

> **Note:** Opcodes `1011`–`1111` are reserved (no-ops via `when others => null`).

---

## Module Hierarchy

```
Nanoprocessor  (top)
├── slow_clock            ← Enable-pulse generator (not a clk_out, outputs 'enable')
├── step_button           ← Debounced single-step button
├── program_rom           ← 8×14-bit ROM
├── inst_selector         ← Mux between ROM instruction and switch input
├── instruction_decoder   ← 4-bit opcode decoder, 10 instructions
├── pc                    ← Program counter with enable port
│   ├── pc_register
│   ├── adder_3bit
│   └── mux2_3bit
├── register_bank         ← 8×4-bit file with enable
│   ├── decoder_3_to_8
│   └── register_4bit  (×8)
├── flags                 ← Dedicated Z/V/GT/EQ/LT flag register
├── mux8_4bit  (ALU input A)
├── mux8_4bit  (ALU input B)
├── mux8_4bit  (JZR register select)
├── top_alu               ← Extended ALU
│   ├── ADD_SUB_4bit      ← Arithmetic unit (add/subtract)
│   │   ├── RCA_4bit
│   │   │   ├── FA (×4)
│   │   │   └── HA
│   ├── binOp             ← Bitwise logic unit (OR/AND/XOR/NOT)
│   └── comparator        ← Signed & unsigned comparator
└── mux2_4bit  (writeback select)
```

---

## Component Descriptions

### `slow_clock`
Generates a single-cycle **enable pulse** every 5 clock cycles of the 100 MHz input (repurposed from General Design's clock divider for simulation convenience). In silicon use, the counter would be scaled to 25,000,000 for a 1 Hz rate. The output `enable` drives the `run_enable` signal instead of being used as a clock.

### `step_button`
A hardware **edge detector** that converts a held button press (`btn`) into a single-clock-cycle pulse. Prevents multiple steps from firing on a held button by tracking the previous button state (`btn_prev`).

### `inst_selector`
A registered instruction mux. On each rising edge of the 100 MHz clock:
- If `mode_sel = '0'` → latches instruction from the ROM
- If `mode_sel = '1'` → latches the 14-bit value from the Basys 3 switches (SW14-SW1)

This allows manually injecting and executing arbitrary instructions without reloading the bitstream.

### `instruction_decoder`
Decodes the 4-bit opcode and generates the full control word:
- `reg_write_en` / `reg_write_sel` — register file write port
- `read_sel_a` / `read_sel_b` — operand read selects
- `alu_op[2:0]` — 3-bit ALU operation selector (lower 3 bits of opcode)
- `wb_sel_imm` — routes immediate instead of ALU result
- `pc_load` — triggers conditional branch (set combinatorially from `zero_flag`)

### `pc` (Program Counter)
Identical structure to General Design but with an added **`enable`** port. The PC register and adder only advance when `run_enable` is asserted, allowing precise cycle-by-cycle control in step mode.

### `register_bank`
Same structure as General Design with an added **`enable`** port passed through to each `register_4bit` instance, ensuring registers only latch new values when `run_enable` is active.

### `flags` (Flag Register)
A dedicated synchronous flag register. Updated on the rising edge of the 100 MHz clock when `enable = run_enable`:

| Condition                         | Flags Updated        |
|-----------------------------------|----------------------|
| `flag_en = 1` (ALU write instr.) | Z, V set; GT/EQ/LT cleared |
| `cmp_en = 1` (CMP/CMPU instr.)  | GT, EQ, LT set; Z/V cleared |
| Otherwise                        | All flags cleared    |

Flag enable logic:
```
flag_en = reg_write_en AND NOT wb_sel_imm
cmp_en  = NOT inst[13] AND NOT inst[12] AND inst[11]   -- opcode "0010" or "0011"
```

### `top_alu`
The extended ALU integrates three functional units:
- **`ADD_SUB_4bit`** — Ripple-carry arithmetic, `alu_op[0]` selects ADD/SUB
- **`binOp`** — 4-bit bitwise logic (OR/AND/XOR/NOT) selected by `alu_op[1:0]`
- **`comparator`** — Signed/unsigned 4-bit comparator, `sign_en = alu_op[0]`

The output mux routes the correct result to `Y` based on `alu_op`:

| `alu_op` | Unit Selected     | Outputs                       |
|----------|-------------------|-------------------------------|
| `000`    | Arithmetic (ADD)  | Y, carry, overflow, zero      |
| `001`    | Arithmetic (SUB)  | Y, carry, overflow, zero      |
| `010`    | Comparator (CMPU) | GT, EQ, LT (Y = 0)           |
| `011`    | Comparator (CMP)  | GT, EQ, LT (Y = 0)           |
| `1xx`    | Logic (binOp)     | Y, zero                       |

### `comparator`
Implements both **unsigned** and **signed** 4-bit comparison using XNOR equality bits and cascaded magnitude logic. The `sign_en` input selects between the two modes (from `alu_op[0]` for CMP vs CMPU).

### `binOp`
A 4-bit bitwise logic unit. The 2-bit `I` input selects the operation:

| `I` | Operation |
|-----|-----------|
| `00`| OR        |
| `01`| AND       |
| `10`| XOR       |
| `11`| NOT A     |

---

## Execution Modes

The Extended Design supports two runtime modes selected by **SW15** (`mode_sel`):

### Mode 0 — Automatic Execution (`mode_sel = '0'`)
The processor runs automatically, advancing one instruction per enable pulse from the `slow_clock`. In simulation this is every 5 cycles; on the Basys 3 this would be at the configured clock divider rate.

### Mode 1 — Single-Step (`mode_sel = '1'`)
Each press of **BTN_CENTER** (`btn_step`) advances the processor by exactly one instruction. The `step_button` module debounces the press into a single-cycle pulse. This mode is ideal for debugging and classroom demonstrations.

### Instruction Injection
When **SW15 = '1'** and **SW14-SW1** are set to a valid 14-bit instruction encoding, the `inst_selector` will feed the switch-encoded instruction to the decoder instead of the ROM. This allows real-time manual instruction injection.

---

## Flags Register

Five processor status flags are maintained in the `flags` register and exposed as output ports:

| Flag     | Port      | Meaning                                    |
|----------|-----------|---------------------------------------------|
| **Z**    | `zero`    | Result of last ALU op was zero             |
| **V**    | `overflow`| Arithmetic overflow occurred               |
| **GT**   | `greater` | Last CMP/CMPU result: A > B               |
| **EQ**   | `equal`   | Last CMP/CMPU result: A = B               |
| **LT**   | `lower`   | Last CMP/CMPU result: A < B               |

---

## Hardcoded Program

The ROM contains a demonstration program exercising the extended ISA:

| Address | Encoding           | Instruction       | Operation                        |
|---------|--------------------|-------------------|----------------------------------|
| `000`   | `10001110001001`   | `MOVI R7, 9`      | R7 ← 9                          |
| `001`   | `10000010000101`   | `MOVI R1, 5`      | R1 ← 5                          |
| `010`   | `00111110010001`   | `ADD R7, R1`      | R7 ← 9 + 5 = 14                 |
| `011`   | `00101110010000`   | `SUB R7, R0`      | R7 ← 14 - 0 = 14 (test SUB)    |
| `100`   | `00001110010000`   | `ADD R7, R0`      | R7 ← 14 + 0 (test flags)       |
| `101`   | `10011110000000`   | `NEG R7`          | R7 ← -14 (0010 in 4-bit)       |
| `110`   | `00111110010000`   | `ADD R7, R0`      | R7 ← R7 + 0 (hold state)       |
| `111`   | `10100000000000`   | `JZR R0, 0`       | Always jump to address 0        |

---

## I/O Pinout

| Signal          | Direction | Basys 3 Resource  | Description                            |
|-----------------|-----------|-------------------|----------------------------------------|
| `Clk_100MHz`    | Input     | W5                | 100 MHz on-board oscillator            |
| `reset`         | Input     | SW0               | Active-high synchronous reset          |
| `mode_sel`      | Input     | SW15              | 0 = auto, 1 = single-step             |
| `sw_inst[13:0]` | Input     | SW14 – SW1        | Manual instruction injection switches  |
| `btn_step`      | Input     | BTNC              | Single-step button (center)            |
| `result[3:0]`   | Output    | LEDs 3–0          | R7 register value                      |
| `zero`          | Output    | LED               | Zero flag (Z)                          |
| `overflow`      | Output    | LED               | Overflow flag (V)                      |
| `greater`       | Output    | LED               | Greater-than flag (GT)                 |
| `equal`         | Output    | LED               | Equal flag (EQ)                        |
| `lower`         | Output    | LED               | Less-than flag (LT)                    |

---

## Project Structure

```
ExtendedDesign/
├── enhanced_version/              # Vivado project files
│   └── enhanced_version.xpr
├── constrains/
│   └── Nanoprocessor.xdc          # Basys 3 pin constraints
├── sim/
│   ├── 7seg/
│   │   └── seven_seg_tb.vhd
│   ├── alu/
│   │   ├── ADD_SUB_4bit_tb.vhd
│   │   ├── FA_tb.vhd
│   │   ├── HA_tb.vhd
│   │   ├── RCA_4bit_tb.vhd
│   │   └── top_alu_tb.vhd         # Extended ALU testbench
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
│   ├── register_bank/
│   │   ├── flags_tb.vhd           # Flags register testbench
│   │   ├── register_4bit_tb.vhd
│   │   └── register_bank_tb.vhd
│   ├── slow_clock/
│   │   └── slow_clock_tb.vhd
│   └── top/
│       └── Nanoprocessor_tb.vhd
└── src/
    ├── 7seg/
    │   ├── 7seg.vhd               # BCD-to-7seg decoder
    │   └── seven_seg_top.vhd      # 7-seg display controller
    ├── alu/
    │   ├── ADD_SUB_4bit.vhd       # 4-bit add/subtract unit
    │   ├── FA.vhd                 # Full adder
    │   ├── HA.vhd                 # Half adder
    │   ├── RCA_4bit.vhd           # Ripple carry adder
    │   └── top_alu.vhd            # Extended ALU (arithmetic + logic + compare)
    ├── decoder/
    │   └── decoder_3_to_8.vhd     # 3-to-8 line decoder
    ├── extra/
    │   ├── binOp.vhd              # Bitwise logic unit (OR/AND/XOR/NOT)
    │   ├── comparator.vhd         # Signed & unsigned 4-bit comparator
    │   ├── inst_selector.vhd      # ROM vs. switch instruction mux
    │   └── step_button.vhd        # Debounced single-step button
    ├── instruction_decoder/
    │   └── instruction_decoder.vhd  # 4-bit opcode / 10-instruction decoder
    ├── mux/
    │   ├── MUX2_3bit.vhd          # 2-to-1 MUX, 3-bit
    │   ├── mux2_4bit.vhd          # 2-to-1 MUX, 4-bit
    │   └── mux8_4bit.vhd          # 8-to-1 MUX, 4-bit
    ├── pc/
    │   ├── Adder_3bit.vhd         # 3-bit incrementer
    │   ├── pc.vhd                 # Program counter with enable
    │   └── pc_register.vhd        # 3-bit PC register
    ├── registers/
    │   ├── flags.vhd              # Z/V/GT/EQ/LT flag register
    │   ├── register_4bit.vhd      # 4-bit D flip-flop register
    │   └── register_bank.vhd      # 8-register file with enable
    ├── rom/
    │   └── program_rom.vhd        # 8×14-bit ROM
    ├── slow_clock/
    │   └── slow_clock.vhd         # 100 MHz → enable pulse generator
    └── top/
        └── Nanoprocessor.vhd      # Top-level integration
```

---

## Simulation

Each module has a corresponding testbench in the `sim/` directory. To run in **Vivado**:

1. Open the project in Vivado (or open `enhanced_version/enhanced_version.xpr`).
2. Add all `src/` and `sim/` `.vhd` files to the project.
3. Set the target `_tb.vhd` as the **top-level simulation source**.
4. Click **Run Simulation → Run Behavioral Simulation**.

Key testbenches to prioritize:
- `top_alu_tb.vhd` — Exercises all 10 ALU operations across signed/unsigned modes
- `flags_tb.vhd` — Verifies flag update prioritization (ALU vs CMP)
- `Nanoprocessor_tb.vhd` — Full system integration test with ROM program execution

---

## How to Run on FPGA

1. **Open Vivado** and create a new RTL project (or open `enhanced_version/enhanced_version.xpr`).
2. Add all `.vhd` files from `src/` as design sources.
3. Add `constrains/Nanoprocessor.xdc` as the constraints file.
4. Set `Nanoprocessor.vhd` as the **top module**.
5. Run **Synthesis** → **Implementation** → **Generate Bitstream**.
6. Connect the Basys 3 via USB and **Program Device** from the Hardware Manager.
7. Interact with the processor:

| Action                   | Switches / Button                    |
|--------------------------|--------------------------------------|
| Reset processor          | SW0 → ON, then OFF                   |
| Auto execution mode      | SW15 → OFF                           |
| Single-step mode         | SW15 → ON                            |
| Execute one instruction  | Press BTNC                           |
| Inject custom instruction| SW15 → ON, set SW14–SW1 to encoding |

> **Tip:** A pre-built bitstream is available in the root `BitStreams/Extended_Version.bit` — you can skip synthesis and program the board directly.

---

## Key Differences from General Design

| Feature                  | General Design        | Extended Design                          |
|--------------------------|-----------------------|------------------------------------------|
| Instruction width        | 12-bit                | **14-bit**                               |
| Opcode size              | 2-bit (4 opcodes)     | **4-bit (10 opcodes)**                   |
| ISA                      | ADD, NEG, MOVI, JZR   | + SUB, CMP, CMPU, OR, AND, XOR, NOT      |
| ALU architecture         | ADD_SUB_4bit only     | **top_alu** (arithmetic + logic + cmp)   |
| Flag register            | Simplified Z/V flags  | **Dedicated synchronous flags module**   |
| Comparison output        | Zero flag only        | **GT, EQ, LT, Z, V flags**              |
| Clock model              | Divided clock signal  | **Enable-pulse architecture**            |
| Execution control        | Always running        | **Auto + Single-step modes**             |
| Instruction source       | ROM only              | **ROM or live switch input**             |
| Extra components         | flags (Z/V only)      | `flags` (5 flags), `binOp`, `comparator`, `inst_selector`, `step_button` |

---

*Computer Organization & Design — University of Moratuwa.*

# 🔬 4-Bit Nanoprocessor — VHDL Implementation

A complete, hierarchical **4-bit nanoprocessor** implemented in VHDL and synthesized for the **Digilent Basys 3 FPGA** (Xilinx Artix-7). This repository contains **two progressively complex designs** developed for the CO326 Computer Organization & Design module.

---

## 🗂️ Designs

| Design | Instruction Width | ISA Size | Key Features |
|---|---|---|---|
| [**General Design**](./GeneralDesign/README.md) | 12-bit | 4 instructions | Core nanoprocessor — ADD, NEG, MOVI, JZR |
| [**Extended Design**](./ExtendedDesign/README.md) | 14-bit | 10 instructions | + SUB, CMP, OR/AND/XOR/NOT, flags register, single-step mode, switch instruction injection |

---

## 📁 Repository Structure

```
Nano-processor/
├── GeneralDesign/          # Baseline 4-bit nanoprocessor
│   ├── src/                # VHDL source files
│   ├── sim/                # Testbenches
│   ├── constrains/         # Basys 3 XDC constraints
│   └── README.md           # Full design documentation
│
└── ExtendedDesign/         # Feature-extended nanoprocessor
    ├── src/                # VHDL source files
    ├── sim/                # Testbenches
    ├── constrains/         # Basys 3 XDC constraints
    └── README.md           # Full design documentation
```

---

## 🛠️ Tools & Target Hardware

- **HDL**: VHDL (IEEE 1076-1993 / 2008)
- **Simulator / Synthesizer**: Xilinx Vivado Design Suite
- **Target Board**: Digilent Basys 3 (Xilinx Artix-7 XC7A35T)
- **Clock**: 100 MHz on-board oscillator

---

## ⚡ Quick Start

1. Clone the repository
2. Open Vivado and create an RTL project
3. Add source files from either `GeneralDesign/src/` or `ExtendedDesign/src/`
4. Add the corresponding `.xdc` constraints file
5. Set `Nanoprocessor.vhd` as the top module
6. Synthesize, implement, and generate bitstream
7. Program the Basys 3 board

Refer to each design's individual `README.md` for complete pinout, ISA tables, and program details.

---

*Computer Organization & Design — University of Moratuwa.*

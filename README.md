# RISCV-with-FPGA

This repository implements RISC-V CPU designs on FPGA and provides a complete flow from RTL design to simulation and board deployment.

- Single-cycle CPU RTL
- 5-stage pipelined CPU RTL
- Vivado projects, testbenches, and generated bitstreams

It is intended for course projects and architecture experiments, making it easy to validate functionality, run synthesis/implementation, and test on hardware.

---

## Project Overview

This project explores how a RISC-V processor is built and verified in a practical FPGA workflow:

- Design core datapath/control logic in Verilog
- Compare single-cycle and pipelined microarchitectures
- Verify behavior with simulation testbenches
- Build Vivado projects for implementation
- Export `bit`/`hwh` files for FPGA deployment

In short, this repo is a full-stack educational hardware project that covers CPU design, verification, and deployment.

---

## Project Structure

```text
RISCV-with-FPGA/
├── README.md
├── Bitstream/
│   ├── pipeline/
│   │   ├── design.bit
│   │   └── design.hwh
│   └── single_cycle/
│       ├── design_single.bit
│       └── design_single.hwh
├── Hardware/
│   ├── Srcs/
│   │   ├── Pipeline/
│   │   │   ├── ALU.v
│   │   │   ├── Controller.v
│   │   │   ├── Datapath.v
│   │   │   ├── Hazard_Unit.v
│   │   │   ├── Pipeline_top.v
│   │   │   └── ...
│   │   └── Single/
│   │       ├── ALU.v
│   │       ├── Controller.v
│   │       ├── rv_sc.v
│   │       └── ...
│   ├── Testbench/
│   │   ├── rv_sc_tb.v
│   │   └── tb_rv_pl.v
│   └── Vivado/
│       ├── rv_sc/
│       │   └── rv_sc.xpr
│       └── Test/
│           └── Test.xpr
├── Software/
│   └── bubble_sort.s
└── Verification/
    └── verify.ipynb
```

---

## Directory Guide

- `Hardware/Srcs/Pipeline/`: Core RTL source files for the pipelined CPU
- `Hardware/Srcs/Single/`: Core RTL source files for the single-cycle CPU
- `Hardware/Testbench/`: Simulation testbenches
- `Hardware/Vivado/`: Vivado project files (`.xpr`)
- `Bitstream/`: Generated `bit`/`hwh` files for hardware deployment
- `Software/`: Assembly test programs
- `Verification/`: Notebook-based verification scripts

---

## Quick Start

1. Open the Vivado projects:
    - `Hardware/Vivado/rv_sc/rv_sc.xpr` (single-cycle related)
    - `Hardware/Vivado/Test/Test.xpr` (test/integration related)
2. Run Simulation and/or Synthesis/Implementation as needed.
3. For board deployment, use the corresponding `bit` and `hwh` files under `Bitstream/`.

---

## Development Notes

- Make RTL changes primarily under `Hardware/Srcs/`.
- Start debugging from `Hardware/Testbench/` when simulation mismatches occur.
- Keep the directory structure stable and avoid committing irrelevant tool-generated cache artifacts.

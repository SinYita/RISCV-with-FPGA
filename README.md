RISC-V FPGA Project
================================

This project implements a RISC-V processor on FPGA using Vivado.
The project is configured in reference mode, meaning Vivado directly
references the RTL source code in the repository instead of copying it.

--------------------------------------------------
Current Status
--------------------------------------------------

- RTL and testbench paths are synchronized and stable.
- Vivado project opens correctly after git pull.(I hope)
- Simulation environment runs successfully.
- Smoke test currently FAILS and is left for further debugging.

The project structure and toolchain setup are complete.
Remaining work is limited to RTL-level debugging.

--------------------------------------------------
Single Source of Truth (IMPORTANT)
--------------------------------------------------

The authoritative RTL source is:

    RISCV-source/

And for testbench:

    testbench_v

Vivado references these directory directly.

Do NOT edit RTL files under:
    vivado-p/.../imports/

If RTL changes are needed:
1. Modify files in RISCV-source/
2. Re-run simulation or synthesis in Vivado

--------------------------------------------------
Project Structure
--------------------------------------------------

RISCV-source/
    RISC-V RTL source code

    - rv_pl.v
    - alu.v
    - controller.v
    - hazard_unit.v
    - register_file.v
    - sign_extender.v

testbench_v/

    Simulation testbench and programs

    - tb_rv_pl.v
    - smoke_done.hex

vivado-p/

    Vivado project directory

    - riscv-fpga.xpr
    - riscv-fpga.srcs/

--------------------------------------------------
Vivado Version
--------------------------------------------------

Tested with Vivado 2021.2
Behavioral simulation uses XSim.

--------------------------------------------------
How to Open the Project
--------------------------------------------------

1. Clone the repository.
2. Open Vivado 2021.2.
3. Open the project file:

    vivado-p/riscv-fpga.xpr

4. If prompted, generate IP or block design output products.

--------------------------------------------------
Simulation Notes
--------------------------------------------------

- Testbench: testbench_v/tb_rv_pl.v
- Program:   testbench_v/smoke_done.hex

Simulation currently runs but does not pass the smoke test.
Debugging should focus on RTL logic, not project configuration.(should be so)

--------------------------------------------------
Notes for Contributors
--------------------------------------------------

- The project uses reference paths; keep directory structure unchanged.
- Do not commit Vivado-generated folders such as .runs, .sim, or .cache.
- Focus debugging efforts on RISCV-source/.

--------------------------------------------------
Handoff Note
--------------------------------------------------

Environment setup, source synchronization, and project structure
have been completed.

Further work is expected to be standard RTL debugging.

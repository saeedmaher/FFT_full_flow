# 16-Point Radix-2 SDF FFT Hardware Accelerator

This repository contains the complete design flow of a **16-point complex Fast Fourier Transform (FFT)** accelerator, starting from the algorithmic MATLAB model and fixed-point study and continuing through RTL design, verification, lint, formal equivalence checking, FPGA implementation, and ASIC physical design.

The hardware uses a four-stage **radix-2 decimation-in-frequency, single-path delay-feedback (DIF R2SDF)** architecture. Complex samples enter and leave serially, allowing one butterfly datapath per stage and delay lines of 8, 4, 2, and 1 complex samples. The default RTL datapath width is 12 bits for each real and imaginary component.

## Project flow

```text
MATLAB floating-point model
          |
Fixed-point analysis and test-vector generation
          |
Four-stage parameterized Verilog RTL
          |
Directed simulation + UVM constrained-random verification
          |
Lint and formal equivalence checking
          |
FPGA synthesis, place and route (Xilinx Vivado)
          |
ASIC synthesis through GDSII (OpenLane / Sky130)
```

## Repository structure

| Path | Purpose |
|---|---|
| [`MATLAB/`](MATLAB/) | Structural FFT model, fixed-point types, numerical analysis, and reference vectors |
| [`Design/`](Design/) | Synthesizable Verilog RTL and a directed RTL testbench |
| [`Verification/`](Verification/) | UVM environment, assertions, scoreboard, coverage, and regression results |
| [`FPGA/`](FPGA/) | Questa Lint artifacts and a Vivado project targeting an Artix-7 device |
| [`ASIC_results/`](ASIC_results/) | Complete OpenLane Sky130 run: logs, reports, intermediate data, and final layout files |
| [`FFT_Presentation.pdf`](FFT_Presentation.pdf) | Project presentation |

Each phase directory has its own README with inputs, outputs, important files, and reproduction guidance.

## Architecture and interface

The top-level module is `DIF_R2SDF_top` in `Design/top.v`.

| Port | Direction | Width | Description |
|---|---:|---:|---|
| `clk` | input | 1 | Rising-edge system clock |
| `rst_n` | input | 1 | Active-low reset |
| `din_re`, `din_im` | input | `DATA_WIDTH` | Signed real and imaginary input sample |
| `in_valid` | input | 1 | Marks a valid input sample |
| `dout_re`, `dout_im` | output | `DATA_WIDTH` | Signed real and imaginary FFT output sample |
| `out_valid` | output | 1 | Marks a valid output sample |

`DATA_WIDTH` is parameterized and defaults to 12. A frame contains 16 consecutive valid complex samples. The four stages implement butterfly spans of 16, 8, 4, and 2, with ROM-based twiddle factors in the first three stages. The MATLAB model reorders the DIF result into natural output order; consumers of the streaming RTL should use the ordering expected by the supplied verification environment.

## Verified results

The checked-in reports show:

- MATLAB comparison against the built-in `fft` reference over 1,000 randomized complex frames, with saved double-, 16-bit-, and 12-bit result sets.
- UVM functional coverage: **100%**.
- UVM assertion results: **0 failures**.
- Filtered total code coverage by instance: **87.07%**.
- FPGA target: **Xilinx Artix-7 `xc7a35ticpg236-1L`**.
- FPGA utilization after placement: **399 LUTs, 227 registers, 12 DSPs, and 0 block RAMs**.
- FPGA routed timing: **+3.770 ns setup WNS**, with all user timing constraints met.
- ASIC technology: **Sky130A**, `sky130_fd_sc_hd` standard-cell library.
- ASIC clock constraint: **20 ns** (50 MHz target).
- OpenLane status: **flow completed**.
- Final ASIC signoff: **0 Magic DRC violations and 0 LVS errors**.
- OpenLane reported die area: **0.52023 mm²** and **9,729 synthesized cells**.
- Extracted critical path: **16.3 ns**; suggested clock frequency: **47.62 MHz** under the reported signoff assumptions.

Formal equivalence between the RTL and synthesized design was also checked using Synopsys Design Compiler/Formality. The Formality scripts and reports are not included in this repository snapshot.

## Tools used

- MATLAB with Fixed-Point Designer and MATLAB Coder
- Verilog/SystemVerilog
- Questa/ModelSim and UVM
- Questa Lint
- Synopsys Design Compiler and Formality
- Xilinx Vivado
- OpenLane/OpenROAD with the Sky130A PDK

Exact tool versions and local installation paths may differ. Generated project files contain paths from the original environment and may need to be updated before rerunning the flow.

## Quick start

1. Start with [`MATLAB/README.md`](MATLAB/README.md) to reproduce the numerical model and fixed-point tradeoff study.
2. See [`Design/README.md`](Design/README.md) for the RTL hierarchy and directed simulation.
3. See [`Verification/README.md`](Verification/README.md) to run the UVM regression and coverage report.
4. See [`FPGA/README.md`](FPGA/README.md) for lint and Vivado implementation results.
5. See [`ASIC_results/README.md`](ASIC_results/README.md) for the OpenLane deliverables and signoff summary.

## Notes

- Twiddle-factor filenames use the spelling `Twidle` in the source tree; this is kept to avoid breaking build scripts.
- The repository contains generated FPGA and ASIC databases. They are useful for inspecting the completed flow but make the repository substantially larger than a source-only project.
- No license file is currently included. Add one before redistributing or reusing the design outside its intended academic context.

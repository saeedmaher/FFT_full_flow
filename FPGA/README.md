# Lint and FPGA Implementation

This directory contains the RTL lint run and the Xilinx Vivado synthesis/place-and-route project for the FFT accelerator.

## Directory contents

| Path | Description |
|---|---|
| `design/` | RTL copy plus Questa Lint project, logs, reports, and generated databases |
| `project_1/` | Vivado project, imported RTL, constraints, synthesis run, and implementation run |
| `FFT_Basys3_full_constraints.xdc` | Top-level FPGA pin and timing constraints |

## Lint

The `design/` folder contains the lint setup and results:

- `fft.prj`: lint project definition.
- `lint_settings.rpt`: applied settings.
- `lint.rpt`: lint findings.
- `lint_run.log` and `lint_status_history.rpt`: execution history.
- `qcache/` and `work/`: generated analysis databases.

Open `fft.prj` in the corresponding Questa Lint environment or inspect `lint.rpt` for the saved results. Generated database paths may be installation-specific.

## Vivado implementation

Open `project_1/project_1.xpr` in Xilinx Vivado. The project uses:

- Top module: `DIF_R2SDF_top`.
- Device: `xc7a35ticpg236-1L` (Artix-7 family).
- RTL language: Verilog.
- Flow: synthesis, optimization, placement, routing, timing, power, utilization, and DRC reporting.

The constraints imported into the project are under `project_1/project_1.srcs/constrs_1/imports/fft_fpga/`.

## Checked-in implementation results

The placed utilization report shows:

- 399 slice LUTs (1.92%).
- 227 slice registers (0.55%).
- 12 DSP blocks (13.33%).
- 0 block RAM tiles.

The routed timing summary reports **+3.770 ns WNS**, **0.000 ns TNS**, and states that all user timing constraints are met. Routed checkpoints and detailed timing, power, DRC, methodology, and utilization reports are stored in `project_1/project_1.runs/impl_1/`.

Because the Vivado project contains generated caches and absolute-path metadata, a different workstation may require refreshing source/constraint paths or recreating the project from the imported files.

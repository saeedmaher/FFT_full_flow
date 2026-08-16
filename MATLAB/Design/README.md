# RTL Design

This directory contains the synthesizable, parameterized Verilog implementation of the 16-point DIF R2SDF FFT and a directed simulation testbench.

## RTL hierarchy

`top.v` defines `DIF_R2SDF_top`, which connects four streaming FFT stages:

| Stage | Butterfly span | Feedback delay | Twiddle support |
|---|---:|---:|---|
| `DIF_R2SDF_Stage1` | 16 | 8 samples | Stage-1 ROM |
| `DIF_R2SDF_Stage2` | 8 | 4 samples | Stage-2 ROM |
| `DIF_R2SDF_Stage3` | 4 | 2 samples | Stage-3 ROM |
| `DIF_R2SDF_Stage4` | 2 | 1 sample | Unity twiddle |

Each stage is formed from a control unit, butterfly, input multiplexers, and a shift-register delay line. The single-path delay-feedback organization accepts serial complex samples and reuses one butterfly in each stage.

## File groups

- `top.v`: top-level datapath and valid propagation.
- `stage1_top.v` through `stage4_top.v`: stage integration.
- `butterfly_st1.v` through `butterfly_st4.v`: signed complex butterfly arithmetic.
- `CU_stage1.v` through `CU_stage4.v`: stage counters and control.
- `Twidle_factor_ROM_stage1.v` through `Twidle_factor_ROM_stage3.v`: quantized twiddle constants.
- `shift_register_8.v`, `shift_register_4.v`, `shift_register_2.v`, `shift_register_1.v`: feedback storage.
- `ShiftREG*_input_MUX.v` and `BF*_input_MUX.v`: stage routing.
- `TOP_tb.v`: directed testbench.
- `run.do` and `wave.do`: ModelSim/Questa compilation, simulation, and waveform setup.

## Interface

The default `DATA_WIDTH` is 12 bits. `din_re`, `din_im`, `dout_re`, and `dout_im` are signed two's-complement values. Drive `in_valid` for each accepted input sample; `out_valid` qualifies the corresponding serial output stream. Reset is synchronous/asynchronous according to the individual sequential blocks and is active low through `rst_n`.

## Directed simulation

From this directory, run the supplied script in ModelSim or Questa:

```tcl
do run.do
```

The script creates the `work` library, compiles the Verilog sources, starts `tb_DIF_R2SDF_top_no_serializer`, loads the waveform configuration, and runs to completion.

## Design handoff

These RTL sources are reused by the UVM, FPGA, and ASIC flows. Formal equivalence between RTL and the synthesized netlist was checked using Synopsys Design Compiler/Formality, although those tool scripts and reports are not included here.

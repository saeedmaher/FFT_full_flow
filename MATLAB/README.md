# MATLAB Modeling and Fixed-Point Analysis

This directory contains the golden algorithmic model used to choose the RTL number format and generate stimulus for hardware verification.

The model implements a 16-point, four-stage radix-2 DIF FFT. It evaluates the structural implementation against MATLAB's built-in `fft`, measures numerical error and signal-to-quantization-noise ratio (SQNR), and supports double-precision and several fixed-point configurations.

## Main files

| File | Description |
|---|---|
| `DIF_FFT.m` | Structural four-stage DIF FFT and final bit-reversal ordering |
| `data_types_FFT.m` | Numeric types and fixed-point `fimath` settings for inputs, twiddles, stages, and outputs |
| `modeling.m` | Runs 1,000 randomized complex frames, compares with `fft`, and saves error/SQNR results |
| `results_sim.m` | Prints statistics and plots error and SQNR comparisons |
| `DIF_FFT_mex.mexw64` | Generated Windows MEX executable used by `modeling.m` |
| `FFT_random_vectors.mat/.txt` | MATLAB-generated frames used by the UVM environment |
| `double_results.mat` | Floating-point experiment results |
| `fixed_16_results.mat` | 16-bit fixed-point experiment results |
| `fixed_12_results.mat` | 12-bit fixed-point experiment results selected for the RTL |

## Fixed-point behavior

The model uses signed fixed-point arithmetic with floor rounding, wrap overflow, and full-precision intermediate products and sums. The fixed-point formats are:

- 16-bit: input `Q3.13`, twiddle `Q2.14`, and stage-specific scaling.
- 12-bit: input `Q4.8`, twiddle `Q2.10`, stages 1–3 `Q5.7`, and final/output `Q6.6`.

Here `Qm.n` follows the widths encoded by the MATLAB `fi` declarations; all formats are signed. The final RTL uses a parameterized 12-bit datapath.

## Running the model

Requirements are MATLAB, Fixed-Point Designer, and MATLAB Coder if the MEX function must be regenerated.

1. Open MATLAB in this directory.
2. In `modeling.m`, select the desired type, for example:

   ```matlab
   T = data_types_FFT('fxt_pt_12');
   ```

3. Enable the matching `save(...)` line.
4. Run `modeling`.
5. Run `results_sim` to compare saved result sets.

## Handoff to verification

The text vector file contains frame/sample indices plus signed real and imaginary input and expected-output fields. The UVM main sequence reads 1,000 frames of 16 samples from `FFT_random_vectors.txt`. Copy or link that file into the simulator working directory before running the regression.

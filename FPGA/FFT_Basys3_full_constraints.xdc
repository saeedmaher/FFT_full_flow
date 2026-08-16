## =============================================================================
## Basys 3 constraints for DIF_R2SDF_top
## Target top-level ports:
##
##   input  clk
##   input  rst_n
##   input  signed [11:0] din_re
##   input  signed [11:0] din_im
##   input  in_valid
##   output signed [11:0] dout_re
##   output signed [11:0] dout_im
##   output out_valid
##
## Physical mapping
## ----------------
## INPUTS
##   SW0  .. SW11  -> din_re[0]  .. din_re[11]
##   SW12 .. SW14  -> din_im[0]  .. din_im[2]
##   JA1  .. JA10  -> din_im[3]  .. din_im[10]   (8 Pmod signal pins)
##   JC1            -> din_im[11]
##   SW15           -> rst_n
##   BTNU           -> in_valid
##
## OUTPUTS
##   LED0  .. LED11 -> dout_re[0] .. dout_re[11]
##   LED12 .. LED14 -> dout_im[0] .. dout_im[2]
##   LED15          -> out_valid
##   JB1   .. JB10  -> dout_im[3] .. dout_im[10]  (8 Pmod signal pins)
##   JC2            -> dout_im[11]
##
## Notes
## -----
## * The Basys 3 on-board oscillator is 100 MHz.
## * rst_n is active-low and is mapped to SW15:
##       SW15 = 0 -> reset asserted
##       SW15 = 1 -> normal operation
## * in_valid is mapped to BTNU and is high while the button is pressed.
## * The JA/JC input pins require external 3.3-V logic/switches.
## * Do NOT apply 5 V to Pmod FPGA I/O pins.
##
## Pin assignments are based on the official Digilent Basys 3 Master XDC.
## =============================================================================


## -----------------------------------------------------------------------------
## 100 MHz SYSTEM CLOCK
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0.000 5.000} [get_ports clk]


## -----------------------------------------------------------------------------
## RESET
## SW15 -> rst_n
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN R2 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]


## -----------------------------------------------------------------------------
## INPUT VALID
## BTNU -> in_valid
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN T18 [get_ports in_valid]
set_property IOSTANDARD LVCMOS33 [get_ports in_valid]


## -----------------------------------------------------------------------------
## FFT REAL INPUT: din_re[11:0]
## SW0 .. SW11
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN V17 [get_ports {din_re[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[0]}]

set_property PACKAGE_PIN V16 [get_ports {din_re[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[1]}]

set_property PACKAGE_PIN W16 [get_ports {din_re[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[2]}]

set_property PACKAGE_PIN W17 [get_ports {din_re[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[3]}]

set_property PACKAGE_PIN W15 [get_ports {din_re[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[4]}]

set_property PACKAGE_PIN V15 [get_ports {din_re[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[5]}]

set_property PACKAGE_PIN W14 [get_ports {din_re[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[6]}]

set_property PACKAGE_PIN W13 [get_ports {din_re[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[7]}]

set_property PACKAGE_PIN V2 [get_ports {din_re[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[8]}]

set_property PACKAGE_PIN T3 [get_ports {din_re[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[9]}]

set_property PACKAGE_PIN T2 [get_ports {din_re[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[10]}]

set_property PACKAGE_PIN R3 [get_ports {din_re[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_re[11]}]


## -----------------------------------------------------------------------------
## FFT IMAGINARY INPUT: din_im[11:0]
##
## din_im[0:2]  -> SW12 .. SW14
## din_im[3:10] -> Pmod JA signal pins
## din_im[11]   -> Pmod JC1
## -----------------------------------------------------------------------------

## SW12
set_property PACKAGE_PIN W2 [get_ports {din_im[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[0]}]

## SW13
set_property PACKAGE_PIN U1 [get_ports {din_im[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[1]}]

## SW14
set_property PACKAGE_PIN T1 [get_ports {din_im[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[2]}]


## Pmod JA1 -> din_im[3]
set_property PACKAGE_PIN J1 [get_ports {din_im[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[3]}]

## Pmod JA2 -> din_im[4]
set_property PACKAGE_PIN L2 [get_ports {din_im[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[4]}]

## Pmod JA3 -> din_im[5]
set_property PACKAGE_PIN J2 [get_ports {din_im[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[5]}]

## Pmod JA4 -> din_im[6]
set_property PACKAGE_PIN G2 [get_ports {din_im[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[6]}]

## Pmod JA7 -> din_im[7]
set_property PACKAGE_PIN H1 [get_ports {din_im[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[7]}]

## Pmod JA8 -> din_im[8]
set_property PACKAGE_PIN K2 [get_ports {din_im[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[8]}]

## Pmod JA9 -> din_im[9]
set_property PACKAGE_PIN H2 [get_ports {din_im[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[9]}]

## Pmod JA10 -> din_im[10]
set_property PACKAGE_PIN G3 [get_ports {din_im[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[10]}]

## Pmod JC1 -> din_im[11]
set_property PACKAGE_PIN K17 [get_ports {din_im[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din_im[11]}]


## -----------------------------------------------------------------------------
## FFT REAL OUTPUT: dout_re[11:0]
## LED0 .. LED11
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN U16 [get_ports {dout_re[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[0]}]

set_property PACKAGE_PIN E19 [get_ports {dout_re[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[1]}]

set_property PACKAGE_PIN U19 [get_ports {dout_re[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[2]}]

set_property PACKAGE_PIN V19 [get_ports {dout_re[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[3]}]

set_property PACKAGE_PIN W18 [get_ports {dout_re[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[4]}]

set_property PACKAGE_PIN U15 [get_ports {dout_re[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[5]}]

set_property PACKAGE_PIN U14 [get_ports {dout_re[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[6]}]

set_property PACKAGE_PIN V14 [get_ports {dout_re[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[7]}]

set_property PACKAGE_PIN V13 [get_ports {dout_re[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[8]}]

set_property PACKAGE_PIN V3 [get_ports {dout_re[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[9]}]

set_property PACKAGE_PIN W3 [get_ports {dout_re[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[10]}]

set_property PACKAGE_PIN U3 [get_ports {dout_re[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_re[11]}]


## -----------------------------------------------------------------------------
## FFT IMAGINARY OUTPUT: dout_im[11:0]
##
## dout_im[0:2]  -> LED12 .. LED14
## dout_im[3:10] -> Pmod JB signal pins
## dout_im[11]   -> Pmod JC2
## -----------------------------------------------------------------------------

## LED12
set_property PACKAGE_PIN P3 [get_ports {dout_im[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[0]}]

## LED13
set_property PACKAGE_PIN N3 [get_ports {dout_im[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[1]}]

## LED14
set_property PACKAGE_PIN P1 [get_ports {dout_im[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[2]}]


## Pmod JB1 -> dout_im[3]
set_property PACKAGE_PIN A14 [get_ports {dout_im[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[3]}]

## Pmod JB2 -> dout_im[4]
set_property PACKAGE_PIN A16 [get_ports {dout_im[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[4]}]

## Pmod JB3 -> dout_im[5]
set_property PACKAGE_PIN B15 [get_ports {dout_im[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[5]}]

## Pmod JB4 -> dout_im[6]
set_property PACKAGE_PIN B16 [get_ports {dout_im[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[6]}]

## Pmod JB7 -> dout_im[7]
set_property PACKAGE_PIN A15 [get_ports {dout_im[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[7]}]

## Pmod JB8 -> dout_im[8]
set_property PACKAGE_PIN A17 [get_ports {dout_im[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[8]}]

## Pmod JB9 -> dout_im[9]
set_property PACKAGE_PIN C15 [get_ports {dout_im[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[9]}]

## Pmod JB10 -> dout_im[10]
set_property PACKAGE_PIN C16 [get_ports {dout_im[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[10]}]

## Pmod JC2 -> dout_im[11]
set_property PACKAGE_PIN M18 [get_ports {dout_im[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout_im[11]}]


## -----------------------------------------------------------------------------
## OUTPUT VALID
## LED15 -> out_valid
## -----------------------------------------------------------------------------

set_property PACKAGE_PIN L1 [get_ports out_valid]
set_property IOSTANDARD LVCMOS33 [get_ports out_valid]


## -----------------------------------------------------------------------------
## OPTIONAL BITSTREAM CONFIGURATION
## -----------------------------------------------------------------------------

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

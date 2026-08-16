interface FFT_Interface(clk);
import shared_pkg::*;

    parameter DATA_WIDTH = DATA_WIDTH_shared;
    input clk;
    logic rst_n;
    logic signed [DATA_WIDTH-1:0] din_re;
    logic signed [DATA_WIDTH-1:0] din_im;
    logic in_valid;
    //serial FFT OUTPUT
    logic signed [DATA_WIDTH-1:0] dout_re;
    logic signed [DATA_WIDTH-1:0] dout_im;
    logic out_valid;
    
    modport DUT (
        input clk,rst_n,din_re,din_im,in_valid,
        output dout_im,dout_re,out_valid
    );

    modport TEST (
        input clk,dout_im,dout_re,out_valid,
        output rst_n,din_re,din_im,in_valid
    );



endinterface
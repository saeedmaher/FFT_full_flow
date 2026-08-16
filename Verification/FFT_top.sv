module FFT_top ();
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_test_pkg::*;

    // Clock Generator
    bit clk;
    always begin
        #10
        clk = ~clk;
    end

    // Interface
    FFT_Interface FFT_if (clk);
     
    // DUT
    DIF_R2SDF_top #(.DATA_WIDTH(FFT_if.DATA_WIDTH)) 
    DUT(
        .clk(clk),
        .rst_n(FFT_if.rst_n),
        .in_valid(FFT_if.in_valid),
        .din_re(FFT_if.din_re),
        .din_im(FFT_if.din_im),
        .dout_re(FFT_if.dout_re),
        .dout_im(FFT_if.dout_im),
        .out_valid(FFT_if.out_valid)
    );

    // Virtual interface to DB and runthe test
    initial begin
        uvm_config_db #(virtual FFT_Interface)::set(null,"uvm_test_top","FFT_IF",FFT_if);
        run_test("FFT_test");
    end




endmodule
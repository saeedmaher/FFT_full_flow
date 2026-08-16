package FFT_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;

    class FFT_seq_item extends uvm_sequence_item;
    `uvm_object_utils(FFT_seq_item) 

        // Inputs
        logic rst_n_c;
        logic signed [DATA_WIDTH_shared-1:0] din_re_c;
        logic signed [DATA_WIDTH_shared-1:0] din_im_c;
        logic in_valid_c;
        logic signed [DATA_WIDTH_shared-1:0] din_re_c_arr [0:15];
        logic signed [DATA_WIDTH_shared-1:0] din_im_c_arr [0:15];
        // Outputs
        logic signed [DATA_WIDTH_shared-1:0] dout_re_c;
        logic signed [DATA_WIDTH_shared-1:0] dout_im_c;
        logic out_valid_c;
        logic signed [DATA_WIDTH_shared-1:0] dout_re_c_arr [0:15];
        logic signed [DATA_WIDTH_shared-1:0] dout_im_c_arr [0:15];


        // Constructor
        function new(string name = "FFT_seq_item");
            super.new(name);
        endfunction

        // Randomization Constraints

    endclass
    
endpackage
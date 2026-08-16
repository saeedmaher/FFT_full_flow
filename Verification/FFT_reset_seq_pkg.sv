package FFT_Reset_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;
    
    class FFT_reset_seq extends uvm_sequence #(FFT_seq_item);
    `uvm_object_utils(FFT_reset_seq)

        //Seq Item
        FFT_seq_item seq_item;

        // Construcotr
        function new(string name = "FFT_reset_seq");
            super.new(name);
        endfunction 

        // Body
        task body();
            main_seq = 0;
            specific_seq = 0;
            seq_item = FFT_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n_c = 0;
            seq_item.din_re_c = 0;
            seq_item.din_im_c = 0;
            seq_item.in_valid_c = 0;
            finish_item(seq_item);
        endtask

    endclass
    
endpackage
package FFT_Specific_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;
// This sequence pass to the FFT some main signals like DC,
// cosine, sine and impulse signals
    
    class FFT_specific_seq extends uvm_sequence #(FFT_seq_item);
    `uvm_object_utils(FFT_specific_seq)

        //Seq Item
        FFT_seq_item seq_item;

        // Construcotr
        function new(string name = "FFT_specific_seq");
            super.new(name);
        endfunction 

        // Body
        task body();
            main_seq = 0;
            specific_seq = 1;
            // DC
            seq_item = FFT_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n_c = 1;
            seq_item.din_re_c_arr = DC_RE;
            seq_item.din_im_c_arr = DC_IM;
            seq_item.in_valid_c = 1;
            finish_item(seq_item);
            // Impulse
            seq_item = FFT_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n_c = 1;
            seq_item.din_re_c_arr = IMPULSE_RE;
            seq_item.din_im_c_arr = IMPULSE_IM;
            seq_item.in_valid_c = 1;
            finish_item(seq_item);

            // give some sycles till output finishes
            specific_seq = 0;
            repeat(18) begin
                seq_item = FFT_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n_c = 1;
                seq_item.din_re_c = 0;
                seq_item.din_im_c = 0;
                seq_item.in_valid_c = 0;
                finish_item(seq_item);
            end
        endtask

    endclass
    
endpackage
package FFT_sqr_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;

    class FFT_sqr extends uvm_sequencer #(FFT_seq_item);
    `uvm_component_utils(FFT_sqr)

        // Constructor
        function new(string name = "FFT_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        
    endclass
    
endpackage
package FFT_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

    class FFT_config extends uvm_object;
    `uvm_object_utils(FFT_config)

        virtual FFT_Interface fft_vif;
        //uvm_active_passive_enum is_active;

        // Constructor
        function new(string name = "FFT_config");
            super.new(name);
        endfunction 


    endclass 
    
endpackage
package FFT_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;

    class FFT_monitor extends uvm_monitor;
    `uvm_component_utils(FFT_monitor)

        // Virtual interface
        virtual FFT_Interface fft_vif;

        // Seq item
        FFT_seq_item seq_item;

        // Analysis port
        uvm_analysis_port #(FFT_seq_item) mon_ap;

        // Constructor
        function new(string name = "FFT_monitor", uvm_component parent);
            super.new(name,parent);
        endfunction 

        // Build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction
        
        // Run task
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = FFT_seq_item::type_id::create("seq_item");
                @(negedge fft_vif.clk);
                seq_item.rst_n_c = fft_vif.rst_n;
                seq_item.in_valid_c = fft_vif.in_valid;
                seq_item.din_re_c = fft_vif.din_re;
                seq_item.din_im_c = fft_vif.din_im;
                seq_item.dout_re_c = fft_vif.dout_re;
                seq_item.dout_im_c = fft_vif.dout_im;
                seq_item.out_valid_c = fft_vif.out_valid;
                mon_ap.write(seq_item);
            end
        endtask

    endclass 

endpackage
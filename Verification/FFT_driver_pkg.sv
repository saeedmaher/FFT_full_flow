package FFT_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;

    class FFT_driver extends uvm_driver #(FFT_seq_item);
    `uvm_component_utils(FFT_driver)

        // Virtual interface
        virtual FFT_Interface fft_vif;

        // Seq Item
        FFT_seq_item seq_item;

        // Constructor
        function new(string name = "FFT_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction
        
        // Run task
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = FFT_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);
                // Main and Specific seq
                if (main_seq || specific_seq) begin
                    for (int i=0; i<16; ++i) begin
                        fft_vif.in_valid = seq_item.in_valid_c;
                        fft_vif.rst_n = seq_item.rst_n_c;
                        fft_vif.din_re = seq_item.din_re_c_arr[i];
                        fft_vif.din_im = seq_item.din_im_c_arr[i];
                        @(negedge fft_vif.clk);    
                    end
                    seq_item_port.item_done();
                end
                // Reset seq
                else begin
                    fft_vif.in_valid = seq_item.in_valid_c;
                    fft_vif.rst_n = seq_item.rst_n_c;
                    fft_vif.din_re = seq_item.din_re_c;
                    fft_vif.din_im = seq_item.din_im_c;
                    repeat (2) @(negedge fft_vif.clk);
                    seq_item_port.item_done();
                end
            end
        endtask

    endclass 

endpackage
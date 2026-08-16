package FFT_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;
    
    class FFT_coverage extends uvm_component;
    `uvm_component_utils(FFT_coverage)

        //seq item
        FFT_seq_item seq_item_cvr;
        
        //ports
        uvm_analysis_export #(FFT_seq_item) cvr_export;
        uvm_tlm_analysis_fifo #(FFT_seq_item) cvr_fifo;

        //covergroups
        covergroup cvg_group; 

            Reset_bins: coverpoint seq_item_cvr.rst_n_c {
                bins asserted = {0};
                bins deasserted = {1};
            }

            Valid_data: coverpoint seq_item_cvr.in_valid_c iff (seq_item_cvr.rst_n_c) {
                bins asserted = {1};
                bins deasserted = {0};
            } 

            Output_Validation: coverpoint seq_item_cvr.out_valid_c iff (seq_item_cvr.rst_n_c) {
                bins asserted = {1};
                bins deasserted = {0};
            }

            Real_IN: coverpoint seq_item_cvr.din_re_c iff (seq_item_cvr.rst_n_c) {
                bins negative = {[-2048:-1]};
                bins zero = {0};
                bins positive = {[1:2047]};
                bins DC_signal = (256 => 256[*15]);
                bins Impulse_signal = (256 => 0[*15]);
            }

            IMAG_IN: coverpoint seq_item_cvr.din_im_c iff (seq_item_cvr.rst_n_c) {
                bins negative = {[-2048:-1]};
                bins zero = {0};
                bins positive = {[1:2047]};
            }

            Real_out: coverpoint seq_item_cvr.dout_re_c iff(seq_item_cvr.rst_n_c) {
                bins negative = {[-2048:-1]};
                bins zero = {0};
                bins positive = {[1:2047]};
                bins DC_response = (1024 => 0[*15]);
                bins Impulse_response = (64 => 64[*15]);
            }

            IMAG_out: coverpoint seq_item_cvr.dout_im_c iff(seq_item_cvr.rst_n_c) {
                bins negative = {[-2048:-1]};
                bins zero = {0};
                bins positive = {[1:2047]};
            }

            In_valid_with_data_in: cross Valid_data,Real_IN,IMAG_IN iff(seq_item_cvr.rst_n_c) {
                ignore_bins not_valid = binsof(Valid_data.deasserted);
                illegal_bins pos_imag_with_dc = binsof(Real_IN.DC_signal) && binsof(IMAG_IN.positive);
                illegal_bins neg_imag_with_dc = binsof(Real_IN.DC_signal) && binsof(IMAG_IN.negative);
                illegal_bins pos_imag_with_impulse = binsof(Real_IN.Impulse_signal) && binsof(IMAG_IN.positive);
                illegal_bins neg_imag_with_impulse = binsof(Real_IN.Impulse_signal) && binsof(IMAG_IN.negative);
            }

            Out_valid_with_data_out: cross Output_Validation,Real_out,IMAG_out iff(seq_item_cvr.rst_n_c) {
                ignore_bins not_valid = binsof(Output_Validation.deasserted);
                illegal_bins pos_imag_with_dc = binsof(Real_out.DC_response) && binsof(IMAG_out.positive);
                illegal_bins neg_imag_with_dc = binsof(Real_out.DC_response) && binsof(IMAG_out.negative);
                illegal_bins pos_imag_with_impulse = binsof(Real_out.Impulse_response) && binsof(IMAG_out.positive);
                illegal_bins neg_imag_with_impulse = binsof(Real_out.Impulse_response) && binsof(IMAG_out.negative);
            }

        endgroup
    

        //constructor
        function new(string name = "FFT_coverage", uvm_component parent = null);
            super.new(name,parent);
            cvg_group = new;
        endfunction //new()

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cvr_export = new("cvr_export",this);
            cvr_fifo = new ("cvr_fifo",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvr_export.connect(cvr_fifo.analysis_export);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cvr_fifo.get(seq_item_cvr);
                cvg_group.sample();
            end
        endtask
    endclass //className extends superClass
endpackage
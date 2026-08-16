package FFT_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_env_pkg::*;
import FFT_Main_seq_pkg::*;
import FFT_Reset_seq_pkg::*;
import FFT_Specific_seq_pkg::*;
import FFT_config_pkg::*;

    class FFT_test extends uvm_test;
    `uvm_component_utils(FFT_test)

        //handles
        FFT_env fft_env;
        FFT_main_seq M_seq;
        FFT_specific_seq S_seq;
        FFT_reset_seq R_seq;
        FFT_config test_cfg;
        virtual FFT_Interface fft_vif;

        //constructor
        function new(string name = "FFT_test", uvm_component parent = null);
             super.new(name,parent);
        endfunction

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            fft_env = FFT_env::type_id::create("fft_env",this);
            M_seq = FFT_main_seq::type_id::create("M_seq");
            S_seq = FFT_specific_seq::type_id::create("S_seq");
            R_seq = FFT_reset_seq::type_id::create("R_seq");
            test_cfg = FFT_config::type_id::create("test_cfg");
            //get the virtual interface from db
            if(!(uvm_config_db #(virtual FFT_Interface)::get(this,"","FFT_IF",test_cfg.fft_vif))) begin
                `uvm_fatal("build phase","unable to get ALSU interface from DB in test class");
            end
            //intialize is active var
            //test_cfg.is_active = UVM_ACTIVE;
            //SET cfg to the db
            uvm_config_db #(FFT_config)::set(this,"fft_env*","CFG_FFT",test_cfg);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run phase","reset asserted",UVM_LOW)
            R_seq.start(fft_env.ag.agent_sqr);
            `uvm_info("run phase","reset deasserted",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of specific seq",UVM_LOW)
            S_seq.start(fft_env.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of specific seq",UVM_LOW)
            `uvm_info("run phase","reset asserted",UVM_LOW)
            R_seq.start(fft_env.ag.agent_sqr);
            `uvm_info("run phase","reset deasserted",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of main seq",UVM_LOW)
            M_seq.start(fft_env.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of main seq",UVM_LOW)
            phase.drop_objection(this);
        endtask

    endclass 
    
endpackage
package FFT_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_sqr_pkg::*;
import FFT_driver_pkg::*;
import FFT_monitor_pkg::*;
import FFT_config_pkg::*;
import FFT_seq_item_pkg::*;

    class FFT_agent extends uvm_agent;
    `uvm_component_utils(FFT_agent)

        // Define handles
        FFT_driver agent_driv;
        FFT_sqr agent_sqr;
        FFT_monitor agent_mon;
        FFT_config agent_cfg;
        uvm_analysis_port #(FFT_seq_item) agent_ap;

        // Constructor
        function new(string name = "FFT_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Get config pointer to handler
            if(!(uvm_config_db #(FFT_config)::get(this,"","CFG_FFT",agent_cfg))) begin
               `uvm_fatal("build_phase","can not get the CFG from DB in the agent")
            end
            //Build blocks
            //if (agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv=FFT_driver::type_id::create("agent_driv",this);
                agent_sqr=FFT_sqr::type_id::create("agent_sqr",this);
            //end
            agent_mon=FFT_monitor::type_id::create("agent_mon",this);
            agent_ap=new("agent_ap",this);
        endfunction

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //if(agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv.seq_item_port.connect(agent_sqr.seq_item_export);
                agent_driv.fft_vif = agent_cfg.fft_vif;
            //end
            agent_mon.fft_vif = agent_cfg.fft_vif;
            agent_mon.mon_ap.connect(agent_ap);
        endfunction

    endclass 
    
endpackage
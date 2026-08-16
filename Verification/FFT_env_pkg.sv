package FFT_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_agent_pkg::*;
import FFT_coverage_pkg::*;
import FFT_scoreboard_pkg::*;

    class FFT_env extends uvm_env;
    `uvm_component_utils(FFT_env)

        //hadles
        FFT_agent ag;
        FFT_coverage cvr;
        FFT_scoreboard sb;

        //constructor
        function new(string name = "FFT_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ag = FFT_agent::type_id::create("ag",this);
            cvr = FFT_coverage::type_id::create("cvr",this);
            sb = FFT_scoreboard::type_id::create("sb",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            ag.agent_ap.connect(cvr.cvr_export);
            ag.agent_ap.connect(sb.sb_export);
        endfunction
    endclass //className extends superClass

    
endpackage
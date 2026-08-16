package FFT_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;
// It checks only the frame outputs not the out_valid

    class FFT_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FFT_scoreboard)

        // Loacal parameter for the samples and frames
        localparam int FFT_SIZE   = 16;
        localparam int NUM_FRAMES = 1000;
        localparam int SPECIFIC_NUM_FRAMES = 2;

        // FRAME / SAMPLE COUNTERS
        // matlab / main seq
        int input_frame_count   = 0;
        int output_frame_count  = 0;
        int input_sample_count  = 0;
        int output_sample_count = 0;
        // specific seq
        int specific_frame_count  = 0;
        int specific_sample_count = 0;

        // Flag to start checking specific signals
        bit specific_check_active = 1'b0;

        // Flag to start checking using matlab results
        bit matlab_check_active = 1'b0;

        // eq Item
        FFT_seq_item seq_item;

        // Analysis export & FIFO
        uvm_analysis_export #(FFT_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(FFT_seq_item) sb_fifo;


        // RTL Output frame
        fft_frame_t rtl_out_re;
        fft_frame_t rtl_out_im;
        fft_frame_t specific_rtl_re;
        fft_frame_t specific_rtl_im;

        // Expected frame from MATLAB
        int signed expected_re [0:FFT_SIZE-1];
        int signed expected_im [0:FFT_SIZE-1];


        // MATLAB FILE VARIABLES
        integer file;
        integer status;
        integer file_frame;
        integer file_sample;
        integer dummy_in_re;
        integer dummy_in_im;
        integer matlab_out_re;
        integer matlab_out_im;


        // Constructor
        function new(string name = "FFT_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Build ports
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
            // Reset the counters
            correct_counter = 0;
            error_counter   = 0;
            input_frame_count   = 0;
            output_frame_count  = 0;
            input_sample_count  = 0;
            output_sample_count = 0;
            specific_frame_count  = 0;
            specific_sample_count = 0;
            // Reset matlab / specific check flag
            matlab_check_active = 1'b0;
            specific_check_active = 1'b0;
        // Open MATLAB reference file
            file = $fopen("FFT_random_vectors.txt","r");
            // Check if its opened or not
            if (file == 0) begin
                `uvm_fatal("FILE_ERROR", "Scoreboard could not open FFT_random_vectors.txt")
            end
        endfunction

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction


        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Wait till the monitor send data
                sb_fifo.get(seq_item);

                // Raise flag of start checking specific signals
                if (specific_seq && (specific_frame_count < SPECIFIC_NUM_FRAMES)) begin
                    specific_check_active = 1'b1;
                end
                // Start MATLAB checking
                if (main_seq)
                    matlab_check_active = 1'b1;
                // Ignore transaction only if neither checker is active
                if (!specific_check_active && !matlab_check_active)
                    continue;                
                // Reset cond
                if (!seq_item.rst_n_c) begin
                    input_sample_count  = 0;
                    output_sample_count = 0;
                    specific_sample_count = 0;
                    continue;
                end

            // MATLAB INPUT FRAME TRACKING
            if (main_seq && seq_item.in_valid_c) begin
                input_sample_count++;
                // End of frame start new one
                if (input_sample_count == FFT_SIZE) begin
                    input_frame_count++;
                    input_sample_count = 0;
                end
            end
                // OUTPUT COLLECTION
                if (seq_item.out_valid_c) begin
                    // SPECIFIC SEQUENCE: DC + IMPULSE
                    if (specific_check_active) begin
                        specific_rtl_re[specific_sample_count] = seq_item.dout_re_c;
                        specific_rtl_im[specific_sample_count] = seq_item.dout_im_c;
                        specific_sample_count++;
                        // Complete specific 16-point FFT frame
                        if (specific_sample_count == FFT_SIZE) begin
                            compare_specific_frame();
                            specific_frame_count++;
                            specific_sample_count = 0;
                            // DC + Impulse are now complete
                            if (specific_frame_count == SPECIFIC_NUM_FRAMES) begin
                                specific_check_active = 1'b0;
                            end
                        end
                    end

                    // MATLAB SEQUENCE
                    else if (matlab_check_active) begin
                        rtl_out_re[output_sample_count] = seq_item.dout_re_c;
                        rtl_out_im[output_sample_count] = seq_item.dout_im_c;
                        output_sample_count++;
                        // Complete MATLAB FFT frame
                        if (output_sample_count == FFT_SIZE) begin
                            read_matlab_expected();
                            compare_frame();
                            output_frame_count++;
                            output_sample_count = 0;
                            if (output_frame_count == NUM_FRAMES) begin
                                matlab_check_active = 1'b0;
                            end
                        end
                    end

                end
            end
        endtask


        // Compare specific sequence
        // ------------------------------------------
        // Frame 0 = DC
        // Frame 1 = Impulse
        // ------------------------------------------

        task compare_specific_frame();
            int frame_errors;
            int signed exp_re;
            int signed exp_im;
            frame_errors = 0;
            // =================================================
            // FRAME 0 : DC
            // Input:
            // 16 samples of 1.0
            // FFT: X[0] = 16 & X[1:15] = 0
            // Q6.6: 16 * 64 = 1024
            // =================================================
            if (specific_frame_count == 0) begin
                
                for (int sample = 0; sample < FFT_SIZE; sample++) begin
                    if (sample == 0)
                        exp_re = 1024;
                    else
                        exp_re = 0;
                    exp_im = 0;
                    if (($signed(specific_rtl_re[sample]) != exp_re) || ($signed(specific_rtl_im[sample]) != exp_im)) begin
                        `uvm_error("FFT_DC_MISMATCH", $sformatf("DC Sample %0d | Expected=(%0d,%0d) RTL=(%0d,%0d)",
                                                                    sample,exp_re,exp_im,$signed(specific_rtl_re[sample]),
                                                                    $signed(specific_rtl_im[sample])
                                                                )
                                )
                        error_counter++;
                        frame_errors++;
                    end
                    else begin
                        correct_counter++;
                    end

                end
                if (frame_errors != 0) begin
                    `uvm_error("FFT_DC_FAIL",$sformatf("DC FFT frame FAILED with %0d mismatches",frame_errors))
                end

            end


            // =================================================
            // FRAME 1 : IMPULSE
            // Input: x[0] = 1 others = 0
            // FFT: X[k] = 1 for every k
            // Q6.6: 1 * 64 = 64
            // =================================================

            else if (specific_frame_count == 1) begin
                for (int sample = 0; sample < FFT_SIZE; sample++) begin
                    exp_re = 64;
                    exp_im = 0;
                    if (($signed(specific_rtl_re[sample]) != exp_re) || ($signed(specific_rtl_im[sample]) != exp_im)) begin
                        error_counter++;
                        frame_errors++;
                    end
                    else begin
                        correct_counter++;
                    end
                end
                if (frame_errors != 0) begin
                    `uvm_error("FFT_IMPULSE_FAIL",
                                $sformatf("Impulse FFT frame FAILED with %0d mismatches",frame_errors)
                            )
                end
            end

        endtask

        // READ matlab expected frame task
        task read_matlab_expected();
            for (int sample = 0;sample < FFT_SIZE;sample++) begin
                status = $fscanf(
                    file,
                    "%d %d %d %d %d %d\n",
                    file_frame,
                    file_sample,
                    dummy_in_re,
                    dummy_in_im,
                    matlab_out_re,
                    matlab_out_im
                );
                // Check complete line was read
                if (status != 6) begin
                    `uvm_fatal(
                        "FILE_ERROR",
                        $sformatf(
                            "Could not read MATLAB frame %0d sample %0d",
                            output_frame_count,
                            sample
                        )
                    )
                end
                // Check frame/sample ordering in MATLAB file
                if ((file_frame != output_frame_count) || (file_sample != sample)) begin
                    `uvm_fatal("FILE_ORDER_ERROR",
                                $sformatf("Expected frame=%0d sample=%0d, got frame=%0d sample=%0d",
                                            output_frame_count,sample,file_frame,file_sample
                                        )
                            )
                end
                // Store expected output
                expected_re[sample] = matlab_out_re;
                expected_im[sample] = matlab_out_im;
            end
        endtask


        // Compare RTL frame Vs MATLAB frame
        task compare_frame();
            int frame_errors;
            frame_errors = 0;
            for (int sample = 0; sample < FFT_SIZE; sample++) begin
                // REAL / IMAGINARY COMPARISON
                if (($signed(rtl_out_re[sample]) != expected_re[sample]) || ($signed(rtl_out_im[sample]) != expected_im[sample])) begin
                    `uvm_error("FFT_MISMATCH",
                                $sformatf("Frame %0d Sample %0d | MATLAB=(%0d,%0d) RTL=(%0d,%0d)",
                                            output_frame_count,sample,expected_re[sample],expected_im[sample],
                                            $signed(rtl_out_re[sample]),$signed(rtl_out_im[sample])
                                        )
                            )
                    error_counter++;
                    frame_errors++;
                end
                else begin
                    correct_counter++;
                end

            end
            if (frame_errors != 0) begin
                `uvm_error("FFT_FRAME_FAIL",
                            $sformatf("Frame %0d FAILED with %0d mismatched samples",
                                        output_frame_count,frame_errors
                                    )
                        )
            end

        endtask

        // Report phase
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            // SAMPLE RESULTS
            `uvm_info("FFT_SCOREBOARD_REPORT",$sformatf("Correct samples = %0d",correct_counter),UVM_NONE)
            `uvm_info("FFT_SCOREBOARD_REPORT",$sformatf("Data mismatches = %0d", error_counter),UVM_NONE)
            // FINAL PASS / FAIL
            if ((error_counter == 0) &&
                ((correct_counter == ((NUM_FRAMES + SPECIFIC_NUM_FRAMES) * FFT_SIZE))) &&
                (specific_frame_count == SPECIFIC_NUM_FRAMES) &&
                (input_frame_count == NUM_FRAMES) &&
                (output_frame_count == NUM_FRAMES)) begin
                    `uvm_info("FFT_SCOREBOARD", "PASS: DC, Impulse, and all 1000 MATLAB FFT frames matched",UVM_NONE)
            end
            else begin
                `uvm_error("FFT_SCOREBOARD",$sformatf("FAIL: mismatches=%0d correct=%0d ",
                                                        error_counter,correct_counter
                                                    )
                        )
            end
            // Report 
            `uvm_info("FFT_SCOREBOARD_REPORT",
                $sformatf(
                "\n
============================================================\n
                FFT VERIFICATION REPORT\n
============================================================\n
    Total correct samples : %0d\n
    Data mismatches       : %0d\n
    MATLAB FFT frames     : %0d\n
    Directed tests        : DC, Impulse\n
------------------------------------------------------------\n
    RESULT                : %s\n
============================================================",
                correct_counter,
                error_counter,
                1000,
                (error_counter == 0) ? "PASS" : "FAIL"
                ),
                UVM_LOW
            );
            
            // CLOSE MATLAB FILE
            if (file != 0)
                $fclose(file);
        endfunction

    endclass

endpackage
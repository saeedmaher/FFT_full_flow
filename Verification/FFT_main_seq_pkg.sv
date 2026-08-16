package FFT_Main_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FFT_seq_item_pkg::*;
import shared_pkg::*;
    
    class FFT_main_seq extends uvm_sequence #(FFT_seq_item);
    `uvm_object_utils(FFT_main_seq)

        //Seq Item
        FFT_seq_item seq_item;

        // Construcotr
        function new(string name = "FFT_main_seq");
            super.new(name);
        endfunction 

        // Matlab read file values
        integer file; // Check if file has been read
        integer status; // // Check number of values in a line
        integer frame_num; // The frame number
        integer sample_num; // The sample number
        integer in_re; // The real input value
        integer in_im; // The imag input value
        integer dummy_out_re; // Dummy real output value
        integer dummy_out_im; // Dummy imag output value


        // Body
        task body();
            main_seq = 1;
            specific_seq = 0;
            // Open the file
            file = $fopen("FFT_random_vectors.txt", "r");
            // Checck the file opened successfully
            if (file == 0) begin
                `uvm_fatal("FILE_ERROR", "Could not open FFT_random_vectors.txt")
            end
            // Loop on the Frames
            for (int frame = 0; frame < 1000; frame++) begin
                seq_item = FFT_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.in_valid_c = 1;
                seq_item.rst_n_c = 1;
                for (int sample = 0; sample < 16; sample++) begin
                    // Save the values to the variables
                    status = $fscanf(file, "%d %d %d %d %d %d\n",
                                    frame_num,sample_num,in_re,in_im,dummy_out_re,dummy_out_im);
                    // Check that the values read completly
                    if (status != 6) begin
                        `uvm_fatal("FILE_ERROR", $sformatf("Error reading frame %0d sample %0d",frame,sample))
                    end
                    seq_item.din_re_c_arr[sample] = in_re;
                    seq_item.din_im_c_arr[sample] = in_im;
                end                
                finish_item(seq_item);
            end
            $fclose(file);
            // Cycles to give the remain output to get out
            repeat (18) begin
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
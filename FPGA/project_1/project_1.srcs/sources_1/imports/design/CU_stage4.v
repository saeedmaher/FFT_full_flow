module DIF_Stage4_CU (
    input  wire clk,
    input  wire rst_n,
    // start counter signal
    input  wire stage3_valid,
    // MUXs sel
    output wire SR_sel,
    output wire out_st3_sel,
    // Stage-4 butterfly output valid
    output reg valid,
    // Final output-stream valid
    output reg out_valid
);


    // =========================================================
    // Counter
    // =========================================================
    // One frame = 16 logical Stage-4 input samples.
    //
    // Sequence:
    //
    // 0  1  2  3 ... 15
    //
    // Stage 4 begins when the first Stage-3 butterfly
    // output becomes valid.
    //
    // Once started, Stage 4 continues through the entire
    // 16-cycle sequence because during Stage3-valid-low
    // intervals the Stage-3 SR2 output still contains
    // useful feedforward data.
    // =========================================================

    reg [3:0] count;



    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            count <= 4'd0;
        end

        else if (count != 4'd0) begin
            // Once started, continue until count wraps
            // naturally from 15 back to 0.
            count <= count + 1'b1;
        end

        else if (stage3_valid) begin
            // First Stage-3 valid result starts Stage 4.
            count <= count + 1'b1;
        end

    end


    // =========================================================
    // Stage-3 source select
    //
    // count:
    //
    // 0,1    -> Stage-3 butterfly
    // 2,3    -> Stage-3 SR2
    // 4,5    -> Stage-3 butterfly
    // 6,7    -> Stage-3 SR2
    // ...
    //
    // Pattern:
    //
    // 11 00 11 00 11 00 11 00
    //
    // =========================================================

    assign out_st3_sel = ~count[1];


    // =========================================================
    // SR1 feedback select
    //
    // Stage 4 operates on adjacent pairs:
    //
    // count 0:
    //      store sample 0
    //
    // count 1:
    //      BF(sample0, sample1)
    //      store BF4 DIFF
    //
    // count 2:
    //      store sample 2
    //
    // count 3:
    //      BF(sample2, sample3)
    //      store BF4 DIFF
    //
    // Pattern:
    // 0 1 0 1 0 1 ...
    // =========================================================

    assign SR_sel = count[0];


    // =========================================================
    // Stage-4 valid
    // Butterfly is valid on logical counts:
    // 1,3,5,7,9,11,13,15
    // =========================================================
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            valid     <= 1'b0;
            out_valid <= 1'b0;

        end

        else begin

            // =================================================
            // Stage-4 butterfly valid
            //
            // Current even count causes the NEXT count
            // to become odd, where the butterfly result
            // is valid.
            // =================================================

            if (
                (count[0] == 1'b0) &&
                ((count != 4'd0) || stage3_valid)
            ) begin

                valid <= 1'b1;

            end

            else begin

                valid <= 1'b0;

            end


            // =================================================
            // Final output stream valid
            //
            // Start together with Stage-4 processing.
            //
            // Because out_valid is REGISTERED:
            //
            // old count = 15
            //      |
            //      +--> count becomes 0
            //      |
            //      +--> out_valid remains 1
            //
            // Therefore the count=0 cycle correctly carries
            // the final DIFF from SR1.
            //
            // On the NEXT clock, old count is already 0,
            // so out_valid becomes 0.
            // =================================================

            if (
                (count != 4'd0) ||
                stage3_valid
            ) begin

                out_valid <= 1'b1;

            end

            else begin

                out_valid <= 1'b0;

            end

        end

    end
endmodule
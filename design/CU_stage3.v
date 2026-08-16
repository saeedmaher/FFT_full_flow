module DIF_Stage3_CU (
    input  wire     clk,
    input  wire     rst_n,
    // start counter signal
    input  wire     stage2_valid,
    //MUXs sel
    output wire     SR_sel,
    output wire     out_st2_sel,
    // Twidle factor address
    output reg      rom_addr,
    // Determine that the output is valid from butterfly
    output reg      valid
);

    // =========================================================
    // Counter
    // =========================================================
    // =====================================================
    // Counter determine the state
    // counter starts when stage 1 start sending valid values
    // count = current Stage-3 input sample position
    // =====================================================

    reg [3:0] count;


    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            count <= 4'd0;
        end

        else if (count != 4'd0) begin
            // Once Stage 3 starts, continue for the
            // entire 16-clock processing sequence.
            count <= count + 1'b1;
        end

        else if (stage2_valid) begin
            // Start Stage 3 when the first Stage-2
            // butterfly output arrives.
            count <= count + 1'b1;
        end

    end

    // =========================================================
    // MUX selections
    // =========================================================
    // =========================================================
    // Stage-2 output source select
    //
    // count 0-3:
    //      Stage-2 butterfly
    //
    // count 4-7:
    //      Stage-2 SR4
    //
    // count 8-11:
    //      Stage-2 butterfly
    //
    // count 12-15:
    //      Stage-2 SR4
    //
    // Pattern:
    //
    // 1111 0000 1111 0000
    //
    // This is exactly ~count[2].
    // =========================================================
    // =========================================================
    // SR2 feedback select
    //
    // count 0-1:
    //      Stage-2 data -> SR2
    //
    // count 2-3:
    //      BF3 DIFF -> SR2
    //
    // count 4-5:
    //      Stage-2 data -> SR2
    //
    // count 6-7:
    //      BF3 DIFF -> SR2
    //
    // etc.
    //
    // Pattern:
    //
    // 0011 0011 0011 0011
    //
    // This is exactly count[1].
    // =========================================================
    
    assign out_st2_sel = ~count[2];
    assign SR_sel = count[1];

    // =====================================================
    // ROM address + valid
    // =====================================================

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            rom_addr <= 1'b0;
            valid    <= 1'b0;

        end

        else begin

            case (count)

                // =============================================
                // Butterfly group 0
                // =============================================

                4'd1: begin
                    rom_addr <= 1'b0;
                    valid    <= 1'b1;
                end


                4'd2: begin
                    rom_addr <= 1'b1;
                    valid    <= 1'b1;
                end


                // =============================================
                // Butterfly group 1
                // =============================================

                4'd5: begin
                    rom_addr <= 1'b0;
                    valid    <= 1'b1;
                end


                4'd6: begin
                    rom_addr <= 1'b1;
                    valid    <= 1'b1;
                end


                // =============================================
                // Butterfly group 2
                // =============================================

                4'd9: begin
                    rom_addr <= 1'b0;
                    valid    <= 1'b1;
                end


                4'd10: begin
                    rom_addr <= 1'b1;
                    valid    <= 1'b1;
                end


                // =============================================
                // Butterfly group 3
                // =============================================

                4'd13: begin
                    rom_addr <= 1'b0;
                    valid    <= 1'b1;
                end


                4'd14: begin
                    rom_addr <= 1'b1;
                    valid    <= 1'b1;
                end


                // =============================================
                // Non-butterfly cycles
                // =============================================

                default: begin
                    rom_addr <= 1'b0;
                    valid    <= 1'b0;
                end

            endcase

        end

    end


endmodule
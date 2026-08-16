module DIF_Stage2_CU (
    input  wire       clk,
    input  wire       rst_n,
    // start counter signal
    input  wire       stage1_valid,
    //MUXs sel
    output wire       SR_sel,
    output wire       out_st1_sel,
    // Twidle factor address in ROM
    output reg [1:0]  rom_addr,
    // Determine that the output is valid from butterfly
    output reg        valid
);

reg [3:0] count;

    // =====================================================
    // Counter determine the state
    // counter starts when stage 1 start sending valid values
    // count = current Stage-2 input sample position
    // 0  -> S0
    // 1  -> S1
    // ...
    // 15 -> D7
    // then wraps to 0
    // =====================================================

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            count <= 4'd0;
        end

        else if (count != 0) begin
            count <= count + 1'b1;
        end

        else if (stage1_valid) begin
            count <= count + 1'b1;
        end

    end


    // =====================================================
    // MUX selections
    // =====================================================
    //
    // 0-3:
    //     Shift Regs gets Stage-1 Butterfly SUM
    //
    // 4-7:
    //     Shift Regs gets Butterfly DIFF 
    //
    // 8-11:
    //     Shift Regs gets From shift regs os stage1
    //
    // 12-15:
    //      Shift Regs gets Butterfly DIFF 
    // =====================================================

    assign SR_sel =
        (count >= 4'd4 && count <= 4'd7)  ||
        (count >= 4'd12 && count <= 4'd15);

    assign out_st1_sel = (count <= 4'd7);


    // =====================================================
    // ROM address + valid
    // =====================================================

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            rom_addr <= 2'd0;
            valid    <= 1'b0;

        end

        else begin

                // First butterfly group: cycles 4-7
                if ((count >= 4'd3) && (count <= 4'd6)) begin

                    rom_addr <= count - 4'd3;
                    valid    <= 1'b1;

                end

                // Second butterfly group: cycles 12-15
                else if ((count >= 4'd11) && (count <= 4'd14)) begin

                    rom_addr <= count - 4'd11;
                    valid    <= 1'b1;

                end

                // Shift-REGs-only periods
                else begin

                    rom_addr <= 2'd0;
                    valid    <= 1'b0;

                end

        end

            

    end

endmodule
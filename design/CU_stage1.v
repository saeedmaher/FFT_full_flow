module DIF_Stage1_CU (
    input  wire       clk,
    input  wire       rst_n,
    // Start of the FFT
    input  wire       in_valid,
    // Input to shift reg sel
    output wire        mux_sel,
    // Twidle factor address in ROM
    output reg [2:0]  rom_addr,
    // Determine that the output is valid from butterfly
    output reg        valid
);

    // =====================================================
    // Counter
    // count represents the CURRENT input sample.
    // first valid  -> 0
    // next         -> 1
    // ...
    //              -> 15
    // next         -> 0
    // =====================================================

    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            count <= 4'd0;
        end

        else if (in_valid) begin
            count <= count + 1'b1;
        end

    end


    // =====================================================
    // Sel + Address + Valid
    // =====================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_addr <= 0;
            valid <= 0;
        end
        else begin
                if (count == 4'd15) begin
                    rom_addr <= 0;
                    valid <= 1'b0;
                end 
                else if (count >= 4'd7) begin
                    rom_addr <= count - 4'd7;
                    valid <= 1'b1;
                end     
        end
    end

    assign mux_sel = (count >= 4'd8)? 1:0;

endmodule
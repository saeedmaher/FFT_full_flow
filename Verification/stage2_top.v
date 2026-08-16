module DIF_R2SDF_Stage2 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    // =====================================================
    // Inputs
    // =====================================================

    // Stage-1 butterfly SUM
    input wire signed [DATA_WIDTH-1:0] st1_sum_re,
    input wire signed [DATA_WIDTH-1:0] st1_sum_im,

    // Stage-1 SR8 output
    input wire signed [DATA_WIDTH-1:0] st1_SR_re,
    input wire signed [DATA_WIDTH-1:0] st1_SR_im,

    // Stage-1 valid
    input wire st1_valid,

    // =====================================================
    // Outputs
    // =====================================================
    output wire signed [DATA_WIDTH-1:0] SR_out_re,
    output wire signed [DATA_WIDTH-1:0] SR_out_im,
    
    output wire signed [DATA_WIDTH-1:0] sum_re,
    output wire signed [DATA_WIDTH-1:0] sum_im,

    output wire valid
);

    // =====================================================
    // INTERNAL SIGNALS
    // =====================================================

    // -----------------------------------------------------
    // Control signals
    // -----------------------------------------------------

    wire SR_sel;
    wire out_st1_sel;
    wire signed [DATA_WIDTH-1:0] bf2_b_re;
    wire signed [DATA_WIDTH-1:0] bf2_b_im;

    // -----------------------------------------------------
    // ROM
    // -----------------------------------------------------

    wire [1:0] rom_addr;

    wire signed [DATA_WIDTH-1:0] w_re;
    wire signed [DATA_WIDTH-1:0] w_im;

    // -----------------------------------------------------
    // SR4
    // -----------------------------------------------------

    wire signed [DATA_WIDTH-1:0] SR4_din_re;
    wire signed [DATA_WIDTH-1:0] SR4_din_im;

    wire signed [DATA_WIDTH-1:0] SR4_dout_re;
    wire signed [DATA_WIDTH-1:0] SR4_dout_im;

    // -----------------------------------------------------
    // Butterfly difference
    // -----------------------------------------------------

    wire signed [DATA_WIDTH-1:0] bf2_diff_re;
    wire signed [DATA_WIDTH-1:0] bf2_diff_im;


    // =====================================================
    // CONTROL UNIT
    // =====================================================

    DIF_Stage2_CU CU (
        .clk(clk),
        .rst_n(rst_n),

        .stage1_valid(st1_valid),

        .SR_sel(SR_sel),
        .out_st1_sel(out_st1_sel),

        .rom_addr(rom_addr),
        .valid(valid)
    );


    // =====================================================
    // TWIDDLE ROM
    // =====================================================

    Twiddle_ROM_Stage2 ROM (
        .addr(rom_addr),
        .w_re(w_re),
        .w_im(w_im)
    );


    // =====================================================
    // SR4 INPUT MUX
    // =====================================================

    ShiftREG4_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR4_MUX (
        .SR_sel(SR_sel),
        .out_st1_sel(out_st1_sel),
        .BF_re(st1_sum_re),
        .BF_im(st1_sum_im),
        .SR_re(st1_SR_re),
        .SR_im(st1_SR_im),
        .diff_re(bf2_diff_re),
        .diff_im(bf2_diff_im),
        .SR_din_re(SR4_din_re),
        .SR_din_im(SR4_din_im)
    );


    // =====================================================
    // Shift REG 4
    // =====================================================

    shift_register_4 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR4 (
        .clk(clk),
        .rst_n(rst_n),
        .din_re(SR4_din_re),
        .din_im(SR4_din_im),
        .dout_re(SR4_dout_re),
        .dout_im(SR4_dout_im)
    );

    // =====================================================
    // STAGE-2 BUTTERFLY
    // =====================================================

    DIF_Butterfly_St2 #(
        .IN_WIDTH(DATA_WIDTH),
        .W_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(DATA_WIDTH)
    ) BUTTERFLY2 (
        .a_re(SR4_dout_re),
        .a_im(SR4_dout_im),
        .b_re(bf2_b_re),
        .b_im(bf2_b_im),
        .w_re(w_re),
        .w_im(w_im),
        .sum_re(sum_re),
        .sum_im(sum_im),
        .diff_re(bf2_diff_re),
        .diff_im(bf2_diff_im)
    );

    // =====================================================
    // STAGE-2 BUTTERFLY input B MUX
    // =====================================================
    BF2_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) BF2_MUX (
        .out_st1_sel(out_st1_sel),
        .sum_re(st1_sum_re),
        .sum_im(st1_sum_im),
        .SR_re(st1_SR_re),
        .SR_im(st1_SR_im),
        .bf2_b_re(bf2_b_re),
        .bf2_b_im(bf2_b_im)
    );
    
    // =====================================================
    // Outputs external
    // =====================================================
    
    assign SR_out_re = SR4_dout_re;
    assign SR_out_im = SR4_dout_im;

endmodule
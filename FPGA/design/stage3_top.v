module DIF_R2SDF_Stage3 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    // =====================================================
    // Inputs
    // =====================================================

    // Stage-2 butterfly SUM output
    input wire signed [DATA_WIDTH-1:0] st2_sum_re,
    input wire signed [DATA_WIDTH-1:0] st2_sum_im,

    // Stage-2 SR4 output
    input wire signed [DATA_WIDTH-1:0] st2_SR_re,
    input wire signed [DATA_WIDTH-1:0] st2_SR_im,

    // Stage-2 butterfly valid
    input wire st2_valid,

    // =====================================================
    // Outputs
    // =====================================================
    //SUM
    output wire signed [DATA_WIDTH-1:0] sum_re,
    output wire signed [DATA_WIDTH-1:0] sum_im,
    //DIFF
    output wire signed [DATA_WIDTH-1:0] diff_re,
    output wire signed [DATA_WIDTH-1:0] diff_im,
    // Stage-3 SR2 output
    output wire signed [DATA_WIDTH-1:0] SR_out_re,
    output wire signed [DATA_WIDTH-1:0] SR_out_im,
    //valid
    output wire valid
);


    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    // ---------------------------------------------------------
    // CU controls
    // ---------------------------------------------------------
    wire SR_sel;
    wire out_st2_sel;
    wire rom_addr;


    // ---------------------------------------------------------
    // Twiddle
    // ---------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] w_re;
    wire signed [DATA_WIDTH-1:0] w_im;


    // ---------------------------------------------------------
    // SR2 input
    // ---------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] SR2_din_re;
    wire signed [DATA_WIDTH-1:0] SR2_din_im;


    // ---------------------------------------------------------
    // SR2 output
    // ---------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] SR2_dout_re;
    wire signed [DATA_WIDTH-1:0] SR2_dout_im;


    // ---------------------------------------------------------
    // BF3 B input
    // ---------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] bf3_b_re;
    wire signed [DATA_WIDTH-1:0] bf3_b_im;


    // ---------------------------------------------------------
    // BF3 difference feedback
    // ---------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] bf3_diff_re;
    wire signed [DATA_WIDTH-1:0] bf3_diff_im;


    // =========================================================
    // CONTROL UNIT
    // =========================================================
    DIF_Stage3_CU CU (
        .clk(clk),
        .rst_n(rst_n),
        .stage2_valid(st2_valid),
        .SR_sel(SR_sel),
        .out_st2_sel(out_st2_sel),
        .rom_addr(rom_addr),
        .valid(valid)
    );


    // =========================================================
    // TWIDDLE ROM
    // =========================================================

    Twiddle_ROM_Stage3 ROM (
        .addr(rom_addr),
        .w_re(w_re),
        .w_im(w_im)
    );


    // =========================================================
    // BUTTERFLY-3 B INPUT MUX
    // =========================================================

    BF3_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) BF3_INPUT_MUX (
        .out_st2_sel(out_st2_sel),
        // Stage-2 butterfly output
        .sum_re(st2_sum_re),
        .sum_im(st2_sum_im),
        // Stage-2 SR4 output
        .SR_re(st2_SR_re),
        .SR_im(st2_SR_im),
        // BF3 B
        .bf3_b_re(bf3_b_re),
        .bf3_b_im(bf3_b_im)
    );


    // =========================================================
    // SR2 INPUT MUX
    // =========================================================

    ShiftREG2_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR2_MUX (
        .SR_sel(SR_sel),
        .out_st2_sel(out_st2_sel),
        // Stage-2 butterfly output
        .BF_re(st2_sum_re),
        .BF_im(st2_sum_im),
        // Stage-2 SR4 output
        .SR_re(st2_SR_re),
        .SR_im(st2_SR_im),
        // BF3 difference feedback
        .diff_re(bf3_diff_re),
        .diff_im(bf3_diff_im),
        // SR2 input
        .SR_din_re(SR2_din_re),
        .SR_din_im(SR2_din_im)
    );


    // =========================================================
    // Shift REG 2
    // =========================================================

    shift_register_2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR2 (
        .clk(clk),
        .rst_n(rst_n),
        .stage2_valid(st2_valid),
        .din_re(SR2_din_re),
        .din_im(SR2_din_im),
        .dout_re(SR2_dout_re),
        .dout_im(SR2_dout_im)
    );


    // =========================================================
    // STAGE-3 BUTTERFLY
    // =========================================================

    DIF_Butterfly_St3 #(
        .IN_WIDTH(DATA_WIDTH),
        .W_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(DATA_WIDTH)
    ) BUTTERFLY3 (
        .a_re(SR2_dout_re),
        .a_im(SR2_dout_im),
        .b_re(bf3_b_re),
        .b_im(bf3_b_im),
        .w_re(w_re),
        .w_im(w_im),
        .sum_re(sum_re),
        .sum_im(sum_im),
        .diff_re(bf3_diff_re),
        .diff_im(bf3_diff_im)
    );


    // =========================================================
    // Stage-3 DIFF output
    // =========================================================

    assign diff_re = bf3_diff_re;
    assign diff_im = bf3_diff_im;


    // =========================================================
    // Expose SR2 output
    // =========================================================

    assign SR_out_re = SR2_dout_re;
    assign SR_out_im = SR2_dout_im;


endmodule
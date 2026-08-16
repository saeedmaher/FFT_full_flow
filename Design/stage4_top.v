module DIF_R2SDF_Stage4 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    // =====================================================
    // Stage-3 inputs
    // Q4.8
    // =====================================================

    // Stage-3 butterfly SUM output
    input wire signed [DATA_WIDTH-1:0] st3_sum_re,
    input wire signed [DATA_WIDTH-1:0] st3_sum_im,

    // Stage-3 SR2 output
    input wire signed [DATA_WIDTH-1:0] st3_SR_re,
    input wire signed [DATA_WIDTH-1:0] st3_SR_im,

    // Stage-3 butterfly valid
    input wire st3_valid,

    // =====================================================
    // Stage-4 outputs
    // Q5.7
    // =====================================================
    // SUM
    output wire signed [DATA_WIDTH-1:0] sum_re,
    output wire signed [DATA_WIDTH-1:0] sum_im,
    // valid
    output wire valid,
    // Shift REG
    output wire signed [DATA_WIDTH-1:0] SR_out_re,
    output wire signed [DATA_WIDTH-1:0] SR_out_im,
    // Final valid
    output wire out_valid
);


    // =========================================================
    // Internal sel
    // =========================================================

    wire SR_sel;
    wire out_st3_sel;


    // =========================================================
    // Shift REG 1
    // =========================================================

    wire signed [DATA_WIDTH-1:0] SR1_din_re;
    wire signed [DATA_WIDTH-1:0] SR1_din_im;

    wire signed [DATA_WIDTH-1:0] SR1_dout_re;
    wire signed [DATA_WIDTH-1:0] SR1_dout_im;


    // =========================================================
    // Butterfly-4 B input
    // =========================================================

    wire signed [DATA_WIDTH-1:0] bf4_b_re;
    wire signed [DATA_WIDTH-1:0] bf4_b_im;


    // =========================================================
    // Butterfly-4 difference feedback
    // =========================================================

    wire signed [DATA_WIDTH-1:0] bf4_diff_re;
    wire signed [DATA_WIDTH-1:0] bf4_diff_im;

    // =========================================================
    // CU-4 final valid
    // =========================================================
    wire out_valid_wire;

    // =========================================================
    // CONTROL UNIT
    // =========================================================

    DIF_Stage4_CU CU (
        .clk(clk),
        .rst_n(rst_n),
        .stage3_valid(st3_valid),
        .SR_sel(SR_sel),
        .out_st3_sel(out_st3_sel),
        .valid(valid),
        .out_valid(out_valid_wire)
    );


    // =========================================================
    // BUTTERFLY-4 B INPUT MUX
    // =========================================================

    BF4_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) BF4_INPUT_MUX (

        .out_st3_sel(out_st3_sel),

        .sum_re(st3_sum_re),
        .sum_im(st3_sum_im),

        .SR_re(st3_SR_re),
        .SR_im(st3_SR_im),

        .bf4_b_re(bf4_b_re),
        .bf4_b_im(bf4_b_im)

    );


    // =========================================================
    // Shift I/P MUX
    // =========================================================

    ShiftREG1_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR1_MUX (
        .SR_sel(SR_sel),
        .out_st3_sel(out_st3_sel),
        .BF_re(st3_sum_re),
        .BF_im(st3_sum_im),

        .SR_re(st3_SR_re),
        .SR_im(st3_SR_im),

        .diff_re(bf4_diff_re),
        .diff_im(bf4_diff_im),

        .SR_din_re(SR1_din_re),
        .SR_din_im(SR1_din_im)

    );


    // =========================================================
    // Shift REG 1
    // =========================================================

    shift_register_1 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR1 (

        .clk(clk),
        .rst_n(rst_n),

        .din_re(SR1_din_re),
        .din_im(SR1_din_im),

        .dout_re(SR1_dout_re),
        .dout_im(SR1_dout_im)

    );


    // =========================================================
    // STAGE-4 BUTTERFLY
    // =========================================================

    DIF_Butterfly_St4 #(
        .IN_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(DATA_WIDTH)
    ) BUTTERFLY4 (

        .a_re(SR1_dout_re),
        .a_im(SR1_dout_im),

        .b_re(bf4_b_re),
        .b_im(bf4_b_im),

        .sum_re(sum_re),
        .sum_im(sum_im),

        .diff_re(bf4_diff_re),
        .diff_im(bf4_diff_im)

    );

    // =========================================================
    // Shift REG output
    // =========================================================

    assign SR_out_re = SR1_dout_re;
    assign SR_out_im = SR1_dout_im;

    assign out_valid = out_valid_wire;
endmodule
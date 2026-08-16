module DIF_R2SDF_top #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    // FFT INPUT
    input wire signed [DATA_WIDTH-1:0] din_re,
    input wire signed [DATA_WIDTH-1:0] din_im,
    input wire in_valid,
    //serial FFT OUTPUT
    output wire signed [DATA_WIDTH-1:0] dout_re,
    output wire signed [DATA_WIDTH-1:0] dout_im,
    // Out valid
    output wire out_valid
);


    // =========================================================
    // STAGE 1 INTERNAL SIGNALS
    // =========================================================

    wire signed [DATA_WIDTH-1:0] st1_sum_re;
    wire signed [DATA_WIDTH-1:0] st1_sum_im;

    //wire signed [DATA_WIDTH-1:0] st1_diff_re;
    //wire signed [DATA_WIDTH-1:0] st1_diff_im;

    wire signed [DATA_WIDTH-1:0] st1_delay_re;
    wire signed [DATA_WIDTH-1:0] st1_delay_im;

    wire st1_valid;


    // =========================================================
    // STAGE 2 INTERNAL SIGNALS
    // =========================================================

    wire signed [DATA_WIDTH-1:0] st2_sum_re;
    wire signed [DATA_WIDTH-1:0] st2_sum_im;

//    wire signed [DATA_WIDTH-1:0] st2_diff_re;
  //  wire signed [DATA_WIDTH-1:0] st2_diff_im;

    wire signed [DATA_WIDTH-1:0] st2_delay_re;
    wire signed [DATA_WIDTH-1:0] st2_delay_im;

    wire st2_valid;


    // =========================================================
    // STAGE 3 INTERNAL SIGNALS
    // =========================================================

    wire signed [DATA_WIDTH-1:0] st3_sum_re;
    wire signed [DATA_WIDTH-1:0] st3_sum_im;

    //wire signed [DATA_WIDTH-1:0] st3_diff_re;
    //wire signed [DATA_WIDTH-1:0] st3_diff_im;

    wire signed [DATA_WIDTH-1:0] st3_delay_re;
    wire signed [DATA_WIDTH-1:0] st3_delay_im;

    wire st3_valid;


    // =========================================================
    // STAGE 4 INTERNAL SIGNALS
    // =========================================================

    wire signed [DATA_WIDTH-1:0] st4_sum_re;
    wire signed [DATA_WIDTH-1:0] st4_sum_im;

    //wire signed [DATA_WIDTH-1:0] st4_diff_re;
    //wire signed [DATA_WIDTH-1:0] st4_diff_im;

    wire signed [DATA_WIDTH-1:0] st4_delay_re;
    wire signed [DATA_WIDTH-1:0] st4_delay_im;

    wire st4_valid;

    // =========================================================
    // STAGE 1
    // =========================================================

    DIF_R2SDF_Stage1 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) STAGE1 (
        .clk(clk),
        .rst_n(rst_n),
        .din_re(din_re),
        .din_im(din_im),
        .in_valid(in_valid),
        .sum_re(st1_sum_re),
        .sum_im(st1_sum_im),
      //  .diff_re(st1_diff_re),
        //.diff_im(st1_diff_im),
        .SR_out_re(st1_delay_re),
        .SR_out_im(st1_delay_im),
        .valid(st1_valid)
    );


    // =========================================================
    // STAGE 2
    // =========================================================

    DIF_R2SDF_Stage2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) STAGE2 (
        .clk(clk),
        .rst_n(rst_n),
        // Stage-1 butterfly SUM
        .st1_sum_re(st1_sum_re),
        .st1_sum_im(st1_sum_im),
        // Stage-1 delay-line output
        .st1_SR_re(st1_delay_re),
        .st1_SR_im(st1_delay_im),
        .st1_valid(st1_valid),
        .sum_re(st2_sum_re),
        .sum_im(st2_sum_im),
//        .diff_re(st2_diff_re),
  //      .diff_im(st2_diff_im),
        .SR_out_re(st2_delay_re),
        .SR_out_im(st2_delay_im),
        .valid(st2_valid)
    );


    // =========================================================
    // STAGE 3
    // =========================================================

    DIF_R2SDF_Stage3 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) STAGE3 (
        .clk(clk),
        .rst_n(rst_n),
        // Stage-2 butterfly SUM
        .st2_sum_re(st2_sum_re),
        .st2_sum_im(st2_sum_im),
        // Stage-2 delay-line output
        .st2_SR_re(st2_delay_re),
        .st2_SR_im(st2_delay_im),
        .st2_valid(st2_valid),
        .sum_re(st3_sum_re),
        .sum_im(st3_sum_im),
    //    .diff_re(st3_diff_re),
      //  .diff_im(st3_diff_im),
        .SR_out_re(st3_delay_re),
        .SR_out_im(st3_delay_im),
        .valid(st3_valid)
    );


    // =========================================================
    // STAGE 4
    // =========================================================

    DIF_R2SDF_Stage4 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) STAGE4 (
        .clk(clk),
        .rst_n(rst_n),
        // Stage-3 butterfly SUM
        .st3_sum_re(st3_sum_re),
        .st3_sum_im(st3_sum_im),
        // Stage-3 delay-line output
        .st3_SR_re(st3_delay_re),
        .st3_SR_im(st3_delay_im),
        .st3_valid(st3_valid),
        .sum_re(st4_sum_re),
        .sum_im(st4_sum_im),
        //.diff_re(st4_diff_re),
        //.diff_im(st4_diff_im),
        .SR_out_re(st4_delay_re),
        .SR_out_im(st4_delay_im),
        .valid(st4_valid),
        .out_valid(out_valid)        
    );

    // ---------------------------------------------------------
    // Final FFT output MUX
    //
    // Butterfly cycle:
    //      output SUM
    //
    // Following cycle:
    //      output SR1 output = previous DIFF
    // ---------------------------------------------------------

    assign dout_re = st4_valid ? st4_sum_re : st4_delay_re;
    assign dout_im = st4_valid ? st4_sum_im : st4_delay_im;

//=====================================================================
// assertions
//=====================================================================

// Reset
always_comb begin
    if(!rst_n) begin
        reset_assertion: assert final(dout_re == 0 && out_valid == 0);
        reset_cover: assert final(dout_re == 0 && out_valid == 0);
    end
end

// Out Valid
property Output_Validation_assert;
	@(posedge clk) disable iff(!rst_n)
	(in_valid) |=> ##15 (out_valid); 
endproperty

assert property (Output_Validation_assert);
cover property (Output_Validation_assert);



endmodule
module DIF_Butterfly_St1 #(
    parameter IN_WIDTH  = 12,
    parameter W_WIDTH   = 12,
    parameter OUT_WIDTH = 12
)(
    // A Q4.8
    input wire signed [IN_WIDTH-1:0] a_re,
    input wire signed [IN_WIDTH-1:0] a_im,

    // B Q4.8
    input wire signed [IN_WIDTH-1:0] b_re,
    input wire signed [IN_WIDTH-1:0] b_im,

    // Twiddle factor Q2.10
    input wire signed [W_WIDTH-1:0] w_re,
    input wire signed [W_WIDTH-1:0] w_im,

    // S1 Q5.7
    output wire signed [OUT_WIDTH-1:0] sum_re,
    output wire signed [OUT_WIDTH-1:0] sum_im,
    output wire signed [OUT_WIDTH-1:0] diff_re,
    output wire signed [OUT_WIDTH-1:0] diff_im
);


    // =========================================================
    // FULL-PRECISION ADDITION/Subtraction
    // Q4.8 + Q4.8 -> Q5.8
    // One extra integer bit is required 
    // 12-bit inputs -> 13-bit result.
    // =========================================================

    wire signed [IN_WIDTH:0] add_re;
    wire signed [IN_WIDTH:0] add_im;


    assign add_re = {a_re[IN_WIDTH-1], a_re} + {b_re[IN_WIDTH-1], b_re};
    assign add_im = {a_im[IN_WIDTH-1], a_im} + {b_im[IN_WIDTH-1], b_im};

    wire signed [IN_WIDTH:0] sub_re;
    wire signed [IN_WIDTH:0] sub_im;


    assign sub_re = {a_re[IN_WIDTH-1], a_re} - {b_re[IN_WIDTH-1], b_re};
    assign sub_im = {a_im[IN_WIDTH-1], a_im} - {b_im[IN_WIDTH-1], b_im};

    // =========================================================
    // Casting point representation
    // Q5.8 ~> Q5.7
    // Fraction bits: 8 -> 7
    // RoundingMethod = Floor
    // =========================================================

    wire signed [IN_WIDTH:0] scaled_sum_re;
    wire signed [IN_WIDTH:0] scaled_sum_im;

    wire signed [IN_WIDTH:0] scaled_sub_re;
    wire signed [IN_WIDTH:0] scaled_sub_im;


    assign scaled_sum_re = add_re >>> 1;
    assign scaled_sum_im = add_im >>> 1;

    assign scaled_sub_re = sub_re >>> 1;
    assign scaled_sub_im = sub_im >>> 1;


    // =========================================================
    // WRAP TO 12-BIT Q5.7
    // OverflowAction = Wrap
    // Therefore retain the lower 12 bits.
    // =========================================================

    wire signed [OUT_WIDTH-1:0] sum_q57_re;
    wire signed [OUT_WIDTH-1:0] sum_q57_im;

    wire signed [OUT_WIDTH-1:0] diff_q57_re;
    wire signed [OUT_WIDTH-1:0] diff_q57_im;


    assign sum_q57_re = scaled_sum_re[OUT_WIDTH-1:0];

    assign sum_q57_im = scaled_sum_im[OUT_WIDTH-1:0];


    assign diff_q57_re = scaled_sub_re[OUT_WIDTH-1:0];

    assign diff_q57_im = scaled_sub_im[OUT_WIDTH-1:0];


    // =========================================================
    // SUM OUTPUT
    // Already Q5.7.
    // =========================================================

    assign sum_re = sum_q57_re;
    assign sum_im = sum_q57_im;


    // =========================================================
    // COMPLEX MULTIPLICATION
    // (a_re + j*a_im) * (b_re + j*b_im) =
    // M_re = a_re * b_re - a_im * b_im
    // M_im = a_im * b_re + a_re * b_im
    // Full-precision individual product: 12 x 12 = 24 bits
    // Q5.7 x Q2.10 ~> Q7.17 then addition ~> Q8.17
    // =========================================================

    wire signed [23:0] mult_re_re;
    wire signed [23:0] mult_im_im;
    wire signed [23:0] mult_re_im;
    wire signed [23:0] mult_im_re;

    assign mult_re_re = diff_q57_re * w_re;
    assign mult_im_im = diff_q57_im * w_im;
    assign mult_re_im = diff_q57_re * w_im;
    assign mult_im_re = diff_q57_im * w_re;


    wire signed [24:0] mult_result_re;
    wire signed [24:0] mult_result_im;


    assign mult_result_re = {mult_re_re[23], mult_re_re} - {mult_im_im[23], mult_im_im};
    assign mult_result_im = {mult_re_im[23], mult_re_im} + {mult_im_re[23], mult_im_re};


    // =========================================================
    // CAST COMPLEX PRODUCT BACK TO Q5.7
    // Fraction: 17 ~> 7
    // MATLAB RoundingMethod = Floor
    // Therefore arithmetic >>> 10.
    // =========================================================

    wire signed [24:0] scaled_result_re;
    wire signed [24:0] scaled_result_im;

    assign scaled_result_re = mult_result_re >>> 10;
    assign scaled_result_im = mult_result_im >>> 10;


    // =========================================================
    // WRAP TO Q5.7
    // OverflowAction = Wrap
    // Retain lower 12 bits.
    // =========================================================

    assign diff_re = scaled_result_re[OUT_WIDTH-1:0];

    assign diff_im = scaled_result_im[OUT_WIDTH-1:0];


endmodule
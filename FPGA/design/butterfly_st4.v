module DIF_Butterfly_St4 #(
    parameter IN_WIDTH  = 12,   // Q5.7
    parameter OUT_WIDTH = 12    // Q6.6
)(
    input wire signed [IN_WIDTH-1:0] a_re,
    input wire signed [IN_WIDTH-1:0] a_im,

    input wire signed [IN_WIDTH-1:0] b_re,
    input wire signed [IN_WIDTH-1:0] b_im,

    output wire signed [OUT_WIDTH-1:0] sum_re,
    output wire signed [OUT_WIDTH-1:0] sum_im,

    output wire signed [OUT_WIDTH-1:0] diff_re,
    output wire signed [OUT_WIDTH-1:0] diff_im
);


    // =========================================================
    // Full-precision addition/subtraction
    // Q5.7 +/- Q5.7 ~> Q6.7
    // One additional integer bit is required.
    // 12-bit inputs -> 13-bit full-precision result.
    // =========================================================

    wire signed [IN_WIDTH:0] add_re;
    wire signed [IN_WIDTH:0] add_im;

    wire signed [IN_WIDTH:0] sub_re;
    wire signed [IN_WIDTH:0] sub_im;


    assign add_re =
        {a_re[IN_WIDTH-1], a_re}
        +
        {b_re[IN_WIDTH-1], b_re};


    assign add_im =
        {a_im[IN_WIDTH-1], a_im}
        +
        {b_im[IN_WIDTH-1], b_im};


    assign sub_re =
        {a_re[IN_WIDTH-1], a_re}
        -
        {b_re[IN_WIDTH-1], b_re};


    assign sub_im =
        {a_im[IN_WIDTH-1], a_im}
        -
        {b_im[IN_WIDTH-1], b_im};


    // =========================================================
    // Casting to signed 12-bit Q6.6
    // Q6.7 ~> 6.6 
    // Therefore remove one fractional bit.
    // RoundingMethod = Floor
    // Arithmetic >>> 1 reproduces Floor for signed
    // =========================================================

    wire signed [IN_WIDTH:0] scaled_sum_re;
    wire signed [IN_WIDTH:0] scaled_sum_im;

    wire signed [IN_WIDTH:0] scaled_diff_re;
    wire signed [IN_WIDTH:0] scaled_diff_im;


    assign scaled_sum_re =
        add_re >>> 1;

    assign scaled_sum_im =
        add_im >>> 1;


    assign scaled_diff_re =
        sub_re >>> 1;

    assign scaled_diff_im =
        sub_im >>> 1;


    // =========================================================
    // Final Q6.6 wrap
    // OverflowAction = Wrap
    // Keep lower 12 bits.
    // =========================================================

    assign sum_re =
        scaled_sum_re[OUT_WIDTH-1:0];

    assign sum_im =
        scaled_sum_im[OUT_WIDTH-1:0];


    assign diff_re =
        scaled_diff_re[OUT_WIDTH-1:0];

    assign diff_im =
        scaled_diff_im[OUT_WIDTH-1:0];


endmodule
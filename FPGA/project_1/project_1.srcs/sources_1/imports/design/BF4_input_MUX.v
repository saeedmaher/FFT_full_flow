module BF4_input_MUX #(
    parameter DATA_WIDTH = 12
)(
    input wire out_st3_sel,

    // Stage-3 SUM
    input wire signed [DATA_WIDTH-1:0] sum_re,
    input wire signed [DATA_WIDTH-1:0] sum_im,

    // Stage-3 SR2 output
    input wire signed [DATA_WIDTH-1:0] SR_re,
    input wire signed [DATA_WIDTH-1:0] SR_im,

    // Butterfly-4 B input
    output wire signed [DATA_WIDTH-1:0] bf4_b_re,
    output wire signed [DATA_WIDTH-1:0] bf4_b_im
);

assign bf4_b_re = out_st3_sel ? sum_re : SR_re;

assign bf4_b_im = out_st3_sel ? sum_im : SR_im;

endmodule
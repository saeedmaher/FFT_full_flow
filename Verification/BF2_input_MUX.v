module BF2_input_MUX #(
    parameter DATA_WIDTH = 12
)(
    input wire out_st1_sel,

    // Stage-1 SUM
    input wire signed [DATA_WIDTH-1:0] sum_re,
    input wire signed [DATA_WIDTH-1:0] sum_im,

    // Stage-1 SR8 output
    input wire signed [DATA_WIDTH-1:0] SR_re,
    input wire signed [DATA_WIDTH-1:0] SR_im,

    // Butterfly-2 B input
    output wire signed [DATA_WIDTH-1:0] bf2_b_re,
    output wire signed [DATA_WIDTH-1:0] bf2_b_im
);

assign bf2_b_re = out_st1_sel ? sum_re : SR_re;

assign bf2_b_im = out_st1_sel ? sum_im : SR_im;

endmodule
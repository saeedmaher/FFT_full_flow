module BF3_input_MUX #(
    parameter DATA_WIDTH = 12
)(
    input wire out_st2_sel,

    // Stage-2 SUM
    input wire signed [DATA_WIDTH-1:0] sum_re,
    input wire signed [DATA_WIDTH-1:0] sum_im,

    // Stage-2 SR4 output
    input wire signed [DATA_WIDTH-1:0] SR_re,
    input wire signed [DATA_WIDTH-1:0] SR_im,

    // Butterfly-3 B input
    output wire signed [DATA_WIDTH-1:0] bf3_b_re,
    output wire signed [DATA_WIDTH-1:0] bf3_b_im
);

assign bf3_b_re = out_st2_sel ? sum_re : SR_re;

assign bf3_b_im = out_st2_sel ? sum_im : SR_im;

endmodule
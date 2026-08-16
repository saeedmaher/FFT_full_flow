module ShiftREG4_input_MUX #(
    parameter DATA_WIDTH = 12 
) (
    // selections
    input wire SR_sel,
    input wire out_st1_sel,
    // Stage1 data either from butterfly or SR8
    input wire signed [DATA_WIDTH-1:0] BF_re,
    input wire signed [DATA_WIDTH-1:0] BF_im,
    input wire signed [DATA_WIDTH-1:0] SR_re,
    input wire signed [DATA_WIDTH-1:0] SR_im,
    // Butterfly2 difference output
    input wire signed [DATA_WIDTH-1:0] diff_re,
    input wire signed [DATA_WIDTH-1:0] diff_im,
    // SR input
    output wire signed [DATA_WIDTH-1:0] SR_din_re,
    output wire signed [DATA_WIDTH-1:0] SR_din_im
);

    assign SR_din_re = (SR_sel)?    diff_re:
                         (out_st1_sel)? BF_re:SR_re;

    assign SR_din_im = (SR_sel)?    diff_im:
                         (out_st1_sel)? BF_im:SR_im;

endmodule
module ShiftREG8_input_MUX #(
    parameter DATA_WIDTH = 12
)(
    //selection
    input wire SR_sel,
    // External FFT input
    input wire signed [DATA_WIDTH-1:0] din_re,
    input wire signed [DATA_WIDTH-1:0] din_im,
    // Butterfly difference output
    input wire signed [DATA_WIDTH-1:0] diff_re,
    input wire signed [DATA_WIDTH-1:0] diff_im,
    // SR input
    output wire signed [DATA_WIDTH-1:0] SR_din_re,
    output wire signed [DATA_WIDTH-1:0] SR_din_im
);

    assign SR_din_re = (SR_sel)? diff_re : din_re;
    assign SR_din_im = (SR_sel)? diff_im : din_im;

endmodule
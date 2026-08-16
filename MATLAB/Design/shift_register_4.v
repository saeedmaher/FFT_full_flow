module shift_register_4 #(
    parameter DATA_WIDTH = 12
)(
    input  wire clk,
    input  wire rst_n,


    // Complex input
    input  wire signed [DATA_WIDTH-1:0] din_re,
    input  wire signed [DATA_WIDTH-1:0] din_im,

    // Delayed complex output
    output wire signed [DATA_WIDTH-1:0] dout_re,
    output wire signed [DATA_WIDTH-1:0] dout_im
);

    reg signed [DATA_WIDTH-1:0] delay_re [0:3];
    reg signed [DATA_WIDTH-1:0] delay_im [0:3];

    integer i;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                delay_re[i] <= {DATA_WIDTH{1'b0}};
                delay_im[i] <= {DATA_WIDTH{1'b0}};
            end
        end

        else begin
            delay_re[0] <= din_re;
            delay_im[0] <= din_im;
            for (i = 1; i < 4; i = i + 1) begin
                delay_re[i] <= delay_re[i-1];
                delay_im[i] <= delay_im[i-1];
            end
        end

    end

    // Oldest sample
    assign dout_re = delay_re[3];
    assign dout_im = delay_im[3];

endmodule
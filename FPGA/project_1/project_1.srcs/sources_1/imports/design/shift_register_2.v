module shift_register_2 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    input wire stage2_valid,

    input wire signed [DATA_WIDTH-1:0] din_re,
    input wire signed [DATA_WIDTH-1:0] din_im,

    output wire signed [DATA_WIDTH-1:0] dout_re,
    output wire signed [DATA_WIDTH-1:0] dout_im
);


reg signed [DATA_WIDTH-1:0] delay_re [0:1];
reg signed [DATA_WIDTH-1:0] delay_im [0:1];

integer i;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                delay_re[i] <= {DATA_WIDTH{1'b0}};
                delay_im[i] <= {DATA_WIDTH{1'b0}};
            end

        end

        else begin
            delay_re[0] <= din_re;
            delay_im[0] <= din_im;
            delay_re[1] <= delay_re[0];
            delay_im[1] <= delay_im[0];
        end

    end

    // O/P
    assign dout_re = delay_re[1];
    assign dout_im = delay_im[1];


endmodule
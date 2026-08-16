module shift_register_8 #(
    parameter DATA_WIDTH = 12
)(
    input  wire clk,
    input  wire rst_n,

    input  wire signed [DATA_WIDTH-1:0] din_re,
    input  wire signed [DATA_WIDTH-1:0] din_im,

    output wire signed [DATA_WIDTH-1:0] dout_re,
    output wire signed [DATA_WIDTH-1:0] dout_im
);

    
    reg signed [DATA_WIDTH-1:0] delay_re [0:7];
    reg signed [DATA_WIDTH-1:0] delay_im [0:7];

    integer i;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                delay_re[i] <= {DATA_WIDTH{1'b0}};
                delay_im[i] <= {DATA_WIDTH{1'b0}};
            end
        end

        else begin
            delay_re[0] <= din_re;
            delay_im[0] <= din_im;
            for (i = 1; i < 8; i = i + 1) begin
                delay_re[i] <= delay_re[i-1];
                delay_im[i] <= delay_im[i-1];
            end
        end

    end
    
    // O/P
    assign dout_re = delay_re[7];
    assign dout_im = delay_im[7];


endmodule
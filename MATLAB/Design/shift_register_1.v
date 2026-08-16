module shift_register_1 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    input wire signed [DATA_WIDTH-1:0] din_re,
    input wire signed [DATA_WIDTH-1:0] din_im,

    output reg signed [DATA_WIDTH-1:0] dout_re,
    output reg signed [DATA_WIDTH-1:0] dout_im
);


    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            dout_re <= {DATA_WIDTH{1'b0}};
            dout_im <= {DATA_WIDTH{1'b0}};

        end

        else begin

            dout_re <= din_re;
            dout_im <= din_im;

        end

    end

endmodule
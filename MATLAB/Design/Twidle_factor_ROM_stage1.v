module Twiddle_ROM_stage1 (
    input  wire [2:0] addr,

    output reg signed [11:0] w_re,
    output reg signed [11:0] w_im
);

    always @(*) begin

        case (addr)

            3'd0: begin
                w_re = 12'sb010000000000; //  1024
                w_im = 12'sb000000000000; //     0
            end

            3'd1: begin
                w_re = 12'sb001110110010; //   946
                w_im = 12'sb111001111000; //  -392
            end

            3'd2: begin
                w_re = 12'sb001011010100; //   724
                w_im = 12'sb110100101011; //  -725
            end

            3'd3: begin
                w_re = 12'sb000110000111; //   391
                w_im = 12'sb110001001101; //  -947
            end

            3'd4: begin
                w_re = 12'sb000000000000; //     0
                w_im = 12'sb110000000000; // -1024
            end

            3'd5: begin
                w_re = 12'sb111001111000; //  -392
                w_im = 12'sb110001001101; //  -947
            end

            3'd6: begin
                w_re = 12'sb110100101011; //  -725
                w_im = 12'sb110100101011; //  -725
            end

            3'd7: begin
                w_re = 12'sb110001001101; //  -947
                w_im = 12'sb111001111000; //  -392
            end

            default: begin
                w_re = 12'sd0;
                w_im = 12'sd0;
            end

        endcase

    end

endmodule
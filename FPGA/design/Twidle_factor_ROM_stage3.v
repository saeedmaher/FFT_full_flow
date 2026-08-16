module Twiddle_ROM_Stage3 (
    input wire addr,

    output reg signed [11:0] w_re,
    output reg signed [11:0] w_im
);

always @(*) begin

    case (addr)

        1'b0: begin

            w_re = 12'sb010000000000; // +1024
            w_im = 12'sb000000000000; //     0

        end


        1'b1: begin

            w_re = 12'sb000000000000; //     0
            w_im = 12'sb110000000000; // -1024

        end


        default: begin

            w_re = 12'sb000000000000;
            w_im = 12'sb000000000000;

        end

    endcase

end

endmodule
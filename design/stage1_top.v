module DIF_R2SDF_Stage1 #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,

    // ==========================================
    // FFT input
    // ==========================================
    input wire signed [DATA_WIDTH-1:0] din_re,
    input wire signed [DATA_WIDTH-1:0] din_im,
    input wire in_valid,

    // ==========================================
    // Stage output
    // ==========================================
    output wire signed [DATA_WIDTH-1:0] sum_re,
    output wire signed [DATA_WIDTH-1:0] sum_im,
    output wire signed [DATA_WIDTH-1:0] diff_re,
    output wire signed [DATA_WIDTH-1:0] diff_im,
    output wire signed [DATA_WIDTH-1:0] SR_out_re,
    output wire signed [DATA_WIDTH-1:0] SR_out_im,
    output wire valid
);

    // =========================================================
    // Registered FFT input
    // =========================================================

    reg signed [DATA_WIDTH-1:0] din_re_reg;
    reg signed [DATA_WIDTH-1:0] din_im_reg;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            din_re_reg <= '0;
            din_im_reg <= '0;
        end

        else if (in_valid) begin
            din_re_reg <= din_re;
            din_im_reg <= din_im;
        end

    end

    // =========================================================
    // Registered valid FFT input "to flow in same as I/P"
    // =========================================================

    reg valid_reg;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            valid_reg <= 0;
        end
        else begin
            valid_reg <= in_valid;
        end

    end

    // =========================================================
    // Internal signals
    // =========================================================

    // ---------------------------------------------------------
    // Shift REG "SR"
    // ---------------------------------------------------------

    wire signed [DATA_WIDTH-1:0] SR_dout_re;
    wire signed [DATA_WIDTH-1:0] SR_dout_im;

    wire signed [DATA_WIDTH-1:0] SR_din_re;
    wire signed [DATA_WIDTH-1:0] SR_din_im;


    // ---------------------------------------------------------
    // Control
    // ---------------------------------------------------------
    wire SR_sel;


    // ---------------------------------------------------------
    // Twiddle ROM
    // ---------------------------------------------------------

    wire [2:0] rom_addr;

    wire signed [DATA_WIDTH-1:0] w_re;
    wire signed [DATA_WIDTH-1:0] w_im;


    // =========================================================
    // CONTROL UNIT
    // =========================================================

    DIF_Stage1_CU CU (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(valid_reg),
        .mux_sel(SR_sel),
        .rom_addr(rom_addr),
        .valid(valid)
    );


    // =========================================================
    // TWIDDLE ROM
    // =========================================================

    Twiddle_ROM_stage1 ROM (
        .addr(rom_addr),
        .w_re(w_re),
        .w_im(w_im)
    );


    // =========================================================
    // INPUT MUX
    // =========================================================

    ShiftREG8_input_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR8_MUX (
        .SR_sel(SR_sel),
        .din_re(din_re_reg),
        .din_im(din_im_reg),
        .diff_re(diff_re),
        .diff_im(diff_im),
        .SR_din_re(SR_din_re),
        .SR_din_im(SR_din_im)
    );


    // =========================================================
    // Shift REG "SR"
    // =========================================================

    shift_register_8 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) SR8 (
        .clk(clk),
        .rst_n(rst_n),
        .fft_in_valid(valid_reg),
        .din_re(SR_din_re),
        .din_im(SR_din_im),
        .dout_re(SR_dout_re),
        .dout_im(SR_dout_im)
    );


    // =========================================================
    // BUTTERFLY
    // =========================================================

    DIF_Butterfly_St1 #(
        .IN_WIDTH(DATA_WIDTH),
        .W_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(DATA_WIDTH)
    ) BUTTERFLY (
        .a_re(SR_dout_re),
        .a_im(SR_dout_im),
        .b_re(din_re_reg),
        .b_im(din_im_reg),
        .w_re(w_re),
        .w_im(w_im),
        .sum_re(sum_re),
        .sum_im(sum_im),
        .diff_re(diff_re),
        .diff_im(diff_im)
    );

    // assign the output of the SR signals
    assign SR_out_re = SR_dout_re;
    assign SR_out_im = SR_dout_im;

endmodule
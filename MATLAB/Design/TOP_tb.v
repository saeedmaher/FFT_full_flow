`timescale 1ns/1ps

module tb_DIF_R2SDF_top_no_serializer;

parameter DATA_WIDTH = 12;


// =========================================================
// DUT INTERFACE
// =========================================================

reg clk;
reg rst_n;

reg signed [DATA_WIDTH-1:0] din_re;
reg signed [DATA_WIDTH-1:0] din_im;

reg in_valid;

wire signed [DATA_WIDTH-1:0] dout_re;
wire signed [DATA_WIDTH-1:0] dout_im;

wire out_valid;


// =========================================================
// DUT
// =========================================================

DIF_R2SDF_top #(
    .DATA_WIDTH(DATA_WIDTH)
) DUT (

    .clk(clk),
    .rst_n(rst_n),

    .din_re(din_re),
    .din_im(din_im),

    .in_valid(in_valid),

    .dout_re(dout_re),
    .dout_im(dout_im),

    .out_valid(out_valid)

);


// =========================================================
// CLOCK
// =========================================================

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


// =========================================================
// INPUT VECTOR
//
// Q4.8 RAW integers
// =========================================================

integer x_re [0:15];
integer x_im [0:15];


// =========================================================
// REFERENCE ARRAYS
//
// Stage 1 = Q5.7
// Stage 2 = Q5.7
// Stage 3 = Q5.7
// Stage 4 = Q6.6
// =========================================================

integer ref_s1_re [0:15];
integer ref_s1_im [0:15];

integer ref_s2_re [0:15];
integer ref_s2_im [0:15];

integer ref_s3_re [0:15];
integer ref_s3_im [0:15];

integer ref_s4_re [0:15];
integer ref_s4_im [0:15];


// =========================================================
// TWIDDLES
// Q2.10
// =========================================================

integer w1_re [0:7];
integer w1_im [0:7];

integer w2_re [0:3];
integer w2_im [0:3];

integer w3_re [0:1];
integer w3_im [0:1];


// =========================================================
// CHECK COUNTERS
// =========================================================

integer errors;
integer output_index;
integer output_checks;

integer i;


// =========================================================
// 12-BIT WRAP
// =========================================================

function integer wrap12;

    input integer value;

    integer temp;

    begin

        temp = value & 4095;

        if (temp >= 2048)
            wrap12 = temp - 4096;
        else
            wrap12 = temp;

    end

endfunction


// =========================================================
// STAGE 1 REFERENCE
//
// Q4.8 -> Q5.7
// =========================================================

task calc_stage1;

    input integer A_RE;
    input integer A_IM;

    input integer B_RE;
    input integer B_IM;

    input integer W_RE;
    input integer W_IM;

    output integer S_RE;
    output integer S_IM;

    output integer D_RE;
    output integer D_IM;

    integer sum_re_temp;
    integer sum_im_temp;

    integer diff_re_temp;
    integer diff_im_temp;

    integer diff_q57_re;
    integer diff_q57_im;

    integer mult_re;
    integer mult_im;

    begin

        // SUM
        sum_re_temp = (A_RE + B_RE) >>> 1;
        sum_im_temp = (A_IM + B_IM) >>> 1;

        S_RE = wrap12(sum_re_temp);
        S_IM = wrap12(sum_im_temp);


        // DIFF cast to Q5.7
        diff_re_temp = (A_RE - B_RE) >>> 1;
        diff_im_temp = (A_IM - B_IM) >>> 1;

        diff_q57_re = wrap12(diff_re_temp);
        diff_q57_im = wrap12(diff_im_temp);


        // Twiddle multiply
        mult_re =
            diff_q57_re * W_RE
            -
            diff_q57_im * W_IM;

        mult_im =
            diff_q57_re * W_IM
            +
            diff_q57_im * W_RE;


        D_RE = wrap12(mult_re >>> 10);
        D_IM = wrap12(mult_im >>> 10);

    end

endtask


// =========================================================
// STAGE 2 / 3 REFERENCE
//
// Q5.7 -> Q5.7
// =========================================================

task calc_q57_butterfly;

    input integer A_RE;
    input integer A_IM;

    input integer B_RE;
    input integer B_IM;

    input integer W_RE;
    input integer W_IM;

    output integer S_RE;
    output integer S_IM;

    output integer D_RE;
    output integer D_IM;

    integer diff_q57_re;
    integer diff_q57_im;

    integer mult_re;
    integer mult_im;

    begin

        S_RE = wrap12(A_RE + B_RE);
        S_IM = wrap12(A_IM + B_IM);

        diff_q57_re = wrap12(A_RE - B_RE);
        diff_q57_im = wrap12(A_IM - B_IM);

        mult_re =
            diff_q57_re * W_RE
            -
            diff_q57_im * W_IM;

        mult_im =
            diff_q57_re * W_IM
            +
            diff_q57_im * W_RE;

        D_RE = wrap12(mult_re >>> 10);
        D_IM = wrap12(mult_im >>> 10);

    end

endtask


// =========================================================
// STAGE 4 REFERENCE
//
// Q5.7 -> Q6.6
// =========================================================

task calc_stage4;

    input integer A_RE;
    input integer A_IM;

    input integer B_RE;
    input integer B_IM;

    output integer S_RE;
    output integer S_IM;

    output integer D_RE;
    output integer D_IM;

    begin

        S_RE = wrap12((A_RE + B_RE) >>> 1);
        S_IM = wrap12((A_IM + B_IM) >>> 1);

        D_RE = wrap12((A_RE - B_RE) >>> 1);
        D_IM = wrap12((A_IM - B_IM) >>> 1);

    end

endtask


// =========================================================
// BUILD REFERENCE FFT
// =========================================================

task build_reference;

    integer p;
    integer base;

    begin

        // Stage 1 twiddles
        w1_re[0] =  1024; w1_im[0] =     0;
        w1_re[1] =   946; w1_im[1] =  -392;
        w1_re[2] =   724; w1_im[2] =  -725;
        w1_re[3] =   391; w1_im[3] =  -947;
        w1_re[4] =     0; w1_im[4] = -1024;
        w1_re[5] =  -392; w1_im[5] =  -947;
        w1_re[6] =  -725; w1_im[6] =  -725;
        w1_re[7] =  -947; w1_im[7] =  -392;


        // Stage 2 twiddles
        w2_re[0] =  1024; w2_im[0] =     0;
        w2_re[1] =   724; w2_im[1] =  -725;
        w2_re[2] =     0; w2_im[2] = -1024;
        w2_re[3] =  -725; w2_im[3] =  -725;


        // Stage 3 twiddles
        w3_re[0] =  1024; w3_im[0] =     0;
        w3_re[1] =     0; w3_im[1] = -1024;


        // -------------------------------------------------
        // Stage 1
        // -------------------------------------------------

        for (p = 0; p < 8; p = p + 1) begin

            calc_stage1(

                x_re[p],
                x_im[p],

                x_re[p+8],
                x_im[p+8],

                w1_re[p],
                w1_im[p],

                ref_s1_re[p],
                ref_s1_im[p],

                ref_s1_re[p+8],
                ref_s1_im[p+8]

            );

        end


        // -------------------------------------------------
        // Stage 2
        // -------------------------------------------------

        for (base = 0; base < 16; base = base + 8) begin

            for (p = 0; p < 4; p = p + 1) begin

                calc_q57_butterfly(

                    ref_s1_re[base+p],
                    ref_s1_im[base+p],

                    ref_s1_re[base+p+4],
                    ref_s1_im[base+p+4],

                    w2_re[p],
                    w2_im[p],

                    ref_s2_re[base+p],
                    ref_s2_im[base+p],

                    ref_s2_re[base+p+4],
                    ref_s2_im[base+p+4]

                );

            end

        end


        // -------------------------------------------------
        // Stage 3
        // -------------------------------------------------

        for (base = 0; base < 16; base = base + 4) begin

            for (p = 0; p < 2; p = p + 1) begin

                calc_q57_butterfly(

                    ref_s2_re[base+p],
                    ref_s2_im[base+p],

                    ref_s2_re[base+p+2],
                    ref_s2_im[base+p+2],

                    w3_re[p],
                    w3_im[p],

                    ref_s3_re[base+p],
                    ref_s3_im[base+p],

                    ref_s3_re[base+p+2],
                    ref_s3_im[base+p+2]

                );

            end

        end


        // -------------------------------------------------
        // Stage 4
        // -------------------------------------------------

        for (base = 0; base < 16; base = base + 2) begin

            calc_stage4(

                ref_s3_re[base],
                ref_s3_im[base],

                ref_s3_re[base+1],
                ref_s3_im[base+1],

                ref_s4_re[base],
                ref_s4_im[base],

                ref_s4_re[base+1],
                ref_s4_im[base+1]

            );

        end

    end

endtask


// =========================================================
// MAIN TEST
// =========================================================

initial begin

    errors        = 0;
    output_index  = 0;
    output_checks = 0;

    rst_n    = 1'b0;
    din_re   = 0;
    din_im   = 0;
    in_valid = 1'b0;


    // =====================================================
    // COMPLEX Q4.8 TEST VECTOR
    // =====================================================

    x_re[0]  =  256;   x_im[0]  =  128;
    x_re[1]  = -384;   x_im[1]  =  256;
    x_re[2]  =  512;   x_im[2]  = -128;
    x_re[3]  = -256;   x_im[3]  = -384;

    x_re[4]  =  640;   x_im[4]  =  192;
    x_re[5]  = -512;   x_im[5]  =  320;
    x_re[6]  =  384;   x_im[6]  = -256;
    x_re[7]  = -640;   x_im[7]  = -128;

    x_re[8]  =  128;   x_im[8]  =  384;
    x_re[9]  = -256;   x_im[9]  = -320;
    x_re[10] =  448;   x_im[10] =  128;
    x_re[11] = -384;   x_im[11] =  256;

    x_re[12] =  320;   x_im[12] = -192;
    x_re[13] = -448;   x_im[13] = -256;
    x_re[14] =  192;   x_im[14] =  320;
    x_re[15] =    0;   x_im[15] = -128;


    // Build reference
    build_reference;


    // =====================================================
    // DISPLAY EXPECTED FINAL STREAM
    // =====================================================

    $display("");
    $display("============================================================");
    $display(" EXPECTED FINAL FFT OUTPUT STREAM");
    $display(" SUM/SHIFT-REGISTER ALTERNATING");
    $display("============================================================");

    for (i = 0; i < 16; i = i + 1) begin

        $display(
            "OUT[%0d] = (%0d,%0d)",
            i,
            ref_s4_re[i],
            ref_s4_im[i]
        );

    end


    // =====================================================
    // RESET
    // =====================================================

    repeat (3)
        @(posedge clk);

    @(negedge clk);

    rst_n = 1'b1;


    // =====================================================
    // SEND 16-SAMPLE INPUT FRAME
    // =====================================================

    for (i = 0; i < 16; i = i + 1) begin

        @(negedge clk);

        din_re   = x_re[i];
        din_im   = x_im[i];
        in_valid = 1'b1;

    end


    // =====================================================
    // END INPUT FRAME
    // =====================================================

    @(negedge clk);

    din_re   = 0;
    din_im   = 0;
    in_valid = 1'b0;


    // =====================================================
    // WAIT FOR FFT TO FINISH
    // =====================================================

    repeat (60)
        @(posedge clk);


    // =====================================================
    // FINAL RESULT
    // =====================================================

    $display("");
    $display("============================================================");
    $display(" FINAL OUTPUT CHECK COMPLETED");
    $display("============================================================");

    $display(
        "Output samples checked = %0d / 16",
        output_checks
    );

    $display(
        "Errors = %0d",
        errors
    );

    $display("============================================================");


    if (
        (errors == 0)
        &&
        (output_checks == 16)
    ) begin

        $display("");
        $display("PASS:");
        $display("FINAL SUM/SR OUTPUT STREAM IS CORRECT.");
        $display("");

    end

    else begin

        $display("");
        $display("FAIL:");
        $display("FINAL OUTPUT STREAM HAS AN ERROR.");
        $display("");

    end


    $stop;

end


// =========================================================
// OUTPUT CHECKER
// =========================================================

integer cycle;

initial begin

    cycle = 0;

    wait (rst_n == 1'b1);

    forever begin

        @(posedge clk);

        #1;


        // -------------------------------------------------
        // Trace useful Stage-4 information
        // -------------------------------------------------

        $display(
            "C%0d | st4V=%b | SUM=(%0d,%0d) SR=(%0d,%0d) | OUTV=%b OUT=(%0d,%0d)",

            cycle,

            DUT.st4_valid,
         
            DUT.st4_sum_re,
            DUT.st4_sum_im,

            DUT.st4_delay_re,
            DUT.st4_delay_im,

            out_valid,

            dout_re,
            dout_im
        );


        // -------------------------------------------------
        // Final output verification
        //
        // Expected:
        //
        // 0 = SUM0
        // 1 = DIFF0 from SR
        // 2 = SUM1
        // 3 = DIFF1 from SR
        // ...
        // -------------------------------------------------

        if (
            out_valid
            &&
            (output_index < 16)
        ) begin

            $display("");
            $display("----------------------------------------------");

            $display(
                "OUTPUT SAMPLE %0d",
                output_index
            );

            $display(
                "Expected = (%0d,%0d)",
                ref_s4_re[output_index],
                ref_s4_im[output_index]
            );

            $display(
                "Actual   = (%0d,%0d)",
                dout_re,
                dout_im
            );


            if (
                (dout_re !== ref_s4_re[output_index])
                ||
                (dout_im !== ref_s4_im[output_index])
            ) begin

                $display(
                    "ERROR OUTPUT %0d",
                    output_index
                );

                errors = errors + 1;

            end

            else begin

                $display(
                    "OUTPUT %0d PASS",
                    output_index
                );

            end


            output_checks =
                output_checks + 1;

            output_index =
                output_index + 1;


            $display("----------------------------------------------");
            $display("");

        end


        cycle = cycle + 1;

    end

end


endmodule
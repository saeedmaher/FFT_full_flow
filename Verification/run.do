vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.FFT_top -classdebug -uvmcontrol=all  -cover 
add wave /FFT_top/FFT_if/*
add wave /FFT_top/DUT/assert__Output_Validation_assert
coverage exclude -du DIF_R2SDF_Stage1 -togglenode w_im
coverage exclude -du DIF_R2SDF_Stage1 -togglenode w_re
coverage exclude -du DIF_R2SDF_Stage2 -togglenode w_im
coverage exclude -du DIF_R2SDF_Stage2 -togglenode w_re
coverage exclude -du DIF_R2SDF_Stage3 -togglenode w_im
coverage exclude -du DIF_R2SDF_Stage3 -togglenode w_re
coverage exclude -du Twiddle_ROM_Stage3 -togglenode w_im
coverage exclude -du Twiddle_ROM_Stage3 -togglenode w_re
coverage exclude -src Twidle_factor_ROM_stage3.v -line 28 -code b
coverage exclude -src Twidle_factor_ROM_stage3.v -line 31 -code s
coverage exclude -src Twidle_factor_ROM_stage3.v -line 30 -code s
coverage exclude -src Twidle_factor_ROM_stage2.v -line 53 -code b
coverage exclude -src Twidle_factor_ROM_stage2.v -line 54 -code s
coverage exclude -src Twidle_factor_ROM_stage2.v -line 55 -code s
coverage exclude -src Twidle_factor_ROM_stage1.v -line 52 -code b
coverage exclude -src Twidle_factor_ROM_stage1.v -line 53 -code s
coverage exclude -src Twidle_factor_ROM_stage1.v -line 54 -code s
coverage exclude -src CU_stage2.v -line 63 -code e
coverage save FFT_DB.ucdb -onexit 
coverage exclude -du Twiddle_ROM_Stage3 -togglenode w_im
coverage exclude -du Twiddle_ROM_Stage3 -togglenode w_re
coverage exclude -du Twiddle_ROM_stage1 -togglenode w_im
coverage exclude -du shift_register_8 -togglenode i
coverage exclude -du Twiddle_ROM_Stage2 -togglenode w_im
coverage exclude -du shift_register_4 -togglenode i
coverage exclude -du shift_register_2 -togglenode i
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_im_im
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_im_re
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_re_im
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_re_re
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_result_im
coverage exclude -du DIF_Butterfly_St3 -togglenode mult_result_re
run -all
vcover report FFT_DB.ucdb -details -annotate -all -output coverage_rpt_FFT.txt
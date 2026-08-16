onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 20 {Control Signls}
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/rst_n
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/clk
add wave -noupdate -divider -height 20 {Input Signals}
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/in_valid
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/din_re
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/din_im
add wave -noupdate -divider -height 20 {Output Signals}
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/out_valid
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/dout_re
add wave -noupdate -height 30 /tb_DIF_R2SDF_top_no_serializer/dout_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {834750 ps}

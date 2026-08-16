vlib work
vlog *v 
vsim -voptargs=+acc tb_DIF_R2SDF_top_no_serializer 
do wave.do
run -all
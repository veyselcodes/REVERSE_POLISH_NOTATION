vlib work
vcom -2008 -work work "../rtl/Block_Ram_Inference_Method.vhd"
vcom -2008 -work work "../rtl/RFN_Module.vhd"
vcom -2008 -work work "../rtl/RFN_Module_tb.vhd"
vsim -t 1ps -L work -voptargs="+acc" RFN_Module_tb
do wave.do
run 2us
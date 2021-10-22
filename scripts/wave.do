onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rfn_module_tb/UUT/rst
add wave -noupdate /rfn_module_tb/UUT/clk
add wave -noupdate /rfn_module_tb/UUT/dIn
add wave -noupdate /rfn_module_tb/UUT/state
add wave -noupdate /rfn_module_tb/UUT/wea
add wave -noupdate /rfn_module_tb/UUT/Number_cnt
add wave -noupdate /rfn_module_tb/UUT/BRAM_Adress_cnt
add wave -noupdate /rfn_module_tb/UUT/Number_register
add wave -noupdate /rfn_module_tb/UUT/First_Number
add wave -noupdate /rfn_module_tb/UUT/Second_Number
add wave -noupdate /rfn_module_tb/UUT/douta
add wave -noupdate /rfn_module_tb/UUT/dina
add wave -noupdate /rfn_module_tb/UUT/dOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2580081 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {2213600 ps} {2725600 ps}

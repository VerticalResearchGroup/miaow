do compile.do
vsim -t 1ns work.dis_controller_tb
do wave.do
run 50us
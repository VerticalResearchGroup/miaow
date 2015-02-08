do compile.do
vsim -t 1ns work.gpu_interface_tb
do wave.do
run 30ms
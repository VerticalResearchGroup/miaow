do compile.do
vsim -t 1ns work.dispatcher_tb
do wave.do
run 30ms
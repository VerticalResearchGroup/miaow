do compile.do
vsim -t 1ns work.allocator_tb
do wave.do
run 800ns
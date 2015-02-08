do compile.do
vsim -t 1ns work.inflight_wg_buffer_tb
do wave.do
run 1ms
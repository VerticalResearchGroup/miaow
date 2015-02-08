vlog -work work -f filelists/allocator  -lint -quiet
vsim -t 1ns work.allocator_tb
run 1ms
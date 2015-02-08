vlog -work work ../../ram_2_port.v  -lint -quiet
vlog -work work ../../cu_handler.v  -lint -quiet
vlog -work work ../../gpu_interface.v  -lint -quiet
vlog -work work ../src/cu_simulator.v  -lint -quiet
vlog -work work ../src/dispatcher_checker.v  -lint -quiet
vlog -work work src/gpu_interface_tb.v  -lint -quiet

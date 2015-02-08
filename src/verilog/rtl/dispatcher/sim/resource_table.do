vlog -work work -f filelists/resource_table  -lint -quiet
vsim -t 1ns work.resource_table_tb
add wave -position insertpoint -radix hexadecimal \
sim:/resource_table_tb/rst \
sim:/resource_table_tb/clk \
sim:/resource_table_tb/DUT/m_state \
sim:/resource_table_tb/DUT/alloc_start \
sim:/resource_table_tb/DUT/alloc_done \
sim:/resource_table_tb/DUT/dealloc_start \
sim:/resource_table_tb/DUT/dealloc_done \
sim:/resource_table_tb/DUT/a_state \
sim:/resource_table_tb/DUT/alloc_res_en_i \
sim:/resource_table_tb/DUT/alloc_cu_id_i \
sim:/resource_table_tb/DUT/alloc_wf_slot_id_i \
sim:/resource_table_tb/DUT/alloc_res_start_i \
sim:/resource_table_tb/DUT/alloc_res_size_i \
sim:/resource_table_tb/DUT/d_state \
sim:/resource_table_tb/DUT/dealloc_res_en_i \
sim:/resource_table_tb/DUT/dealloc_cu_id_i \
sim:/resource_table_tb/DUT/dealloc_wf_slot_id_i \
sim:/resource_table_tb/DUT/f_state \
sim:/resource_table_tb/DUT/find_max_start \
sim:/resource_table_tb/DUT/find_max_done \
sim:/resource_table_tb/DUT/res_table_max_size \
sim:/resource_table_tb/DUT/res_table_max_start \
sim:/resource_table_tb/DUT/res_addr_cu_id \
sim:/resource_table_tb/DUT/res_addr_wf_slot \
sim:/resource_table_tb/DUT/table_head_pointer \
sim:/resource_table_tb/DUT/res_table_rd_valid \
sim:/resource_table_tb/DUT/res_table_rd_reg \
sim:/resource_table_tb/DUT/res_table_last_rd_reg \
sim:/resource_table_tb/DUT/res_table_wr_en \
sim:/resource_table_tb/DUT/res_table_wr_reg \
sim:/resource_table_tb/DUT/cu_initialized \
sim:/resource_table_tb/DUT/cu_initialized_i \
sim:/resource_table_tb/DUT/table_head_pointer_i \
sim:/resource_table_tb/DUT/table_head_pointer \
sim:/resource_table_tb/DUT/resource_table_ram
run 500us
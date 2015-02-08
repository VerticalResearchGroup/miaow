onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dis_controller_tb/rst
add wave -noupdate /dis_controller_tb/clk
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_start_alloc
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_alloc_ack
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_wg_alloc_valid
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_wg_dealloc_valid
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_wg_rejected_valid
add wave -noupdate -group dis_controller_out -radix hexadecimal /dis_controller_tb/DC_DUT/dis_controller_cu_busy
add wave -noupdate -group cu_interface /dis_controller_tb/gpu_interface_dealloc_available
add wave -noupdate -group cu_interface /dis_controller_tb/gpu_interface_cu_id
add wave -noupdate -group cu_interface /dis_controller_tb/gpu_interface_wg_id
add wave -noupdate -group cpu_interface /dis_controller_tb/inflight_wg_buffer_alloc_valid
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_vgpr_size
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_sgpr_size
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_gds_size
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_lds_size
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_num_wf
add wave -noupdate -group cpu_interface -radix unsigned /dis_controller_tb/inflight_wg_buffer_alloc_wg_id
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/end_of_deallocations
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/end_of_allocations
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/curr_alloc
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/allocated_wf_id
add wave -noupdate -group control_signals /dis_controller_tb/curr_alloc_cu_id
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/allocated_cu_id
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/curr_dealloc
add wave -noupdate -group control_signals -radix unsigned /dis_controller_tb/dealloc_wait
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/inflight_wg_buffer_alloc_valid
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/allocator_cu_valid
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/allocator_cu_rejected
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/allocator_cu_id_out
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/grt_wg_alloc_done
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/grt_wg_dealloc_done
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/grt_wg_alloc_wgid
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/grt_wg_dealloc_wgid
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/gpu_interface_dealloc_available
add wave -noupdate -group dis_controller_input -radix unsigned /dis_controller_tb/DC_DUT/gpu_interface_cu_id
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_start_alloc
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_alloc_ack
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_alloc_valid
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_dealloc_valid
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_rejected_valid
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_cu_busy
add wave -noupdate -group dis_controller_internal_st -radix unsigned -childformat {{{/dis_controller_tb/DC_DUT/cus_allocating[7]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[6]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[5]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[4]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[3]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[2]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[1]} -radix unsigned} {{/dis_controller_tb/DC_DUT/cus_allocating[0]} -radix unsigned}} -subitemconfig {{/dis_controller_tb/DC_DUT/cus_allocating[7]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[6]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[5]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[4]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[3]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[2]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[1]} {-height 13 -radix unsigned} {/dis_controller_tb/DC_DUT/cus_allocating[0]} {-height 13 -radix unsigned}} /dis_controller_tb/DC_DUT/cus_allocating
add wave -noupdate -group dis_controller_internal_st /dis_controller_tb/DC_DUT/cu_groups_allocating
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/accepted_waiting_cu_id
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/accepted_waiting
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_start_alloc_i
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_alloc_ack_i
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_alloc_valid_i
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_dealloc_valid_i
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/dis_controller_wg_rejected_valid_i
add wave -noupdate -group dis_controller_internal_st -radix unsigned /dis_controller_tb/DC_DUT/alloc_st
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_cu_valid
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_cu_rejected
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_wg_id_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_cu_id_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_wf_count
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_vgpr_size_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_sgpr_size_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_lds_size_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_vgpr_start_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_sgpr_start_out
add wave -noupdate -group allocator_out -radix unsigned /dis_controller_tb/ALLOC_DUT/allocator_lds_start_out
add wave -noupdate -group allocator_out -radix unsigned -childformat {{{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[6]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[5]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[4]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[3]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[2]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[1]} -radix unsigned} {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[0]} -radix unsigned}} -subitemconfig {{/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[6]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[5]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[4]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[3]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[2]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[1]} {-height 13 -radix unsigned} {/dis_controller_tb/ALLOC_DUT/allocator_gds_start_out[0]} {-height 13 -radix unsigned}} /dis_controller_tb/ALLOC_DUT/allocator_gds_start_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/dis_controller_wg_dealloc_valid
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/gpu_interface_cu_id
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/gpu_interface_wg_id
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/dis_controller_wg_alloc_valid
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_cu_id_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_wg_id_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_wf_count
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_vgpr_start_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_sgpr_start_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_lds_start_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_gds_start_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_vgpr_size_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_sgpr_size_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_lds_size_out
add wave -noupdate -group grt_in -radix unsigned /dis_controller_tb/GRT_DUT/allocator_gds_size_out
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_valid
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_cu_id
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_wg_count
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_vgpr_strt
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_vgpr_size
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_sgpr_strt
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_sgpr_size
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_lds_strt
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_lds_size
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_gds_strt
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_cam_up_gds_size
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_wg_alloc_done
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_wg_alloc_wgid
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_wg_dealloc_done
add wave -noupdate -expand -group grt_out -radix unsigned /dis_controller_tb/GRT_DUT/grt_wg_dealloc_wgid
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/vgpr_res_table_done
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/vgpr_res_table_waiting
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/sgpr_res_table_done
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/sgpr_res_table_waiting
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/lds_res_table_done
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/lds_res_table_waiting
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/all_res_done_array
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/res_done_array_select
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/res_done_valid
add wave -noupdate -group grt_internals /dis_controller_tb/GRT_DUT/res_done_valid_final
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_en}
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_cu_id}
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_wg_slot_id}
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_size}
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_start}
add wave -noupdate -group grt_internals -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_table_done}
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/vgpr_search_out
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/sgpr_search_out
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/lds_search_out
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/wg_search_out
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/gds_valid
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/cam_wait_valid
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/alloc_num_wf_i
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/cam_up_wg_count_i
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/grt_cam_up_valid
add wave -noupdate -expand -group alloc_internals /dis_controller_tb/ALLOC_DUT/wf_cam/cam_ram
add wave -noupdate -expand -group alloc_internals -radix unsigned /dis_controller_tb/ALLOC_DUT/gds_free
add wave -noupdate -expand -group alloc_internals -radix unsigned /dis_controller_tb/ALLOC_DUT/gds_strt
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/m_state}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/a_state}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_start}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_done}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/d_state}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/dealloc_start}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/dealloc_done}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/f_state}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/find_max_start}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/find_max_done}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/new_entry_is_last}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/new_entry_is_first}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rem_entry_is_last}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rem_entry_is_first}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned -childformat {{{/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[3]} -radix unsigned} {{/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[2]} -radix unsigned} {{/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[1]} -radix unsigned} {{/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[0]} -radix unsigned}} -subitemconfig {{/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[3]} {-height 13 -radix unsigned} {/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[2]} {-height 13 -radix unsigned} {/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[1]} {-height 13 -radix unsigned} {/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer[0]} {-height 13 -radix unsigned}} {/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/table_head_pointer_i}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_addr_cu_id}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_addr_wg_slot}
add wave -noupdate -expand -group res_tbl_walk {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_table_rd_en}
add wave -noupdate -expand -group res_tbl_walk {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_table_rd_valid}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtrr_res_strt}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtrr_res_size}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtrr_prev_item}
add wave -noupdate -expand -group res_tbl_walk -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtrr_next_item}
add wave -noupdate -expand -group res_tbl_walk {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_table_wr_en}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_tbl_wr_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtwr_res_strt}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_tbl_wr_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtwr_res_size}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_tbl_wr_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtwr_prev_item}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_tbl_wr_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtwr_next_item}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_table_last_rd_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtlrr_res_strt}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_table_last_rd_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtlrr_res_size}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_table_last_rd_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtlrr_prev_item}
add wave -noupdate -expand -group res_tbl_walk -expand -group res_table_last_rd_reg -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/rtlrr_next_item}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_en}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/dealloc_res_en}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_cu_id}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/dealloc_cu_id}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_wg_slot_id}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/dealloc_wg_slot_id}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_size}
add wave -noupdate -expand -group rt_vgpr_in -radix unsigned {/dis_controller_tb/GRT_DUT/vgpr_table[0]/alloc_res_start}
add wave -noupdate -group rt_vgpr_out {/dis_controller_tb/GRT_DUT/vgpr_table[0]/res_table_done}
add wave -noupdate -group rt_vgpr_out {/dis_controller_tb/GRT_DUT/vgpr_table[0]/cam_biggest_space_size}
add wave -noupdate -group rt_vgpr_out {/dis_controller_tb/GRT_DUT/vgpr_table[0]/cam_biggest_space_addr}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{last normal alloation} {1555 ns} 1} {{local exato do erro - res_addr_wg_slot errado} {3915 ns} 1} {{Cursor 3} {3798 ns} 0}
quietly wave cursor active 3
configure wave -namecolwidth 563
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3793 ns} {4069 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dispatcher_tb/DUT/clk
add wave -noupdate /dispatcher_tb/DUT/rst
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_wg_valid
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_host_rcvd_ack
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_wg_id
add wave -noupdate -group host_interface -radix hexadecimal /dispatcher_tb/DUT/host_start_pc
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_num_wf
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_lds_size_total
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_sgpr_size_per_wf
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_sgpr_size_total
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_vgpr_size_per_wf
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_vgpr_size_total
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_gds_size_total
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/host_wf_size
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_host_wf_done
add wave -noupdate -group host_interface -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_host_wf_done_wg_id
add wave -noupdate -group cu_interface -radix binary /dispatcher_tb/DUT/dispatch2cu_wf_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_wf_tag_dispatch
add wave -noupdate -group cu_interface -radix hexadecimal /dispatcher_tb/DUT/dispatch2cu_start_pc_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_vgpr_base_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_sgpr_base_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_lds_base_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_wg_wf_count
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/dispatch2cu_wf_size_dispatch
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/cu2dispatch_wf_done
add wave -noupdate -group cu_interface -radix unsigned /dispatcher_tb/DUT/cu2dispatch_wf_tag_done
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_available
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_valid
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_wg_id
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_sgpr_size
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_num_wf
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_lds_size
add wave -noupdate -expand -group inflight_wg_buffer_to_alloc -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_alloc_gds_size
add wave -noupdate -expand -group dis_controller_alloc -radix unsigned /dispatcher_tb/DUT/dis_controller_inst/dis_controller_wg_alloc_valid
add wave -noupdate -expand -group dis_controller_alloc -radix unsigned /dispatcher_tb/DUT/dis_controller_inst/dis_controller_wg_rejected_valid
add wave -noupdate -expand -group dis_controller_alloc -radix unsigned /dispatcher_tb/DUT/dis_controller_inst/dis_controller_start_alloc
add wave -noupdate -expand -group dis_controller_alloc -radix unsigned /dispatcher_tb/DUT/dis_controller_inst/dis_controller_alloc_ack
add wave -noupdate -radix binary /dispatcher_tb/DUT/dis_controller_inst/dis_controller_cu_busy
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_cu_valid
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_cu_rejected
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_cu_id_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_wg_id_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_wf_count
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_vgpr_start_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_vgpr_size_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_sgpr_start_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_sgpr_size_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_lds_start_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_lds_size_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_gds_start_out
add wave -noupdate -expand -group allocator_out -radix unsigned /dispatcher_tb/DUT/allocator_inst/allocator_gds_size_out
add wave -noupdate -expand -group inflight_wg_buffer_to_gpu -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_gpu_valid
add wave -noupdate -expand -group inflight_wg_buffer_to_gpu -radix hexadecimal /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_start_pc
add wave -noupdate -expand -group inflight_wg_buffer_to_gpu -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_gpu_wf_size
add wave -noupdate -expand -group inflight_wg_buffer_to_gpu -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_gpu_vgpr_size_per_wf
add wave -noupdate -expand -group inflight_wg_buffer_to_gpu -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_wg_buffer_gpu_sgpr_size_per_wf
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_valid
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_cu_id
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_wg_count
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_vgpr_strt
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_vgpr_size
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_sgpr_strt
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_sgpr_size
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_lds_strt
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_lds_size
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_gds_strt
add wave -noupdate -expand -group grt_cam_up -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_cam_up_gds_size
add wave -noupdate -expand -group grt_alloc -radix unsigned /dispatcher_tb/DUT/gpu_interface_inst/gpu_interface_alloc_available
add wave -noupdate -expand -group grt_alloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_alloc_done
add wave -noupdate -expand -group grt_alloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_alloc_wgid
add wave -noupdate -expand -group grt_alloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_alloc_cu_id
add wave -noupdate -expand -group gpu_dealloc -radix unsigned /dispatcher_tb/DUT/gpu_interface_inst/gpu_interface_dealloc_available
add wave -noupdate -expand -group gpu_dealloc -radix unsigned /dispatcher_tb/DUT/dis_controller_inst/dis_controller_wg_dealloc_valid
add wave -noupdate -expand -group gpu_dealloc -radix unsigned /dispatcher_tb/DUT/gpu_interface_inst/gpu_interface_dealloc_wg_id
add wave -noupdate -expand -group gpu_dealloc -radix unsigned /dispatcher_tb/DUT/gpu_interface_inst/gpu_interface_cu_id
add wave -noupdate -expand -group grt_dealloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_dealloc_done
add wave -noupdate -expand -group grt_dealloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_dealloc_wgid
add wave -noupdate -expand -group grt_dealloc -radix unsigned /dispatcher_tb/DUT/global_resource_table_inst/grt_wg_dealloc_cu_id
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/res_wg_slots_free
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/res_vgpr_free
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/res_sgpr_free
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/res_lds_free
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/res_gds_free
add wave -noupdate -expand -group checker -radix unsigned /dispatcher_tb/CHECKER/cycle_counter
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/tbl_walk_wg_id_searched
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/tbl_walk_rd_valid
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/tbl_walk_rd_en
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/tbl_walk_idx
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_tbl_rd_host_st
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/inflight_tbl_alloc_st
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/ready_tbl_wr_reg
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/ready_tbl_rd_reg
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/new_index_wr_en
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/new_index_comb
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/new_index
add wave -noupdate -radix unsigned -childformat {{{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[47]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[46]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[45]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[44]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[43]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[42]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[41]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[40]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[39]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[38]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[37]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[36]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[35]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[34]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[33]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[32]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[31]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[30]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[29]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[28]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[27]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[26]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[25]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[24]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[23]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[22]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[21]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[20]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[19]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[18]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[17]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[16]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[15]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[14]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[13]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[12]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[11]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[10]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[9]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[8]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[7]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[6]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[5]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[4]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[3]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[2]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[1]} -radix unsigned} {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[0]} -radix unsigned}} -subitemconfig {{/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[47]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[46]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[45]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[44]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[43]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[42]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[41]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[40]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[39]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[38]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[37]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[36]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[35]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[34]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[33]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[32]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[31]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[30]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[29]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[28]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[27]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[26]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[25]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[24]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[23]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[22]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[21]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[20]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[19]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[18]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[17]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[16]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[15]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[14]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[13]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[12]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[11]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[10]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[9]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[8]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[7]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[6]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[5]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[4]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[3]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[2]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[1]} {-height 13 -radix unsigned} {/dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg[0]} {-height 13 -radix unsigned}} /dispatcher_tb/DUT/inflight_wg_buffer_inst/new_entry_wr_reg
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/table_walk_rd_reg
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/waiting_tbl_pending
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/waiting_tbl_valid
add wave -noupdate /dispatcher_tb/DUT/inflight_wg_buffer_inst/chosen_entry_is_valid
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/chosen_entry
add wave -noupdate -radix unsigned /dispatcher_tb/DUT/inflight_wg_buffer_inst/last_chosen_entry_rr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {135 ns} 1} {{Cursor 2} {151 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 648
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
WaveRestoreZoom {0 ns} {480 ns}

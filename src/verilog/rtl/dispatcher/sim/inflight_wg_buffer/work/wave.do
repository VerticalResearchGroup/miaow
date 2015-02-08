onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /inflight_wg_buffer_tb/clk
add wave -noupdate -radix unsigned /inflight_wg_buffer_tb/rst
add wave -noupdate -expand -group test_control -radix unsigned /inflight_wg_buffer_tb/host_curr_wg
add wave -noupdate -expand -group test_control -radix unsigned /inflight_wg_buffer_tb/curr_alloc_wg
add wave -noupdate -expand -group test_control -radix unsigned /inflight_wg_buffer_tb/curr_end_wg
add wave -noupdate -expand -group test_control -radix binary /inflight_wg_buffer_tb/sim_wg_issued
add wave -noupdate -expand -group test_control -radix binary /inflight_wg_buffer_tb/sim_wg_accepted
add wave -noupdate -expand -group test_control -radix binary /inflight_wg_buffer_tb/sim_wg_ended
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wg_valid
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wg_id
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_num_wf
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wf_size
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_vgpr_size_total
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_sgpr_size_total
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_lds_size_total
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_gds_size_total
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_vgpr_size_per_wf
add wave -noupdate -group host_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_sgpr_size_per_wf
add wave -noupdate -expand -group host_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_host_rcvd_ack
add wave -noupdate -expand -group host_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_host_wf_done
add wave -noupdate -expand -group host_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_host_wf_done_wg_id
add wave -noupdate -expand -group controller_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/dis_controller_start_alloc
add wave -noupdate -expand -group controller_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/dis_controller_wg_alloc_valid
add wave -noupdate -expand -group controller_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/dis_controller_wg_dealloc_valid
add wave -noupdate -expand -group controller_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/dis_controller_wg_rejected_valid
add wave -noupdate -expand -group controller_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/allocator_wg_id_out
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_valid
add wave -noupdate -expand -group alloc_outputs /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_available
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_wg_id
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_num_wf
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_vgpr_size
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_sgpr_size
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_lds_size
add wave -noupdate -expand -group alloc_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_alloc_gds_size
add wave -noupdate -group gpu_inputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/gpu_dealloc_wg_id
add wave -noupdate -group gpu_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_gpu_valid
add wave -noupdate -group gpu_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_gpu_vgpr_size_per_wf
add wave -noupdate -group gpu_outputs -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_wg_buffer_gpu_sgpr_size_per_wf
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wg_valid_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wg_id_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_num_wf_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_wf_size_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_vgpr_size_total_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_sgpr_size_total_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_lds_size_total_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_gds_size_total_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_vgpr_size_per_wf_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/host_sgpr_size_per_wf_i
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/inflight_tbl_rd_host_st
add wave -noupdate -group host_new_entry /inflight_wg_buffer_tb/DUT_IWB/new_index_wr_en
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/new_index
add wave -noupdate -group host_new_entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/new_index_comb
add wave -noupdate -group host_new_entry /inflight_wg_buffer_tb/DUT_IWB/new_entry_wr_reg
add wave -noupdate -expand -group tbl_walk /inflight_wg_buffer_tb/DUT_IWB/wait_tbl_busy
add wave -noupdate -expand -group tbl_walk -radix binary -childformat {{{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[7]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[6]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[5]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[4]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[3]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[2]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[1]} -radix unsigned} {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[0]} -radix unsigned}} -subitemconfig {{/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[7]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[6]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[5]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[4]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[3]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[2]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[1]} {-height 13 -radix unsigned} {/inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid[0]} {-height 13 -radix unsigned}} /inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_valid
add wave -noupdate -expand -group tbl_walk -radix binary /inflight_wg_buffer_tb/DUT_IWB/waiting_tbl_pending
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/tbl_walk_idx
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/table_walk_rd_reg
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/ready_tbl_rd_reg
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/tbl_walk_rd_en
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/tbl_walk_rd_valid
add wave -noupdate -expand -group tbl_walk -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/tbl_walk_wg_id_searched
add wave -noupdate /inflight_wg_buffer_tb/DUT_IWB/ram_wg_waiting_allocation/ram_table
add wave -noupdate -group chosen_Entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/chosen_entry
add wave -noupdate -group chosen_Entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/chosen_entry_comb
add wave -noupdate -group chosen_Entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/chosen_entry_is_valid
add wave -noupdate -group chosen_Entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/chosen_entry_is_valid_comb
add wave -noupdate -group chosen_Entry -radix unsigned /inflight_wg_buffer_tb/DUT_IWB/last_chosen_entry_rr
add wave -noupdate /inflight_wg_buffer_tb/DUT_IWB/inflight_tbl_start_st
add wave -noupdate -group alloc_st_machine /inflight_wg_buffer_tb/DUT_IWB/inflight_tbl_alloc_st
add wave -noupdate -group alloc_st_machine /inflight_wg_buffer_tb/DUT_IWB/wg_waiting_alloc_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{last normal alloation} {1555 ns} 1} {{local exato do erro - res_addr_wg_slot errado} {3915 ns} 1} {{Cursor 3} {155 ns} 0}
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
WaveRestoreZoom {13714 ns} {20242 ns}

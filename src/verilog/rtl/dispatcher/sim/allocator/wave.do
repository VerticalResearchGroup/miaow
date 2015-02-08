onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /allocator_tb/DUT/clk
add wave -noupdate /allocator_tb/DUT/rst
add wave -noupdate -expand -group allocation_port /allocator_tb/DUT/dis_controller_alloc_ack
add wave -noupdate -expand -group allocation_port /allocator_tb/DUT/dis_controller_cu_busy
add wave -noupdate -expand -group allocation_port /allocator_tb/DUT/dis_controller_wg_buffer_valid
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_wg_id
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_num_wf
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_vgpr_size
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_sgpr_size
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_lds_size
add wave -noupdate -expand -group allocation_port -radix unsigned /allocator_tb/DUT/inflight_wg_buffer_alloc_gds_size
add wave -noupdate -group cam_up_port /allocator_tb/DUT/grt_cam_up_valid
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_cu_id
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_vgpr_strt
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_vgpr_size
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_sgpr_strt
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_sgpr_size
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_lds_strt
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_lds_size
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_gds_strt
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_gds_size
add wave -noupdate -group cam_up_port -radix unsigned /allocator_tb/DUT/grt_cam_up_wg_count
add wave -noupdate -expand -group output /allocator_tb/DUT/allocator_cu_valid
add wave -noupdate -expand -group output /allocator_tb/DUT/allocator_cu_rejected
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_wg_id_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_cu_id_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_vgpr_start_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_sgpr_start_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_lds_start_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_gds_start_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_vgpr_size_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_sgpr_size_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_lds_size_out
add wave -noupdate -expand -group output -radix unsigned /allocator_tb/DUT/allocator_gds_size_out
add wave -noupdate -expand -group anded_cam /allocator_tb/DUT/anded_cam_out_valid
add wave -noupdate -expand -group anded_cam /allocator_tb/DUT/anded_cam_out
add wave -noupdate -expand -group anded_cam -radix unsigned /allocator_tb/DUT/anded_cam_wg_id
add wave -noupdate -expand -group anded_cam -radix unsigned /allocator_tb/DUT/anded_cam_vgpr_size
add wave -noupdate -expand -group anded_cam -radix unsigned /allocator_tb/DUT/anded_cam_sgpr_size
add wave -noupdate -expand -group anded_cam -radix unsigned /allocator_tb/DUT/anded_cam_lds_size
add wave -noupdate -expand -group anded_cam -radix unsigned /allocator_tb/DUT/anded_cam_gds_size
add wave -noupdate -expand -group anded_cam /allocator_tb/DUT/anded_cam_gds_strt
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_out_valid
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_found_valid
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_found_valid_comb
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_id
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_id_comb
add wave -noupdate -expand -group encoded /allocator_tb/DUT/encoded_cu_wg_id
add wave -noupdate -expand -group encoded -radix unsigned /allocator_tb/DUT/encoded_vgpr_size
add wave -noupdate -expand -group encoded -radix unsigned /allocator_tb/DUT/encoded_sgpr_size
add wave -noupdate -expand -group encoded -radix unsigned /allocator_tb/DUT/encoded_lds_size
add wave -noupdate -expand -group encoded -radix unsigned /allocator_tb/DUT/encoded_gds_size
add wave -noupdate -expand -group encoded -radix unsigned /allocator_tb/DUT/encoded_gds_strt
add wave -noupdate /allocator_tb/DUT/vgpr_search_out
add wave -noupdate /allocator_tb/DUT/sgpr_search_out
add wave -noupdate /allocator_tb/DUT/lds_search_out
add wave -noupdate /allocator_tb/DUT/wg_search_out
add wave -noupdate /allocator_tb/DUT/gds_valid
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/res_search_en
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/res_search_size
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/res_search_out
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/res_search_size_i
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/cam_ram
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/cam_valid_entry
add wave -noupdate -group vgpr_cam /allocator_tb/DUT/vgpr_cam/decoded_output
add wave -noupdate /allocator_tb/DUT/pipeline_waiting
add wave -noupdate /allocator_tb/DUT/cu_initialized
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/wr_en
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/wr_addr
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/wr_word
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/rd_en
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/rd_addr
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/rd_word
add wave -noupdate -group res_start_ram /allocator_tb/DUT/res_start_cam/ram_table
add wave -noupdate -expand -group cam_up /allocator_tb/DUT/cam_up_valid_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_cu_id_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_vgpr_strt_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_vgpr_size_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_sgpr_strt_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_sgpr_size_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_lds_strt_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_lds_size_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_gds_strt_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_gds_size_i
add wave -noupdate -expand -group cam_up -radix unsigned /allocator_tb/DUT/cam_up_wg_count_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Troublesome allocation} {2135 ns} 1} {{Cursor 2} {65 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {89 ns} {417 ns}

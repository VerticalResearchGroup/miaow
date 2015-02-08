onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /global_resource_table_tb/clk
add wave -noupdate /global_resource_table_tb/rst
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_cu_id_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_gds_size_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_lds_size_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_lds_start_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_sgpr_size_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_sgpr_start_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_vgpr_size_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_vgpr_start_out
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_wf_count
add wave -noupdate -group allocator_in -radix unsigned /global_resource_table_tb/allocator_wg_id_out
add wave -noupdate -group allocator_in /global_resource_table_tb/dis_controller_wg_alloc_valid
add wave -noupdate -group dealloc_out -radix unsigned /global_resource_table_tb/dis_controller_wg_dealloc_valid
add wave -noupdate -group dealloc_out -radix unsigned /global_resource_table_tb/gpu_interface_cu_id
add wave -noupdate -group dealloc_out -radix unsigned /global_resource_table_tb/gpu_interface_wg_id
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_wg_alloc_done
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_wg_alloc_wgid
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_wg_dealloc_done
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_wg_dealloc_wgid
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_valid
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_cu_id
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_gds_size
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_lds_size
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_lds_strt
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_sgpr_size
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_sgpr_strt
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_vgpr_size
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_vgpr_strt
add wave -noupdate -group cam_up_out -radix unsigned /global_resource_table_tb/grt_cam_up_wg_count
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_cu_id_out_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_gds_size_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_lds_size_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_lds_start_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_sgpr_size_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_sgpr_start_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_vgpr_size_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_vgpr_start_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_wf_count_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/allocator_wg_id_out_i
add wave -noupdate -expand -group flops_i /global_resource_table_tb/DUT/dis_controller_wg_alloc_valid_i
add wave -noupdate -expand -group flops_i /global_resource_table_tb/DUT/dis_controller_wg_dealloc_valid_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/gpu_interface_cu_id_i
add wave -noupdate -expand -group flops_i -radix unsigned /global_resource_table_tb/DUT/gpu_interface_wg_id_i
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_cu_id
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_cu_id_res_tbl
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_cu_id_res_tbl_seq
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_wg_slot_id
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_alloc_res_en
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_wg_id
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_gds_size
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_lds_size
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_lds_start
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_sgpr_size
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_sgpr_start
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_vgpr_size
add wave -noupdate -expand -group stage1_global -radix unsigned /global_resource_table_tb/DUT/stage1_alloc_vgpr_start
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_dealloc_res_en
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_dealloc_wg_id
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_res_tbl_alloc_selected
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_res_tbl_selected_seq
add wave -noupdate -expand -group stage1_global -radix hexadecimal /global_resource_table_tb/DUT/stage1_res_tbl_dealloc_selected
add wave -noupdate -expand -group stage1_global /global_resource_table_tb/DUT/stage1_wg_slot_id
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_alloc_en
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_alloc_wf_count
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_bitmap_data
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_cu_id
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_dealloc_en
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_dealloc_wg_slot_id
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_init_cu
add wave -noupdate -group stage1_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage1_wg_id
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_alloc_calculated_wg_slot_id
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_alloc_calculated_wg_slot_id_seq
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_alloc_en
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_alloc_wf_count
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data
add wave -noupdate -group stage2_wg -radix unsigned -childformat {{{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[39]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[38]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[37]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[36]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[35]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[34]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[33]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[32]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[31]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[30]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[29]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[28]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[27]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[26]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[25]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[24]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[23]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[22]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[21]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[20]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[19]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[18]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[17]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[16]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[15]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[14]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[13]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[12]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[11]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[10]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[9]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[8]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[7]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[6]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[5]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[4]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[3]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[2]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[1]} -radix unsigned} {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[0]} -radix unsigned}} -subitemconfig {{/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[39]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[38]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[37]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[36]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[35]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[34]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[33]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[32]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[31]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[30]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[29]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[28]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[27]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[26]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[25]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[24]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[23]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[22]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[21]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[20]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[19]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[18]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[17]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[16]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[15]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[14]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[13]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[12]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[11]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[10]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[9]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[8]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[7]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[6]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[5]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[4]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[3]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[2]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[1]} {-height 13 -radix unsigned} {/global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq[0]} {-height 13 -radix unsigned}} /global_resource_table_tb/DUT/wg_res_tbl/stage2_bitmap_update_data_seq
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_cu_id
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_cu_wf_count
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_dealloc_en
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_dealloc_wf_count
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_dealloc_wg_slot_id
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_init_cu
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_op_en
add wave -noupdate -group stage2_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage2_wg_id
add wave -noupdate -group stage3_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage3_cu_id
add wave -noupdate -group stage3_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage3_op_en
add wave -noupdate -group stage3_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage3_wf_count
add wave -noupdate -group stage3_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage3_wf_free
add wave -noupdate -group stage3_wg -radix unsigned /global_resource_table_tb/DUT/wg_res_tbl/stage3_wg_slot_id
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_addr
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_addr_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_addr_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_size
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_size_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_biggest_space_size_seq
add wave -noupdate -group saida_res_tbls -expand /global_resource_table_tb/DUT/lds_res_table_done
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_res_table_done_array
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/lds_res_table_done_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_addr
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_addr_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_addr_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_size
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_size_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_biggest_space_size_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_res_table_done
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_res_table_done_array
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/sgpr_res_table_done_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_addr
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_addr_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_addr_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_size
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_size_buf
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_biggest_space_size_seq
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_res_table_done
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_res_table_done_array
add wave -noupdate -group saida_res_tbls /global_resource_table_tb/DUT/vgpr_res_table_done_seq
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_alloc
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_alloc_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_cu_id
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_cu_id_seq
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_dealloc
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_dealloc_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_gds_biggest_space_size
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_lds_biggest_space_addr
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_lds_biggest_space_addr_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_lds_biggest_space_size
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_lds_biggest_space_size_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_sgpr_biggest_space_addr
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_sgpr_biggest_space_addr_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_sgpr_biggest_space_size
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_sgpr_biggest_space_size_seq
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_tbl_addr
add wave -noupdate -group output_mux /global_resource_table_tb/DUT/mux_tbl_valid
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_vgpr_biggest_space_addr
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_vgpr_biggest_space_addr_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_vgpr_biggest_space_size
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_vgpr_biggest_space_size_seq
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_wf_free_count
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_wg_id
add wave -noupdate -group output_mux -radix unsigned /global_resource_table_tb/DUT/mux_tbl_wg_id_seq
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/alloc_cu_id_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/alloc_res_en_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/alloc_res_size_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/alloc_res_start_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/alloc_wg_slot_id_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/cu_initialized_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/dealloc_cu_id_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/dealloc_res_en_i}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/dealloc_wg_slot_id_i}
add wave -noupdate -group res_tbl {/global_resource_table_tb/DUT/vgpr_table[0]/d_state}
add wave -noupdate -group res_tbl {/global_resource_table_tb/DUT/vgpr_table[0]/f_state}
add wave -noupdate -group res_tbl {/global_resource_table_tb/DUT/vgpr_table[0]/m_state}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/table_head_pointer}
add wave -noupdate -group res_tbl -radix unsigned {/global_resource_table_tb/DUT/vgpr_table[0]/table_head_pointer_i}
add wave -noupdate -group res_tbl_select /global_resource_table_tb/DUT/res_done_array_select
add wave -noupdate -group res_tbl_select /global_resource_table_tb/DUT/res_done_array_select_seq
add wave -noupdate -group res_tbl_select /global_resource_table_tb/DUT/res_done_tbl_addr
add wave -noupdate -group res_tbl_select /global_resource_table_tb/DUT/res_done_tbl_addr_seq
add wave -noupdate -group res_tbl_select /global_resource_table_tb/DUT/all_res_done_array
add wave -noupdate /global_resource_table_tb/DUT/inflight_operation_tbl
add wave -noupdate /global_resource_table_tb/DUT/inflight_operation_tbl_seq
add wave -noupdate /global_resource_table_tb/DUT/wg_res_tbl/cu_init_array
add wave -noupdate -group stage1_gds /global_resource_table_tb/DUT/gds_res_tbl/stage1_alloc_en
add wave -noupdate -group stage1_gds /global_resource_table_tb/DUT/gds_res_tbl/stage1_alloc_gds_size
add wave -noupdate -group stage1_gds /global_resource_table_tb/DUT/gds_res_tbl/stage1_dealloc_en
add wave -noupdate -group stage1_gds /global_resource_table_tb/DUT/gds_res_tbl/stage1_dealloc_gds_size
add wave -noupdate -group stage1_gds /global_resource_table_tb/DUT/gds_res_tbl/stage1_res_tbl_addr
add wave -noupdate -group stage2_gds /global_resource_table_tb/DUT/gds_res_tbl/stage2_inflight_free
add wave -noupdate -group stage2_gds /global_resource_table_tb/DUT/gds_res_tbl/stage2_op_en
add wave -noupdate -group stage2_gds /global_resource_table_tb/DUT/gds_res_tbl/stage2_res_tbl_addr
add wave -noupdate /global_resource_table_tb/DUT/gds_res_tbl/gds_res_tbl_cu_id
add wave -noupdate -radix unsigned /global_resource_table_tb/DUT/gds_res_tbl/gds_used_space_reg
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/alloc_cu_id_i}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/alloc_res_en_i}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/alloc_res_size_i}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/alloc_res_start_i}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/alloc_wg_slot_id_i}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/dealloc_cu_id_i}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/dealloc_wg_slot_id_i}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/a_state}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/d_state}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/f_state}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/m_state}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_addr_cu_id}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_addr_wg_slot}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_rd_valid}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_rd_reg_next_wg_slot}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_rd_reg_prev_wg_slot}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_rd_reg_res_size}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_rd_reg_res_start}
add wave -noupdate -expand -group sgpr_res_tbl {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_wr_en}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_wr_reg_next_wg_slot}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_wr_reg_prev_wg_slot}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_wr_reg_res_size}
add wave -noupdate -expand -group sgpr_res_tbl -radix unsigned {/global_resource_table_tb/DUT/sgpr_table[0]/res_table_wr_reg_res_start}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3105 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 603
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
WaveRestoreZoom {2965 ns} {3306 ns}

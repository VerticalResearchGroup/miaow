# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Tue Jan 29 21:13:55 2013
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 45 signals
# End_DVE_Session_Save_Info

# DVE version: F-2011.12-SP1_Full64
# DVE build date: May 27 2012 20:48:40


#<Session mode="View" path="/afs/cs.wisc.edu/u/m/d/mdrumond/private/miaow/src/verilog/tb/issue/debug_wave_configurations/gpu_test_issue_alu_sb_info.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Tue Jan 29 21:13:55 2013
# 45 signals
# End_DVE_Session_Save_Info

# DVE version: F-2011.12-SP1_Full64
# DVE build date: May 27 2012 20:48:40


#Add ncecessay scopes
gui_load_child_values {gpu_tb.DUT[0].issue0.sb_src2_operand.valid_reg}

gui_set_time_units 1ns
set Group1 Group1
if {[gui_sg_is_group -name Group1]} {
    set Group1 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group1" { {V1:gpu_tb.clk} {V1:gpu_tb.rst} }
set Group2 Group2
if {[gui_sg_is_group -name Group2]} {
    set Group2 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group2" { {V1:gpu_tb.DUT[0].decode0.issue_wf_halt} {V1:gpu_tb.DUT[0].decode0.issue_valid} {V1:gpu_tb.DUT[0].decode0.issue_cc_write} {V1:gpu_tb.DUT[0].decode0.issue_cc_read} {V1:gpu_tb.DUT[0].decode0.issue_fu} {V1:gpu_tb.DUT[0].decode0.issue_wfid} {V1:gpu_tb.DUT[0].decode0.issue_source_reg1} {V1:gpu_tb.DUT[0].decode0.issue_source_reg2} {V1:gpu_tb.DUT[0].decode0.issue_source_reg3} {V1:gpu_tb.DUT[0].decode0.issue_dest_reg} {V1:gpu_tb.DUT[0].decode0.issue_opcode} {V1:gpu_tb.DUT[0].decode0.issue_instr_pc} }
set Group3 Group3
if {[gui_sg_is_group -name Group3]} {
    set Group3 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group3" { {V1:gpu_tb.DUT[0].issue0.sgpr_dest_reg_addr} {V1:gpu_tb.DUT[0].issue0.sgpr_dest_reg_valid} {V1:gpu_tb.DUT[0].issue0.sgpr_wr_done} {V1:gpu_tb.DUT[0].issue0.sgpr_wr_done_wfid} }
set Group4 Group4
if {[gui_sg_is_group -name Group4]} {
    set Group4 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group4" { {V1:gpu_tb.DUT[0].issue0.vgpr_dest_reg_addr} {V1:gpu_tb.DUT[0].issue0.vgpr_dest_reg_valid} {V1:gpu_tb.DUT[0].issue0.vgpr_wr_done} {V1:gpu_tb.DUT[0].issue0.vgpr_wr_done_wfid} }
set Group5 Group5
if {[gui_sg_is_group -name Group5]} {
    set Group5 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group5" { {V1:gpu_tb.DUT[0].issue0.salu_alu_ready} {V1:gpu_tb.DUT[0].issue0.simd0_alu_ready} {V1:gpu_tb.DUT[0].issue0.simd1_alu_ready} {V1:gpu_tb.DUT[0].issue0.simd2_alu_ready} {V1:gpu_tb.DUT[0].issue0.simd3_alu_ready} }
set Group6 Group6
if {[gui_sg_is_group -name Group6]} {
    set Group6 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group6" { {V1:gpu_tb.DUT[0].issue0.alu_dest_reg} {V1:gpu_tb.DUT[0].issue0.alu_imm_value} {V1:gpu_tb.DUT[0].issue0.alu_instr_pc} {V1:gpu_tb.DUT[0].issue0.alu_opcode} {V1:gpu_tb.DUT[0].issue0.alu_source_reg1} {V1:gpu_tb.DUT[0].issue0.alu_source_reg2} {V1:gpu_tb.DUT[0].issue0.fetchwave_wf_done_en} {V1:gpu_tb.DUT[0].issue0.fetchwave_wf_done_wf_id} {V1:gpu_tb.DUT[0].issue0.salu_alu_select} {V1:gpu_tb.DUT[0].issue0.smid0_alu_select} {V1:gpu_tb.DUT[0].issue0.smid1_alu_select} {V1:gpu_tb.DUT[0].issue0.smid2_alu_select} {V1:gpu_tb.DUT[0].issue0.smid3_alu_select} {V1:gpu_tb.DUT[0].issue0.wave_instr_issued_alu} {V1:gpu_tb.DUT[0].issue0.wavealu_wfid} {V1:gpu_tb.DUT[0].issue0.sb_src2_operand.valid_reg.out} {V1:gpu_tb.DUT[0].issue0.sb_src2_operand.lsu_cmp_reg_addr} {V1:gpu_tb.DUT[0].issue0.sb_src2_operand.alu_cmp_reg_addr} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 150
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group1]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group2]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group3]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group4]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group5]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group6]
gui_list_select -id ${Wave.1} {{gpu_tb.DUT[0].decode0.issue_source_reg2} }
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group $Group6  -position in

gui_marker_move -id ${Wave.1} {C1} 105
gui_view_scroll -id ${Wave.1} -vertical -set 703
gui_show_grid -id ${Wave.1} -enable false
#</Session>


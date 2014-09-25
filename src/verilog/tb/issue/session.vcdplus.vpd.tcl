# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Sun Mar 17 23:59:39 2013
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 68 signals
# End_DVE_Session_Save_Info

# DVE version: F-2011.12-SP1_Full64
# DVE build date: May 27 2012 20:48:40


#<Session mode="View" path="/afs/cs.wisc.edu/u/m/d/mdrumond/private/miaow/src/verilog/tb/issue/session.vcdplus.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Sun Mar 17 23:59:39 2013
# 68 signals
# End_DVE_Session_Save_Info

# DVE version: F-2011.12-SP1_Full64
# DVE build date: May 27 2012 20:48:40


#Add ncecessay scopes

gui_set_time_units 1ns
set Group1 Group1
if {[gui_sg_is_group -name Group1]} {
    set Group1 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group1" { {V1:issue_tb.clk} {V1:issue_tb.rst} {V1:issue_tb.decode_barrier} {V1:issue_tb.decode_branch} {V1:issue_tb.decode_dest_reg1} {V1:issue_tb.decode_dest_reg2} {V1:issue_tb.decode_exec_rd} {V1:issue_tb.decode_exec_wr} {V1:issue_tb.decode_fu} {V1:issue_tb.decode_imm_value0} {V1:issue_tb.decode_imm_value1} {V1:issue_tb.decode_instr_pc} {V1:issue_tb.decode_m0_rd} {V1:issue_tb.decode_m0_wr} {V1:issue_tb.decode_opcode} {V1:issue_tb.decode_scc_rd} {V1:issue_tb.decode_scc_wr} {V1:issue_tb.decode_source_reg1} {V1:issue_tb.decode_source_reg2} {V1:issue_tb.decode_source_reg3} {V1:issue_tb.decode_source_reg4} {V1:issue_tb.decode_valid} {V1:issue_tb.decode_vcc_rd} {V1:issue_tb.decode_vcc_wr} {V1:issue_tb.decode_wf_halt} {V1:issue_tb.decode_wfid} }
set Group2 Group2
if {[gui_sg_is_group -name Group2]} {
    set Group2 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group2" { {V1:issue_tb.issue.salu_alu_select} {V1:issue_tb.issue.simd0_alu_select} {V1:issue_tb.issue.simd0_alu_select} {V1:issue_tb.issue.simd1_alu_select} {V1:issue_tb.issue.simd2_alu_select} {V1:issue_tb.issue.simd3_alu_select} {V1:issue_tb.issue.simf0_alu_select} {V1:issue_tb.issue.simf1_alu_select} {V1:issue_tb.issue.simf2_alu_select} {V1:issue_tb.issue.simf3_alu_select} {V1:issue_tb.issue.alu_dest_reg1} {V1:issue_tb.issue.alu_dest_reg2} {V1:issue_tb.issue.alu_imm_value0} {V1:issue_tb.issue.alu_imm_value1} {V1:issue_tb.issue.alu_instr_pc} {V1:issue_tb.issue.alu_opcode} {V1:issue_tb.issue.alu_source_reg1} {V1:issue_tb.issue.alu_source_reg2} {V1:issue_tb.issue.alu_source_reg3} {V1:issue_tb.issue.alu_wfid} {V1:issue_tb.issue.fetchwave_wf_done_en} {V1:issue_tb.issue.fetchwave_wf_done_wf_id} }
set Group3 Group3
if {[gui_sg_is_group -name Group3]} {
    set Group3 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group3" { {V1:issue_tb.issue.vgpr_alu_dest_reg_addr} {V1:issue_tb.issue.vgpr_alu_dest_reg_valid} {V1:issue_tb.issue.vgpr_alu_wr_done} {V1:issue_tb.issue.vgpr_alu_wr_done_wfid} {V1:issue_tb.issue.sgpr_alu_dest_reg_addr} {V1:issue_tb.issue.sgpr_alu_dest_reg_valid} {V1:issue_tb.issue.sgpr_alu_wr_done} {V1:issue_tb.issue.sgpr_alu_wr_done_wfid} }
set Group4 Group4
if {[gui_sg_is_group -name Group4]} {
    set Group4 [gui_sg_generate_new_name]
}

gui_sg_addsignal -group "$Group4" { {V1:issue_tb.issue.barrier_wait_arry} {V1:issue_tb.issue.fu_simd} {V1:issue_tb.issue.fu_simf} {V1:issue_tb.issue.lsu_ready_to_issue} {V1:issue_tb.issue.max_instr_inflight_array} {V1:issue_tb.issue.mem_wait_arry} {V1:issue_tb.issue.pending_branches_arry} {V1:issue_tb.issue.ready_array_data_dependencies} {V1:issue_tb.issue.salu_ready_to_issue} {V1:issue_tb.issue.simd_ready_to_issue} {V1:issue_tb.issue.simf_ready_to_issue} {V1:issue_tb.issue.valid_entry_out} }
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
gui_wv_zoom_timerange -id ${Wave.1} 0 550
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group1]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group2]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group3]
gui_list_add_group -id ${Wave.1} -after {New Group} [list $Group4]
gui_list_select -id ${Wave.1} {issue_tb.issue.barrier_wait_arry issue_tb.issue.fu_simd issue_tb.issue.fu_simf issue_tb.issue.lsu_ready_to_issue issue_tb.issue.max_instr_inflight_array issue_tb.issue.mem_wait_arry issue_tb.issue.pending_branches_arry issue_tb.issue.ready_array_data_dependencies issue_tb.issue.salu_ready_to_issue issue_tb.issue.simd_ready_to_issue issue_tb.issue.simf_ready_to_issue issue_tb.issue.valid_entry_out }
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
gui_list_set_insertion_bar  -id ${Wave.1} -group $Group4  -item {issue_tb.issue.simf_ready_to_issue[39:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 292
gui_view_scroll -id ${Wave.1} -vertical -set 1205
gui_show_grid -id ${Wave.1} -enable false
#</Session>


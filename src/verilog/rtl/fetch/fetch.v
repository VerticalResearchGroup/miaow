module fetch(
      dispatch2cu_wf_dispatch,
      dispatch2cu_wf_tag_dispatch,
      dispatch2cu_start_pc_dispatch,
      dispatch2cu_vgpr_base_dispatch,
      dispatch2cu_sgpr_base_dispatch,
      dispatch2cu_lds_base_dispatch,
      dispatch2cu_wf_size_dispatch,
      dispatch2cu_wg_wf_count,
      buff_ack,
      wave_stop_fetch,
      issue_wf_done_en,
      issue_wf_done_wf_id,
      issue_wg_wfid,
      salu_branch_wfid,
      salu_branch_en,
      salu_branch_taken,
      salu_branch_pc_value,
      cu2dispatch_wf_tag_done,
      cu2dispatch_wf_done,
      buff_addr,
      buff_tag,
      buff_rd_en,
      wave_reserve_slotid,
      wave_reserve_valid,
      wave_basereg_wr,
      wave_basereg_wfid,
      wave_vgpr_base,
      wave_sgpr_base,
      wave_lds_base,
      exec_init_wf_en,
      exec_init_wf_id,
      exec_init_value,
      issue_wg_wgid,
      issue_wg_wf_count,
      tracemon_dispatch,
      tracemon_wf_tag_dispatch,
      tracemon_new_wfid,
      clk,
      rst
 );

input clk;

input rst;

input dispatch2cu_wf_dispatch, buff_ack, issue_wf_done_en, salu_branch_en,
         salu_branch_taken;
input[3:0] dispatch2cu_wg_wf_count;
input[5:0] dispatch2cu_wf_size_dispatch, issue_wf_done_wf_id, issue_wg_wfid,
         salu_branch_wfid;
input[8:0] dispatch2cu_sgpr_base_dispatch;
input[9:0] dispatch2cu_vgpr_base_dispatch;
input[14:0] dispatch2cu_wf_tag_dispatch;
input[15:0] dispatch2cu_lds_base_dispatch;
input[31:0] dispatch2cu_start_pc_dispatch, salu_branch_pc_value;
input[39:0] wave_stop_fetch;

output cu2dispatch_wf_done, buff_rd_en, wave_reserve_valid, wave_basereg_wr,
         exec_init_wf_en, tracemon_dispatch;
output[3:0] issue_wg_wf_count;
output[5:0] wave_reserve_slotid, wave_basereg_wfid, exec_init_wf_id,
         issue_wg_wgid, tracemon_new_wfid;
output[8:0] wave_sgpr_base;
output[9:0] wave_vgpr_base;
output[14:0] cu2dispatch_wf_tag_done;
output[14:0] tracemon_wf_tag_dispatch;
output[15:0] wave_lds_base;
output[31:0] buff_addr;
output[38:0] buff_tag;
output[63:0] exec_init_value;

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////

wire fetch_instr_en;
wire [39:0] vacant_next;
wire wf_dispatch;
wire wr;
wire [3:0]  wg_wf_count;
wire [14:0] wf_tag_dispatch;
wire fetch_valid;
wire [31:0] start_pc_dispatch;
wire [5:0] wf_size_dispatch;
wire [39:0] vacant;
wire vacant_reg_wr;
wire [5:0] buff_tag_sch;
wire [32:0] buff_addr_init;
wire [5:0] new_wfid;

wire branch_wr, pcblk_wr;
wire [31:0] pcblk_pc;
wire [5:0] pcblk_wfid;

assign buff_rd_en = fetch_instr_en;
assign wave_basereg_wfid = new_wfid;
assign exec_init_wf_en = wr;
assign exec_init_wf_id = wave_basereg_wfid;
assign buff_tag = {buff_addr_init[32], buff_tag_sch, buff_addr_init[31:0]};
assign wave_basereg_wr = wr;
assign cu2dispatch_wf_done = issue_wf_done_en;
assign wave_reserve_slotid = buff_tag_sch;
assign vacant_reg_wr = (wr | issue_wf_done_en);
assign buff_addr = buff_addr_init[31:0];

assign branch_wr = salu_branch_en & salu_branch_taken;
assign pcblk_pc = branch_wr ? salu_branch_pc_value : start_pc_dispatch;
assign pcblk_wfid = branch_wr ? salu_branch_wfid : new_wfid;
assign pcblk_wr = branch_wr | wr;

// tracemon signals
assign tracemon_dispatch = wf_dispatch;
assign tracemon_wf_tag_dispatch = wf_tag_dispatch;
assign tracemon_new_wfid = new_wfid;

regfile #(93) dispatch_info_latch (
      { dispatch2cu_wf_dispatch, dispatch2cu_wf_tag_dispatch,
        dispatch2cu_start_pc_dispatch, dispatch2cu_vgpr_base_dispatch,
        dispatch2cu_sgpr_base_dispatch, dispatch2cu_lds_base_dispatch,
        dispatch2cu_wf_size_dispatch, dispatch2cu_wg_wf_count },
      1'b1,
      { wf_dispatch, wf_tag_dispatch, start_pc_dispatch,
        wave_vgpr_base, wave_sgpr_base, wave_lds_base,
        wf_size_dispatch, wg_wf_count },
      clk, rst
);

wfid_generator wfgen (
      issue_wf_done_en, wf_tag_dispatch, issue_wf_done_wf_id,
      vacant, vacant_next, new_wfid,
      cu2dispatch_wf_tag_done, clk, wr, rst
);

wavegrp_info wginfo (
      wf_dispatch, wf_tag_dispatch,
      wg_wf_count, new_wfid,
      issue_wf_done_en, issue_wf_done_wf_id,
      issue_wg_wfid, issue_wg_wgid, issue_wg_wf_count,
      clk, rst
);

regfile_clr #(40) vacant_reg (
      vacant_next, vacant_reg_wr,
      vacant, clk, rst
);

fetch_controller fcontrol (
      wf_dispatch, fetch_valid,
      wr, fetch_instr_en, wave_reserve_valid
);

round_robin scheduler (
      fetch_valid, buff_tag_sch, wave_stop_fetch,
      buff_ack, vacant, clk, rst
);

pc_block pcb1 (
      pcblk_pc, pcblk_wfid, pcblk_wr,
      fetch_instr_en, buff_tag_sch,
      buff_addr_init, clk, rst
);

mask_gen execmaskgen (wf_size_dispatch, exec_init_value);

endmodule
